#!/bin/bash

# Cursor Rules Sync Script
# Syncs .cursor directory from GitHub repository to all target directories
# One-way sync: Source -> All Destinations (respects .syncignore and .syncinclude)
# ID-based matching: Matches files by ID first, then filename (handles renames)
#
# Version: 2.1.0
# Author: Himel Das

set -e

# Script metadata
SCRIPT_VERSION="2.1.0"

SOURCE_REPO="https://github.com/thehimel/cursor-rules-and-prompts.git"
SOURCE_DIR=".cursor"
TEMP_DIR=$(mktemp -d)
PYCHARM_DIR="$HOME/PycharmProjects"
SOURCE_PROJECT_DIR="$PYCHARM_DIR/cursor-rules-and-prompts"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Cleanup function
cleanup() {
    echo -e "\n${BLUE}Cleaning up temporary files...${NC}"
    rm -rf "$TEMP_DIR"
}

# Set trap to cleanup on exit
trap cleanup EXIT

echo -e "${BLUE}🔄 Cursor Rules Sync Script${NC}"
echo -e "${BLUE}===========================${NC}"
echo -e "${YELLOW}Version: ${SCRIPT_VERSION}${NC}\n"

# Function to normalize path (resolve symlinks and get absolute path)
normalize_path() {
    local path="$1"
    local original_pwd
    
    original_pwd=$(pwd)
    
    if [ -d "$path" ]; then
        cd "$path" && pwd
        cd "$original_pwd"
    else
        local parent=$(dirname "$path")
        local basename=$(basename "$path")
        if [ -d "$parent" ]; then
            cd "$parent" && echo "$(pwd)/$basename"
            cd "$original_pwd"
        else
            echo "$path"
        fi
    fi
}

# Function to check if path is under a parent directory
is_under_path() {
    local child="$1"
    local parent="$2"
    parent="${parent%/}"
    child="${child%/}"
    [[ "$child" == "$parent" ]] || [[ "$child" == "$parent"/* ]]
}

# Function to get all destination directories
get_destinations() {
    local current_dir
    local normalized_current
    local normalized_source
    local normalized_pycharm
    
    current_dir=$(pwd)
    normalized_current=$(normalize_path "$current_dir")
    normalized_source=$(normalize_path "$SOURCE_PROJECT_DIR")
    normalized_pycharm=$(normalize_path "$PYCHARM_DIR")
    
    # Get all directories from ~/PycharmProjects/ (excluding source)
    if [ -d "$PYCHARM_DIR" ]; then
        find "$PYCHARM_DIR" -maxdepth 1 -type d ! -path "$PYCHARM_DIR" ! -path "$SOURCE_PROJECT_DIR" | sort
    fi
    
    # If current directory is outside ~/PycharmProjects/ and not the source, add it
    if [[ "$normalized_current" != "$normalized_source" ]] && ! is_under_path "$normalized_current" "$normalized_pycharm"; then
        echo "$normalized_current"
    fi
}

# Function to check if a path matches patterns in .syncignore
# Returns 0 (true) if path should be excluded, 1 (false) if it should be included
is_excluded() {
    local relative_path="$1"
    local syncignore_file="$2"
    
    # If no .syncignore file exists, nothing is excluded
    if [ ! -f "$syncignore_file" ]; then
        return 1  # Not excluded
    fi
    
    # Normalize path (remove leading/trailing slashes for comparison)
    local normalized_path="${relative_path#/}"
    normalized_path="${normalized_path%/}"
    
    # Read .syncignore file and check patterns
    while IFS= read -r line || [ -n "$line" ]; do
        # Skip empty lines and comments
        if [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]]; then
            continue
        fi
        
        # Remove leading/trailing whitespace
        pattern=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        
        if [ -z "$pattern" ]; then
            continue
        fi
        
        # Normalize pattern (remove leading/trailing slashes)
        local normalized_pattern="${pattern#/}"
        normalized_pattern="${normalized_pattern%/}"
        
        # Handle exact matches
        if [ "$normalized_path" = "$normalized_pattern" ]; then
            return 0  # Excluded
        fi
        
        # Handle prefix matches (pattern matches if path starts with pattern/)
        if [[ "$normalized_path" == "$normalized_pattern"/* ]] || [[ "$normalized_path" == "$normalized_pattern" ]]; then
            return 0  # Excluded
        fi
        
        # Handle wildcard patterns using shell glob matching
        case "$normalized_path" in
            $normalized_pattern)
                return 0  # Excluded
                ;;
            $normalized_pattern/*)
                return 0  # Excluded
                ;;
        esac
        
        # Handle patterns that appear as path segments
        if [[ "$normalized_path" =~ (^|/)${normalized_pattern}(/|$) ]]; then
            return 0  # Excluded
        fi
    done < "$syncignore_file"
    
    return 1  # Not excluded
}

# Function to extract ID from frontmatter in a file
# Returns the ID if found, empty string otherwise
extract_id_from_file() {
    local file_path="$1"
    
    if [ ! -f "$file_path" ]; then
        return 1
    fi
    
    # Check if file starts with frontmatter delimiter
    local first_line=$(head -n 1 "$file_path" 2>/dev/null)
    if [ "$first_line" != "---" ]; then
        return 1
    fi
    
    # Extract ID from frontmatter (look for "id: value" pattern)
    local id=$(awk '
        /^---$/ { in_frontmatter = !in_frontmatter; next }
        in_frontmatter && /^id:[[:space:]]*/ {
            sub(/^id:[[:space:]]*/, "")
            gsub(/^[[:space:]]+|[[:space:]]+$/, "")
            print
            exit
        }
    ' "$file_path" 2>/dev/null)
    
    if [ -n "$id" ]; then
        echo "$id"
        return 0
    fi
    
    return 1
}

# Function to build ID-to-filename mapping for a directory
# Outputs: id:filename pairs, one per line
build_id_mapping() {
    local dir_path="$1"
    local relative_base="$2"
    
    if [ ! -d "$dir_path" ]; then
        return
    fi
    
    shopt -s nullglob dotglob
    find "$dir_path" -type f \( -name "*.md" -o -name "*.mdc" \) | while read -r file_path; do
        local relative_file="${file_path#$dir_path/}"
        local relative_path="${relative_base:+$relative_base/}$relative_file"
        
        # Skip .syncignore and .syncinclude files
        local filename=$(basename "$relative_file")
        if [ "$filename" = ".syncignore" ] || [ "$filename" = ".syncinclude" ]; then
            continue
        fi
        
        local id=$(extract_id_from_file "$file_path")
        if [ -n "$id" ]; then
            echo "$id|$relative_path"
        fi
    done
    shopt -u nullglob dotglob
}

# Function to find target file by ID
# Returns the relative path (from base) to the target file if found, empty otherwise
find_target_by_id() {
    local search_id="$1"
    local id_mapping_file="$2"
    
    if [ ! -f "$id_mapping_file" ]; then
        return 1
    fi
    
    # Search for the ID in the mapping
    local matched_path=$(grep "^${search_id}|" "$id_mapping_file" 2>/dev/null | head -n 1 | cut -d'|' -f2-)
    
    if [ -n "$matched_path" ]; then
        echo "$matched_path"
        return 0
    fi
    
    return 1
}

# Function to check if a path matches patterns in .syncinclude
# Returns 0 (true) if path should be included, 1 (false) if it should be excluded
is_included() {
    local relative_path="$1"
    local syncinclude_file="$2"
    
    # If no .syncinclude file exists, everything is included (unless excluded by .syncignore)
    if [ ! -f "$syncinclude_file" ]; then
        return 0  # Included (default)
    fi
    
    # Normalize path (remove leading/trailing slashes for comparison)
    local normalized_path="${relative_path#/}"
    normalized_path="${normalized_path%/}"
    
    # Read .syncinclude file and check patterns
    while IFS= read -r line || [ -n "$line" ]; do
        # Skip empty lines and comments
        if [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]]; then
            continue
        fi
        
        # Remove leading/trailing whitespace
        pattern=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        
        if [ -z "$pattern" ]; then
            continue
        fi
        
        # Normalize pattern (remove leading/trailing slashes)
        local normalized_pattern="${pattern#/}"
        normalized_pattern="${normalized_pattern%/}"
        
        # Handle exact matches
        if [ "$normalized_path" = "$normalized_pattern" ]; then
            return 0  # Included
        fi
        
        # Handle prefix matches (pattern matches if path starts with pattern/)
        if [[ "$normalized_path" == "$normalized_pattern"/* ]] || [[ "$normalized_path" == "$normalized_pattern" ]]; then
            return 0  # Included
        fi
        
        # Handle wildcard patterns using shell glob matching
        case "$normalized_path" in
            $normalized_pattern)
                return 0  # Included
                ;;
            $normalized_pattern/*)
                return 0  # Included
                ;;
        esac
        
        # Handle patterns that appear as path segments
        if [[ "$normalized_path" =~ (^|/)${normalized_pattern}(/|$) ]]; then
            return 0  # Included
        fi
    done < "$syncinclude_file"
    
    return 1  # Not included (whitelist mode - only included patterns are synced)
}

# Function to sync directory recursively respecting .syncignore and .syncinclude
# IMPORTANT: This function implements MERGE behavior with ID-based matching:
# - Files are matched by ID first, then by filename if no ID match
# - Files/directories that exist in source are added/updated in target
# - Files with matching IDs but different filenames are updated (rename handling)
# - Source files take precedence when there's a conflict
sync_directory() {
    local source_path="$1"
    local dest_path="$2"
    local relative_path="$3"
    local source_syncignore="$4"
    local dest_syncignore="$5"
    local source_syncinclude="$6"
    local dest_syncinclude="$7"
    local source_id_map="$8"
    local dest_id_map="$9"
    
    # Check if .syncinclude exists (whitelist mode takes precedence)
    local has_include=false
    if [ -f "$source_syncinclude" ] || [ -f "$dest_syncinclude" ]; then
        has_include=true
    fi
    
    # In whitelist mode, check if this path is included
    # If .syncinclude exists, only items matching patterns in it are synced (whitelist mode)
    local is_included_result=true  # Default: included (when no .syncinclude exists)
    if [ "$has_include" = true ]; then
        is_included_result=false
        # Check source .syncinclude
        if [ -f "$source_syncinclude" ] && is_included "$relative_path" "$source_syncinclude"; then
            is_included_result=true
        fi
        # Check dest .syncinclude (if either matches, include it)
        if [ -f "$dest_syncinclude" ] && is_included "$relative_path" "$dest_syncinclude"; then
            is_included_result=true
        fi
        # If not in whitelist, skip (unless it's the root directory being checked)
        if [ "$is_included_result" = false ] && [ -n "$relative_path" ]; then
            return 0  # Skip - not in whitelist
        fi
    fi
    
    # Check if this directory itself is excluded (blacklist mode)
    # .syncignore is only checked if .syncinclude doesn't exist (blacklist mode)
    if [ "$has_include" = false ]; then
        if [ -f "$source_syncignore" ] && is_excluded "$relative_path" "$source_syncignore"; then
            return 0  # Skip - excluded
        fi
        if [ -f "$dest_syncignore" ] && is_excluded "$relative_path" "$dest_syncignore"; then
            return 0  # Skip - excluded
        fi
    fi
    
    # Create destination directory if it doesn't exist
    mkdir -p "$dest_path"
    
    # Process all items in source directory (including hidden files)
    # NOTE: We only iterate over SOURCE items, which means:
    # - Target-only files/directories are NEVER touched (preserved automatically)
    # - Only source items are added/updated in target
    # - This implements merge behavior: source takes precedence, target-only items preserved
    shopt -s nullglob dotglob
    for item in "$source_path"/*; do
        local item_name=$(basename "$item")
        local source_item="$source_path/$item_name"
        local dest_item="$dest_path/$item_name"
        local item_relative="${relative_path:+$relative_path/}$item_name"
        
        # Skip .syncignore and .syncinclude files themselves
        if [ "$item_name" = ".syncignore" ] || [ "$item_name" = ".syncinclude" ]; then
            continue
        fi
        
        # Check whitelist mode first (if .syncinclude exists)
        if [ "$has_include" = true ]; then
            local item_included=false
            if [ -f "$source_syncinclude" ] && is_included "$item_relative" "$source_syncinclude"; then
                item_included=true
            fi
            if [ -f "$dest_syncinclude" ] && is_included "$item_relative" "$dest_syncinclude"; then
                item_included=true
            fi
            if [ "$item_included" = false ]; then
                echo -e "${YELLOW}⊘${NC} $item_relative (not in .syncinclude whitelist)"
                continue
            fi
        fi
        
        # Check blacklist mode (only if .syncinclude doesn't exist)
        if [ "$has_include" = false ]; then
            if [ -f "$source_syncignore" ] && is_excluded "$item_relative" "$source_syncignore"; then
                echo -e "${YELLOW}⊘${NC} $item_relative (excluded by .syncignore)"
                continue
            fi
            if [ -f "$dest_syncignore" ] && is_excluded "$item_relative" "$dest_syncignore"; then
                echo -e "${YELLOW}⊘${NC} $item_relative (excluded by .syncignore)"
                continue
            fi
        fi
        
        if [ -d "$source_item" ]; then
            # It's a directory, recurse
            # Note: Target-only subdirectories are preserved (we only process source items)
            sync_directory "$source_item" "$dest_item" "$item_relative" "$source_syncignore" "$dest_syncignore" "$source_syncinclude" "$dest_syncinclude" "$source_id_map" "$dest_id_map"
        elif [ -f "$source_item" ]; then
            # It's a file from source
            local source_id=$(extract_id_from_file "$source_item")
            local matched_dest_file=""
            local matched_by_id=false
            
            # Try to match by ID first
            if [ -n "$source_id" ] && [ -f "$dest_id_map" ]; then
                local matched_relative=$(find_target_by_id "$source_id" "$dest_id_map")
                if [ -n "$matched_relative" ]; then
                    # matched_relative is from base (e.g., "rules/category/file.mdc" or "prompts/file.md")
                    # Find .cursor directory by going up from dest_path
                    local cursor_dir="$dest_path"
                    while [ "$(basename "$cursor_dir")" != ".cursor" ] && [ "$cursor_dir" != "/" ] && [ "$cursor_dir" != "." ]; do
                        cursor_dir=$(dirname "$cursor_dir")
                    done
                    if [ -d "$cursor_dir" ]; then
                        matched_dest_file="$cursor_dir/$matched_relative"
                        if [ -f "$matched_dest_file" ]; then
                            matched_by_id=true
                        fi
                    fi
                fi
            fi
            
            # Determine the actual destination file path
            if [ "$matched_by_id" = true ]; then
                # File matched by ID - use the matched path
                local matched_dest_path="$matched_dest_file"
                local matched_dest_name=$(basename "$matched_dest_file")
                
                # If filename is different, we need to handle rename
                if [ "$matched_dest_name" != "$item_name" ]; then
                    echo -e "${YELLOW}🔄${NC} $item_relative (matched by ID, renaming from $matched_relative)"
                    # Remove old file and copy with new name
                    rm -f "$matched_dest_file"
                    cp "$source_item" "$dest_item"
                    echo -e "${GREEN}   ✅ Renamed and updated${NC}"
                else
                    # Same filename, just update if different
                    if cmp -s "$source_item" "$matched_dest_path"; then
                        echo -e "${GREEN}✓${NC} $item_relative (unchanged, matched by ID)"
                    else
                        echo -e "${YELLOW}⚠${NC} $item_relative (updated from source, matched by ID)"
                        cp "$source_item" "$matched_dest_path"
                        echo -e "${GREEN}   ✅ Updated${NC}"
                    fi
                fi
            elif [ -f "$dest_item" ]; then
                # No ID match, but file exists with same filename
                # Check if target has a different ID (ID was updated in source)
                local dest_id=$(extract_id_from_file "$dest_item")
                local id_updated=false
                local id_added=false
                
                # Check for ID changes
                if [ -n "$source_id" ] && [ -n "$dest_id" ]; then
                    # Both have IDs - check if they're different
                    if [ "$source_id" != "$dest_id" ]; then
                        id_updated=true
                    fi
                elif [ -n "$source_id" ] && [ -z "$dest_id" ]; then
                    # Source has ID but target doesn't - ID was added
                    id_added=true
                elif [ -z "$source_id" ] && [ -n "$dest_id" ]; then
                    # Target has ID but source doesn't - ID was removed (shouldn't happen, but handle it)
                    id_updated=true
                fi
                
                # Update file if different
                if cmp -s "$source_item" "$dest_item"; then
                    if [ "$id_updated" = true ] || [ "$id_added" = true ]; then
                        # File content is same but ID changed - update to sync new ID
                        if [ "$id_added" = true ]; then
                            echo -e "${YELLOW}🔄${NC} $item_relative (ID added: $source_id)"
                        else
                            echo -e "${YELLOW}🔄${NC} $item_relative (ID updated: $dest_id → $source_id)"
                        fi
                        cp "$source_item" "$dest_item"
                        echo -e "${GREEN}   ✅ ID updated${NC}"
                    else
                        echo -e "${GREEN}✓${NC} $item_relative (unchanged)"
                    fi
                else
                    if [ "$id_updated" = true ]; then
                        echo -e "${YELLOW}🔄${NC} $item_relative (updated from source, ID changed: $dest_id → $source_id)"
                    elif [ "$id_added" = true ]; then
                        echo -e "${YELLOW}🔄${NC} $item_relative (updated from source, ID added: $source_id)"
                    else
                        echo -e "${YELLOW}⚠${NC} $item_relative (updated from source)"
                    fi
                    cp "$source_item" "$dest_item"
                    echo -e "${GREEN}   ✅ Updated${NC}"
                fi
            else
                # New file in source that doesn't exist in target - add it
                echo -e "${GREEN}+${NC} $item_relative (new file from source)"
                cp "$source_item" "$dest_item"
                echo -e "${GREEN}   ✅ Added${NC}"
            fi
        fi
    done
    shopt -u nullglob dotglob
    
    # IMPORTANT: Files/directories that exist ONLY in target are NEVER processed or deleted here
    # Cleanup of orphaned files happens after all syncing is complete
}

# Function to cleanup orphaned files in target
# Removes files that have IDs matching source IDs but are no longer in source,
# or files that were matched by ID but source file was removed
cleanup_orphaned_files() {
    local dest_dir="$1"
    local source_id_map="$2"
    local dest_id_map="$3"
    
    if [ ! -f "$dest_id_map" ]; then
        return 0
    fi
    
    echo -e "${BLUE}🧹 Cleaning up orphaned files...${NC}"
    local cleaned_count=0
    
    # Find .cursor directory
    local cursor_dir="$dest_dir"
    if [ "$(basename "$cursor_dir")" != ".cursor" ]; then
        cursor_dir="$dest_dir/.cursor"
    fi
    
    # Process each file in target ID mapping
    while IFS='|' read -r target_id target_relative; do
        if [ -z "$target_id" ] || [ -z "$target_relative" ]; then
            continue
        fi
        
        local target_file="$cursor_dir/$target_relative"
        
        # Check if this ID exists in source
        if [ -f "$source_id_map" ]; then
            local source_match=$(grep "^${target_id}|" "$source_id_map" 2>/dev/null | head -n 1)
            if [ -z "$source_match" ]; then
                # ID exists in target but not in source - this is an orphaned file
                if [ -f "$target_file" ]; then
                    echo -e "${YELLOW}🗑️${NC} Removing orphaned file: $target_relative (ID: $target_id)"
                    rm -f "$target_file"
                    cleaned_count=$((cleaned_count + 1))
                fi
            fi
        fi
    done < "$dest_id_map"
    
    if [ $cleaned_count -eq 0 ]; then
        echo -e "${GREEN}   ✅ No orphaned files found${NC}"
    else
        echo -e "${GREEN}   ✅ Removed $cleaned_count orphaned file(s)${NC}"
    fi
}

# Function to sync to a destination directory
sync_to_destination() {
    local dest_dir="$1"
    local source_cursor_dir="$2"
    
    echo -e "${BLUE}📁 Syncing to: ${dest_dir}${NC}"
    
    # Create .cursor directory if it doesn't exist
    local dest_cursor="$dest_dir/$SOURCE_DIR"
    if [ ! -d "$dest_cursor" ]; then
        mkdir -p "$dest_cursor"
    fi
    
    # Paths to .syncignore and .syncinclude files
    local source_syncignore="$source_cursor_dir/.syncignore"
    local dest_syncignore="$dest_cursor/.syncignore"
    local source_syncinclude="$source_cursor_dir/.syncinclude"
    local dest_syncinclude="$dest_cursor/.syncinclude"
    
    # Build ID mappings for source and target
    local temp_dir=$(mktemp -d)
    local source_rules_id_map="$temp_dir/source_rules_id_map.txt"
    local source_prompts_id_map="$temp_dir/source_prompts_id_map.txt"
    local dest_rules_id_map="$temp_dir/dest_rules_id_map.txt"
    local dest_prompts_id_map="$temp_dir/dest_prompts_id_map.txt"
    
    echo -e "${BLUE}🔍 Building ID mappings...${NC}"
    
    # Build source ID mappings
    if [ -d "$source_cursor_dir/rules" ]; then
        build_id_mapping "$source_cursor_dir/rules" "rules" > "$source_rules_id_map"
    fi
    if [ -d "$source_cursor_dir/prompts" ]; then
        build_id_mapping "$source_cursor_dir/prompts" "prompts" > "$source_prompts_id_map"
    fi
    
    # Build target ID mappings
    if [ -d "$dest_cursor/rules" ]; then
        build_id_mapping "$dest_cursor/rules" "rules" > "$dest_rules_id_map"
    fi
    if [ -d "$dest_cursor/prompts" ]; then
        build_id_mapping "$dest_cursor/prompts" "prompts" > "$dest_prompts_id_map"
    fi
    
    # Check if prompts directory is excluded
    local sync_prompts=true
    if is_excluded "prompts" "$source_syncignore" || is_excluded "prompts" "$dest_syncignore"; then
        sync_prompts=false
        echo -e "${YELLOW}⚠️  Prompts directory is excluded in .syncignore, skipping prompts sync.${NC}"
    fi
    
    # Sync rules if not excluded
    if [ -d "$source_cursor_dir/rules" ]; then
        if ! is_excluded "rules" "$source_syncignore" && ! is_excluded "rules" "$dest_syncignore"; then
            echo -e "${BLUE}📋 Syncing Rules...${NC}"
            sync_directory "$source_cursor_dir/rules" "$dest_cursor/rules" "rules" "$source_syncignore" "$dest_syncignore" "$source_syncinclude" "$dest_syncinclude" "$source_rules_id_map" "$dest_rules_id_map"
        else
            echo -e "${YELLOW}⚠️  Rules directory is excluded in .syncignore, skipping.${NC}"
        fi
    fi
    
    # Sync prompts (always synced unless excluded)
    if [ "$sync_prompts" = true ] && [ -d "$source_cursor_dir/prompts" ]; then
        echo -e "${BLUE}💬 Syncing Prompts...${NC}"
        sync_directory "$source_cursor_dir/prompts" "$dest_cursor/prompts" "prompts" "$source_syncignore" "$dest_syncignore" "$source_syncinclude" "$dest_syncinclude" "$source_prompts_id_map" "$dest_prompts_id_map"
    fi
    
    # Rebuild target ID mappings after sync (in case files were renamed)
    if [ -d "$dest_cursor/rules" ]; then
        build_id_mapping "$dest_cursor/rules" "rules" > "$dest_rules_id_map"
    fi
    if [ -d "$dest_cursor/prompts" ]; then
        build_id_mapping "$dest_cursor/prompts" "prompts" > "$dest_prompts_id_map"
    fi
    
    # Cleanup orphaned files
    if [ -f "$dest_rules_id_map" ] && [ -f "$source_rules_id_map" ]; then
        cleanup_orphaned_files "$dest_cursor" "$source_rules_id_map" "$dest_rules_id_map"
    fi
    if [ "$sync_prompts" = true ] && [ -f "$dest_prompts_id_map" ] && [ -f "$source_prompts_id_map" ]; then
        cleanup_orphaned_files "$dest_cursor" "$source_prompts_id_map" "$dest_prompts_id_map"
    fi
    
    # Cleanup temp files
    rm -rf "$temp_dir"
    
    echo ""
}

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ Error: git is not installed. Please install git first.${NC}"
    exit 1
fi

# Clone the source repository to temp directory
echo -e "${YELLOW}📥 Cloning source repository...${NC}"
if ! git clone --depth 1 "$SOURCE_REPO" "$TEMP_DIR" 2>/dev/null; then
    echo -e "${RED}❌ Error: Failed to clone repository. Check your internet connection.${NC}"
    exit 1
fi

SOURCE_CURSOR_DIR="$TEMP_DIR/$SOURCE_DIR"

# Check if source .cursor directory exists
if [ ! -d "$SOURCE_CURSOR_DIR" ]; then
    echo -e "${RED}❌ Error: .cursor directory not found in source repository.${NC}"
    exit 1
fi

# Get all destination directories
echo -e "${YELLOW}🔍 Finding target directories...${NC}"
DESTINATIONS=($(get_destinations))

if [ ${#DESTINATIONS[@]} -eq 0 ]; then
    echo -e "${YELLOW}⚠️  No target directories found.${NC}"
    echo -e "${BLUE}Looking for directories in: $PYCHARM_DIR${NC}"
    exit 0
fi

echo -e "${GREEN}✅ Found ${#DESTINATIONS[@]} target directory(ies)${NC}\n"

# Sync to each destination
for dest_dir in "${DESTINATIONS[@]}"; do
    if [ ! -d "$dest_dir" ]; then
        echo -e "${YELLOW}⚠️  Skipping non-existent directory: $dest_dir${NC}\n"
        continue
    fi
    
    sync_to_destination "$dest_dir" "$SOURCE_CURSOR_DIR"
done

echo -e "${GREEN}✨ Sync complete!${NC}"
echo -e "${BLUE}All target directories have been updated from source repository.${NC}"

#!/bin/bash

# Script to sync .cursor directory from source to all destination directories
# One-way sync: Source -> All Destinations (respects .syncignore and .syncinclude)
# ID-based matching: Matches files by ID first, then filename (handles renames and ID updates)
# Source: ~/PycharmProjects/cursor-rules-and-prompts/.cursor
# Destinations: All other directories in ~/PycharmProjects/

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Paths
PYCHARM_DIR="$HOME/PycharmProjects"
SOURCE_DIR="$PYCHARM_DIR/cursor-rules-and-prompts"
SOURCE_CURSOR="$SOURCE_DIR/.cursor"

# Function to print colored messages
info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to get all destination directories
get_destinations() {
    [ -d "$PYCHARM_DIR" ] && find "$PYCHARM_DIR" -maxdepth 1 -type d ! -path "$PYCHARM_DIR" ! -path "$SOURCE_DIR" | sort
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
# Outputs: id|relative_path pairs, one per line
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

# Function to cleanup orphaned files in target
# Removes files that have IDs matching source IDs but are no longer in source,
# or files that were matched by ID but source file was removed
cleanup_orphaned_files() {
    local dest_cursor="$1"
    local source_id_map="$2"
    local dest_id_map="$3"
    
    if [ ! -f "$dest_id_map" ]; then
        return 0
    fi
    
    info "Cleaning up orphaned files..."
    local cleaned_count=0
    
    # Process each file in target ID mapping
    while IFS='|' read -r target_id target_relative; do
        if [ -z "$target_id" ] || [ -z "$target_relative" ]; then
            continue
        fi
        
        local target_file="$dest_cursor/$target_relative"
        
        # Check if this ID exists in source
        if [ -f "$source_id_map" ]; then
            local source_match=$(grep "^${target_id}|" "$source_id_map" 2>/dev/null | head -n 1)
            if [ -z "$source_match" ]; then
                # ID exists in target but not in source - this is an orphaned file
                if [ -f "$target_file" ]; then
                    warning "Removing orphaned file: $target_relative (ID: $target_id)"
                    rm -f "$target_file"
                    cleaned_count=$((cleaned_count + 1))
                fi
            fi
        fi
    done < "$dest_id_map"
    
    if [ $cleaned_count -eq 0 ]; then
        success "No orphaned files found"
    else
        success "Removed $cleaned_count orphaned file(s)"
    fi
}

# Function to process ID-based matching and renames after rsync
# Handles file renames based on ID matching
process_id_based_matching() {
    local dest_cursor="$1"
    local source_cursor="$2"
    local sync_type="$3"  # "rules" or "all"
    
    local temp_dir=$(mktemp -d)
    local source_rules_id_map="$temp_dir/source_rules_id_map.txt"
    local source_prompts_id_map="$temp_dir/source_prompts_id_map.txt"
    local dest_rules_id_map="$temp_dir/dest_rules_id_map.txt"
    local dest_prompts_id_map="$temp_dir/dest_prompts_id_map.txt"
    
    info "Building ID mappings for ID-based matching..."
    
    # Build source ID mappings
    if [ -d "$source_cursor/rules" ]; then
        build_id_mapping "$source_cursor/rules" "rules" > "$source_rules_id_map"
    fi
    if [ -d "$source_cursor/prompts" ]; then
        build_id_mapping "$source_cursor/prompts" "prompts" > "$source_prompts_id_map"
    fi
    
    # Build target ID mappings
    if [ -d "$dest_cursor/rules" ]; then
        build_id_mapping "$dest_cursor/rules" "rules" > "$dest_rules_id_map"
    fi
    if [ -d "$dest_cursor/prompts" ]; then
        build_id_mapping "$dest_cursor/prompts" "prompts" > "$dest_prompts_id_map"
    fi
    
    # Process rules if syncing rules or all
    if [ "$sync_type" = "rules" ] || [ "$sync_type" = "all" ]; then
        if [ -d "$source_cursor/rules" ] && [ -f "$source_rules_id_map" ] && [ -f "$dest_rules_id_map" ]; then
            process_directory_id_matching "$source_cursor/rules" "$dest_cursor/rules" "rules" "$source_rules_id_map" "$dest_rules_id_map"
        fi
    fi
    
    # Process prompts if syncing all
    if [ "$sync_type" = "all" ]; then
        if [ -d "$source_cursor/prompts" ] && [ -f "$source_prompts_id_map" ] && [ -f "$dest_prompts_id_map" ]; then
            process_directory_id_matching "$source_cursor/prompts" "$dest_cursor/prompts" "prompts" "$source_prompts_id_map" "$dest_prompts_id_map"
        fi
    fi
    
    # Rebuild target ID mappings after processing (in case files were renamed)
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
    if [ "$sync_type" = "all" ] && [ -f "$dest_prompts_id_map" ] && [ -f "$source_prompts_id_map" ]; then
        cleanup_orphaned_files "$dest_cursor" "$source_prompts_id_map" "$dest_prompts_id_map"
    fi
    
    # Cleanup temp files
    rm -rf "$temp_dir"
}

# Function to process ID-based matching for a directory
process_directory_id_matching() {
    local source_dir="$1" dest_dir="$2" source_id_map="$4" dest_id_map="$5"
    [ ! -d "$source_dir" ] || [ ! -d "$dest_dir" ] && return
    
    shopt -s nullglob dotglob
    find "$source_dir" -type f \( -name "*.md" -o -name "*.mdc" \) | while read -r source_file; do
        local source_relative="${source_file#$source_dir/}"
        local source_id=$(extract_id_from_file "$source_file")
        [ -z "$source_id" ] && continue
        
        local matched_relative=$(find_target_by_id "$source_id" "$dest_id_map")
        local dest_file="$dest_dir/$source_relative"
        
        if [ -n "$matched_relative" ]; then
            local matched_file="$dest_dir/$matched_relative"
            if [ "$(basename "$matched_file")" != "$(basename "$source_file")" ] && [ -f "$matched_file" ]; then
                info "File renamed by ID: $matched_relative → $source_relative (ID: $source_id)"
                rm -f "$matched_file"
            elif [ -f "$dest_file" ]; then
                local dest_id=$(extract_id_from_file "$dest_file")
                [ -n "$dest_id" ] && [ "$dest_id" != "$source_id" ] && \
                    info "ID updated: $source_relative ($dest_id → $source_id)"
            fi
        elif [ -f "$dest_file" ]; then
            local dest_id=$(extract_id_from_file "$dest_file")
            if [ -n "$source_id" ] && [ -n "$dest_id" ] && [ "$source_id" != "$dest_id" ]; then
                info "ID updated: $source_relative ($dest_id → $source_id)"
            elif [ -n "$source_id" ] && [ -z "$dest_id" ]; then
                info "ID added: $source_relative ($source_id)"
            fi
        fi
    done
    shopt -u nullglob dotglob
}

# Helper function to read patterns from a file (skip comments and empty lines)
read_patterns() {
    local file="$1"
    if [ -f "$file" ]; then
        while IFS= read -r line || [ -n "$line" ]; do
            [[ -n "$line" && ! "$line" =~ ^[[:space:]]*# ]] && echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | grep -v '^$'
        done < "$file"
    fi
}

# Function to build rsync include file from .syncinclude files
build_include_file() {
    local target_dir="$1"
    local source_include="$SOURCE_CURSOR/.syncinclude"
    local target_include="$target_dir/.cursor/.syncinclude"
    
    [ ! -f "$source_include" ] && [ ! -f "$target_include" ] && return
    
    local temp_file=$(mktemp)
    read_patterns "$source_include" >> "$temp_file"
    read_patterns "$target_include" >> "$temp_file"
    
    if [ -s "$temp_file" ]; then
        local temp_expanded=$(mktemp)
        while IFS= read -r pattern; do
            [ -z "$pattern" ] && continue
            [[ "$pattern" == */ ]] && echo "${pattern%/}/*" >> "$temp_expanded"
            echo "$pattern" >> "$temp_expanded"
            local parent="${pattern%/}"
            while [[ "$parent" == */* ]]; do
                parent="${parent%/*}"
                [ -n "$parent" ] && echo "${parent}/" >> "$temp_expanded"
            done
        done < "$temp_file"
        sort -u "$temp_expanded" | grep -v '^$' > "$temp_file"
        rm -f "$temp_expanded"
    fi
    
    echo "$temp_file"
}

# Function to build rsync exclude file from .syncignore files
build_exclude_file() {
    local target_dir="$1"
    local temp_file=$(mktemp)
    
    echo ".syncignore" >> "$temp_file"
    echo ".syncinclude" >> "$temp_file"
    read_patterns "$SOURCE_CURSOR/.syncignore" >> "$temp_file"
    read_patterns "$target_dir/.cursor/.syncignore" >> "$temp_file"
    
    [ -s "$temp_file" ] && sort -u "$temp_file" | grep -v '^$' > "${temp_file}.sorted" && mv "${temp_file}.sorted" "$temp_file"
    echo "$temp_file"
}

# Function to sync from source to destination (one-way sync: source -> destination)
sync_source_to_dest() {
    local dest_dir="$1"
    local sync_rules_only="$2"
    local exclude_file
    local include_file
    local rsync_exit=0
    
    # Check for .syncinclude first (whitelist mode takes precedence)
    include_file=$(build_include_file "$dest_dir" "$sync_rules_only")
    exclude_file=$(build_exclude_file "$dest_dir")
    
    if [ "$sync_rules_only" = "y" ] || [ -z "$sync_rules_only" ]; then
        # Sync only rules directory
        info "Syncing rules only to $dest_dir..."
        if [ -d "$SOURCE_CURSOR/rules" ]; then
            mkdir -p "$dest_dir/.cursor/rules"
            if [ -n "$include_file" ] && [ -s "$include_file" ]; then
                # Whitelist mode: only include patterns from .syncinclude
                rsync -av --delete --exclude=".syncinclude" --include-from="$include_file" --exclude='*' "$SOURCE_CURSOR/rules/" "$dest_dir/.cursor/rules/" 2>&1 | awk '/^Transfer starting:/{print; getline; if(/^$/) getline; print; next}1'
                rsync_exit=${PIPESTATUS[0]}
            elif [ -s "$exclude_file" ]; then
                # Blacklist mode: exclude patterns from .syncignore
                rsync -av --delete --exclude-from="$exclude_file" "$SOURCE_CURSOR/rules/" "$dest_dir/.cursor/rules/" 2>&1 | awk '/^Transfer starting:/{print; getline; if(/^$/) getline; print; next}1'
                rsync_exit=${PIPESTATUS[0]}
            else
                # Normal mode: sync everything
                rsync -av --delete "$SOURCE_CURSOR/rules/" "$dest_dir/.cursor/rules/" 2>&1 | awk '/^Transfer starting:/{print; getline; if(/^$/) getline; print; next}1'
                rsync_exit=${PIPESTATUS[0]}
            fi
        else
            warning "Rules directory not found in source, skipping..."
            rsync_exit=1
        fi
    else
        # Sync everything
        info "Syncing everything to $dest_dir..."
        if [ -n "$include_file" ] && [ -s "$include_file" ]; then
            # Whitelist mode: only include patterns from .syncinclude
            rsync -av --delete --exclude=".syncinclude" --include-from="$include_file" --exclude='*' "$SOURCE_CURSOR/" "$dest_dir/.cursor/" 2>&1 | awk '/^Transfer starting:/{print; getline; if(/^$/) getline; print; next}1'
            rsync_exit=${PIPESTATUS[0]}
        elif [ -s "$exclude_file" ]; then
            # Blacklist mode: exclude patterns from .syncignore
            rsync -av --delete --exclude-from="$exclude_file" "$SOURCE_CURSOR/" "$dest_dir/.cursor/" 2>&1 | awk '/^Transfer starting:/{print; getline; if(/^$/) getline; print; next}1'
            rsync_exit=${PIPESTATUS[0]}
        else
            # Normal mode: sync everything
            rsync -av --delete "$SOURCE_CURSOR/" "$dest_dir/.cursor/" 2>&1 | awk '/^Transfer starting:/{print; getline; if(/^$/) getline; print; next}1'
            rsync_exit=${PIPESTATUS[0]}
        fi
    fi
    
    # Clean up temp files
    rm -f "$exclude_file" "$include_file"
    
    # Process ID-based matching after rsync
    if [ "$sync_rules_only" = "y" ] || [ -z "$sync_rules_only" ]; then
        process_id_based_matching "$dest_dir/.cursor" "$SOURCE_CURSOR" "rules" || true
    else
        process_id_based_matching "$dest_dir/.cursor" "$SOURCE_CURSOR" "all" || true
    fi
    
    return $rsync_exit
}

# Main execution
main() {
    local target_dir="$1"  # Optional: specific directory to sync to
    
    info "Starting .cursor directory sync..."
    [ ! -d "$SOURCE_CURSOR" ] && error "Source directory does not exist: $SOURCE_CURSOR" && exit 1
    
    echo -n "Do you want to sync only rules? (Y/n): "
    read -r sync_rules_only
    sync_rules_only="${sync_rules_only:-y}"
    
    # If a specific directory is provided, sync only to that directory
    if [ -n "$target_dir" ]; then
        # Normalize the path (resolve relative paths, symlinks, etc.)
        if [ ! -d "$target_dir" ]; then
            error "Directory does not exist: $target_dir"
            exit 1
        fi
        
        # Get absolute path
        target_dir=$(cd "$target_dir" && pwd)
        
        # Check if it's the source directory
        if [ "$target_dir" = "$SOURCE_DIR" ]; then
            error "Cannot sync to source directory: $target_dir"
            exit 1
        fi
        
        # Check if .cursor directory exists
        if [ ! -d "$target_dir/.cursor" ]; then
            error "Directory does not have .cursor folder: $target_dir"
            exit 1
        fi
        
        info "Syncing to specific directory: $target_dir"
        if sync_source_to_dest "$target_dir" "$sync_rules_only"; then
            success "Sync completed!"
        else
            error "Sync failed for $target_dir"
            exit 1
        fi
        return
    fi
    
    # Sync to all destinations
    info "Syncing source to all destinations..."
    
    # Count total destinations first
    local total_destinations=0
    while IFS= read -r dest_dir; do
        [ -z "$dest_dir" ] && continue
        [ ! -d "$dest_dir/.cursor" ] && continue
        total_destinations=$((total_destinations + 1))
    done < <(get_destinations)
    
    if [ $total_destinations -eq 0 ]; then
        warning "No destination directories found"
        success "Sync completed!"
        return
    fi
    
    local dest_count=0
    local dest_word="destination"
    [ $total_destinations -ne 1 ] && dest_word="destinations"
    
    while IFS= read -r dest_dir; do
        [ -z "$dest_dir" ] && continue
        [ ! -d "$dest_dir/.cursor" ] && info "Skipping $dest_dir (no .cursor directory)" && continue
        
        if sync_source_to_dest "$dest_dir" "$sync_rules_only"; then
            dest_count=$((dest_count + 1))
            info "Synced to $dest_count/$total_destinations $dest_word"
            echo ""  # Add blank line after progress
        fi
    done < <(get_destinations)
    
    success "Sync completed!"
}

# Run main function
main "$@"


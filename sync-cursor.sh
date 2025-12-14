#!/bin/bash

# Script to sync .cursor directory from source to all destination directories
# One-way sync: Source -> All Destinations (respects .include file, ! prefix for exclusion)
# ID-based matching: Matches files by ID first, then filename (handles renames and ID updates)
# Source: ~/PycharmProjects/cursor-rules-and-prompts/.cursor
# Destinations: All other directories in ~/PycharmProjects/

set +e  # Don't exit on error - we handle errors explicitly

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
        
        # Skip .include file
        local filename=$(basename "$relative_file")
        if [ "$filename" = ".include" ]; then
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
# Processes whatever directories exist after rsync (path-based syncing)
process_id_based_matching() {
    local dest_cursor="$1"
    local source_cursor="$2"
    local temp_dir=$(mktemp -d)
    
    info "Building ID mappings for ID-based matching..."
    
    # Process each directory type (rules, prompts)
    for dir_type in rules prompts; do
        local source_dir="$source_cursor/$dir_type"
        local dest_dir="$dest_cursor/$dir_type"
        local source_id_map="$temp_dir/source_${dir_type}_id_map.txt"
        local dest_id_map="$temp_dir/dest_${dir_type}_id_map.txt"
        
        # Build ID mappings if directories exist
        [ -d "$source_dir" ] && build_id_mapping "$source_dir" "$dir_type" > "$source_id_map"
        [ -d "$dest_dir" ] && build_id_mapping "$dest_dir" "$dir_type" > "$dest_id_map"
        
        # Process ID matching if both source and dest exist with mappings
        if [ -d "$source_dir" ] && [ -d "$dest_dir" ] && [ -f "$source_id_map" ] && [ -f "$dest_id_map" ]; then
            process_directory_id_matching "$source_dir" "$dest_dir" "$source_id_map" "$dest_id_map"
            # Rebuild dest mapping after processing (in case files were renamed)
            build_id_mapping "$dest_dir" "$dir_type" > "$dest_id_map"
        fi
        
        # Cleanup orphaned files
        [ -f "$source_id_map" ] && [ -f "$dest_id_map" ] && \
            cleanup_orphaned_files "$dest_cursor" "$source_id_map" "$dest_id_map"
    done
    
    rm -rf "$temp_dir"
}

# Function to process ID-based matching for a directory
process_directory_id_matching() {
    local source_dir="$1" dest_dir="$2" source_id_map="$3" dest_id_map="$4"
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

# Helper function to check if a file has non-comment, non-empty lines
has_content() {
    local file="$1"
    [ -f "$file" ] && [ -s "$file" ] && grep -v '^[[:space:]]*#' "$file" | grep -v '^[[:space:]]*$' | grep -q .
}

# Function to check if .include file exists and has content
has_include_patterns() {
    local target_dir="$1"
    has_content "$SOURCE_CURSOR/.include" || has_content "$target_dir/.cursor/.include"
}

# Helper function to read patterns from .include file
read_patterns() {
    local include_file="$1"
    local include_out="$2"
    local exclude_out="$3"
    
    [ ! -f "$include_file" ] && return
    
    while IFS= read -r line || [ -n "$line" ]; do
        [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
        line=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        [ -z "$line" ] && continue
        
        if [[ "$line" =~ ^! ]]; then
            echo "${line#!}" >> "$exclude_out"
        else
            echo "$line" >> "$include_out"
        fi
    done < "$include_file"
}

# Function to build rsync include and exclude files from .include file
# Patterns without ! are includes, patterns with ! prefix are excludes
build_include_exclude_files() {
    local target_dir="$1"
    local include_file=$(mktemp)
    local exclude_file=$(mktemp)
    
    # Always exclude .include file itself
    echo ".include" >> "$exclude_file"
    
    # Process both source and target .include files
    read_patterns "$SOURCE_CURSOR/.include" "$include_file" "$exclude_file"
    read_patterns "$target_dir/.cursor/.include" "$include_file" "$exclude_file"
    
    # Expand patterns: add parent directories and wildcards for rsync
    # For directory patterns, recursively include all subdirectories at any depth
    expand_patterns() {
        local input_file="$1"
        local output_file="$2"
        if [ -s "$input_file" ]; then
            local temp_expanded=$(mktemp)
            while IFS= read -r pattern; do
                [ -z "$pattern" ] && continue
                
                # If pattern ends with /, it's a directory - include recursively
                if [[ "$pattern" == */ ]]; then
                    local dir_pattern="${pattern%/}"
                    # Include the directory itself
                    echo "$dir_pattern/" >> "$temp_expanded"
                    # Include all immediate contents (files and directories)
                    echo "${dir_pattern}/*" >> "$temp_expanded"
                    # For recursive inclusion, we need patterns that match subdirectories at each level
                    # Key: include subdirectories with / so rsync traverses into them
                    # Generate recursive patterns: dir/*/, dir/*/*/, dir/*/*/*/, etc.
                    local recursive_pattern="${dir_pattern}"
                    for i in {1..20}; do
                        recursive_pattern="${recursive_pattern}/*"
                        # Include files at this depth
                        echo "${recursive_pattern}" >> "$temp_expanded"
                        # Include subdirectories at this depth (critical for traversal)
                        echo "${recursive_pattern}/" >> "$temp_expanded"
                    done
                else
                    # Regular pattern (file or directory without trailing /)
                    echo "$pattern" >> "$temp_expanded"
                    # If it might be a directory (no extension and no slash), add recursive patterns
                    if [[ "$pattern" != *.* ]] && [[ "$pattern" != */* ]]; then
                        echo "${pattern}/" >> "$temp_expanded"
                        echo "${pattern}/*" >> "$temp_expanded"
                        local recursive_pattern="${pattern}"
                        for i in {1..20}; do
                            recursive_pattern="${recursive_pattern}/*"
                            echo "${recursive_pattern}" >> "$temp_expanded"
                            echo "${recursive_pattern}/" >> "$temp_expanded"
                        done
                    fi
                fi
                
                # Add parent directories for rsync traversal
                local parent="${pattern%/}"
                while [[ "$parent" == */* ]]; do
                    parent="${parent%/*}"
                    [ -n "$parent" ] && echo "${parent}/" >> "$temp_expanded"
                done
            done < "$input_file"
            sort -u "$temp_expanded" | grep -v '^$' > "$output_file"
            rm -f "$temp_expanded"
        fi
    }
    
    expand_patterns "$include_file" "$include_file"
    expand_patterns "$exclude_file" "$exclude_file"
    
    # Check for conflicts (same pattern in both include and exclude)
    if [ -s "$include_file" ] && [ -s "$exclude_file" ]; then
        while IFS= read -r include_pattern; do
            if grep -Fxq "$include_pattern" "$exclude_file" 2>/dev/null; then
                warning "Pattern '$include_pattern' found in both include and exclude - include takes precedence"
            fi
        done < "$include_file"
    fi
    
    echo "$include_file|$exclude_file"
}

# Function to sync from source to destination (one-way sync: source -> destination)
sync_source_to_dest() {
    local dest_dir="$1"
    local files_result
    local include_file
    local exclude_file
    local rsync_exit=0
    
    # Build include and exclude files from .include
    files_result=$(build_include_exclude_files "$dest_dir")
    include_file=$(echo "$files_result" | cut -d'|' -f1)
    exclude_file=$(echo "$files_result" | cut -d'|' -f2)
    
    info "Syncing to $dest_dir..."
    
    if [ -n "$include_file" ] && [ -s "$include_file" ]; then
        # Whitelist mode: only include patterns from .include
        rsync -av --delete --exclude=".include" --include-from="$include_file" --exclude='*' "$SOURCE_CURSOR/" "$dest_dir/.cursor/" 2>&1 | awk '/^Transfer starting:/{print; getline; if(/^$/) getline; print; next}1'
        rsync_exit=${PIPESTATUS[0]}
    elif [ -s "$exclude_file" ]; then
        # Blacklist mode: exclude patterns from .include (with ! prefix)
        rsync -av --delete --exclude-from="$exclude_file" "$SOURCE_CURSOR/" "$dest_dir/.cursor/" 2>&1 | awk '/^Transfer starting:/{print; getline; if(/^$/) getline; print; next}1'
        rsync_exit=${PIPESTATUS[0]}
    else
        # Normal mode: sync everything (no .include file or empty)
        rsync -av --delete --exclude=".include" "$SOURCE_CURSOR/" "$dest_dir/.cursor/" 2>&1 | awk '/^Transfer starting:/{print; getline; if(/^$/) getline; print; next}1'
        rsync_exit=${PIPESTATUS[0]}
    fi
    
    # Clean up temp files
    rm -f "$exclude_file" "$include_file"
    
    # Process ID-based matching after rsync
    # Process whatever directories exist (path-based syncing via .include)
    process_id_based_matching "$dest_dir/.cursor" "$SOURCE_CURSOR" || true
    
    return $rsync_exit
}

# Main execution
main() {
    local target_dir="$1"  # Optional: specific directory to sync to
    
    info "Starting .cursor directory sync..."
    [ ! -d "$SOURCE_CURSOR" ] && error "Source directory does not exist: $SOURCE_CURSOR" && exit 1
    
    # If a specific directory is provided, sync only to that directory
    if [ -n "$target_dir" ]; then
        [ ! -d "$target_dir" ] && error "Directory does not exist: $target_dir" && exit 1
        target_dir=$(cd "$target_dir" && pwd)
        [ "$target_dir" = "$SOURCE_DIR" ] && error "Cannot sync to source directory: $target_dir" && exit 1
        [ ! -d "$target_dir/.cursor" ] && error "Directory does not have .cursor folder: $target_dir" && exit 1
        
        if ! has_include_patterns "$target_dir"; then
            warning "No .include file found or .include file is empty in $target_dir/.cursor - skipping sync"
            warning "You have not included or excluded any rules and prompts paths"
            success "Sync completed!"
            return
        fi
        
        info "Syncing to specific directory: $target_dir"
        sync_source_to_dest "$target_dir" && success "Sync completed!" || (error "Sync failed for $target_dir" && exit 1)
        return
    fi
    
    # Sync to all destinations
    info "Syncing source to all destinations..."
    
    # Collect valid destinations (with .cursor and .include files)
    local valid_destinations=()
    while IFS= read -r dest_dir; do
        [ -z "$dest_dir" ] || [ ! -d "$dest_dir/.cursor" ] && continue
        has_include_patterns "$dest_dir" && valid_destinations+=("$dest_dir")
    done < <(get_destinations)
    
    if [ ${#valid_destinations[@]} -eq 0 ]; then
        warning "No destination directories found with .include file or .include files are empty"
        warning "You have not included or excluded any rules and prompts paths"
        success "Sync completed!"
        return
    fi
    
    local total=${#valid_destinations[@]}
    local dest_word="destination"
    [ $total -ne 1 ] && dest_word="destinations"
    local count=0
    
    for dest_dir in "${valid_destinations[@]}"; do
        if sync_source_to_dest "$dest_dir"; then
            count=$((count + 1))
            info "Synced to $count/$total $dest_word"
            echo ""
        fi
    done
    
    success "Sync completed!"
}

# Run main function
main "$@"


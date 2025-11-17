#!/bin/bash

# Script to sync .cursor directory from source to all destination directories
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
META_FILE="$SOURCE_CURSOR/meta.json"

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

# Function to read version from meta.json
read_version() {
    if [ -f "$META_FILE" ]; then
        if command -v jq &> /dev/null; then
            jq -r '.version // "1.0.0"' "$META_FILE"
        elif command -v python3 &> /dev/null; then
            python3 -c "import json, sys; data = json.load(open('$META_FILE')); print(data.get('version', '1.0.0'))"
        else
            grep -o '"version"[[:space:]]*:[[:space:]]*"[^"]*"' "$META_FILE" | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' | head -1 || echo "1.0.0"
        fi
    else
        echo "1.0.0"
    fi
}

# Function to get current date in YYYY-MM-DD format
get_current_date() {
    date +%Y-%m-%d
}

# Function to increment version by 0.0.1 and update meta.json
increment_version() {
    local current_version=$(read_version)
    local major=$(echo "$current_version" | cut -d. -f1)
    local minor=$(echo "$current_version" | cut -d. -f2)
    local patch=$(echo "$current_version" | cut -d. -f3)
    
    # Increment patch version by 1 (0.0.1 means incrementing patch by 1)
    patch=$((patch + 1))
    local new_version="$major.$minor.$patch"
    local current_date=$(get_current_date)
    
    # Update meta.json
    if command -v jq &> /dev/null; then
        jq --arg version "$new_version" --arg date "$current_date" '.version = $version | .last_updated = $date' "$META_FILE" > "$META_FILE.tmp" && mv "$META_FILE.tmp" "$META_FILE"
    elif command -v python3 &> /dev/null; then
        python3 << EOF
import json
import sys
with open('$META_FILE', 'r') as f:
    data = json.load(f)
data['version'] = '$new_version'
data['last_updated'] = '$current_date'
with open('$META_FILE', 'w') as f:
    json.dump(data, f, indent=4)
EOF
    else
        # Fallback: basic sed replacement (less reliable but works for simple JSON)
        sed -i.bak "s/\"version\":[[:space:]]*\"[^\"]*\"/\"version\": \"$new_version\"/" "$META_FILE"
        sed -i.bak "s/\"last_updated\":[[:space:]]*\"[^\"]*\"/\"last_updated\": \"$current_date\"/" "$META_FILE"
        rm -f "$META_FILE.bak"
    fi
    
    echo "$new_version"
}

# Function to normalize path (resolve symlinks and get absolute path)
normalize_path() {
    local path="$1"
    local original_pwd
    
    # Save current directory
    original_pwd=$(pwd)
    
    # Get absolute path
    if [ -d "$path" ]; then
        cd "$path" && pwd
        cd "$original_pwd"
    else
        # If path doesn't exist, try to resolve parent and append basename
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
    # Remove trailing slashes for comparison
    parent="${parent%/}"
    child="${child%/}"
    # Check if child starts with parent followed by /
    [[ "$child" == "$parent" ]] || [[ "$child" == "$parent"/* ]]
}

# Function to get all destination directories
get_destinations() {
    local current_dir
    local normalized_current
    local normalized_source
    local normalized_pycharm
    
    # Get current directory and normalize for comparison
    current_dir=$(pwd)
    normalized_current=$(normalize_path "$current_dir")
    normalized_source=$(normalize_path "$SOURCE_DIR")
    normalized_pycharm=$(normalize_path "$PYCHARM_DIR")
    
    # Get all directories from ~/PycharmProjects/ (excluding source)
    find "$PYCHARM_DIR" -maxdepth 1 -type d ! -path "$PYCHARM_DIR" ! -path "$SOURCE_DIR" | sort
    
    # If current directory is outside ~/PycharmProjects/ and not the source, add it
    if [[ "$normalized_current" != "$normalized_source" ]] && ! is_under_path "$normalized_current" "$normalized_pycharm"; then
        echo "$normalized_current"
    fi
}

# Function to check if destination has newer files than source
check_for_updates() {
    local dest_cursor="$1/.cursor"
    local has_updates=false
    local new_files=()
    local updated_files=()
    
    if [ ! -d "$dest_cursor" ]; then
        return 1
    fi
    
    # Check for new files in destination (exclude meta.json from comparison)
    while IFS= read -r file; do
        local rel_path="${file#$dest_cursor/}"
        local source_file="$SOURCE_CURSOR/$rel_path"
        
        # Skip meta.json in comparison (it's managed separately)
        if [ "$rel_path" = "meta.json" ]; then
            continue
        fi
        
        if [ ! -f "$source_file" ]; then
            new_files+=("$rel_path")
            has_updates=true
        elif [ "$file" -nt "$source_file" ]; then
            updated_files+=("$rel_path")
            has_updates=true
        fi
    done < <(find "$dest_cursor" -type f ! -name "meta.json")
    
    if [ "$has_updates" = true ]; then
        echo "NEW:${new_files[*]}|UPDATED:${updated_files[*]}"
        return 0
    fi
    
    return 1
}

# Function to sync from destination to source (with permission)
sync_dest_to_source() {
    local dest_dir="$1"
    local dest_cursor="$dest_dir/.cursor"
    local updates
    local exit_code
    
    updates=$(check_for_updates "$dest_dir")
    exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        local new_files=$(echo "$updates" | cut -d'|' -f1 | sed 's/NEW://')
        local updated_files=$(echo "$updates" | cut -d'|' -f2 | sed 's/UPDATED://')
        
        warning "Found updates in: $dest_dir"
        if [ -n "$new_files" ]; then
            info "New files: $new_files"
        fi
        if [ -n "$updated_files" ]; then
            info "Updated files: $updated_files"
        fi
        
        echo -n "Do you want to update source from $dest_dir? (y/n): "
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]] || [ -z "$response" ]; then
            info "Syncing from $dest_dir to source..."
            rsync -av --update "$dest_cursor/" "$SOURCE_CURSOR/" --exclude="meta.json"
            success "Source updated from $dest_dir"
            return 0
        else
            info "Skipping update from $dest_dir"
            return 1
        fi
    fi
    
    return 1
}

# Function to sync from source to destination
sync_source_to_dest() {
    local dest_dir="$1"
    local sync_rules_only="$2"
    
    if [ "$sync_rules_only" = "y" ] || [ -z "$sync_rules_only" ]; then
        # Sync only rules directory
        info "Syncing rules only to $dest_dir..."
        if [ -d "$SOURCE_CURSOR/rules" ]; then
            mkdir -p "$dest_dir/.cursor/rules"
            rsync -av --delete "$SOURCE_CURSOR/rules/" "$dest_dir/.cursor/rules/"
        else
            warning "Rules directory not found in source, skipping..."
        fi
    else
        # Sync everything including meta.json
        info "Syncing everything to $dest_dir..."
        rsync -av --delete "$SOURCE_CURSOR/" "$dest_dir/.cursor/"
    fi
}

# Main execution
main() {
    local current_dir
    local normalized_current
    local normalized_source
    
    info "Starting .cursor directory sync..."
    
    # Get current directory and check if we're in source
    current_dir=$(pwd)
    normalized_current=$(normalize_path "$current_dir")
    normalized_source=$(normalize_path "$SOURCE_DIR")
    
    # If running from source directory, no special handling needed
    if [[ "$normalized_current" == "$normalized_source" ]]; then
        info "Running from source directory"
    fi
    
    # Check if source directory exists
    if [ ! -d "$SOURCE_CURSOR" ]; then
        error "Source directory does not exist: $SOURCE_CURSOR"
        exit 1
    fi
    
    # Create meta.json if it doesn't exist
    if [ ! -f "$META_FILE" ]; then
        local current_date=$(get_current_date)
        if command -v jq &> /dev/null; then
            jq -n --arg version "1.0.0" --arg date "$current_date" '{version: $version, last_updated: $date}' > "$META_FILE"
        elif command -v python3 &> /dev/null; then
            python3 << EOF
import json
data = {"version": "1.0.0", "last_updated": "$current_date"}
with open('$META_FILE', 'w') as f:
    json.dump(data, f, indent=4)
EOF
        else
            cat > "$META_FILE" << EOF
{
    "version": "1.0.0",
    "last_updated": "$current_date"
}
EOF
        fi
        info "Created meta.json with initial version 1.0.0"
    fi
    
    # Ask for sync type
    echo -n "Do you want to sync only rules? (Y/n): "
    read -r sync_rules_only
    sync_rules_only="${sync_rules_only:-y}"  # Default to 'y'
    
    # Get current version
    current_version=$(read_version)
    info "Current version: $current_version"
    
    # Step 1: Check all destinations for updates
    info "Checking destinations for updates..."
    source_updated=false
    
    while IFS= read -r dest_dir; do
        if [ -d "$dest_dir/.cursor" ]; then
            if sync_dest_to_source "$dest_dir"; then
                source_updated=true
            fi
        fi
    done < <(get_destinations)
    
    # Step 2: Increment version if source was updated
    if [ "$source_updated" = true ]; then
        new_version=$(increment_version)
        success "Version updated: $current_version -> $new_version"
    fi
    
    # Step 3: Sync source to all destinations
    info "Syncing source to all destinations..."
    dest_count=0
    
    while IFS= read -r dest_dir; do
        # Create .cursor directory if it doesn't exist
        mkdir -p "$dest_dir/.cursor"
        
        sync_source_to_dest "$dest_dir" "$sync_rules_only"
        dest_count=$((dest_count + 1))
    done < <(get_destinations)
    
    if [ $dest_count -eq 0 ]; then
        warning "No destination directories found"
    else
        success "Synced to $dest_count destination(s)"
    fi
    
    # Display final version
    final_version=$(read_version)
    info "Final version: $final_version"
    
    success "Sync completed!"
}

# Run main function
main


#!/bin/bash

# Cursor Rules Sync Script
# Syncs .cursor directory with https://github.com/thehimel/cursor-rules-and-prompts.git

set -e

SOURCE_REPO="https://github.com/thehimel/cursor-rules-and-prompts.git"
SOURCE_DIR=".cursor"
TEMP_DIR=$(mktemp -d)
CURRENT_DIR=$(pwd)

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
echo -e "${BLUE}===========================${NC}\n"

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

# If local .cursor doesn't exist or is empty, copy everything
if [ ! -d "$CURRENT_DIR/$SOURCE_DIR" ] || [ -z "$(ls -A $CURRENT_DIR/$SOURCE_DIR 2>/dev/null)" ]; then
    echo -e "${YELLOW}📁 Local .cursor directory not found or empty.${NC}"
    echo -e "${GREEN}✅ Copying all files from source...${NC}"
    mkdir -p "$CURRENT_DIR/$SOURCE_DIR"
    cp -r "$SOURCE_CURSOR_DIR"/* "$CURRENT_DIR/$SOURCE_DIR/"
    echo -e "${GREEN}✨ Done! All files copied.${NC}"
    exit 0
fi

# Function to compare files
compare_files() {
    local file1="$1"
    local file2="$2"
    
    if [ ! -f "$file1" ] || [ ! -f "$file2" ]; then
        return 1
    fi
    
    if cmp -s "$file1" "$file2"; then
        return 0  # Files are identical
    else
        return 1  # Files are different
    fi
}

# Function to sync directory recursively
sync_directory() {
    local source_path="$1"
    local dest_path="$2"
    local relative_path="$3"
    
    # Create destination directory if it doesn't exist
    mkdir -p "$dest_path"
    
    # Process all items in source directory (including hidden files)
    shopt -s nullglob dotglob
    for item in "$source_path"/*; do
        local item_name=$(basename "$item")
        local source_item="$source_path/$item_name"
        local dest_item="$dest_path/$item_name"
        local item_relative="${relative_path:+$relative_path/}$item_name"
        
        if [ -d "$source_item" ]; then
            # It's a directory, recurse
            sync_directory "$source_item" "$dest_item" "$item_relative"
        elif [ -f "$source_item" ]; then
            # It's a file
            if [ -f "$dest_item" ]; then
                # File exists in both places, compare
                if compare_files "$source_item" "$dest_item"; then
                    echo -e "${GREEN}✓${NC} $item_relative (unchanged)"
                else
                    echo -e "${YELLOW}⚠${NC} $item_relative (different)"
                    echo -e "${BLUE}   Source file has been updated.${NC}"
                    read -p "   Replace your local file? [y/N]: " -n 1 -r
                    echo
                    if [[ $REPLY =~ ^[Yy]$ ]]; then
                        cp "$source_item" "$dest_item"
                        echo -e "${GREEN}   ✅ Replaced${NC}"
                    else
                        echo -e "${YELLOW}   ⏭️  Skipped${NC}"
                    fi
                fi
            else
                # New file in source, add it
                echo -e "${GREEN}+${NC} $item_relative (new file)"
                cp "$source_item" "$dest_item"
                echo -e "${GREEN}   ✅ Added${NC}"
            fi
        fi
    done
    shopt -u nullglob dotglob
}

# Start syncing
echo -e "${YELLOW}🔄 Syncing .cursor directory...${NC}\n"
sync_directory "$SOURCE_CURSOR_DIR" "$CURRENT_DIR/$SOURCE_DIR" ""

# Check for files that exist locally but not in source (orphaned files)
echo -e "\n${BLUE}🔍 Checking for local-only files...${NC}"
orphaned_count=0
while IFS= read -r local_file; do
    relative_path="${local_file#$CURRENT_DIR/$SOURCE_DIR/}"
    source_file="$SOURCE_CURSOR_DIR/$relative_path"
    
    if [ ! -f "$source_file" ]; then
        echo -e "${YELLOW}⚠${NC} $relative_path (exists locally but not in source)"
        echo -e "${BLUE}   This file will be kept as it's your local addition.${NC}"
        orphaned_count=$((orphaned_count + 1))
    fi
done < <(find "$CURRENT_DIR/$SOURCE_DIR" -type f)

if [ $orphaned_count -eq 0 ]; then
    echo -e "${GREEN}✓ No local-only files found.${NC}"
fi

echo -e "\n${GREEN}✨ Sync complete!${NC}"
echo -e "${BLUE}Your .cursor directory is now up to date.${NC}"


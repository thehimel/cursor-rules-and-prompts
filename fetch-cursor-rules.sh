#!/bin/bash

# Cursor Rules Sync Script
# Syncs .cursor directory with https://github.com/thehimel/cursor-rules-and-prompts.git
#
# Version: 1.0.0
# Author: Himel Das

set -e

# Script metadata
SCRIPT_VERSION="1.0.0"

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
echo -e "${BLUE}===========================${NC}"
echo -e "${YELLOW}Version: ${SCRIPT_VERSION}${NC}\n"

# Function to check for script updates
check_script_update() {
    # Check if curl is available
    if ! command -v curl &> /dev/null; then
        echo -e "${YELLOW}⚠️  curl not found. Skipping version check.${NC}\n"
        return
    fi
    
    echo -e "${BLUE}🔍 Checking for script updates...${NC}"
    
    # Script URL for downloading latest version
    SCRIPT_URL="https://raw.githubusercontent.com/thehimel/cursor-rules-and-prompts/main/sync-cursor-rules.sh"
    
    # Download the latest script to a temp file
    TEMP_SCRIPT=$(mktemp)
    if curl -s -o "$TEMP_SCRIPT" "$SCRIPT_URL" 2>/dev/null; then
        # Extract version from the downloaded script
        LATEST_VERSION=$(grep -m 1 "SCRIPT_VERSION=" "$TEMP_SCRIPT" | sed 's/.*SCRIPT_VERSION="\([^"]*\)".*/\1/' || echo "")
        rm -f "$TEMP_SCRIPT"
        
        if [ -n "$LATEST_VERSION" ] && [ "$LATEST_VERSION" != "$SCRIPT_VERSION" ]; then
            echo -e "${YELLOW}⚠️  A newer version of the sync script is available!${NC}"
            echo -e "${YELLOW}   Your version: ${SCRIPT_VERSION}${NC}"
            echo -e "${YELLOW}   Latest version: ${LATEST_VERSION}${NC}"
            echo ""
            read -p "Would you like to update the script now? [y/N]: " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                SCRIPT_PATH="$0"
                if curl -s -o "$SCRIPT_PATH" "$SCRIPT_URL" 2>/dev/null; then
                    chmod +x "$SCRIPT_PATH"
                    echo -e "${GREEN}✅ Script updated successfully!${NC}"
                    echo -e "${BLUE}Please run the script again to use the new version.${NC}"
                    exit 0
                else
                    echo -e "${RED}❌ Failed to update script. Please update manually.${NC}"
                fi
            else
                echo -e "${YELLOW}⏭️  Continuing with current version...${NC}"
            fi
            echo ""
        else
            echo -e "${GREEN}✓ You're using the latest version.${NC}\n"
        fi
    else
        echo -e "${YELLOW}⚠️  Could not check for updates (no internet connection or repository unavailable).${NC}\n"
    fi
}

# Check for updates
check_script_update

# Menu for selecting what to sync
echo -e "${YELLOW}What would you like to sync?${NC}"
echo -e "  1) 📋 Rules only"
echo -e "  2) 💬 Prompts only"
echo -e "  3) 📋💬 Rules and Prompts (both)"
echo ""
read -p "Enter your choice [1-3] (default: 3): " -n 1 -r
echo ""

SYNC_CHOICE="${REPLY:-3}"

case $SYNC_CHOICE in
    1)
        SYNC_RULES=true
        SYNC_PROMPTS=false
        SYNC_TARGET="Rules"
        ;;
    2)
        SYNC_RULES=false
        SYNC_PROMPTS=true
        SYNC_TARGET="Prompts"
        ;;
    3)
        SYNC_RULES=true
        SYNC_PROMPTS=true
        SYNC_TARGET="Rules and Prompts"
        ;;
    *)
        echo -e "${RED}❌ Invalid choice. Defaulting to sync both.${NC}"
        SYNC_RULES=true
        SYNC_PROMPTS=true
        SYNC_TARGET="Rules and Prompts"
        ;;
esac

echo -e "${GREEN}✅ Selected: ${SYNC_TARGET}${NC}\n"

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

# Create .cursor directory if it doesn't exist
if [ ! -d "$CURRENT_DIR/$SOURCE_DIR" ]; then
    mkdir -p "$CURRENT_DIR/$SOURCE_DIR"
fi

# Function to copy selected directories
copy_selected() {
    if [ "$SYNC_RULES" = true ] && [ -d "$SOURCE_CURSOR_DIR/rules" ]; then
        if [ ! -d "$CURRENT_DIR/$SOURCE_DIR/rules" ] || [ -z "$(ls -A $CURRENT_DIR/$SOURCE_DIR/rules 2>/dev/null)" ]; then
            echo -e "${GREEN}✅ Copying rules...${NC}"
            mkdir -p "$CURRENT_DIR/$SOURCE_DIR/rules"
            cp -r "$SOURCE_CURSOR_DIR/rules"/* "$CURRENT_DIR/$SOURCE_DIR/rules/"
        fi
    fi
    
    if [ "$SYNC_PROMPTS" = true ] && [ -d "$SOURCE_CURSOR_DIR/prompts" ]; then
        if [ ! -d "$CURRENT_DIR/$SOURCE_DIR/prompts" ] || [ -z "$(ls -A $CURRENT_DIR/$SOURCE_DIR/prompts 2>/dev/null)" ]; then
            echo -e "${GREEN}✅ Copying prompts...${NC}"
            mkdir -p "$CURRENT_DIR/$SOURCE_DIR/prompts"
            cp -r "$SOURCE_CURSOR_DIR/prompts"/* "$CURRENT_DIR/$SOURCE_DIR/prompts/"
        fi
    fi
}

# If local .cursor is empty, copy selected items
if [ -z "$(ls -A $CURRENT_DIR/$SOURCE_DIR 2>/dev/null)" ]; then
    echo -e "${YELLOW}📁 Local .cursor directory is empty.${NC}"
    echo -e "${GREEN}✅ Copying selected items from source...${NC}"
    copy_selected
    echo -e "${GREEN}✨ Done! Selected items copied.${NC}"
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

# Start syncing based on selection
echo -e "${YELLOW}🔄 Syncing selected items...${NC}\n"

if [ "$SYNC_RULES" = true ] && [ -d "$SOURCE_CURSOR_DIR/rules" ]; then
    echo -e "${BLUE}📋 Syncing Rules...${NC}"
    if [ ! -d "$CURRENT_DIR/$SOURCE_DIR/rules" ]; then
        mkdir -p "$CURRENT_DIR/$SOURCE_DIR/rules"
    fi
    sync_directory "$SOURCE_CURSOR_DIR/rules" "$CURRENT_DIR/$SOURCE_DIR/rules" "rules"
    echo ""
fi

if [ "$SYNC_PROMPTS" = true ] && [ -d "$SOURCE_CURSOR_DIR/prompts" ]; then
    echo -e "${BLUE}💬 Syncing Prompts...${NC}"
    if [ ! -d "$CURRENT_DIR/$SOURCE_DIR/prompts" ]; then
        mkdir -p "$CURRENT_DIR/$SOURCE_DIR/prompts"
    fi
    sync_directory "$SOURCE_CURSOR_DIR/prompts" "$CURRENT_DIR/$SOURCE_DIR/prompts" "prompts"
    echo ""
fi

# Check for files that exist locally but not in source (orphaned files)
echo -e "${BLUE}🔍 Checking for local-only files...${NC}"
orphaned_count=0

# Check rules if they were synced
if [ "$SYNC_RULES" = true ] && [ -d "$CURRENT_DIR/$SOURCE_DIR/rules" ]; then
    while IFS= read -r local_file; do
        relative_path="${local_file#$CURRENT_DIR/$SOURCE_DIR/}"
        source_file="$SOURCE_CURSOR_DIR/$relative_path"
        
        if [ ! -f "$source_file" ]; then
            echo -e "${YELLOW}⚠${NC} $relative_path (exists locally but not in source)"
            echo -e "${BLUE}   This file will be kept as it's your local addition.${NC}"
            orphaned_count=$((orphaned_count + 1))
        fi
    done < <(find "$CURRENT_DIR/$SOURCE_DIR/rules" -type f 2>/dev/null)
fi

# Check prompts if they were synced
if [ "$SYNC_PROMPTS" = true ] && [ -d "$CURRENT_DIR/$SOURCE_DIR/prompts" ]; then
    while IFS= read -r local_file; do
        relative_path="${local_file#$CURRENT_DIR/$SOURCE_DIR/}"
        source_file="$SOURCE_CURSOR_DIR/$relative_path"
        
        if [ ! -f "$source_file" ]; then
            echo -e "${YELLOW}⚠${NC} $relative_path (exists locally but not in source)"
            echo -e "${BLUE}   This file will be kept as it's your local addition.${NC}"
            orphaned_count=$((orphaned_count + 1))
        fi
    done < <(find "$CURRENT_DIR/$SOURCE_DIR/prompts" -type f 2>/dev/null)
fi

if [ $orphaned_count -eq 0 ]; then
    echo -e "${GREEN}✓ No local-only files found in synced directories.${NC}"
fi

echo -e "\n${GREEN}✨ Sync complete!${NC}"
echo -e "${BLUE}Your .cursor directory is now up to date.${NC}"


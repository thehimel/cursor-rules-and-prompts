# Cursor Rules Sync Script

Syncs the `.cursor` directory from the source repository to all other projects in `~/PycharmProjects/` and any directory where the script is run from. Handles bidirectional syncing with version tracking and interactive prompts.

## Overview

The script manages synchronization of Cursor rules across multiple projects. Source directory is `~/PycharmProjects/cursor-rules-and-prompts/.cursor`. Destination directories include:
- All other directories in `~/PycharmProjects/` (excluding source)
- The current directory if the script is run from outside `~/PycharmProjects/`

The script can be run from anywhere in the system. If run from the source directory or from another directory within `~/PycharmProjects/`, behavior remains unchanged. If run from outside `~/PycharmProjects/`, that directory is automatically included as a destination.

See: [sync-cursor.sh](../sync-cursor.sh)

## Features

- **Interactive sync mode**: Choose to sync only rules or everything
- **Bidirectional sync**: Checks destinations for updates before syncing
- **Version tracking**: Uses [meta.json](../.cursor/meta.json) to track versions
- **Permission-based updates**: Prompts before updating source from destinations
- **Automatic versioning**: Increments version by 0.0.1 when source is updated

## Setup

To run the script from any directory, add an alias to `~/.zshrc`:

```bash
# Cursor rules sync script
alias sync-cursor="~/PycharmProjects/cursor-rules-and-prompts/sync-cursor.sh"
```

After adding the alias, reload your shell configuration:

```bash
source ~/.zshrc
```

Now you can run `sync-cursor` from any directory.

## Usage

Run from any directory using the alias:

```bash
sync-cursor
```

Or run directly with the full path:

```bash
~/PycharmProjects/cursor-rules-and-prompts/sync-cursor.sh
```

The script uses absolute paths and automatically detects where it's being run from. Behavior depends on the current directory:

- **From source directory** (`~/PycharmProjects/cursor-rules-and-prompts`): Normal operation, current directory is not treated as a destination
- **From another directory in `~/PycharmProjects/`**: Normal operation, current directory is already included in destinations
- **From outside `~/PycharmProjects/`**: Current directory is automatically added as a destination and will be synced

## How It Works

### 1. Sync Mode Selection

Prompts for sync type:
- **Default (Y or blank)**: Syncs only the `rules/` directory
- **N**: Syncs everything in `.cursor/` including `meta.json`

### 2. Destination Detection

The script automatically detects destination directories:
- All directories in `~/PycharmProjects/` (excluding source)
- Current directory if it's outside `~/PycharmProjects/`

### 3. Update Detection

Scans all destination directories for:
- New files that don't exist in source
- Updated files with newer modification times

Excludes `meta.json` from comparison since it's managed separately.

### 4. Source Update (if needed)

If updates are found in any destination:
- Lists new and updated files
- Prompts for permission before updating source
- Syncs from destination to source (excluding `meta.json`)

### 5. Version Increment

When source is updated:
- Reads current version from `meta.json`
- Increments patch version by 1 (e.g., 1.0.0 → 1.0.1)
- Updates `last_updated` field with current date (YYYY-MM-DD)

### 6. Destination Sync

Syncs updated source to all destinations:
- Creates `.cursor/` directory if missing
- Syncs based on selected mode (rules only or everything)
- When syncing everything, includes updated `meta.json`

## Version Tracking

Version is tracked in [meta.json](../.cursor/meta.json) with this structure:

```json
{
    "version": "1.0.0",
    "last_updated": "2025-11-17"
}
```

The script automatically:
- Creates `meta.json` with version 1.0.0 if missing
- Increments version when source is updated
- Updates `last_updated` date on each version increment

## JSON Parsing

The script supports multiple JSON parsing methods (in order of preference):
1. `jq` - Most reliable, preserves formatting
2. `python3` - Fallback option
3. Basic `grep`/`sed` - Last resort for simple JSON

## Sync Behavior

### Rules Only Mode
- Syncs only `rules/` directory
- Preserves existing `meta.json` in destinations
- Uses `rsync --delete` to remove files not in source

### Everything Mode
- Syncs entire `.cursor/` directory
- Includes `meta.json` with updated version
- Uses `rsync --delete` to match source exactly

## File Exclusions

- `meta.json` is excluded when syncing from destinations to source
- `meta.json` is included when syncing everything from source to destinations
- `meta.json` is excluded from update comparison checks

## Error Handling

- Exits if source directory doesn't exist
- Creates `meta.json` if missing
- Handles missing JSON parsing tools gracefully
- Continues processing even if individual destinations fail

## Output

The script provides colored output:
- **Blue [INFO]**: General information
- **Green [SUCCESS]**: Successful operations
- **Yellow [WARNING]**: Warnings (e.g., missing directories)
- **Red [ERROR]**: Errors that stop execution

## Requirements

- `rsync` - For file synchronization
- `bash` - Shell interpreter
- One of: `jq`, `python3`, or basic shell tools for JSON parsing

## Example Workflow

1. Run script from any directory: `sync-cursor` (or use full path)
2. Script detects current directory and includes it as destination if outside `~/PycharmProjects/`
3. Choose sync mode: `Y` (rules only) or `n` (everything)
4. Script checks all destinations (including current directory if applicable) for updates
5. If updates found, prompts: "Do you want to update source from [dir]? (y/n)"
6. If source updated, version increments automatically
7. Source syncs to all destinations (including current directory if applicable)
8. Shows final version and completion message

## Running from Different Locations

### From Source Directory
```bash
cd ~/PycharmProjects/cursor-rules-and-prompts
sync-cursor
```
Current directory is not treated as a destination. All other directories in `~/PycharmProjects/` are synced.

### From Another Project in PycharmProjects
```bash
cd ~/PycharmProjects/my-other-project
sync-cursor
```
Current directory is already included in the standard destinations list. No special handling needed.

### From Outside PycharmProjects
```bash
cd ~/Documents/my-project
sync-cursor
```
Current directory (`~/Documents/my-project`) is automatically added as a destination. It will:
- Be checked for new or updated files
- Prompt to sync updates to source if found
- Receive synced content from source


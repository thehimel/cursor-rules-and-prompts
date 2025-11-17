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
- **`.syncignore` support**: Exclude files and patterns from syncing (like `.gitignore`)
- **`.syncinclude` support**: Whitelist mode - sync only specified patterns (takes precedence over `.syncignore`)

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
- **Note**: Only directories that already have a `.cursor/` directory are synced. Directories without `.cursor/` are skipped.

### 3. Update Detection

Scans all destination directories for:
- New files that don't exist in source
- Updated files with newer modification times

Excludes `meta.json`, `.syncignore`, and `.syncinclude` from comparison since they're managed separately.

### 4. Source Update (if needed)

If updates are found in any destination:
- Lists new and updated files
- Prompts for permission before updating source
- Syncs from destination to source (excluding `meta.json` and respecting destination's `.syncinclude` or `.syncignore` patterns)

### 5. Version Increment

When source is updated:
- Reads current version from `meta.json`
- Increments patch version by 1 (e.g., 1.0.0 → 1.0.1)
- Updates `last_updated` field with current date (YYYY-MM-DD)

### 6. Destination Sync

Syncs updated source to all destinations:
- Skips destinations that don't have a `.cursor/` directory
- Respects patterns from both source and destination `.syncinclude` files (whitelist mode) or `.syncignore` files (blacklist mode)
- `.syncinclude` takes precedence over `.syncignore` when both exist
- Syncs based on selected mode (rules only or everything)
- When syncing everything, includes updated `meta.json` (unless `.syncinclude` excludes it)

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

### Managed Files

- `meta.json` is excluded when syncing from destinations to source
- `meta.json` is included when syncing everything from source to destinations
- `meta.json` is excluded from update comparison checks
- `.syncignore` is never synced to destinations (always excluded)
- `.syncinclude` is never synced to destinations (always excluded)

### .syncignore Support

The script supports `.syncignore` files that work like `.gitignore` for the `.cursor` directory. This allows you to exclude specific files or patterns from syncing.

#### How It Works

1. **Source `.syncignore`**: Patterns in `~/PycharmProjects/cursor-rules-and-prompts/.cursor/.syncignore` are applied when syncing to destinations
2. **Destination `.syncignore`**: Patterns in destination `.cursor/.syncignore` files are also respected when syncing to that destination
3. **Combined patterns**: When syncing to destinations, patterns from both source and destination `.syncignore` files are combined
4. **Never synced**: The `.syncignore` file itself is never copied to destinations
5. **Bidirectional**: When syncing from destination to source, only the destination's `.syncignore` patterns are used

#### Usage

Create a `.syncignore` file in your `.cursor` directory with patterns to exclude:

```bash
# Example .syncignore
*.log
temp/
*.cache
backup/
# Comments are supported
```

#### Pattern Syntax

The `.syncignore` file uses the same pattern syntax as `.gitignore`:
- `*.ext` - Exclude all files with extension `.ext`
- `directory/` - Exclude entire directory
- `file.txt` - Exclude specific file
- `# comment` - Comments (lines starting with `#` are ignored)
- Empty lines are ignored

#### Examples

**Exclude entire directories:**
```
# Exclude entire directory and all its contents
backup/
temp/
old-rules/
cache/
```

**Exclude specific files:**
```
# Exclude individual files
local-config.json
personal-notes.md
secrets.env
```

**Exclude files by pattern:**
```
# Exclude all temporary files
*.tmp
*.log
*.cache

# Exclude all files in a directory matching a pattern
backup/*.bak
temp/*.old
```

**Combined example - exclude directories and files:**
```
# Exclude directories
backup/
temp/
old-rules/

# Exclude specific files
local-config.json
secrets.env

# Exclude file patterns
*.tmp
*.log
```

### .syncinclude Support

The script supports `.syncinclude` files that act as a **whitelist** for syncing. If a `.syncinclude` file exists in source or destination, **only** the patterns defined in it will be synced, and everything else will be skipped.

#### How It Works

1. **Whitelist mode**: If `.syncinclude` exists in source or destination, only patterns listed in it are synced
2. **Takes precedence**: `.syncinclude` takes precedence over `.syncignore` (whitelist mode overrides blacklist mode)
3. **Combined patterns**: When syncing to destinations, patterns from both source and destination `.syncinclude` files are combined
4. **Never synced**: The `.syncinclude` file itself is never copied to destinations
5. **Bidirectional**: When syncing from destination to source, only the destination's `.syncinclude` patterns are used
6. **Parent directories**: Parent directories are automatically included to allow rsync traversal

#### Usage

Create a `.syncinclude` file in your `.cursor` directory with patterns to include:

```bash
# Example .syncinclude
rules/*
rules/code-style/*
meta.json
```

#### Pattern Syntax

The `.syncinclude` file uses the same pattern syntax as `.gitignore`:
- `*.ext` - Include all files with extension `.ext`
- `directory/*` - Include entire directory and all its contents
- `file.txt` - Include specific file
- `# comment` - Comments (lines starting with `#` are ignored)
- Empty lines are ignored

**Important**: When using `.syncinclude`, only the patterns listed will be synced. If `meta.json` is not in the include list, it won't be synced (even in "everything" mode).

#### Examples

**Include entire directories:**
```gitignore
# Include entire directory and all its contents
rules/*
rules/code-style/*
rules/organization/*
prompts/*
```

**Include specific files:**
```
# Include individual files
meta.json
rules/code-style/imports.mdc
rules/organization/file-organization.mdc
prompts/common-prompts.md
```

**Include files by pattern:**
```
# Include all files with specific extension
*.mdc
*.json

# Include all files in a directory matching a pattern
rules/**/*.mdc
prompts/*.md
```

**Combined example - include directories and files:**
```
# Include entire directories
rules/*
rules/code-style/*
prompts/*

# Include specific files
meta.json
config.json

# Include file patterns
*.mdc
*.json
```

**Real-world example - sync only essential rules:**
```
# Include only essential rule directories
rules/code-style/*
rules/organization/*
rules/documentation/*

# Include meta.json for version tracking
meta.json
```

#### Quick Reference: Common Use Cases

| Use Case                                     | `.syncignore` Example                 | `.syncinclude` Example              |
|----------------------------------------------|---------------------------------------|-------------------------------------|
| **Exclude/Include entire directory**         | `backup/`                             | `rules/*`                           |
| **Exclude/Include specific file**            | `secrets.env`                         | `meta.json`                         |
| **Exclude/Include all files with extension** | `*.tmp`                               | `*.mdc`                             |
| **Exclude/Include files in subdirectory**    | `temp/*.old`                          | `rules/**/*.mdc`                    |
| **Exclude/Include multiple directories**     | `backup/`<br>`temp/`<br>`cache/`      | `rules/*`<br>`prompts/*`<br>`config/*` |
| **Exclude/Include mixed (dirs + files)**     | `backup/`<br>`secrets.env`<br>`*.tmp` | `rules/*`<br>`meta.json`<br>`*.mdc`  |

#### Priority

When both `.syncinclude` and `.syncignore` exist:
- **`.syncinclude` takes precedence** - Only patterns in `.syncinclude` are synced
- `.syncignore` is ignored when `.syncinclude` is present

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


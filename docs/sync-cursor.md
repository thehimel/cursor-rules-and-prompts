# Cursor Rules Sync Script

Syncs the `.cursor` directory from the source repository to all other projects in `~/PycharmProjects/`. Uses path-based syncing with ID-based file matching for handling renames and updates.

## Overview

The script manages one-way synchronization of Cursor rules and prompts across multiple projects. Source directory is `~/PycharmProjects/cursor-rules-and-prompts/.cursor`. Destination directories are all other directories in `~/PycharmProjects/` that have both a `.cursor` directory and a `.include` file.

**Note**: The `fetch-cursor-rules.sh` script is deprecated and no longer used. All synchronization is handled by `sync-cursor.sh`.

See: [sync-cursor.sh](../sync-cursor.sh)

## Features

- **One-way sync**: Source → Destinations only (no bidirectional sync)
- **Path-based syncing**: Uses `.include` file to specify what to sync (no interactive mode selection)
- **ID-based matching**: Matches files by unique ID in frontmatter, handles renames and ID updates
- **Recursive directory inclusion**: Automatically includes all subdirectories when a directory pattern is specified
- **Single configuration file**: Uses `.include` file (replaces `.syncignore` and `.syncinclude`)
- **Orphaned file cleanup**: Removes files in destinations that no longer exist in source
- **Specific directory sync**: Can sync to a single directory by passing it as an argument

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

### Sync to All Destinations

Run from any directory:

```bash
sync-cursor
```

Or run directly with the full path:

```bash
~/PycharmProjects/cursor-rules-and-prompts/sync-cursor.sh
```

The script will:
1. Find all directories in `~/PycharmProjects/` (excluding source)
2. Only sync to directories that have both `.cursor/` directory and `.include` file
3. Skip directories without `.cursor/` or without `.include` file (with warnings)

### Sync to Specific Directory

Pass the directory path as an argument:

```bash
sync-cursor /path/to/specific/project
```

The script will:
1. Validate that the directory exists and has `.cursor/` directory
2. Check for `.include` file
3. Sync only to that directory

## How It Works

### 1. Destination Detection

The script automatically detects destination directories:
- All directories in `~/PycharmProjects/` (excluding source: `cursor-rules-and-prompts`)
- **Requirement**: Directory must have both `.cursor/` directory and `.include` file
- Directories without `.cursor/` are skipped with info message
- Directories without `.include` file (or empty `.include`) are skipped with warning

### 2. Pattern Processing

The script reads patterns from `.include` files:
- **Source `.include`**: `~/PycharmProjects/cursor-rules-and-prompts/.cursor/.include`
- **Destination `.include`**: `{destination}/.cursor/.include`
- Patterns from both files are combined
- Patterns without `!` prefix are **inclusions**
- Patterns with `!` prefix are **exclusions**

### 3. Pattern Expansion

For directory patterns (ending with `/`), the script automatically generates recursive patterns:
- `prompts/` → includes `prompts/`, `prompts/*`, `prompts/*/`, `prompts/*/*/`, etc. (up to 20 levels deep)
- This ensures all subdirectories are included recursively

### 4. File Synchronization

Uses `rsync` with the generated include/exclude patterns:
- **Whitelist mode**: If include patterns exist, only those are synced
- **Blacklist mode**: If only exclude patterns exist, everything except those is synced
- **Normal mode**: If no patterns, syncs everything (except `.include` file itself)
- Uses `--delete` to remove files not in source

### 5. ID-Based Matching

After `rsync` completes, the script processes ID-based matching:
- Extracts unique `id` from frontmatter of each file
- Matches files by ID first, then falls back to filename
- Handles file renames: if source file has same ID but different name, renames target file
- Handles ID updates: if filename same but ID changed, updates the file
- Cleans up orphaned files: removes files in destination whose IDs no longer exist in source

## ID-Based File Matching

### How It Works

Each rule and prompt file should have a unique `id` in its frontmatter:

```yaml
---
id: rule-academic-copyright-and-genericity
alwaysApply: true
description: Copyright and genericity guidelines
author: Himel Das
---
```

The script uses this ID to:
1. **Match files across locations**: Even if filename changes, same ID = same file
2. **Handle renames**: If source file is renamed but ID stays same, target file is renamed
3. **Detect ID changes**: If filename same but ID changes, file is updated
4. **Clean up orphans**: Files in destination with IDs not in source are removed

### ID Format

- **Rules**: `rule-{category}-{filename-without-ext}`
  - Example: `rule-academic-copyright-and-genericity`
- **Prompts**: `prompt-{filename-without-ext}`
  - Example: `prompt-architecture-diagram-generation`

### Fallback Behavior

If a file doesn't have an ID:
- Script falls back to filename-based matching
- File is still synced, but rename detection won't work

## .include File

The `.include` file replaces both `.syncignore` and `.syncinclude`. It uses a single file where:
- Patterns without `!` are **inclusions** (whitelist)
- Patterns with `!` prefix are **exclusions** (blacklist)
- Similar to `.gitignore` but inverted (inclusions are default)

### Location

- **Source**: `~/PycharmProjects/cursor-rules-and-prompts/.cursor/.include`
- **Destination**: `{destination}/.cursor/.include`
- Patterns from both files are combined

### Pattern Syntax

- `pattern` - Include this pattern
- `!pattern` - Exclude this pattern
- `# comment` - Comments (lines starting with `#` are ignored)
- Empty lines are ignored
- Directory patterns ending with `/` are recursively expanded

### Examples

**Include only rules and prompts:**

```bash
# Include rules directory (recursively)
rules/

# Include prompts directory (recursively)
prompts/
```

**Include specific subdirectories:**

```bash
# Include only specific rule categories
rules/academic/
rules/documentation/

# Include prompts
prompts/

# Exclude a specific subdirectory
!rules/academic/old/
```

**Include with exclusions:**

```bash
# Include rules but exclude old rules
rules/
!rules/old/
!rules/deprecated/

# Include prompts but exclude specific files
prompts/
!prompts/temp.md
```

**Exclude patterns only (blacklist mode):**

```bash
# Exclude temporary files
!*.tmp
!*.log
!temp/
!backup/
```

### Recursive Directory Inclusion

When you specify a directory pattern (ending with `/`), all subdirectories are automatically included:

```bash
# This includes:
# - prompts/
# - prompts/html-to-markdown/
# - prompts/html-to-markdown/subdir/
# - All files at any depth
prompts/
```

The script generates patterns up to 20 levels deep automatically.

### Pattern Conflicts

If the same pattern appears in both include and exclude:
- **Include takes precedence** (warning is logged)
- Example: `rules/` and `!rules/` → `rules/` is included

### Important Notes

- The `.include` file itself is **never synced** (always excluded)
- If no `.include` file exists or it's empty, the directory is **skipped** with a warning
- Both source and destination `.include` files are read and combined
- Patterns are relative to `.cursor/` directory

## File Processing Flow

1. **Read `.include` files** (source + destination)
2. **Parse patterns** (inclusions and exclusions)
3. **Expand directory patterns** (recursive inclusion)
4. **Run rsync** with generated patterns
5. **Build ID mappings** (source and destination)
6. **Process ID matching** (handle renames, updates)
7. **Cleanup orphaned files** (remove files not in source)

## Error Handling

- Exits if source directory doesn't exist
- Skips destinations without `.cursor/` directory (with info message)
- Skips destinations without `.include` file (with warning)
- Continues processing even if individual destinations fail
- Logs warnings for pattern conflicts
- Handles missing ID gracefully (falls back to filename)

## Output

The script provides colored output:
- **Blue [INFO]**: General information and progress
- **Green [SUCCESS]**: Successful operations
- **Yellow [WARNING]**: Warnings (e.g., missing `.include` files, pattern conflicts)
- **Red [ERROR]**: Errors that stop execution

Progress messages show: `Synced to X/Y destinations` after each successful sync.

## Requirements

- `rsync` - For file synchronization
- `bash` - Shell interpreter
- `awk`, `grep`, `sed` - Text processing (standard Unix tools)

## Example Workflow

1. Create `.include` file in source: `~/PycharmProjects/cursor-rules-and-prompts/.cursor/.include`
   ```bash
   rules/
   prompts/
   ```

2. Create `.include` file in destination: `~/PycharmProjects/my-project/.cursor/.include`
   ```bash
   rules/academic/
   prompts/
   ```

3. Run sync: `sync-cursor`

4. Script will:
   - Read both `.include` files
   - Combine patterns (rules/, prompts/, rules/academic/)
   - Sync matching files from source to destination
   - Process ID-based matching (handle renames)
   - Clean up orphaned files

## Deprecated Scripts

### fetch-cursor-rules.sh

The `fetch-cursor-rules.sh` script is **deprecated** and no longer used. All functionality has been migrated to `sync-cursor.sh`. The new script provides:

- Better ID-based matching
- Simpler configuration (single `.include` file)
- Path-based syncing (no interactive prompts)
- Recursive directory inclusion
- Improved error handling

If you have any references to `fetch-cursor-rules.sh`, please update them to use `sync-cursor.sh` instead.

## Migration from Old Scripts

If you were using the old scripts, here's what changed:

### From fetch-cursor-rules.sh

- **No longer needed**: The script is deprecated
- **Use**: `sync-cursor.sh` instead
- **Configuration**: Create `.include` file instead of using GitHub repository

### From Old sync-cursor.sh (with .syncignore/.syncinclude)

1. **Combine files**: Merge `.syncignore` and `.syncinclude` into single `.include` file
2. **Add exclusions**: Prefix exclusion patterns with `!`
3. **Remove interactive prompts**: No more "sync only rules?" prompt - it's path-based now
4. **Remove meta.json**: Version tracking is no longer used

### Example Migration

**Old `.syncinclude`:**
```
rules/
prompts/
```

**Old `.syncignore`:**
```
*.tmp
backup/
```

**New `.include`:**
```
rules/
prompts/
!*.tmp
!backup/
```

## Troubleshooting

### Directory Not Syncing

**Problem**: Directory has `.cursor/` but nothing is syncing.

**Solution**: 
- Check if `.include` file exists in `.cursor/` directory
- Check if `.include` file has non-empty, non-comment lines
- Script will warn if `.include` is missing or empty

### Subdirectories Not Included

**Problem**: Added `prompts/` but subdirectories like `prompts/html-to-markdown/` are not syncing.

**Solution**: 
- Ensure pattern ends with `/` (e.g., `prompts/` not `prompts`)
- Script automatically expands directory patterns recursively
- Check that subdirectories aren't excluded by `!` patterns

### Files Not Renaming

**Problem**: File renamed in source but still has old name in destination.

**Solution**:
- Ensure both source and destination files have `id` in frontmatter
- Check that IDs match between source and destination
- Script uses ID-based matching for renames

### Orphaned Files Not Removed

**Problem**: Files deleted in source still exist in destination.

**Solution**:
- Ensure files have `id` in frontmatter
- Script only removes files with IDs that no longer exist in source
- Files without IDs won't be automatically cleaned up

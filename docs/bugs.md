# Bugs

None currently reported.

## Known Behavior (Not Bugs)

### Files in Destination Not in Source Are Removed

**Behavior**: When syncing, files that exist in the destination but not in the source are automatically removed.

**Why**: This is expected behavior with one-way sync (`--delete` flag). The script ensures destinations match the source exactly (based on `.include` patterns). Files added directly to destinations will be removed on the next sync.

**Solution**: 
- Add files to the source repository first, then sync
- Or exclude the destination directory from syncing if you need destination-specific files
- Files with IDs that no longer exist in source are considered "orphaned" and are cleaned up automatically

# Equation-Based DRY Prompting: Optimization Results

This document tracks the results of applying **Equation-Based DRY Prompting (EBDP)** to various prompts.

## Results Table

| File | Before (Chars) | Before (Lines) | After (Chars) | After (Lines) | Reduction (Chars) | Reduction (Lines) | Commit |
|------|----------------|---------------|--------------|--------------|-------------------|------------------|--------|
| [transcript-to-markdown.md](../../.cursor/prompts/transcript-to-markdown.md) | 13,892 | 267 | 3,514 | 95 | 74.7% | 64.4% | [79d223c](https://github.com/thehimel/cursor-rules-and-prompts/commit/79d223cbb924ded5d7bf729e6db2641214d69bdc) |
| [course-structure-folder-hierarchy.md](../../.cursor/prompts/course-structure-folder-hierarchy.md) | - | 225 | - | 82 | - | 63.6% | - |

## Notes

- **Characters**: Total character count (including spaces)
- **Lines**: Total line count
- **Reduction**: Percentage reduction from before to after
- **Commit**: GitHub commit link showing the optimization changes

## Adding New Results

When adding new optimization results:
1. Measure before and after (characters and lines)
2. Calculate reduction percentages
3. Get the commit hash/link
4. Add a new row to the table

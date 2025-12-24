---
id: course-structure-folder-hierarchy
description: Prompt for creating course folder structure with chapters and lessons from screenshots or chapter overviews, following naming conventions and creating README files
author: Himel Das
---

# Create Course Structure from Screenshots

## Purpose

Create course folder structure with numbered chapters and lessons from screenshots/overviews, following naming conventions and generating README files.

## Input Requirements

Provide: screenshots/chapter overviews, target course directory, optional naming preferences.

## Core Rules

### Numbering Format

For count `c` items at each level:
- `c ≤ 9` → format = `N` (1, 2, 3, ...)
- `c ≥ 10` → format = `NN` (01, 02, 03, ...)
- Apply consistently within each level

**Lesson Numbering**:
- Source shows numbers: use exact, preserve course-wide sequence
- Source doesn't show: number sequentially from `1` or `01` within chapter
- Individual number format: `n < 10` → `N`, `n ≥ 10` → `NN`

### Same-Level Items Rule

`visual_level(item) = folder_level(item)`. Only create sections if there's clear hierarchical grouping with nested items.

### Content Guidelines

No copyrighted content. Lesson READMEs: title only. Chapter READMEs: generic descriptions from screenshots.

## Process

### Analyze Screenshots

Extract chapter/lesson titles and descriptions. Count chapters and lessons. Determine hierarchy using **Same-Level Items Rule**. Note if lesson numbers are shown in source.

### Create Folder Structure

**Pattern**: `{N|NN}-{kebab-case-name}` where `{N|NN}` follows **Numbering Format**.

- **Chapters**: `{N|NN}-chapter-name`, sequential from `1` or `01`
- **Lessons**: `{N|NN}-lesson-name`, apply **Lesson Numbering Logic** + **Same-Level Items Rule**
- **Sections** (if hierarchical): `{N|NN}-section-name` → lessons within, apply both rules

### Create README Files

- **Chapter**: `README.md` → `# Chapter {N|NN}: [Title]` + generic description
- **Lesson**: `README.md` → `# [Title]`
- Apply **Content Guidelines**, end with exactly `1` newline

## Output Structure

```
course-directory/
├── README.md
├── {N|NN}-chapter-name/
│   ├── README.md
│   ├── {N|NN}-lesson-name/
│   │   └── README.md
│   └── {N|NN}-section-name/ (if hierarchical)
│       ├── README.md
│       └── {N|NN}-lesson-name/
│           └── README.md
└── ...
```

## Guidelines

Follow all **Core Rules** consistently. Use numbered prefixes, lowercase with dashes, concise names. Create README files for all chapters and lessons.

## Verification

Verify: naming = `{N|NN}-{kebab-case}`, **Numbering Format** consistent, sequential numbering, `README.md` present for all chapters/lessons, **Content Guidelines** followed, file endings = `1` newline.

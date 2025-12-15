---
id: course-structure-folder-hierarchy
description: Prompt for creating course folder structure with chapters and lessons from screenshots or chapter overviews, following naming conventions and creating README files
author: Himel Das
---

# Create Course Structure from Screenshots

## Purpose

This prompt guides the creation of a complete course folder structure with chapters and lessons based on screenshots or chapter overview pages. It creates numbered directories following naming conventions and generates README files for each chapter and lesson.

## Input Requirements

When using this prompt, provide:

1. **Screenshots or chapter overviews** - Images showing chapter titles, lesson lists, and descriptions
2. **Target course directory** - The base directory where the course structure should be created
3. **Naming preferences** (optional) - Any specific naming conventions to follow

## Process

### Analyze Screenshots

- Extract chapter titles and descriptions from screenshots
- Identify all lessons within each chapter
- Count total number of chapters and lessons per chapter
- Note any section groupings or hierarchical structures
- Extract lesson titles and any descriptions

### Determine Numbering Format

- **For chapters**: Count total chapters
  - If 9 or fewer chapters: use single digits (1, 2, 3, ...)
  - If 10 or more chapters: use zero-padded double digits (01, 02, 03, ...)
- **For lessons**: Count lessons within each chapter
  - If 9 or fewer lessons: use single digits (1, 2, 3, ...)
  - If 10 or more lessons: use zero-padded double digits (01, 02, 03, ...)
- **For sections**: Count sections within each chapter
  - If 9 or fewer sections: use single digits (1, 2, 3, ...)
  - If 10 or more sections: use zero-padded double digits (01, 02, 03, ...)

### Create Folder Structure

#### Chapter Folders

- Create numbered chapter folders using format: `N-chapter-name` or `NN-chapter-name`
- Use single digits (1, 2, 3, ...) if 9 or fewer chapters
- Use zero-padded double digits (01, 02, 03, ...) if 10 or more chapters
- Use lowercase with dashes separating words
- Make names concise (e.g., "introduction" → "intro")
- Number chapters sequentially starting from 1 or 01

#### Lesson Folders

- Create numbered lesson folders within each chapter: `N-lesson-name` or `NN-lesson-name`
- Use single digits (1, 2, 3, ...) if 9 or fewer lessons in the chapter
- Use zero-padded double digits (01, 02, 03, ...) if 10 or more lessons in the chapter
- Use lowercase with dashes separating words
- Make names concise and descriptive
- Number lessons sequentially within each chapter starting from 1 or 01

#### Section Folders (if applicable)

- If lessons are grouped into sections, create section folders first
- Format: `N-section-name` or `NN-section-name`
- Use single digits if 9 or fewer sections, zero-padded double digits if 10 or more
- Then create lesson folders within sections: `N-lesson-name` or `NN-lesson-name`
- Apply same numbering logic for lessons within sections
- Number sections and lessons sequentially within their parent

### Create README Files

#### Chapter README Files

- Create `README.md` in each chapter folder
- Include chapter title as main heading: `# Chapter N: [Chapter Title]`
- Include chapter description from screenshot if available
- Keep descriptions generic and avoid copyrighted content

#### Lesson README Files

- Create `README.md` in each lesson folder
- Include lesson title as main heading: `# [Lesson Title]`
- Keep content minimal initially (just the title)
- Do not include copyrighted course content

### Naming Conventions

- **Format**: Lowercase words separated by dashes
- **Prefix**: Number followed by dash
  - Single digit format: `1-intro-to-topic`, `2-chapter-name` (for 9 or fewer items)
  - Double digit format: `01-intro-to-topic`, `02-chapter-name` (for 10 or more items)
- **Numbering Logic**:
  - Count total items at each level (chapters, lessons, sections)
  - Use single digits (1-9) if count is 9 or fewer
  - Use zero-padded double digits (01-99) if count is 10 or more
  - Apply consistently within each level
- **Conciseness**: Shorten common words:
  - "introduction" → "intro"
  - "application" → "app"
  - "utilizing" → "using" (if appropriate)
  - "conversations" → "conversations" (keep if no good short form)
- **Clarity**: Ensure names are descriptive and clear

## Output Structure

The final structure should follow this pattern:

**Example with 9 or fewer chapters/lessons (single digits):**
```
course-directory/
├── README.md (course-level)
├── 1-chapter-name/
│   ├── README.md (chapter description)
│   ├── 1-lesson-name/
│   │   └── README.md (lesson title)
│   ├── 2-lesson-name/
│   │   └── README.md
│   └── ...
├── 2-chapter-name/
│   ├── README.md
│   ├── 1-section-name/
│   │   ├── README.md
│   │   ├── 1-lesson-name/
│   │   │   └── README.md
│   │   └── ...
│   └── ...
└── ...
```

**Example with 10 or more chapters/lessons (zero-padded double digits):**
```
course-directory/
├── README.md (course-level)
├── 01-chapter-name/
│   ├── README.md (chapter description)
│   ├── 01-lesson-name/
│   │   └── README.md (lesson title)
│   ├── 02-lesson-name/
│   │   └── README.md
│   └── ...
├── 02-chapter-name/
│   ├── README.md
│   ├── 01-section-name/
│   │   ├── README.md
│   │   ├── 01-lesson-name/
│   │   │   └── README.md
│   │   └── ...
│   └── ...
└── ...
```

## Guidelines

- Always use numbered prefixes for chapters and lessons
- Determine numbering format based on count:
  - Single digits (1-9) for 9 or fewer items
  - Zero-padded double digits (01-99) for 10 or more items
- Apply numbering format consistently within each level (chapters, lessons, sections)
- Maintain sequential numbering within each level
- Use lowercase with dashes for all folder names
- Keep names concise but descriptive
- Create README files for all chapters and lessons
- Include chapter descriptions in chapter READMEs when available
- Keep lesson READMEs minimal (title only) initially
- Do not include copyrighted content in README files
- Ensure all README files end with exactly one newline character

## Verification

After creating the structure:

- Verify all folders follow naming conventions
- Confirm numbering format is consistent (single digits for ≤9 items, double digits for ≥10 items)
- Verify sequential numbering is correct within each level
- Check that all chapters and lessons have README files
- Ensure README files have appropriate content
- Verify no copyrighted content is included
- Confirm file endings have exactly one newline

## Remember

- The goal is to create a clean, organized folder structure
- Naming should be consistent and follow conventions
- Numbering format depends on count: single digits (≤9) or zero-padded double digits (≥10)
- Apply numbering format consistently within each level
- README files provide structure, not content
- Avoid including any copyrighted material
- Structure should be ready for content to be added later
- Numbering helps maintain order and navigation, especially for alphabetical sorting

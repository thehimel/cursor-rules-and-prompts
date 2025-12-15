---
id: prompt-organize-questions-by-topic
alwaysApply: false
description: Generic prompt for organizing questions or content items by topic/theme while preserving all original content and sequence numbers
author: Himel Das
---

# Organize Questions by Topic

## Task Description

When given a collection of questions or content items that are sequentially ordered, organize them into topic-based groups while maintaining all original content exactly as provided. This operation is purely organizational - grouping related items together for easier study and reference.

## Input Formats

The input can be provided in various formats:

- **Multiple sequential files**: Files numbered sequentially (e.g., `001-050.md`, `051-100.md`, `101-150.md`)
- **Single file**: All questions in one file
- **Plain text**: Questions provided as text in the conversation
- **Mixed formats**: Combination of the above

## Core Requirements

### Content Preservation

- **Do not change a single letter** of the original question content
- Preserve all original sequence numbers exactly as they appear
- Maintain all formatting, including markdown, images, code blocks, and special characters
- Keep all answer explanations and metadata exactly as provided
- Preserve image file references and ensure paths remain correct

### Organization Structure

1. **Analyze all questions** to identify common themes and topics
2. **Create topic categories** based on the content themes found
3. **Group related questions** together within each topic
4. **Order similar questions** one after another when they cover the same concept
5. **Maintain sequence numbers** - questions keep their original numbering even when grouped

### File Structure

- Create a `README.md` file listing all topics with brief descriptions
- Create individual topic files (e.g., `01-topic-name.md`, `02-another-topic.md`)
- Use `##` headings for topics in the README
- Use `###` headings for individual questions (maintaining original format)
- Use kebab-case for topic filenames (e.g., `basic-concepts.md`, `advanced-topics.md`)

### Topic Files Format

Each topic file should include:

1. **Title**: Descriptive topic name
2. **Summary**: English summary explaining the key concepts covered in that topic, written so that studying the summary enables answering all questions in that topic
3. **Questions**: All questions belonging to that topic, maintaining original sequence numbers and formatting

### Grouping Rules

- Group questions that share the same core concept or theme
- Place duplicate or very similar questions together (e.g., if the same question appears in multiple versions, group them)
- Order questions logically within each topic (similar questions adjacent to each other)
- Ensure every question is assigned to exactly one topic
- Verify all questions are included (no questions should be missing)

### Image and Resource Handling

- Preserve all image references exactly as they appear in the original
- Ensure image paths remain correct relative to the file structure
- Maintain any other resource references (links, files, etc.)

## Process Steps

1. **Read and analyze** all input files to understand the full scope of questions
2. **Identify topics** by analyzing question content and themes
3. **Create topic structure** in README.md with clear descriptions
4. **Extract and categorize** each question into appropriate topic files
5. **Group similar questions** together within each topic
6. **Add summaries** to each topic file explaining the key concepts
7. **Verify completeness** - ensure all questions are included and properly categorized
8. **Check formatting** - ensure all markdown, images, and special formatting is preserved

## Output Structure

```
target-directory/
├── README.md                    # Overview with topic list
├── 01-topic-name.md            # Topic file with questions
├── 02-another-topic.md         # Another topic file
├── ...
└── images/                      # Image resources (if applicable)
    └── ...
```

## Quality Checklist

Before completion, verify:

- ✅ All original questions are included
- ✅ All sequence numbers are preserved
- ✅ No content has been modified
- ✅ Similar questions are grouped together
- ✅ Each topic has a clear summary
- ✅ Image paths are correct
- ✅ README.md lists all topics
- ✅ File structure is organized and logical

## Important Notes

- This is a **grouping operation only** - no content modification
- Questions maintain their original sequence numbers for reference
- The goal is to make content easier to study by grouping related items
- All original formatting, languages, and structure must be preserved exactly


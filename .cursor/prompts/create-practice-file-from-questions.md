---
id: prompt-create-practice-file-from-questions
alwaysApply: false
description: Generic prompt for creating a practice/recall file from question sets by removing translations while preserving questions and answers
author: Himel Das
---

# Create Practice File from Questions

## Task Description

When given a collection of questions with translations and answer explanations, create a practice file that removes translations from the question text and options while preserving the original questions and answer sections. This enables users to practice recall by reading questions in the target language and checking answers immediately.

## Input Formats

The input can be provided in various formats:

- **Multiple sequential files**: Files numbered sequentially (e.g., `001-050.md`, `051-100.md`, `101-150.md`)
- **Single file**: All questions in one file
- **Files with translations**: Questions containing both source language and translated text
- **Mixed formats**: Combination of the above

## Core Requirements

### Content Processing

- **Remove translations** from question text and answer options (typically text in parentheses)
- **Preserve original language** text exactly as written
- **Remove bold formatting** from question text and options
- **Keep answer sections intact** in their original format with all explanations
- **Maintain question structure** including headings, numbering, and formatting
- **Preserve image references** exactly as they appear

### Answer Section Handling

- **Include answer sections** in the original format
- **Keep all answer content** including explanations and translations
- **Maintain answer formatting** (e.g., `> Answer: **option** - explanation`)
- **Preserve answer structure** for immediate checking

### File Structure

- Create a single consolidated file (e.g., `all.md`, `practice.md`, `recall.md`)
- Include all questions sequentially from the input files
- Maintain original question numbering
- Use appropriate heading structure (e.g., `### Question 1`, `### Aufgabe 1`)

## Process Steps

1. **Read all input files** to understand the structure and format
2. **Identify translation patterns** (typically text in parentheses after original text)
3. **Extract questions** maintaining original structure
4. **Remove translations** from question text and options
5. **Remove bold formatting** from questions and options
6. **Preserve answer sections** in their original format
7. **Combine all questions** into a single file
8. **Verify completeness** - ensure all questions are included
9. **Check formatting** - ensure structure is maintained

## Processing Rules

### Translation Removal

- Remove text in parentheses that appears to be translations
- Preserve the original language text exactly
- Handle cases where translations might be in different formats
- Be careful not to remove important content that happens to be in parentheses

### Formatting Cleanup

- Remove bold markers (`**`) from question text and options
- Preserve other formatting like lists, headings, and line breaks
- Maintain consistent spacing and structure

### Answer Preservation

- Keep answer sections exactly as they appear in the source
- Do not modify answer explanations
- Preserve answer formatting and structure
- Include all answer content for immediate verification

## Output Format

The output file should contain:

```
# Title

### Question 1
[Question text in original language without translations]
- a. [Option without translation]
- b. [Option without translation]
- c. [Option without translation]
- d. [Option without translation]
> Answer: [Original answer format with all content preserved]

### Question 2
...
```

## Quality Checklist

Before completion, verify:

- ✅ All questions are included
- ✅ Translations removed from questions and options
- ✅ Original language text preserved exactly
- ✅ Answer sections included and intact
- ✅ Question numbering maintained
- ✅ Image references preserved
- ✅ File structure is clean and readable
- ✅ No content has been accidentally removed

## Important Notes

- This operation **removes translations** but **preserves original content**
- Answer sections remain **fully intact** for immediate checking
- The goal is to create a **practice/recall file** for language learning
- All original formatting and structure should be maintained where appropriate
- The output enables users to practice by reading questions and checking answers


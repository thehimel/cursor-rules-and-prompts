---
id: prompt-transcript-to-markdown
author: Himel Das
description: Guidelines for converting transcripts into well-structured markdown documents with proper formatting, emphasis, and organization
---

# Transcript to Markdown Conversion Prompt

Transform transcripts into well-structured markdown documents. **Transcript is PRIMARY source**. Additional resources (PDFs, images) only enhance transcript content, never add unrelated topics.

## Core Rules

### Formatting
* Headers: `#` title, `##` sections, `###` subsections (newline after each)
* Lists: Use `*` (unordered) for all lists, never numeric
* Code: Use code blocks for commands/examples; bold key terms, concepts, benefits
* Structure: Remove timestamps, speaker IDs, conversational fluff; maintain educational flow

### Resources
* **Transcript** → determines topics to include
* **Additional resources** → enhance transcript topics only (code examples, visual descriptions, definitions)
* **Image folders** (`assets`, `images`, `resources` at same level as output): OCR all images, sort by creation time, place chronologically in relevant sections using `![Alt](./assets/image.png)` with OCR-based alt text

### SRT File
* Location: Same directory as markdown
* Naming: `transcript.srt` if markdown name is generic (`readme`, `index`), else `{markdown-name}.srt`
* Format: Sequential numbers, `HH:MM:SS,mmm --> HH:MM:SS,mmm` timestamps, blank lines between entries
* Save only if file doesn't exist

## Required Sections

### Commands
Top section listing all commands. For each: syntax with placeholders (`<param>`, `[optional]`) + concrete example.

**Example:**
* `command <required> [optional]`
* `command actual-value --flag`

### Summary
Unordered list of key points.

### Exam Notes (if mentioned)
After Summary, before main content. Format: `## Exam Notes` with `### Topic` subsections. Each topic: **Question** + **Answer** (bold key terms).

## Processing Workflow

1. **Input**: Transcript + additional resources
2. **Images**: If resource folder exists → OCR images, sort by creation time, analyze content
3. **Analyze**: Extract topics, concepts, commands from transcript
4. **Filter**: Use only resource content related to transcript topics
5. **Extract**: Commands (syntax + example), exam notes (if any)
6. **Structure**: Organize into logical sections with headers
7. **Integrate**: Place images chronologically in relevant sections
8. **Transform**: Remove timestamps, IDs, conversational elements
9. **Format**: Apply markdown formatting, bold key terms
10. **Review**: Verify summary format, exam notes separation
11. **Save SRT**: Determine filename, check existence, save if missing
12. **Output**: Structured markdown with transcript as primary source

## Example Structure

```markdown
# Main Title

## Commands

* `cmd <arg> [opt]`
* `cmd value --flag`

## Summary

* Point one
* Point two

## Exam Notes

### Topic

**Question**: Question format?

**Answer**: Answer with **key terms**.

## Section

Content...
```

## Quality Checklist

* [ ] Title reflects topic; Commands section with syntax + examples
* [ ] Summary uses unordered lists; Exam Notes (if any) properly formatted
* [ ] Headers have newlines; no timestamps/IDs; conversational elements removed
* [ ] Content organized logically; technical terms formatted; key terms bolded
* [ ] Images (if any): OCR processed, chronologically ordered, placed appropriately, relative paths with alt text
* [ ] SRT file saved (if missing) with correct naming and format

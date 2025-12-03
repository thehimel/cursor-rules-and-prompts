---
description: Prompt for creating markdown documentation from plain text and images while preserving 100% text match and applying proper formatting
author: Himel Das
---

# Create Markdown from Text and Images

## Purpose

This prompt guides the creation of markdown documentation files from plain text content and image files, ensuring 100% text preservation while applying proper markdown formatting and image insertion.

## Input Requirements

When using this prompt, provide:

1. **Plain text content** - The exact text content to be converted to markdown
2. **Images directory** - A directory containing image files
3. **Target file path** - Where the markdown file should be created (optional)

### Target File Path Determination

If target file path is not explicitly provided:

- **First priority**: Use the currently open file in the editor if it exists and is a markdown file
- **Second priority**: Intelligently determine the appropriate file path based on:
  - The context of the text content (section titles, topic)
  - The location of the images directory
  - Existing file structure and naming conventions
  - Create the file if it doesn't exist in the appropriate location

## Process

### Target File Determination

- If target file path is provided, use it
- If not provided, check for currently open markdown file in the editor
- If no open file, intelligently determine or create the appropriate file path based on content context and images directory location

### Text Preservation

- Preserve **100% of the original text content** exactly as provided
- Do not modify, remove, or add any text content
- Maintain all original sentences, paragraphs, and structure

### Markdown Formatting

Apply markdown formatting while preserving text:

- Convert section titles to appropriate markdown headers
- Apply bold formatting to key terms and important concepts when first introduced
- Use code formatting for code snippets, filenames, and technical terms
- Convert series of related items into bulleted or numbered lists when appropriate
- Maintain clear hierarchy with proper header levels

### Image Insertion

Insert images from the images directory:

- Match image filenames to section headers or content
- Place images immediately after their corresponding section headers
- Use relative paths from the markdown file to images directory
- Use descriptive alt text matching the section or image purpose

### Verification

Before finalizing:

- Verify all original text is preserved exactly
- Confirm all images are inserted in appropriate locations
- Check markdown syntax is correct
- Ensure relative paths to images are correct

### Final Verification and Confirmation

After creating the markdown content:

- Compare the final markdown file text content with the original text provided
- Strip all markdown formatting from the created file and compare with original text
- Verify that every word, sentence, and paragraph matches exactly
- Display a confirmation message indicating whether the content is 100% match
- If any discrepancies are found, identify and report them before finalizing

## Output Format

The final markdown file should:

- Contain 100% of the original text content unchanged
- Have proper markdown formatting applied
- Include all images with correct relative paths
- Follow markdown best practices for readability
- End with exactly one newline character

## Guidelines

- Determine target file path intelligently if not explicitly provided
- Use currently open file if available, otherwise find or create appropriate file
- Always preserve text content exactly as provided
- Apply markdown formatting without changing text
- Insert images based on filename-to-section matching
- Always use relative paths for images
- Ensure file ends with exactly one newline character

## Remember

- The goal is 100% text preservation with proper markdown formatting
- Images enhance but never replace text content
- Formatting should improve readability without changing meaning
- When in doubt, preserve the original text exactly as provided
- Always perform final verification and display confirmation message showing 100% text match status

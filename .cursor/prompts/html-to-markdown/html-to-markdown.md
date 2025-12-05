---
description: Prompt for converting HTML files to markdown documentation with organized directory structure, automatic sequence numbering, and asset management
author: Himel Das
---

# Convert HTML to Markdown Directory Structure

## Purpose

This prompt guides the conversion of HTML files into a structured markdown documentation format with organized directory structure, automatic sequence numbering, and proper asset management.

**⚡ Performance Note:** For optimal speed, use the included conversion script [convert.py](convert.py). 

**File Location:** The `convert.py` script is located in the **same directory as this prompt file**. When using it, reference it as: `[convert.py](convert.py)`

## Input Requirements

When using this prompt, provide:

1. **HTML file** - The HTML file to be converted to markdown
2. **Output directory** (optional) - If not provided, the output will be created in the same directory as the HTML file
3. **Screenshot** (optional) - A screenshot of the web page can be provided to better understand the overall layout and structure, especially helpful for accurately extracting code blocks and understanding the visual organization of content

**⚡ FASTEST METHOD:** Use the Python script [convert.py](convert.py) located in the same directory as this prompt - it completes the entire conversion in seconds. 

Simply run: `python convert.py <html_file> [screenshot_file]` from the directory containing the HTML file, or use the full path to [convert.py](convert.py) from your current location.

## Quick Start (Fast Method)

**For fastest conversion, use the provided Python script [convert.py](convert.py):**

**Important:** The `convert.py` script is located in the same directory as this prompt file.

1. **Option 1 - Navigate to prompt directory first:**
   ```bash
   cd [path-to-prompt-directory]
   python convert.py <html_file> [screenshot_file]
   ```

2. **Option 2 - Use full path to convert.py:**
   ```bash
   python [path-to-prompt-directory]/convert.py <html_file> [screenshot_file]
   ```

3. The script will automatically:
   - Extract source URL
   - Generate directory name and sequence number
   - Convert HTML to markdown
   - Copy assets
   - Verify content match
   - Clean up original files

The script completes the entire process in seconds. If you prefer manual step-by-step conversion, follow the detailed process below.

## Process

### Directory Name Generation

Generate the directory name from the HTML filename:

1. Remove the `.html` extension from the filename
2. Convert to lowercase
3. Replace `&` with `and`
4. Remove all special characters except spaces and hyphens
5. Replace spaces with hyphens
6. Replace multiple consecutive hyphens with a single hyphen
7. Remove leading and trailing hyphens

### Sequence Numbering

Determine the sequence number for the directory:

1. Scan the current directory for existing files and directories
2. Identify items that start with a number followed by a hyphen (e.g., `1-`, `2-`, `3-`)
3. Extract all sequence numbers from these items
4. Calculate the next number: `max(existing_numbers) + 1` if numbers exist, otherwise use `1`
5. Prepend this number to the directory name with a hyphen separator

### Directory Structure Creation

Create the following structure:

```
{N}-{directory-name}/
├── README.md
└── assets/
    └── [image files]
```

Where:
- `{N}` is the calculated sequence number
- `{directory-name}` is the generated directory name from the HTML filename

### HTML to Markdown Conversion

Convert the HTML content to markdown:

1. **Extract source URL:**
   - Look for `<link rel="canonical" href="...">` in the HTML head
   - If not found, check for `<!-- saved from url=... -->` comment
   - Extract the URL and store it for adding to the markdown

2. **Extract main content:**
   - Find the main title (first `<h1>` tag)
   - Extract content between the title and script/body closing tags

3. **Process sections:**
   - Split content by `<h2>` tags to identify sections
   - Extract section headings and convert to markdown `##` headers
   - **Always add a newline character after each heading** (heading on one line, blank line, then content)
   - Process each section's content
   - If a screenshot is provided, use it to verify the structure and layout, especially for code blocks

4. **Handle images:**
   - Find all `<img>` tags with `src` and `alt` attributes
   - Map image filenames to their references
   - Update image paths to point to `assets/{filename}`
   - Copy image files from their original location to the `assets/` directory
   - **Always add a blank line after each image** - format: `![alt](path)\n\n` (image, blank line, then next content)

5. **Convert code blocks:**
   - Extract `<pre>` tags and convert to markdown code blocks
   - Clean up line numbers if present (remove leading numbers followed by letters)
   - Use appropriate language identifier (default to `python` if not specified)
   - **If a screenshot is provided, use it to verify code block accuracy** - ensure code content matches what's visible in the screenshot and avoid duplicating text that appears above or below code blocks in the visual layout
   - Be careful not to include explanatory text that appears near code blocks in the HTML but is not part of the actual code
   - **Always add a blank line after each code block** - format: ````python\ncode\n```\n\n` (code block, blank line, then next content)

6. **Convert paragraphs:**
   - Extract `<p>` tags and convert to markdown paragraphs
   - Convert inline `<code>` tags to markdown inline code with backticks
   - Remove HTML tags and decode HTML entities
   - Filter out UI elements and navigation text
   - **Always add a blank line between consecutive paragraphs** - format: `Paragraph 1\n\nParagraph 2\n\n` (paragraph, blank line, next paragraph)

7. **Maintain content order:**
   - Preserve the original order of content elements
   - Sort extracted elements by their position in the HTML

### Asset Management

Handle image and asset files:

1. **Identify assets:**
   - Find all image references in the HTML (SVG, PNG, JPG, etc.)
   - Locate the source files (typically in a `_files` directory or similar)

2. **Copy to assets directory:**
   - Create the `assets/` directory inside the output directory
   - Copy all referenced image files to the `assets/` directory
   - Preserve original filenames

3. **Update references:**
   - Update all image references in the markdown to use `assets/{filename}` format
   - Ensure relative paths are correct from the README.md location

### README.md Creation

Create the README.md file:

1. **Content structure:**
   - Start with the main title as `# {title}`
   - If a source URL was found, add it immediately after the title as: `[Source]({url})`
   - Follow with sections using `## {section-title}`
   - **Always add a newline after each heading** - headings should be followed by a blank line before the content begins
   - Insert images immediately after section headers when appropriate
   - Include code blocks with proper syntax highlighting
   - Maintain paragraph structure

2. **Formatting:**
   - **Ensure each heading is followed by exactly one newline** (heading, blank line, then content)
   - **Ensure paragraphs are separated by blank lines** - each paragraph should be followed by a blank line before the next paragraph or block element
   - **Ensure images are followed by blank lines** - each image should be followed by a blank line before the next content
   - **Ensure code blocks are followed by blank lines** - each code block should be followed by a blank line before the next content
   - Clean up extra newlines (replace 3+ consecutive newlines with 2)
   - Ensure proper spacing between sections
   - End file with exactly one newline character

3. **Content cleanup:**
   - Remove UI elements and navigation text
   - Filter out language selector buttons and similar interface elements
   - Preserve all actual content text

## Output Format

The final output should be:

```
{N}-{directory-name}/
├── README.md          # Main markdown documentation file
└── assets/            # Directory containing all image files
    ├── image1.svg
    ├── image2.svg
    └── ...
```

## Guidelines

- Always check for existing numbered directories/files to determine the next sequence number
- Generate directory names following the specified naming convention
- Preserve all content from the HTML while converting to markdown
- Copy all referenced assets to the assets directory
- Use relative paths for all image references
- Ensure proper markdown formatting and structure
- **Always add a newline after headings** - format: `## Heading\n\nContent` (heading, blank line, content)
- **Always add blank lines between paragraphs** - format: `Paragraph 1\n\nParagraph 2\n\n` (paragraph, blank line, next paragraph)
- **Always add blank lines after images** - format: `![alt](path)\n\n` (image, blank line, next content)
- **Always add blank lines after code blocks** - format: ````python\ncode\n```\n\n` (code block, blank line, next content)
- Remove HTML artifacts and UI elements
- Maintain the original content order
- End README.md with exactly one newline character
- **If a screenshot is provided, use it as a reference** to verify code block accuracy and understand the visual layout

## Verification

Before finalizing:

- Verify the directory structure is correct
- Confirm README.md contains all content from the HTML
- Check that all image references point to the correct files in assets/
- Ensure all referenced images exist in the assets directory
- Verify markdown syntax is correct
- Confirm the file ends with exactly one newline

### Content Match Verification

After creating the README.md file, perform a 100% content match verification:

1. **Extract text content from HTML:**
   - Strip all HTML tags from the original HTML content
   - Remove UI elements, navigation text, and script content
   - Extract only the actual content text (headings, paragraphs, code)
   - Normalize whitespace (convert multiple spaces to single, normalize newlines)

2. **Extract text content from markdown:**
   - Strip all markdown formatting from the created README.md
   - Remove markdown syntax (headers, code blocks, images, links)
   - Extract only the plain text content
   - Normalize whitespace (convert multiple spaces to single, normalize newlines)

3. **Compare content:**
   - Compare the extracted text from HTML with the extracted text from markdown
   - Check that all sentences, paragraphs, and content elements match exactly
   - Verify no content was lost, added, or modified during conversion

4. **Print verification message:**
   - If content matches 100%: Print a success message confirming "✓ Content verification: 100% match - All content from HTML has been successfully converted to markdown"
   - If discrepancies are found: Print a detailed message listing what differs and fix the issues before finalizing
   - Always display the verification result before completing the task

### Cleanup

After successful conversion and verification:

1. **Identify associated files:**
   - Locate the HTML file that was converted
   - Find associated directories (typically named `{html-filename}_files` or similar patterns)
   - Identify any other files related to the HTML (same base name with different extensions)

2. **Delete files and directories:**
   - Delete the original HTML file
   - Delete the associated files directory (e.g., `{html-filename}_files/`)
   - Remove any other related files that were used only for the HTML version
   - Only delete files after confirming the conversion was successful and verified

3. **Verification before deletion:**
   - Ensure the markdown conversion is complete
   - Confirm all assets have been copied to the assets directory
   - Verify content match is 100% before proceeding with deletion
   - Do not delete if verification failed or if there are any issues

## Remember

- **The `convert.py` script is in the same directory as this prompt** - reference it as `[convert.py](convert.py)`
- The directory name is derived from the HTML filename using the specified transformation rules
- Sequence numbers are automatically calculated based on existing numbered items
- All assets are organized in the assets subdirectory
- The README.md file is the main documentation file
- Image paths use relative paths from README.md to the assets directory
- Content order and structure should match the original HTML as closely as possible
- **Always perform content match verification and print the verification result message before completing the task**
- **After successful conversion and verification, delete the original HTML file and its associated files directory**

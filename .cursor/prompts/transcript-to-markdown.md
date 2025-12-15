---
id: prompt-transcript-to-markdown
author: Himel Das
description: Guidelines for converting transcripts into well-structured markdown documents with proper formatting, emphasis, and organization
---

# Transcript to Markdown Conversion Prompt

Transform transcripts (provided as text or via file) into well-structured markdown documents following these guidelines. If additional resources such as slide PDFs, presentation materials, or supplementary content are provided along with the transcript, combine all resources with the transcript to generate a comprehensive output.

## Transformation Guidelines

### 1. Document Structure

Create a clear, hierarchical markdown document with:

* A main title reflecting the overall topic
* Sections and subsections that capture the key concepts
* Conversion of technical information into readable, informative prose

### 2. Key Transformation Steps

* Remove timestamps and speaker identifiers
* Remove conversational elements such as greetings, transitional phrases, and references to future content (e.g., "Welcome back!", "Let's look at...", "We'll cover this later...")
* Keep content concise and focused on technical information, avoiding conversational fluff that increases document size without adding value
* Organize content into logical sections
* Use markdown headers:
  * `#` for main title
  * `##` for sections
  * `###` for subsections
* Convert bullet points or lists where appropriate (use `*` for list items and child list items as well)
* Highlight key concepts and definitions
* Maintain the original educational flow and intent of the transcript

### 3. Focus Areas

* Capture the main ideas
* Provide clear explanations
* Create a document that can serve as a reference or study guide
* Ensure technical accuracy
* Use a clean, professional formatting style

### 4. Handling Additional Resources

* If additional resources are provided (e.g., slide PDFs, presentation materials, supplementary documents), combine them with the transcript content
* Extract relevant information from all provided resources
* Integrate content from additional resources seamlessly into the markdown structure
* Ensure information from slides and other materials complements and enhances the transcript content
* Cross-reference information between transcript and additional resources to create a comprehensive document
* Maintain consistency in formatting and structure when combining multiple sources

### 5. Saving Transcript in SRT Format

* **Location**: Save the transcript in SRT format in the same directory where the markdown file is saved
* **File Naming**: Use the same base name as the markdown file with `.srt` extension (e.g., if markdown is `lesson.md`, save as `lesson.srt`)
* **Conditional Saving**: Only save the SRT file if it does not already exist in the repository
* **SRT Format**: Ensure the transcript is saved in proper SRT subtitle format with:
  * Sequential subtitle numbers
  * Timestamp format: `HH:MM:SS,mmm --> HH:MM:SS,mmm`
  * Text content for each subtitle entry
  * Blank lines between subtitle entries
* **Check Before Saving**: Always check if an SRT file with the same name already exists in the target directory before creating a new one

### 6. Additional Instructions

* Use code blocks or special formatting for technical terms or examples
* Include brief explanatory notes where helpful
* Aim for a balance between comprehensive coverage and concise presentation
* Always use a next-line character after a header
* Process the transcript paying special attention to details

### 7. Required Sections

#### Commands Section

At the top of the document, create a "Commands" section that lists all commands used in the transcript. This section is for fast reading and quick reference.

#### Summary Section

Always keep a summary section written in points. Use unordered lists (not numeric lists) for all summaries and content.

### 8. Formatting Rules

* Always use unordered lists (`*`) instead of numeric lists
* **Line Wrapping Rule**: All text (paragraphs, list items, and summary points) should be wrapped at word boundaries to maximize line length, staying as close to 120 characters as possible. Avoid unnecessary breaks—only break when approaching the 120-character limit.
* **Paragraph Formatting**: Paragraphs should be wrapped at word boundaries, with each line as close to 120 characters as
  possible. Separate paragraphs with blank lines. Do not create unnecessarily short lines—maximize usage of the 120-character
  limit.
* **List Item Formatting**: List items and summary points should also be wrapped at word boundaries, maximizing line length
  close to 120 characters.
* **Line Wrapping Example**: For a long sentence like "The implementation of this feature requires careful consideration of multiple factors including performance optimization, security best practices, and user experience design", wrap at word boundaries to maximize usage:
  * Line 1: "The implementation of this feature requires careful consideration of multiple factors including performance optimization, security" (close to 120 chars)
  * Line 2: "best practices, and user experience design." (continuation)
* Maintain proper markdown syntax throughout
* Use code blocks for commands, code snippets, or technical examples
* **Bold important terms and concepts**: Always bold key terms, important concepts, main benefits, critical phrases, and
  significant points throughout the document. This includes:
  * Key technical terms and domain-specific terminology
  * Main advantages and benefits mentioned in the content
  * Critical concepts and important phrases
  * Important company names, products, and certifications referenced
  * Key takeaways and significant statements
  * Important benefits and advantages mentioned in the content

## Processing Workflow

1. **Input**: Receive transcript as text or file, along with any additional resources (e.g., slide PDFs, presentation materials)
2. **Combine Resources**: If additional resources are provided, extract and combine relevant content from all sources with the transcript
3. **Extract Commands**: Identify and list all commands from the transcript and any additional resources in the "Commands" section
4. **Structure Content**: Organize combined content into logical sections with appropriate headers
5. **Transform**: Remove timestamps, speaker identifiers, conversational elements, and clean up formatting
6. **Format**: Apply markdown formatting with proper line breaks and list formatting
7. **Review**: Ensure all text (paragraphs, list items, summary points) is wrapped at word boundaries as close to 120 characters as possible, avoiding unnecessary breaks, and summary is in point form
8. **Save SRT File**: Check if an SRT file with the same name already exists in the target directory. If not, save the original transcript in SRT format in the same location as the markdown file
9. **Output**: Deliver a well-structured markdown document that integrates content from all provided resources

## Example Structure

```markdown
# Main Title

## Commands

* `command1 --option value`
* `command2 -flag argument`
* `command3 subcommand`

## Summary

* Key point one
* Key point two
* Key point three

## Section 1

### Subsection 1.1

Content here...

### Subsection 1.2

Content here...

## Section 2

Content here...
```

## Quality Checklist

* [ ] Main title reflects the overall topic
* [ ] Commands section exists at the top with all commands listed
* [ ] Summary section uses unordered lists
* [ ] All headers have next-line characters after them
* [ ] No timestamps or speaker identifiers remain
* [ ] Conversational elements have been removed (greetings, transitional phrases, future references)
* [ ] Content is organized into logical sections
* [ ] All text (paragraphs, list items, summary points) is wrapped at word boundaries as close to 120 characters as
  possible, avoiding unnecessary breaks
* [ ] Technical terms are properly formatted
* [ ] Important terms, concepts, benefits, and key points are bolded throughout the document
* [ ] Educational flow is maintained
* [ ] Document serves as a useful reference or study guide
* [ ] SRT file has been saved in the same directory as the markdown file (only if it didn't already exist)
* [ ] SRT file follows proper SRT format with sequential numbers, timestamps, and text content

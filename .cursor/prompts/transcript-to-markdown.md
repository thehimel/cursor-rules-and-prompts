---
author: Himel Das
description: Guidelines for converting transcripts into well-structured markdown documents with proper formatting, emphasis, and organization
---

# Transcript to Markdown Conversion Prompt

Transform transcripts (provided as text or via file) into well-structured markdown documents following these guidelines.

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

### 4. Additional Instructions

* Use code blocks or special formatting for technical terms or examples
* Include brief explanatory notes where helpful
* Aim for a balance between comprehensive coverage and concise presentation
* Always use a next-line character after a header
* Process the transcript paying special attention to details

### 5. Required Sections

#### Commands Section

At the top of the document, create a "Commands" section that lists all commands used in the transcript. This section is for fast reading and quick reference.

#### Summary Section

Always keep a summary section written in points. Use unordered lists (not numeric lists) for all summaries and content.

### 6. Formatting Rules

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

1. **Input**: Receive transcript as text or file
2. **Extract Commands**: Identify and list all commands in the "Commands" section
3. **Structure Content**: Organize into logical sections with appropriate headers
4. **Transform**: Remove timestamps, speaker identifiers, conversational elements, and clean up formatting
5. **Format**: Apply markdown formatting with proper line breaks and list formatting
6. **Review**: Ensure all text (paragraphs, list items, summary points) is wrapped at word boundaries as close to 120 characters as possible, avoiding unnecessary breaks, and summary is in point form
7. **Output**: Deliver a well-structured markdown document

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

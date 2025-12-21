---
id: prompt-transcript-to-markdown
author: Himel Das
description: Guidelines for converting transcripts into well-structured markdown documents with proper formatting, emphasis, and organization
---

# Transcript to Markdown Conversion Prompt

Transform transcripts (provided as text or via file) into well-structured markdown documents following these guidelines. The transcript is the PRIMARY source for content. If additional resources such as slide PDFs, presentation materials, or supplementary content are provided, use them ONLY to enhance or supplement content that is already covered in the transcript. Do not include information from additional resources that is not mentioned or related to topics in the transcript.

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

**Important**: Additional resources (e.g., slide PDFs, presentation materials, supplementary documents) may be for a single lesson, an entire chapter, or even the whole course. Only use content from these resources that relates to topics already covered in the transcript.

**Guidelines for using additional resources:**
* The **transcript is the primary source** - use it to determine what topics and concepts to include
* **Only extract information** from additional resources that enhances, clarifies, or provides details about content mentioned in the transcript
* **Do not include** information from additional resources that is not related to topics covered in the transcript
* Use additional resources to:
  * Provide code examples or technical details for concepts mentioned in the transcript
  * Add visual descriptions or structured information that supports transcript content
  * Enhance explanations with definitions, examples, or clarifications
* Maintain consistency in formatting and structure when integrating supplemental content
* If a topic is mentioned in the transcript but not detailed, use additional resources to provide that detail

### 5. Saving Transcript in SRT Format

* **Location**: Save the transcript in SRT format in the same directory where the markdown file is saved
* **File Naming**: 
  * If the target markdown file has a generic name (case-insensitive) such as `readme`, `index`, `README`, `INDEX`, etc., save the SRT file as `transcript.srt`
  * Otherwise, use the same base name as the markdown file with `.srt` extension (e.g., if markdown is `lesson.md`, save as `lesson.srt`)
* **Conditional Saving**: Only save the SRT file if it does not already exist in the repository
* **SRT Format**: Ensure the transcript is saved in proper SRT subtitle format with:
  * Sequential subtitle numbers
  * Timestamp format: `HH:MM:SS,mmm --> HH:MM:SS,mmm`
  * Text content for each subtitle entry
  * Blank lines between subtitle entries
* **Check Before Saving**: Always check if an SRT file with the determined name already exists in the target directory before creating a new one

### 6. Additional Instructions

* Use code blocks or special formatting for technical terms or examples
* Include brief explanatory notes where helpful
* Aim for a balance between comprehensive coverage and concise presentation
* Always use a next-line character after a header
* Process the transcript paying special attention to details

### 7. Required Sections

#### Commands Section

At the top of the document, create a "Commands" section that lists all commands used in the transcript. Include commands from additional resources only if they relate to concepts or examples mentioned in the transcript. This section is for fast reading and quick reference.

**Command Formatting**: For each command, always include:
1. The command syntax/pattern with placeholders (e.g., `<parameter>`, `[optional_arg]`) to show the structure
2. A concrete example showing actual values

**Example:**
* `command-name <required-arg> [optional-arg]`
* `command-name actual-value --flag`

This format makes it easy to remember the command structure while also providing a practical example.

#### Summary Section

Always keep a summary section written in points. Use unordered lists (not numeric lists) for all summaries and content.

#### Exam Notes Section

If the author mentions exam tips, likely exam questions, or important exam-related information, create an "Exam Notes" section after the Summary section. This section should:

* Be placed after the Summary section and before the main content sections
* Use `## Exam Notes` as the section header
* Create separate subsections for each topic/question using `###` headers
* Each subsection should have a descriptive title (e.g., "Secure Fine-Tuning with Sensitive Data")
* Format each exam note with:
  * **Question**: The exam question format
  * **Answer**: The answer or key information
  * Additional context or explanation as needed

**Example:**
```markdown
## Exam Notes

### Topic Name

**Question**: Generic exam question format here?

**Answer**: Generic answer with key technical concepts. This type of question may appear on the exam, so remember the key principle: [generic technical guidance].
```

**Guidelines:**
* Only create this section if exam-related information is mentioned in the transcript
* Separate each exam topic/question into its own subsection
* Use clear, descriptive subsection titles
* Bold key terms in answers
* Keep questions and answers concise and exam-focused

### 8. Formatting Rules

* Always use unordered lists (`*`) instead of numeric lists
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
2. **Analyze Transcript**: Identify all topics, concepts, and commands mentioned in the transcript - this determines what content to include
3. **Filter Additional Resources**: Review additional resources and identify only the content that relates to topics covered in the transcript
4. **Extract Commands**: Identify and list all commands from the transcript and any related commands from additional resources that support transcript content. For each command, include both the syntax/pattern with placeholders and a concrete example
5. **Extract Exam Notes**: Identify any exam tips, likely exam questions, or exam-related information mentioned by the author. Create separate subsections for each topic/question
6. **Structure Content**: Organize transcript content into logical sections with appropriate headers, using additional resources to enhance details where relevant
7. **Transform**: Remove timestamps, speaker identifiers, conversational elements, and clean up formatting
8. **Format**: Apply markdown formatting with proper line breaks and list formatting
9. **Review**: Ensure summary is in point form and exam notes are properly separated by topic
9. **Save SRT File**: Determine the SRT filename based on the markdown filename (use `transcript.srt` for generic names like `readme` or `index`, otherwise use the same base name). Check if an SRT file with the determined name already exists in the target directory. If not, save the original transcript in SRT format in the same location as the markdown file
10. **Output**: Deliver a well-structured markdown document based primarily on the transcript, with supplemental content from additional resources only where it enhances transcript topics

## Example Structure

```markdown
# Main Title

## Commands

* `command1 --option <value>`
* `command1 --option example-value`
* `command2 -flag <argument>`
* `command2 -flag example-argument`
* `command3 <subcommand>`
* `command3 example-subcommand`

## Summary

* Key point one
* Key point two
* Key point three

## Exam Notes

### Topic 1

**Question**: Exam question format here?

**Answer**: Answer with key information.

### Topic 2

**Question**: Another exam question?

**Answer**: Another answer.

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
* [ ] Commands section exists at the top with all commands listed, each showing both syntax/pattern with placeholders and a concrete example
* [ ] Summary section uses unordered lists
* [ ] Exam Notes section exists (if exam-related information is mentioned) with separate subsections for each topic/question
* [ ] All headers have next-line characters after them
* [ ] No timestamps or speaker identifiers remain
* [ ] Conversational elements have been removed (greetings, transitional phrases, future references)
* [ ] Content is organized into logical sections
* [ ] Technical terms are properly formatted
* [ ] Important terms, concepts, benefits, and key points are bolded throughout the document
* [ ] Educational flow is maintained
* [ ] Document serves as a useful reference or study guide
* [ ] SRT file has been saved in the same directory as the markdown file (only if it didn't already exist)
* [ ] SRT file naming follows the rule: `transcript.srt` for generic filenames (readme, index, etc.), otherwise same name as markdown file
* [ ] SRT file follows proper SRT format with sequential numbers, timestamps, and text content

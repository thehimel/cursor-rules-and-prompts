---
id: prompt-revision-guide-generation
author: Himel Das
description: Guidelines for generating comprehensive revision guides from course lecture materials, extracting commands and summaries for interview preparation
---

# Revision Guide Generation Prompt

Generate comprehensive revision guides from course lecture materials that consolidate commands, summaries, and key concepts for efficient interview preparation and quick reference.

## Purpose

Create a single, well-organized markdown document that serves as a complete reference guide for a course, making it easy to review all commands, concepts, and summaries before interviews or exams.

## Input Requirements

* Course directory structure with lecture markdown files
* Each lecture file should contain Commands and Summary sections
* Course should be organized into chapters or modules
* **Alternative content sources**: If markdown files lack sufficient content, look for PDFs, slides, or other available materials in the chapter directory

## Document Structure

### Required Sections

1. **Title and Table of Contents**
   * Main title: `[Course Name] Interview Revision Guide`
   * Table of contents with links to all chapters

2. **Chapter Sections**
   * Each chapter should have its own section
   * Include all lectures within that chapter
   * Organize lectures in sequential order

3. **Lecture Subsections**
   * For each lecture, include:
     * Lecture title as subsection header
     * Commands section (extracted from lecture)
     * Summary section (extracted from lecture)
     * Key Concepts section (derived from lecture content)

4. **Quick Reference Section**
   * Consolidated command reference with code blocks
   * Common resource types and operations
   * Quick concept reference

5. **Interview Preparation Section**
   * Core concepts to master
   * Common interview questions (generic, not course-specific)
   * Practice scenarios (generic examples)

## Content Extraction Guidelines

### Content Source Priority

1. **Primary Source**: Markdown files with well-structured notes
   * Check if markdown file has substantial content (Commands, Summary sections, detailed explanations)
   * Evaluate if content is sufficient for creating comprehensive revision guide

2. **Fallback Source**: Alternative content when markdown is insufficient
   * If markdown file exists but lacks significant/well-structured notes:
     * Look for PDF files in the same chapter directory
     * Check for slide files (PPTX, PDF slides)
     * Search for other document formats (DOCX, etc.)
     * Examine any supplementary materials available
   * **Deeply study** the alternative content to extract:
     * Commands and code examples
     * Key concepts and definitions
     * Important summaries and takeaways
     * Technical details and explanations

### Commands Extraction

* Extract all commands from each lecture's Commands section (if present in markdown)
* If markdown lacks commands, extract from PDFs or other sources by:
  * Identifying code blocks and command examples
  * Extracting syntax and usage patterns
  * Understanding context from surrounding content
* Format commands clearly with proper syntax
* Group related commands together
* Include command descriptions where helpful
* Use code blocks for command examples

### Summary Extraction

* Extract summary points from each lecture's Summary section (if present in markdown)
* If markdown lacks summaries, create summaries from alternative sources by:
  * Reading and understanding the full content deeply
  * Identifying key points and main concepts
  * Extracting important takeaways
  * Understanding the overall structure and flow
* Maintain logical summary structure
* Preserve important terminology and concepts
* Keep summaries concise and focused

### Key Concepts Derivation

* Identify important concepts from lecture content (markdown or alternative sources)
* When using alternative sources, deeply analyze the content to:
  * Understand core concepts and their relationships
  * Identify technical terminology and definitions
  * Extract important principles and patterns
  * Recognize key examples and use cases
* Create concise definitions and explanations
* Highlight relationships between concepts
* Use bold formatting for key terms
* Organize concepts logically within each lecture section

## Content Organization Rules

### Chapter Organization

* Group lectures by their chapter or module
* Maintain the original course sequence
* Use clear hierarchical headers (`##` for chapters, `###` for lectures)
* Include chapter numbers or names in headers

### Lecture Organization

* Each lecture should have:
  * Clear title as subsection header
  * Commands listed first (if any)
  * Summary points following commands
  * Key Concepts section with definitions and explanations

### Quick Reference Format

* Organize commands by category (e.g., Basic Operations, Resource Management, Monitoring)
* Use code blocks for command syntax
* Include brief descriptions for each command category
* List common resource types separately

## Formatting Guidelines

### Text Formatting

* **Bold** all key terms, important concepts, and technical terminology
* Use code formatting (backticks) for command names, resource types, and technical terms
* Use code blocks for command examples and syntax
* Maintain consistent formatting throughout

### Line Wrapping

* Wrap text at word boundaries
* Target approximately 120 characters per line
* Avoid unnecessary line breaks
* Keep paragraphs readable and well-formatted

### List Formatting

* Use unordered lists (`*`) for all lists
* Maintain consistent indentation
* Use nested lists for hierarchical information
* Keep list items concise and scannable

## Content Creation Rules

### Copyright Compliance

* **DO NOT** copy verbatim content from course materials
* **DO** extract and summarize information in your own words
* **DO** focus on commands, concepts, and structural information
* **DO** create original explanations and definitions
* **DO NOT** reproduce entire paragraphs or sections word-for-word

### Content Transformation

* Transform extracted information into concise reference format
* Create original summaries that capture key points
* Develop original key concept definitions
* Generate generic interview questions (not course-specific)
* Create practice scenarios that are illustrative but not copied

### Quality Standards

* Ensure all commands are accurately extracted
* Verify summaries capture essential points
* Confirm key concepts are clearly explained
* Maintain technical accuracy throughout
* Ensure document serves as effective study guide

## Processing Workflow

1. **Explore Course Structure**
   * Identify all chapter directories
   * Locate all lecture markdown files
   * Understand course organization
   * Identify available alternative content sources (PDFs, slides, etc.)

2. **Evaluate and Read Content**
   * For each chapter/lecture:
     * **Check markdown file quality**:
       * Read the markdown file
       * Assess if it contains well-structured notes
       * Evaluate if it has sufficient Commands and Summary sections
       * Determine if content is substantial enough for revision guide
     * **If markdown is insufficient**:
       * Search for alternative content in the chapter directory:
         * PDF files (lecture notes, slides, documents)
         * Slide files (PPTX, PDF presentations)
         * Other document formats (DOCX, etc.)
       * **Deeply study the alternative content**:
         * Read and understand the full content thoroughly
         * Extract commands, code examples, and syntax
         * Identify key concepts, definitions, and terminology
         * Understand relationships between concepts
         * Extract important summaries and takeaways
         * Note technical details and explanations
     * **If markdown is sufficient**:
       * Extract Commands sections
       * Extract Summary sections
       * Identify key concepts from content

3. **Organize Content**
   * Group lectures by chapter
   * Maintain lecture sequence
   * Identify common patterns and themes
   * Ensure all content (from markdown or alternative sources) is properly organized

4. **Generate Sections**
   * Create chapter sections
   * Generate lecture subsections with commands, summaries, and key concepts
   * Use content from markdown files when available and sufficient
   * Use content extracted from alternative sources when markdown is insufficient
   * Build quick reference section
   * Create interview preparation section

5. **Format and Review**
   * Apply consistent formatting
   * Ensure proper markdown syntax
   * Verify all commands are included (from any source)
   * Check for completeness and accuracy
   * Ensure content quality is consistent regardless of source

6. **Final Output**
   * Well-structured markdown document
   * Complete command reference (from all available sources)
   * Comprehensive summaries (from all available sources)
   * Clear key concepts (from all available sources)
   * Interview preparation resources

## Example Structure

```markdown
# [Course Name] Interview Revision Guide

Complete command reference and summary guide for [Course Name] course.

## Table of Contents

1. [Chapter 1: Title](#chapter-1-title)
2. [Chapter 2: Title](#chapter-2-title)
3. [Quick Command Reference](#quick-command-reference)
4. [Interview Preparation Tips](#interview-preparation-tips)

## Chapter 1: Title

### Lecture 1: Topic

**Commands:**
* `command1 --option value` - Description
* `command2 -flag argument` - Description

**Summary:**
* Key point one
* Key point two
* Key point three

**Key Concepts:**
* **Concept Name**: Definition and explanation
* **Related Concept**: How it relates to other concepts

## Quick Command Reference

### Basic Operations
```bash
# Command examples
command --option value
```

## Interview Preparation Tips

### Core Concepts to Master
* Concept 1
* Concept 2

### Common Interview Questions
* Generic question about topic
* Generic question about implementation
```

## Quality Checklist

* [ ] All lectures are included and organized by chapter
* [ ] For each chapter, content source was evaluated (markdown vs. alternative sources)
* [ ] If markdown was insufficient, alternative sources (PDFs, etc.) were located and studied
* [ ] Commands section exists for each lecture with commands (extracted from any available source)
* [ ] Summary section exists for each lecture (extracted from any available source)
* [ ] Key Concepts section provides clear definitions (derived from any available source)
* [ ] Content from alternative sources was deeply studied and properly extracted
* [ ] Quick reference section consolidates all commands
* [ ] Interview preparation section is included
* [ ] No verbatim copying from course materials
* [ ] All key terms are bolded
* [ ] Commands are properly formatted in code blocks
* [ ] Document serves as effective study and interview preparation resource
* [ ] Table of contents is complete and accurate
* [ ] Content is technically accurate and complete
* [ ] Content quality is consistent regardless of whether it came from markdown or alternative sources

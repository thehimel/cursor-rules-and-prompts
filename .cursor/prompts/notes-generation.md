---
id: prompt-notes-generation
author: Himel Das
description: Generate comprehensive study notes from provided resources for any topic with organized directory structure, images, and practice questions
---

# Comprehensive Notes Generation from Resources

Generate complete, well-structured study notes from provided documentation, books, resources, and tips. The notes should serve as a single source of truth for understanding the topic.

## Purpose

Create comprehensive, exam-ready notes from various source materials that consolidate key concepts, practical examples, code snippets, architecture diagrams, and practice questions into an organized, easy-to-study format.

## Input Requirements

* **Topic outline**: Directory structure or list of topics/subtopics to cover
* **Resources**: Any combination of:
  * Official documentation (local files or directories)
  * Books (PDFs, markdown)
  * Study tips or guides
  * Architecture diagrams and images
  * Code examples
  * Reference materials

## Directory Structure Creation

### Automatic Directory Setup

Before generating content, create the following structure:

```
notes/
├── topic-1/
│   ├── subtopic-1/
│   │   ├── assets/
│   │   └── README.md
│   ├── subtopic-2/
│   │   ├── assets/
│   │   └── README.md
│   └── README.md
├── topic-2/
│   ├── subtopic-1/
│   │   ├── assets/
│   │   └── README.md
│   └── README.md
└── README.md
```

### Directory Naming Convention

* Use **kebab-case** for all directory names
* Create an `assets/` folder in each topic/subtopic directory
* Place a `README.md` in each directory to hold the notes

### README Files at Different Levels

Create README files at multiple levels of the directory hierarchy:

**Main README** (`notes/README.md`):
* Comprehensive overview of all topics
* Study strategy and timeline
* Key focus areas across all topics
* Quick reference cheat sheet
* How to use the notes
* Exam/study tips
* Navigation to all sections

**Section README** (e.g., `notes/topic-1/README.md`):
* Overview of what's covered in this section
* Detailed breakdown of subtopics with bullet points
* Why this section matters (relevance)
* Key focus areas for this section
* Study approach specific to this section
* Quick tips and memorable one-liners
* Navigation links to subtopics and other sections

**Subtopic README** (e.g., `notes/topic-1/subtopic-1/README.md`):
* Detailed content with key takeaways
* Core concepts and explanations
* Code examples and practical guidance
* Visual aids and reference tables
* Practice questions

## Content Generation Process

### Step 1: Explore Resources

1. **Read provided directory structure** or topic outline
2. **Identify all available resources**:
   * Documentation files (`.rst`, `.md`, `.txt`)
   * Books or PDFs
   * Tips or study guides
   * Image assets
   * Code examples
3. **Map resources to topics**: Determine which resources relate to which topics

### Step 2: Deep Content Analysis

For each topic/subtopic:

1. **Read all relevant documentation** deeply and thoroughly
2. **Extract key information**:
   * Core concepts and definitions
   * Architecture and components
   * How things work (step-by-step flows)
   * Commands and syntax
   * Use cases and examples
   * Common patterns and best practices
   * Limitations and constraints
3. **Identify important diagrams and images** in the source materials
4. **Note practical tips** from provided study guides

### Step 3: Image Handling

When source materials contain images:

1. **Copy relevant images** to the `assets/` folder of the appropriate topic/subtopic
2. **Use appropriate naming**: Keep original names or rename descriptively
3. **Reference images** in markdown using relative paths:
   ```markdown
   ![Description](./assets/image-name.png)
   ```
4. **Supported image types**: PNG, JPG, SVG, GIF

### Step 4: Content Structure

Different README files have different purposes and structures:

#### Main README Structure (notes/README.md)

1. **Title and Overview**
   * Brief description of the study material
   * Purpose and context

2. **Study Strategy**
   * Week-by-week or phase-by-phase study plan
   * How to approach the material
   * Time estimates

3. **Topic Overview**
   * List of all major sections
   * What each section covers
   * Exam weight or importance

4. **Key Focus Areas**
   * Most important topics across all sections
   * Common patterns to remember
   * Critical concepts that appear frequently

5. **Quick Reference Cheat Sheet**
   * One-page summary of essential information
   * Formulas, commands, syntax
   * Quick lookup tables

6. **How to Use These Notes**
   * For initial study
   * For revision
   * Before exam/assessment

7. **Tips and Best Practices**
   * Exam-taking strategies
   * Study tips
   * Common pitfalls to avoid

8. **Navigation**
   * Links to all major sections

#### Section README Structure (notes/topic-1/README.md)

1. **Section Title**
   * What this section covers

2. **Overview and Breakdown**
   * Detailed list of subtopics
   * What each subtopic contains
   * Why this section matters

3. **Key Focus Areas**
   * Most important topics in this section
   * Specific to this section only

4. **Study Approach**
   * How to study this section effectively
   * Recommended exercises
   * Practical tips

5. **Quick Tips**
   * Memorable one-liners
   * Key concepts to remember
   * Common patterns

6. **Navigation**
   * Links to subtopics and other sections

#### Subtopic README Structure (notes/topic-1/subtopic-1/README.md)

1. **Key Takeaways**
   * Most important points to remember (use unordered list with bullets)
   * Common patterns
   * Critical concepts
   * Quick summary for revision

2. **Introduction**
   * What is this topic?
   * Why is it important?
   * High-level overview

3. **Core Concepts**
   * Key terminology with definitions
   * Fundamental principles
   * Architecture and components (with diagrams)
   * How things work together

4. **Practical Examples**
   * Code examples with explanations
   * Real-world use cases
   * Step-by-step walkthroughs

5. **Commands/Syntax Reference** (if applicable)
   * Common commands with examples
   * Syntax patterns
   * Important flags or options

6. **Visual Aids**
   * Architecture diagrams
   * Flow charts
   * Screenshots (if relevant)

7. **Quick Reference Tables**
   * Summary tables for quick lookup
   * Comparison tables
   * Feature matrices

8. **Practice Questions**
   * Multiple choice questions with checkboxes
   * Answers with explanations
   * Format:
     ```markdown
     **Q1: Question text?**
     
     **Answer**:
     - □ Option A
     - ✓ Option B (correct)
     - □ Option C
     - □ Option D
     
     **Explanation**: Why B is correct...
     ```

## Writing Style Guidelines

### Tone and Language

* **Natural, human-like writing**: Avoid AI-sounding phrases
* **Conversational but informative**: Write like explaining to a colleague
* **Clear and direct**: Start with the answer, not preamble
* **Active voice**: Prefer active over passive constructions
* **Practical focus**: Emphasize "what this means" and "how to use it"

### Formatting Best Practices

* **Bold key terms** when first introduced or emphasized
* **Use inline code** for commands, variables, file names: `command`, `variable`
* **Use code blocks** for examples with proper language tags
* **Use lists** for multiple related items (3+ items)
* **Use tables** for structured comparisons or quick reference
* **Use arrows** for progressions: **Step 1** → **Step 2** → **Step 3**
* **Use horizontal rules** (`---`) to separate major sections

### Emphasis Guidelines

* **Bold** for key concepts, important terms, section labels
* *Italic* for soft emphasis or temporal aspects
* `Code format` for technical terms, commands, file paths
* **Tables** for structured data and comparisons
* **Superscript** for powers: 10⁴, N², 2ⁿ (not caret notation: 10^4)

## Content Quality Standards

### Accuracy and Completeness

* Extract information directly from provided resources
* Verify technical accuracy against source materials
* Include all critical concepts from the resources
* Don't omit important details

### Practical Focus

* Include code examples with explanations
* Provide real-world use cases
* Show step-by-step processes
* Explain "why" not just "what"

### Organization

* Logical flow from basic to advanced concepts
* Clear section hierarchy (H2, H3, H4)
* Consistent formatting throughout
* Easy to scan and navigate

### Study Effectiveness

* Content should be comprehensive enough to learn from notes alone
* Include practice questions to test understanding
* Provide quick reference sections for review
* Highlight critical points for focused study

## Special Considerations

### Tips Integration

If study tips are provided:

1. **Identify focus areas** mentioned in tips
2. **Emphasize these topics** in the notes
3. **Add exam tips** or "Important!" callouts for these areas
4. **Create extra practice questions** for focus areas
5. **Include tip references**: "Tip from [source]: ..."

### Multiple Source Integration

When multiple resources cover the same topic:

1. **Synthesize information** from all sources
2. **Use most detailed/official** source as primary
3. **Add supplementary details** from other sources
4. **Cross-reference** different perspectives
5. **Maintain consistency** in terminology

## Processing Workflow

1. **Analyze Structure**
   * Read provided topic outline
   * Understand topic hierarchy
   * Identify what needs to be covered

2. **Create Directories**
   * Create all topic/subtopic folders
   * Create `assets/` folders in each
   * Create empty `README.md` files at all levels

3. **Map Resources**
   * Identify which resources cover which topics
   * Note which images relate to which topics
   * Plan content organization

4. **Generate Main README**
   * Create comprehensive overview of all topics
   * Include study strategy and timeline
   * Add quick reference cheat sheet
   * Provide exam/study tips
   * Add navigation links

5. **Generate Section READMEs**
   * For each major section (topic-1, topic-2, etc.)
   * Create section overview with subtopic breakdown
   * Explain why the section matters
   * Provide section-specific study approach
   * Add quick tips and navigation

6. **Generate Subtopic Content**
   * Start with first subtopic
   * Read all relevant source materials deeply
   * Copy relevant images to assets folder
   * Write comprehensive notes following structure
   * Include code examples from sources
   * Add practice questions

7. **Review and Refine**
   * Verify all topics are covered
   * Check all README files exist at appropriate levels
   * Check all images are copied and referenced
   * Ensure consistent formatting
   * Verify technical accuracy
   * Test that notes are comprehensive
   * Verify navigation links work correctly

## Example Directory After Generation

```
notes/
├── README.md (main overview with study guide, cheat sheet, navigation)
├── fundamentals/
│   ├── README.md (section overview with subtopic breakdown, study approach)
│   ├── basic-concepts/
│   │   ├── assets/
│   │   │   ├── architecture-diagram.png
│   │   │   ├── workflow-chart.png
│   │   │   └── component-view.png
│   │   └── README.md (detailed content with key takeaways, examples, questions)
│   └── advanced-features/
│       ├── assets/
│       │   ├── advanced-architecture.png
│       │   └── use-case-diagram.png
│       └── README.md (detailed content with key takeaways, examples, questions)
└── task-management/
    ├── README.md (section overview with subtopic breakdown, study approach)
    └── operators/
        ├── assets/
        └── README.md (detailed content with key takeaways, examples, questions)
```

## Quality Checklist

### Directory Structure
* [ ] All directories created with proper structure
* [ ] All `assets/` folders exist where needed
* [ ] README files exist at all appropriate levels (main, section, subtopic)

### Content Quality
* [ ] Main README provides comprehensive overview and study guide
* [ ] Section READMEs provide topic breakdown and study approach
* [ ] Subtopic READMEs have detailed content following the structure
* [ ] Key takeaways listed at the beginning of each subtopic for quick revision (using unordered lists)
* [ ] Code examples included with explanations
* [ ] Architecture diagrams and visuals present
* [ ] Quick reference tables included
* [ ] Practice questions with answers included
* [ ] Content is accurate to source materials
* [ ] Notes are comprehensive enough to learn from alone

### Images and References
* [ ] All relevant images copied to appropriate `assets/` folders
* [ ] Images referenced correctly in markdown with relative paths

### Navigation and Formatting
* [ ] Navigation links work correctly between sections
* [ ] Writing style is natural and human-like
* [ ] Formatting is consistent (bold, code, lists, tables)
* [ ] All sections properly separated with spacing
* [ ] Horizontal rules used appropriately for visual separation

### Study Integration
* [ ] Study tips integrated into relevant sections
* [ ] Study strategy provided in main README
* [ ] Quick tips included in section READMEs
* [ ] Exam focus areas highlighted throughout

## Copyright and Attribution

* **DO NOT** copy verbatim text from sources
* **DO** summarize and explain in your own words
* **DO** extract commands, syntax, and technical details
* **DO** credit tips when using them: "Tip: ..."
* **DO** focus on educational transformation of content

## Output Format

* All content in **Markdown** format
* One `README.md` per topic/subtopic
* Images in `assets/` folders
* Proper markdown syntax throughout
* Line ending with single newline character


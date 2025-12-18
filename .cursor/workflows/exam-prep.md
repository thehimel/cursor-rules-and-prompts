---
id: workflow-exam-prep
author: Himel Das
description: Step-by-step workflow for creating comprehensive exam preparation documentation from scratch
---

# Exam Preparation Documentation Workflow

A systematic approach to create comprehensive, exam-ready study notes for any certification exam.

## Steps

### 1. Analyze the Exam

Create main exam README:

- List exam format, duration, passing score
- **Document all exam topics from official syllabus**
- Include resources and preparation strategy

### 2. Collect Resources

**Official Documentation**:
- Gather official docs, guides, architecture diagrams, examples
- Store in a separate location from exam notes

**Study Tips**:
- Collect exam feedback, focus areas, common pitfalls
- Store in tips folder

### 3. Create Directory Structure

Set up exam-prep folder with major topics and subtopics (structure defined in `@.cursor/prompts/notes-generation.md`).

### 4. Generate Content

Use `@.cursor/prompts/notes-generation.md` to generate notes using the given resources:

**Approach**: Generate all topics at once OR topic by topic

- Provide resources: official docs, tips files, exam topics
- Generates: detailed READMEs for subtopics with key takeaways, concepts, examples, practice questions
- Creates: section READMEs with overview and study approach
- Creates: main exam-prep README with study strategy, cheat sheet, navigation
- Copies: relevant images to assets folders

### 5. Review and Verify

Check:
- All directories and README files exist
- Navigation links work
- Images are copied and referenced
- Content is accurate and comprehensive
- Practice questions included

---
id: course-structure-chapter-content
author: Himel Das
description: Guidelines for creating course chapter structure with lesson files, exercises, and directories
---

# Course Structure Guidelines

When creating course chapter directories, follow these structure guidelines:

## File Structure

### Lesson Files

* Create markdown files for video lectures only
* Use sequential numbering starting from 1 (e.g., `1-topic.md`, `2-topic.md`, `3-topic.md`)
* Each lesson file should contain only the title as a level 1 heading (`# Title`)
* Do not include Commands or Summary sections in lesson files initially

### Exercises File

* Create an `exercises.md` file in each chapter directory
* This file will contain all exercises for the chapter

### Directory Structure

* Create an `images/` directory for storing images and screenshots
* Create a `src/` directory for source code files
* Do not create subdirectories within `src/` unless specifically needed
* Keep directories empty initially - they will be populated as content is added

## Example Structure

```
chapter-name/
├── 1-first-lesson.md
├── 2-second-lesson.md
├── 3-third-lesson.md
├── exercises.md
├── images/
└── src/
```

## Rules

* ✅ Use sequential numbering for lesson files
* ✅ Include only the title in lesson markdown files
* ✅ Create `exercises.md`, `images/`, and `src/` directories
* ❌ Do not create subdirectories within `src/` unless needed
* ❌ Do not add Commands or Summary sections to lesson files initially


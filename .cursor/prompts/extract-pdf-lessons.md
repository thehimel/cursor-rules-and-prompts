---
id: prompt-extract-pdf-lessons
description: Extract lesson-wise PDFs from a combined PDF file by identifying lesson start markers
author: Himel Das
---

# Extract PDF Lessons

## Core Rules

**Input** → Single PDF with multiple lessons, each starting with a marker page.  
**Output** → Sequential PDFs: `1.pdf`, `2.pdf`, `3.pdf`, ...  
**Library** → `pypdf` only.  
**Detection** → User-provided hints or intelligent analysis (text patterns, image characteristics, page structure).  
**Script Location** → Create extraction script in `scripts/` directory at same level as input PDF.

## Process

### Identify Lesson Start Pages

**With hint**: Use specified pattern (text/image/structure) to detect lesson starts.  
**Without hint**: Scan pages intelligently—extract text, identify patterns (title/logo pages, section headers, distinct formatting), use first page as lesson 1 start.

### Extract Lessons

**Python Environment**: Check for virtual environment at repository root (`.venv/`, `venv/`, `env/`). If found → activate and use it; else → use global Python. Create extraction script in `scripts/` directory at same level as input PDF. If `OUTPUT_DIR` not specified → create directory with same name as PDF file (without extension) at same level as input PDF. For lesson `i` (1-indexed): start = marker `i`, end = marker `i+1` (or PDF end for last lesson). Extract pages `[start, end)` → save as `{i}.pdf` in `OUTPUT_DIR`. Create `PdfReader` once, reuse for all extractions. Handle missing markers, empty pages, extraction failures gracefully.

## Constants

- **PDF_PATH**: Input PDF file path
- **OUTPUT_DIR**: Directory for extracted lesson PDFs (default: PDF filename without extension at same level as input PDF if not specified)
- **SCRIPT_DIR**: Directory for extraction script (default: `scripts/` at same level as input PDF)
- **MARKER_PATTERN**: Text/image pattern for lesson start detection (if provided)

## Output & Verification

Sequential numbering (`1.pdf`, `2.pdf`, ...), pages `[start, end)` per lesson, preserve quality. Verify all PDFs created, page counts match ranges, no missing/duplicated pages, files readable. **Validate page count**: Sum of pages in all output PDFs = total pages in input PDF. Print validation results in chat (input pages, output pages per lesson, total output pages, match status).

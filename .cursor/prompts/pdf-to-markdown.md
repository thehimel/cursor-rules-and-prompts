---
Author: Himel Das
---

# PDF to Markdown Conversion Prompt

Use MarkItDown (Microsoft's document conversion tool) to convert PDF slide decks to markdown, then rewrite them in conversational, non-academic language.

MarkItDown is already installed in your project's virtual environment - use it via command line.

## Conversion Process

### Step 1: Initial Markdown Extraction

Use MarkItDown from the command line to extract raw markdown from the PDF:

```bash
markitdown path-to-file.pdf -o output.md
```

### Step 2: Conversational Rewrite

After MarkItDown extracts the markdown, rewrite it in:
- Non-academic, conversational language
- Include real-world examples and practical scenarios
- Break down complex concepts into simple terms
- Use clear headers, bullets, and formatting
- Focus on practical application rather than academic definitions
- Keep it engaging and easy to follow
- Aim for clarity and readability over academic precision

IMPORTANT: Maintain the exact structure and flow of the original content:
- Keep the same section order
- Preserve the same slide/lecture flow
- Maintain the same topic progression
- Follow the original document's organization
- Keep the same sequence of concepts as presented

The structure should match the input exactly - only the language and explanations should be rewritten, not the organization.

File naming: Save the output with the same name as the input file, just replace the .pdf extension with .md  
Example: input "lecture1.pdf" → output "lecture1.md"

## Complete Workflow

```bash
# Step 1: Convert PDF to markdown using MarkItDown
markitdown lecture1.pdf -o lecture1_raw.md

# Step 2: Apply conversational rewrite to lecture1_raw.md
# (Send the raw markdown to AI with the rewriting instructions below)

# Step 3: Save final conversational markdown as lecture1.md
```

## Advanced Options (Optional)

### Azure Document Intelligence

For better PDF extraction quality, especially for complex layouts:

```bash
markitdown path-to-file.pdf -o output.md -d -e "<your_endpoint>"
```

More info: https://github.com/microsoft/markitdown

## Style Guide

### Before (Academic Style):
```
Definition. Optimization: The action of making the best or most effective use of a situation or resource; the process by which a system, design, or decision becomes as fully perfect, functional, or effective as possible.
```

### After (Conversational Style):
```
Optimization means making something work as well as possible. Think of it like tuning a race car - you're adjusting various components to get the best performance. Sometimes you make it faster, sometimes more efficient, depending on what you need most.
```

## Key Principles

1. **Preserve the exact structure** - maintain slide order, sections, and topic flow
2. **Use "you" instead of "one" or passive voice**
3. **Add analogies and comparisons** to explain complex concepts
4. **Include practical examples** from real companies and projects
5. **Break down frameworks** into step-by-step instructions
6. **Use clear section headers** and bullet points that match the original
7. **Remove unnecessary jargon** unless absolutely required
8. **Focus on "what this means for you"** rather than just definitions
9. **Add takeaways and action items** throughout
10. **Follow the same sequence** as the original slides/lecture

## Additional Notes

- **Structure is sacred** - maintain the exact same sequence, sections, and flow as the original
- Keep all original core information
- Remove redundant content (but keep the order)
- Add practical examples wherever possible
- Use markdown formatting for clarity (headers, bullets, code blocks, etc.)
- Make it student-friendly and immediately applicable
- The only thing changing is the language and explanations - the organization stays the same

## Reference

- **MarkItDown GitHub**: https://github.com/microsoft/markitdown
- **Note**: MarkItDown is already installed in the project's virtual environment
- Use via command line: `markitdown input.pdf -o output.md`

---
id: prompt-reduce-prompt-size
description: Prompt for reducing the size of other prompts by consolidating repeated content, using concise notation, and applying optimization techniques
author: Himel Das
---

# Reduce Prompt Size

> **Note**: The author has named this technique **Equation-Based DRY Prompting (EBDP)**.

## Purpose

Reduce the size of prompts by consolidating repeated content, using concise notation, and applying optimization techniques while maintaining clarity and completeness.

## Techniques

### 1. Consolidate Core Rules

**Before**: Rules repeated in multiple sections
**After**: Create a single "Core Rules" section at the top, reference it throughout

- Extract repeated rules into a dedicated section
- Use bold references like **Rule Name** when referencing
- Define rules once, reference many times

### 2. Use Easy Mathematical Notation

Replace verbose explanations with simple equations:
- Inequalities: `c ≤ 9`, `c ≥ 10`, `n < 10`
- Arrows: `→` for transformations (e.g., `format = N`)
- Equals: `=` for definitions
- Pattern notation: `{N|NN}` for optional values
- Variables: `c` for count, `n` for number

**Avoid**: Advanced symbols like `∃`, `∀` - use plain English instead

### 3. Convert Lists to Sentences

**Before**: Multiple bullet points
**After**: Concise sentences or single-line descriptions

- Merge related bullet points into one sentence
- Use commas and semicolons to combine related items
- Keep only essential information

### 4. Merge Similar Sections

**Before**: Separate sections for similar concepts
**After**: Single section with sub-bullets or inline notes

- Combine sections with overlapping content
- Use "Common Format" notes for shared instructions
- Group related operations together

### 5. Remove Redundant Examples

**Before**: Multiple examples showing the same concept
**After**: One concise example or pattern notation

- Keep only the most representative example
- Use pattern notation instead of multiple examples
- Remove examples that don't add unique value

### 6. Simplify Structure

- Remove unnecessary headers for simple points
- Combine verification and guidelines when possible
- Use inline notes instead of separate sections

## Process

1. **Identify Repetition**: Find rules/explanations repeated across sections
2. **Extract Core Rules**: Create a "Core Rules" section with all unique rules
3. **Replace with References**: Update all sections to reference core rules
4. **Apply Notation**: Replace verbose explanations with equations/patterns
5. **Condense Lists**: Convert bullet lists to concise sentences
6. **Merge Sections**: Combine similar sections
7. **Remove Redundancy**: Eliminate duplicate examples and explanations
8. **Verify**: Ensure all essential information is preserved

## Output

The reduced prompt should:
- Be 40-60% smaller than original
- Maintain all essential information
- Use easy-to-understand notation
- Have clear structure with core rules at top
- Reference rules instead of repeating them

## Remember

- Clarity > Brevity: Don't sacrifice understanding for size
- Use easy notation: Standard symbols (≤, ≥, →, =) are fine, avoid advanced math
- Test readability: Ensure the prompt is still understandable after reduction
- Preserve functionality: All original capabilities must remain intact


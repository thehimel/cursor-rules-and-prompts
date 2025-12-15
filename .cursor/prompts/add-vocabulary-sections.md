---
id: prompt-add-vocabulary-sections
alwaysApply: false
description: Prompt for adding vocabulary sections to educational content, Q&A materials, or topic-based documents with essential words only
author: Himel Das
---

# Add Vocabulary Sections

## Task Description

When given educational content organized by topics or themes (such as Q&A materials, study guides, or topic-based documents), add vocabulary sections that extract and list essential words needed to understand the content. The vocabulary should focus only on necessary terms that appear in questions and correct answers, avoiding unnecessary words from unused options or peripheral content.

## Core Requirements

### Vocabulary Extraction

- **Extract words from questions and correct answers only** - Focus on terms that are essential for understanding the content
- **Exclude unused options** - Do not include vocabulary from incorrect answer choices or options that are not part of the correct answer
- **Identify part of speech** - Determine whether each word is a noun, verb, adjective, adverb, etc.
- **Provide translations** - Include clear English translations for all extracted terms
- **Link to source** - Create links to the specific questions or sections where each word appears

### Content Selection Criteria

Include vocabulary that:
- Appears in question text and is essential for understanding
- Is part of the correct answer or explanation
- Represents key concepts or terminology for the topic
- Is necessary for comprehension of the material

Exclude vocabulary that:
- Only appears in incorrect answer options
- Is peripheral or not essential to understanding
- Is common knowledge that doesn't require explanation
- Appears only in examples or supplementary material

### Format Requirements

Each vocabulary section should include:

1. **Title**: "Vocabulary" or "Essential Vocabulary"
2. **Table format** with four columns:
   - **Original Language**: The word or phrase in the original language
   - **English**: English translation
   - **Part of Speech**: Grammatical category (noun, verb, adjective, adverb, etc.)
   - **Used In**: Links to specific questions or sections where the word appears

3. **Placement**: Add vocabulary section below the summary/overview and before the main content

### Table Structure

```
## Vocabulary

| Original Language | English | Part of Speech | Used In |
|-------------------|---------|----------------|---------|
| Word 1 | Translation 1 | noun | [Question 1](#link-1), [Question 5](#link-5) |
| Word 2 | Translation 2 | verb | [Question 2](#link-2) |
```

### Linking Requirements

- Create anchor links to questions using markdown link format: `[Question Title](#anchor-id)`
- Use consistent anchor naming (e.g., lowercase with hyphens)
- Ensure links are clickable and navigate to the correct section
- Group multiple references for the same word in the "Used In" column

### Part of Speech Guidelines

Common parts of speech to identify:
- **noun**: Person, place, thing, or concept
- **verb**: Action or state of being
- **adjective**: Describes or modifies nouns
- **adverb**: Modifies verbs, adjectives, or other adverbs
- **preposition**: Shows relationship between words
- **conjunction**: Connects words, phrases, or clauses
- **pronoun**: Replaces nouns
- **phrase**: Multi-word expression

### Vocabulary Organization

The vocabulary table must be organized according to the following hierarchy:

1. **Basic/Fundamental Words First** - Place basic, fundamental words at the top of the table. These are core words that form the foundation of the topic (e.g., "state", "law", "people"). Basic words typically:
   - Are simple, root words without prefixes or suffixes
   - Represent fundamental concepts
   - Are frequently used throughout the content
   - Form the basis for compound or derived words

2. **Group Similar Words Together** - Words that share a root, are related, or are compound words containing the same base should be placed immediately after one another. Similar words include:
   - Compound words sharing the same root (e.g., "Rechtsstaat", "Bundesstaat" both contain "Staat")
   - Words with the same prefix or suffix
   - Related concepts or terms
   - Words that are semantically connected

3. **Place Opposites After Similar Words** - Opposite or contrasting words should be placed immediately after their similar counterparts. This helps learners understand relationships and contrasts:
   - If "democratic" appears, place "dictatorship" nearby
   - If "freedom" appears, place related restrictions nearby
   - Group antonyms or contrasting concepts together

**Organization Example:**
```
| Staat | state | noun | ... |
| Gesetze | laws | noun | ... |
| Rechtsstaat | constitutional state | noun | ... |
| Bundesstaat | federal state | noun | ... |
| Diktatur | dictatorship | noun | ... |
| Monarchie | monarchy | noun | ... |
```

In this example:
- "Staat" and "Gesetze" are basic words (top)
- "Rechtsstaat" and "Bundesstaat" are similar (both contain "Staat") - grouped together
- "Diktatur" and "Monarchie" are opposites/contrasts to democratic concepts - placed after similar words

## Process Steps

1. **Analyze content** - Review all questions and correct answers in each topic
2. **Extract essential vocabulary** - Identify words that are necessary for understanding
3. **Filter unnecessary terms** - Remove words that only appear in incorrect options
4. **Identify parts of speech** - Determine grammatical category for each word
5. **Create translations** - Provide clear English translations
6. **Organize vocabulary** - Arrange words according to organization hierarchy:
   - Place basic/fundamental words at the top
   - Group similar words together sequentially
   - Place opposite/contrasting words after their similar counterparts
7. **Generate links** - Create anchor links to source questions
8. **Format table** - Organize vocabulary in the specified table format
9. **Insert section** - Place vocabulary section in appropriate location

## Quality Checklist

Before completion, verify:

- ✅ Only essential vocabulary is included
- ✅ No words from unused/incorrect options
- ✅ All words have correct part of speech
- ✅ Translations are accurate and clear
- ✅ Links navigate to correct questions
- ✅ Table format is consistent
- ✅ Vocabulary section is properly placed
- ✅ All necessary words for understanding are included
- ✅ Basic/fundamental words are at the top
- ✅ Similar words are grouped together sequentially
- ✅ Opposite/contrasting words follow their similar counterparts

## Important Notes

- **Focus on necessity** - Only include vocabulary that is essential for comprehension
- **Avoid redundancy** - Don't include common words that don't need explanation
- **Maintain accuracy** - Ensure translations and parts of speech are correct
- **Keep it practical** - The goal is to help readers understand the content, not create an exhaustive dictionary
- **Be selective** - Quality over quantity - fewer essential words are better than many unnecessary ones

## Use Cases

This prompt can be applied to:
- Q&A materials and study guides
- Topic-based educational content
- Language learning materials
- Technical documentation with terminology
- Any structured content where vocabulary extraction would be helpful


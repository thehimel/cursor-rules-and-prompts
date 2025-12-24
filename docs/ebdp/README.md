# Equation-Based DRY Prompting: A Simple Technique for More Concise AI Prompts

After using 1B tokens and 3.8K agents in 2025 with LLMs, I've discovered a technique for optimizing AI prompts that's been really helpful. I thought I'd share it in case others find it useful too.

## The Problem

Like many of you, I've noticed that my prompts were getting longer and longer. Rules were repeated across multiple sections, explanations were verbose, and examples were duplicated. The prompts worked, but they were harder to maintain and took up unnecessary space.

## The Discovery

While refactoring a course structure prompt, I started applying some familiar software engineering principles—specifically DRY (Don't Repeat Yourself)—but adapted it for prompt engineering. I also began using simple mathematical notation to replace verbose explanations.

The result? The prompt went from 225 lines to 82 lines (about 64% reduction) while maintaining all functionality and actually improving readability.

## What is Equation-Based DRY Prompting?

**Equation-Based DRY Prompting (EBDP)** is a technique that combines:

1. **Core Rule Consolidation**: Extract repeated rules into a single "Core Rules" section and reference them throughout, rather than repeating them
2. **Mathematical Notation**: Use simple equations (`≤`, `≥`, `→`, `=`, `{A|B}` patterns) instead of verbose explanations
3. **List-to-Sentence Conversion**: Merge related bullet points into concise sentences
4. **Section Merging**: Combine similar sections to eliminate redundancy
5. **Example Reduction**: Keep only the most representative examples, use pattern notation

## A Quick Example

**Before:**
```
- If 9 or fewer items: use single digits (1, 2, 3, ...)
- If 10 or more items: use zero-padded double digits (01, 02, 03, ...)
- Apply consistently within each level
```

**After:**
```
For count `c` items at each level:
- `c ≤ 9` → format = `N` (1, 2, 3, ...)
- `c ≥ 10` → format = `NN` (01, 02, 03, ...)
```

The equation format is more scannable and takes less space while being just as clear.

## Why It Works

- **Reduces cognitive load**: Less to read, easier to scan
- **Easier maintenance**: Change a rule once, not in multiple places
- **Better structure**: Core rules at the top create clear hierarchy
- **Preserves functionality**: All original capabilities remain intact
- **Cost savings**: Smaller prompts mean fewer input tokens, directly reducing API costs

## Cost Optimization

Reducing prompt size directly translates to cost savings. Since LLM pricing is typically based on input tokens (prompt
tokens), a 40-60% reduction in prompt size means proportional savings on every API call.

**Example calculation** (based on [LLM pricing data](https://www.llm-prices.com/) as of December 24, 2025):

If your original prompt uses 10,000 tokens and you reduce it by 50%:

- **Before**: 10,000 input tokens per call
- **After**: 5,000 input tokens per call
- **Savings**: 50% reduction in input token costs

For high-volume usage, this adds up quickly. If you're making 1,000 calls per day:

- **Daily savings**: 5,000 tokens × 1,000 calls = 5M tokens saved per day
- **Monthly savings**: ~150M tokens saved

### Cost Savings by Model

Here's a practical breakdown of cost savings for popular models when reducing prompt size by 50% (10,000 → 5,000 tokens
per call, 1,000 calls/day):

| Model                    | Input Cost (per 1M tokens) | Original Cost/Day | After 50% Reduction | Daily Savings | Monthly Savings |
|--------------------------|----------------------------|-------------------|---------------------|---------------|-----------------|
| **OpenAI GPT-4 Turbo**   | $10.00                     | $100.00           | $50.00              | $50.00        | ~$1,500         |
| **OpenAI GPT-4**         | $30.00                     | $300.00           | $150.00             | $150.00       | ~$4,500         |
| **OpenAI GPT-3.5 Turbo** | $0.50                      | $5.00             | $2.50               | $2.50         | ~$75            |
| **Claude 3.5 Sonnet**    | $3.00                      | $30.00            | $15.00              | $15.00        | ~$450           |
| **Claude 3 Opus**        | $15.00                     | $150.00           | $75.00              | $75.00        | ~$2,250         |
| **Claude 3.5 Haiku**     | $0.25                      | $2.50             | $1.25               | $1.25         | ~$37.50         |

*Pricing data from [LLM pricing calculator](https://www.llm-prices.com/) as of December 24, 2025*

**Key insight**: For premium models like GPT-4 or Claude 3 Opus, the savings are substantial. Even a 40% reduction (
which is more conservative) would save $60-120 daily on GPT-4, or $1,800-3,600 monthly.

The beauty of EBDP is that you get these cost savings while actually improving prompt clarity and maintainability—a
win-win.

## The Key Principle

The most important thing I learned: **Clarity > Brevity**. The goal isn't to make prompts as short as possible—it's to make them as clear and maintainable as possible while removing unnecessary repetition.

## Try It Yourself

If you have prompts that feel repetitive or verbose, try:
1. Identifying repeated rules/explanations
2. Extracting them into a "Core Rules" section
3. Replacing verbose explanations with simple equations
4. Merging similar sections

You might be surprised by how much you can reduce while improving clarity.

## What I'd Love to Know

Have you tried similar techniques? What's worked for you in prompt optimization? I'm always learning and would appreciate your thoughts and experiences.

---

*Note: I've named this technique "Equation-Based DRY Prompting" (EBDP) for easy reference, but honestly, it's just applying good software engineering principles to prompt design. Nothing revolutionary—just practical.*


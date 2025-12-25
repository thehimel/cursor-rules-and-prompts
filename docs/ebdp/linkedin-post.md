# LinkedIn Post: Equation-Based DRY Prompting

---

After using 1B tokens and 3.8K agents in 2025 with LLMs, I've discovered a simple technique for optimizing AI prompts that's been really helpful. Thought I'd share it in case others find it useful too.

**The Problem**: My prompts were getting longer—rules repeated across sections, verbose explanations, duplicate examples. They worked, but were harder to maintain.

**The Discovery**: While refactoring a prompt, I applied DRY principles (Don't Repeat Yourself) + simple mathematical notation. Result? 225 lines → 82 lines (64% reduction) while improving readability.

**Equation-Based DRY Prompting (EBDP)** combines:
✅ Core Rule Consolidation (extract repeated rules, reference them)
✅ Mathematical Notation (use `≤`, `≥`, `→`, `{A|B}` instead of verbose text)
✅ List-to-Sentence conversion
✅ Section merging
✅ Example reduction

**Example:**
Before: "If 9 or fewer items: use single digits. If 10 or more items: use zero-padded double digits."

After: `c ≤ 9 → format = N` | `c ≥ 10 → format = NN`

The equation format is more scannable and takes less space while being just as clear.

**Why it works:**
- Reduces cognitive load
- Easier maintenance (change once, not multiple places)
- Better structure (core rules at top)
- Preserves all functionality
- **Cost savings**: 40-60% smaller prompts = proportional reduction in input token costs

**Cost impact**: A 50% prompt reduction = 50% fewer input tokens per call. Real numbers (10K→5K tokens, 1K calls/day):

💰 **GPT-4 Turbo**: $1,500/month saved
💰 **GPT-4**: $4,500/month saved  
💰 **Claude 3.5 Sonnet**: $450/month saved
💰 **Claude 3 Opus**: $2,250/month saved

Even a 40% reduction saves $1,800-3,600/month on premium models. ([LLM pricing](https://www.llm-prices.com/), Dec 2025)

All while improving clarity. Win-win! 💰

**Key principle**: Clarity > Brevity. The goal isn't to make prompts as short as possible—it's to make them clear and maintainable while removing unnecessary repetition.

Have you tried similar techniques? What's worked for you in prompt optimization? Always learning and would appreciate your thoughts! 💭

#AIPrompts #PromptEngineering #DRY #SoftwareEngineering

---

*Note: I've named this "Equation-Based DRY Prompting" (EBDP) for reference, but it's really just applying good software engineering principles to prompt design. Nothing revolutionary—just practical.*


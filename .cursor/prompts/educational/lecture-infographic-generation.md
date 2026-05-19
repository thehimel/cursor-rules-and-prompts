---
id: prompt-lecture-infographic-generation
author: Himel Das
description: Generate premium AWS-style infographic lecture diagrams from notes via image generation (1920×1080, 16:9)
---

# Lecture Infographic Generation

Generate a **presentation-ready infographic slide** from lecture notes. Output = single image (**Image Generation**). Style = modern cloud-training aesthetic (AWS certification slide quality).

## Constants

- **RESOLUTION**: `1920×1080` | **ASPECT**: `16:9`
- **PRIMARY**: dark navy blue | **SECONDARY**: AWS orange | **ACCENTS**: green, purple, cyan | **NEUTRALS**: white, light gray
- **SECTIONS**: 7 (see **Content Structure**)

## Core Rules

### Copyright & Text
- **Paraphrase only**: Never copy notes verbatim; preserve technical meaning with fresh wording
- **Concise bullets** only (no paragraphs); keywords emphasized visually in the brief
- Readable from a projector; teaching-friendly summaries

### Visual Style
- Modern educational infographic; clean vector graphics; professional typography
- White/light background; colored content cards; soft shadows; rounded corners; subtle gradients
- Flat modern icons (cloud, server, storage, maps, workflow arrows); consistent icon style
- Minimal clutter; balanced spacing/alignment; ultra-sharp, enterprise-grade

### Layout
- **Top-left**: large bold title | **Top-right**: small logo/icon area
- **Center**: process/workflow/architecture diagram (main focus)
- **Surround**: supporting info cards in multi-section layout
- **Bottom**: key takeaways summary bar
- Connectors: arrows, workflow lines, network/map accents for distributed topics

### Section Card Pattern
Each section → colored header banner + relevant icon + short bullets. Emphasize key concepts via contrasting colors, larger icons, flow arrows, emphasis boxes.

## Content Structure

Map paraphrased lecture content to these 7 sections:

| # | Section | Role |
|---|---------|------|
| 1 | Definition / Overview | What it is |
| 2 | Importance / Purpose | Why it matters |
| 3 | Types / Categories | Variants or classifications |
| 4 | Workflow / Architecture Flow | **Central diagram** — steps, data flow, components |
| 5 | Key Components | Building blocks |
| 6 | Best Practices / Notes | Guidance, cautions |
| 7 | Key Takeaways | Bottom summary bar — 3–5 memorable points |

## Input

User provides lecture notes (pasted after prompt). No notes → ask for source material before generating.

## Process

1. **Analyze** notes: concepts, relationships, workflow, components, takeaways
2. **Paraphrase** into **SECTIONS** bullets (unique wording, accurate terminology)
3. **Plan layout**: central flow (§4) + surrounding cards (§1–3, §5–6) + bottom bar (§7)
4. **Build image brief**: style (**Core Rules**), palette (**Constants**), layout, all section text (concise)
5. **Generate** image at **RESOLUTION**, **ASPECT** via image generation
6. **Deliver**: image + optional short caption listing section topics covered

## Image Generation Brief

Include in the generation request:

```
Premium educational infographic, AWS/cloud training slide style.
Resolution: 1920×1080, aspect ratio 16:9.
Colors: primary dark navy, secondary AWS orange, accents green/purple/cyan, light background.
Layout: [title top-left] [icon top-right] [central workflow diagram] [surrounding cards] [takeaways bar bottom].
Style: clean vector, rounded cards, soft shadows, subtle gradients, flat icons, professional typography.
Sections:
1. [title + bullets]
...
7. [takeaways bullets]
Central diagram: [workflow description with arrows and icons].
```

Fill all bracketed content from paraphrased notes. Keep every bullet short (≤ 12 words when possible).

## Quality Checklist

- [ ] All **SECTIONS** present with paraphrased (non-verbatim) content
- [ ] Central workflow/architecture diagram is the visual focus
- [ ] Palette and style match **Core Rules** and **Constants**
- [ ] Text is concise, scannable, presentation-ready
- [ ] Image is 1920×1080, 16:9, sharp, balanced, uncluttered
- [ ] No copied sentences from source notes

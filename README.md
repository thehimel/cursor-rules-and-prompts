# 🎯 Cursor Rules & Prompts

> 💡 **Stop repeating yourself.** Make Cursor AI follow your coding standards automatically.

[![License](https://img.shields.io/badge/License-Proprietary-red.svg)](LICENSE)
[![Maintained](https://img.shields.io/badge/Maintained-Yes-success.svg)](https://github.com)

A comprehensive collection of rules and prompts that transform Cursor from a helpful assistant into a team member who knows your codebase conventions. These rules enforce best practices, maintain code quality, and ensure consistency—without you having to explain the same things over and over.

<div align="left">

<a href=".cursor/rules" style="text-decoration: none; display: inline-block; margin: 10px;">
  <img src="https://img.shields.io/badge/📋_RULES-4A90E2?style=for-the-badge&logo=book&logoColor=white" alt="Rules" style="height: 70px;"/>
</a>
<a href=".cursor/prompts" style="text-decoration: none; display: inline-block; margin: 10px;">
  <img src="https://img.shields.io/badge/💬_PROMPTS-50C878?style=for-the-badge&logo=lightbulb&logoColor=white" alt="Prompts" style="height: 70px;"/>
</a>

</div>

## 📖 What This Is

Ever find yourself constantly reminding Cursor to "use `@/` instead of relative paths" or "don't add inline styles"? This repository solves that. 🤯

Instead of manually correcting the AI every time, these rules ensure it follows your standards automatically. Think of it as a coding style guide that the AI actually reads, understands, and applies consistently across your entire project.

> 💼 **It's like having a senior developer review every AI-generated change before it hits your codebase.**

## Key Features

✨ **Automatic Enforcement** - Rules apply automatically, no manual intervention needed  
🎯 **Project-Agnostic** - Works with any tech stack, easily customizable  
📚 **Comprehensive** - Covers code style, organization, documentation, and more  
🔄 **Maintainable** - Well-organized, easy to understand and modify  
🚀 **Time-Saving** - Stop repeating the same instructions to AI

## 🎁 Why Use This

- ✅ **Consistency**: Your codebase stays consistent even when multiple people (or AI) work on it
- ⚡ **Less Review Time**: Fewer style issues means faster code reviews
- 🚀 **Better Onboarding**: New team members (and AI) understand your patterns immediately
- 🛡️ **Quality by Default**: Best practices are enforced automatically, not by memory
- ⏱️ **Time Savings**: Stop explaining the same conventions repeatedly

## 💡 Real-World Example

**❌ Before**: You ask Cursor to create a component, and it generates:
```typescript
import { Button } from '../../../components/ui/button';
import { MyType } from '../types';
```

**✅ After**: With these rules, Cursor automatically generates:
```typescript
import { Button } from '@/components/ui/button';
import { MyType } from '@/components/quiz/types';
```

🎉 The AI knows your conventions and follows them without being told!

## 🚀 Quick Start

### Option 1: Manual Setup
1. 📥 **Clone or copy this repository** into your project
2. 📁 **Place the `.cursor` folder** in your project root
3. ✨ **That's it** - Cursor will automatically use these rules

### Option 2: Automatic Sync (Recommended)
Use the sync script to automatically keep your `.cursor` directory updated:

```bash
# Download and run the sync script
curl -o sync-cursor-rules.sh https://raw.githubusercontent.com/thehimel/cursor-rules-and-prompts/main/sync-cursor-rules.sh
chmod +x sync-cursor-rules.sh
./sync-cursor-rules.sh
```

> 📌 **Sync Script Version:** `1.0.0`
> 
> ⚠️ **Important:** Before running the sync script, always download the latest version to ensure you have the most recent updates. The script will display its version number when run - compare it with the version shown above. If your script version is older, download the updated script first.

The script will:
- 📋💬 Let you choose what to sync: Rules only, Prompts only, or Both
- ✅ Copy selected files if `.cursor` doesn't exist
- 🔄 Compare and sync files if `.cursor` already exists
- ❓ Ask before replacing modified files
- ➕ Automatically add new files from the repository

> 💬 The rules are organized by category and apply automatically when you're working in Cursor. No configuration needed.

## 📦 What's Included

This repository contains a growing collection of rules and prompts organized by category. The rules cover areas like:

- 🎨 **Code Style**: Import patterns, component structure, styling conventions
- 📂 **Organization**: File structure, feature organization, code migration
- 📝 **Documentation**: Writing standards, comment style, documentation patterns
- 🏗️ **Infrastructure**: Route management, configuration patterns
- 🚫 **Constraints**: What to avoid, best practices
- 📚 **Dependencies**: Library selection, component usage

> 📍 Rules are stored in `.cursor/rules/` organized by category, and reusable prompts are in `.cursor/prompts/`. The collection continues to grow as new patterns and best practices are identified. 🌱

## 📋 Rule Format

All rules follow a consistent format:

```markdown
---
alwaysApply: true | false
description: Brief description of what the rule does
author: Himel Das
---

# Rule Title

## Section
- Rule content
- More rules
```

Rules are:
- ✂️ **Concise and generic** - work across projects
- 🌍 **Language independent** - not tied to specific tech stacks
- 🎯 **Action-oriented** - explain what to do, not just how
- 📁 **Well-organized** - categorized for easy navigation

## 🎯 Use Cases

### 👥 For Teams
- 🎓 **Onboarding**: New developers (and AI) understand your patterns immediately
- 🔍 **Code Reviews**: Fewer style discussions, more focus on logic
- 🤝 **Consistency**: Multiple developers produce code that looks like one person wrote it

### 🧑‍💻 For Solo Developers
- ⭐ **Quality**: Best practices enforced automatically
- ⚡ **Speed**: Less time fixing style issues, more time building features
- 🔮 **Future-Proofing**: When you add team members, they'll follow the same patterns

### 🌐 For Open Source Projects
- 🤝 **Contributor Experience**: Clear, consistent rules for everyone
- 🔧 **Maintainability**: Easier to maintain when code follows patterns
- 📖 **Documentation**: Rules serve as living documentation of your standards

## 🛠️ Customization

These rules are designed to be:
- 🔄 **Generic enough** to work in most projects
- 🎯 **Specific enough** to be useful
- ✏️ **Easy to modify** for your needs

Feel free to:
- ➕ Add your own rules
- ✏️ Modify existing ones
- ➖ Remove rules that don't fit your project
- 📁 Create new categories as needed

> 📖 See the rule creation guidelines in `.cursor/rules/organization/rule-creation.mdc` for details on creating new rules.

## 🤝 Contributing

This is a proprietary project. For permissions or inquiries, please contact Himel Das.

## 📄 License

**PROPRIETARY LICENSE - All Rights Reserved**

Copyright (c) 2025 Himel Das

This software is proprietary and confidential. You are NOT permitted to:
- ❌ Share, distribute, or publish this software
- ❌ Modify or create derivative works
- ❌ Use this software for commercial purposes

If you are granted explicit permission to share, you must provide attribution to Himel Das.

See [LICENSE](LICENSE) file for full terms and conditions.

## 👤 Author

**Himel Das**

Created to help developers leverage Cursor AI more effectively and maintain high code quality standards.

---

## 🎬 Getting Started Today

1. 🍴 **Fork or clone this repository**
2. 📁 **Copy the `.cursor` folder** to your project root
3. 💻 **Start coding** - the rules work automatically

> ✨ No setup, no configuration, no hassle. Just better code, automatically.

> ⚠️ **Note**: These rules work with Cursor's AI features. Make sure you have [Cursor](https://cursor.sh) installed and the `.cursor` folder in your project root for them to take effect.

---

<div align="left">

**Made with ❤️ for the developer community**

If this helps you write better code, consider giving it a ⭐ and sharing it with your team!

[⬆ Back to Top](#-cursor-rules--prompts)

</div>

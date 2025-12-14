---
id: prompt-architecture-diagram-generation
description: Prompt for generating comprehensive architectural diagrams using Mermaid syntax for any software project
author: Himel Das
---

# Architecture Diagram Generation

## Purpose

This prompt guides the creation of comprehensive architectural documentation using Mermaid diagrams. It helps visualize system architecture, data flows, component hierarchies, and technology stacks for any software project.

## Input Requirements

When using this prompt, provide:

1. **Project context** - Brief description of the project and its purpose
2. **Technology stack** - List of technologies, frameworks, and libraries used
3. **System components** - Key components, layers, and modules
4. **Data flow requirements** - How data moves through the system
5. **Target file path** - Where the architecture diagram file should be created (optional)

### Target File Path Determination

If target file path is not explicitly provided:

- **First priority**: Use the currently open file in the editor if it exists and is a markdown file
- **Second priority**: Intelligently determine the appropriate file path based on:
  - Project structure (typically `docs/architecture-diagram.md` or `docs/architecture.md`)
  - Existing documentation directory structure
  - Create the file if it doesn't exist in the appropriate location

## Diagram Types to Generate

### 1. System Architecture Overview

Create a top-to-bottom (`graph TB`) diagram showing:

- **Client Layer**: Different client types (web browsers, mobile apps, desktop apps, etc.)
- **Frontend Application**: Framework, UI components, routing, state management
- **Authentication & Authorization**: Auth providers, session management, role-based access
- **API Layer**: API routes, endpoints, and handlers
- **Security System**: Middleware, protection mechanisms, security headers
- **Data Layer**: Static data, database, ORM, data models
- **External Services**: Third-party integrations
- **Build & Deployment**: Deployment platform, environment configuration

**Connections**: Show relationships between components using arrows (`-->`)

**Styling**: Apply color coding to important components using `style` declarations

### 2. Data Flow Architecture

Create a sequence diagram (`sequenceDiagram`) showing:

- **Participants**: User, Browser, Middleware, Auth, Authorization, API, ORM, Database
- **Flow**: Request → Authentication → Authorization → API → Database → Response
- **Alternatives**: Use `alt` blocks to show different scenarios (authorized/unauthorized, success/error)

### 3. Component-Specific Architecture

For major subsystems, create focused diagrams:

- **Authentication Flow**: Sign in/up → Session creation → Permission checking → Route protection
- **Admin Panel**: Resource management, CRUD operations, form system, validation
- **Security System**: Configuration → Components → Protection mechanisms → Hooks
- **PWA/Mobile**: Web app → PWA features → Native app wrapper → Platform features

### 4. Technology Stack Summary

Create a mindmap (`mindmap`) showing:

- Root node with project name
- Main categories (Frontend, Backend, Database, Authentication, etc.)
- Subcategories with specific technologies
- Organized hierarchically

### 5. Component Hierarchy

Create a top-down diagram (`graph TD`) showing:

- Root component (e.g., `_app.tsx` or main entry point)
- Provider components
- Layout components
- Feature components
- Nested component relationships

### 6. API Architecture

Create a left-to-right diagram (`graph LR`) showing:

- **Public APIs**: Unauthenticated endpoints
- **Protected APIs**: Authenticated endpoints
- **API Protection**: Middleware layers, permission checks
- **Data Access**: ORM, database connections

## Mermaid Syntax Guidelines

### Node Definitions

- Use descriptive node IDs in UPPERCASE with underscores (e.g., `API_AUTH`, `USER_TABLE`)
- For labels with special characters (`/`, `*`, etc.), wrap in double quotes: `API_AUTH["/api/auth/*\nDescription"]`
- Use `\n` for line breaks in labels, NOT `<br/>` HTML tags
- For database tables, use cylinder shape: `USER_TABLE[(User Table)]`
- Keep node labels concise but descriptive

### Subgraphs

- Use subgraphs to group related components
- Provide descriptive subgraph labels in quotes: `subgraph "API Layer"`
- Nest subgraphs when appropriate to show hierarchy

### Connections

- Use `-->` for directed connections
- Use `-.->` for optional or conditional connections
- Use `-->>` for return flows in sequence diagrams
- Label connections when needed: `A -->|Label| B`

### Styling

- Apply colors to important nodes: `style NODE_NAME fill:#color`
- Use consistent color scheme:
  - Primary framework: Blue tones
  - Database: Dark gray/black
  - Authentication: Purple/indigo
  - Security: Orange/yellow
  - Admin: Red/pink
  - Deployment: Black

### Common Patterns

```mermaid
# System Architecture
graph TB
    subgraph "Layer Name"
        NODE1[Node 1]
        NODE2[Node 2]
    end
    NODE1 --> NODE2
    style NODE1 fill:#color

# Sequence Diagram
sequenceDiagram
    participant A
    participant B
    A->>B: Request
    B-->>A: Response

# Mindmap
mindmap
    root((Root))
        Category1
            Item1
            Item2
```

## Process

### 1. Analysis

- Analyze the project structure and codebase
- Identify key components, layers, and relationships
- Understand data flow and authentication mechanisms
- Note external integrations and services

### 2. Diagram Creation

- Start with System Architecture Overview (most comprehensive)
- Create Data Flow Architecture for key user journeys
- Add Component-Specific Architecture for major subsystems
- Include Technology Stack Summary
- Add Component Hierarchy if applicable
- Create API Architecture diagram

### 3. Syntax Validation

- Ensure all node labels with special characters are quoted
- Use `\n` instead of `<br/>` for line breaks
- Verify all node IDs are unique
- Check that all referenced nodes in connections are defined
- Validate Mermaid syntax before finalizing

### 4. Organization

- Use clear section headers for each diagram type
- Add brief descriptions before each diagram
- Group related diagrams together
- Include a summary section with key architectural decisions

### 5. Documentation

- Add a title and brief introduction
- Include a "Key Architectural Decisions" section at the end
- Document important design choices and patterns
- Keep descriptions generic and technology-agnostic where possible

### 6. README Integration

- Locate or create the main README file (typically `README.md` in the project root)
- Add a link to the architecture diagram in an appropriate section:
  - **Recommended placement**: After "Quick Start" or "Getting Started" section
  - **Alternative placements**: In a "Documentation" section or "Architecture" section
- Use a descriptive section header (e.g., "📐 Architecture" or "Architecture")
- Include a brief description explaining what the diagram contains
- Use relative path from README to architecture diagram file (e.g., `docs/architecture-diagram.md`)
- Format example:
  ```markdown
  ## 📐 Architecture

  For a detailed overview of the system architecture, including diagrams of the component hierarchy, data flow, authentication, and API structure, see the [Architecture Diagram Documentation](docs/architecture-diagram.md).
  ```

## Output Format

The final markdown file should:

- Start with a title and brief project description
- Contain multiple Mermaid diagram code blocks
- Each diagram in its own section with a descriptive header
- Use proper markdown formatting
- Include a summary section with architectural decisions
- End with exactly one newline character

## Common Issues and Solutions

### Issue: Lexical errors with special characters

**Solution**: Wrap node labels containing `/`, `*`, or other special characters in double quotes:
```mermaid
# Wrong
API_AUTH[/api/auth/*<br/>Description]

# Correct
API_AUTH["/api/auth/*\nDescription"]
```

### Issue: Line breaks not working

**Solution**: Use `\n` instead of `<br/>`:
```mermaid
# Wrong
NODE[Label<br/>Description]

# Correct
NODE["Label\nDescription"]
```

### Issue: Unrecognized node references

**Solution**: Ensure all nodes are defined before being referenced in connections, and node IDs match exactly (case-sensitive).

## Guidelines

- Keep diagrams generic and reusable - avoid project-specific details that limit reusability
- Use consistent naming conventions across all diagrams
- Group related components logically in subgraphs
- Show clear relationships with well-placed connections
- Apply consistent styling to highlight important components
- Validate Mermaid syntax before finalizing
- Make diagrams readable at different zoom levels
- Avoid overcrowding - split complex systems into multiple focused diagrams

## Remember

- The goal is to create clear, comprehensive architectural documentation
- Diagrams should be self-explanatory with minimal text
- Use consistent patterns and conventions throughout
- Test diagrams render correctly in the target markdown viewer
- Keep content generic and applicable to any project type
- Always validate Mermaid syntax to prevent rendering errors
- **Always link the architecture diagram in the main README** to make it discoverable

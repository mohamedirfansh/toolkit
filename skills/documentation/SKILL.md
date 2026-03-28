# Skill: Documentation

## When to use this skill
Activate when writing README files, API docs, inline code comments, architecture decision records (ADRs), or any technical documentation.

## Principles
- **Documentation is for the reader, not the writer.** Write for someone who doesn't have your context.
- **Docs rot.** Only document what won't change often. Let the code speak for stable implementation details.
- **Examples over descriptions.** A working code example is worth 10 paragraphs.
- **One source of truth.** Never duplicate documentation — link instead.

## README Structure (for a project)

```markdown
# Project Name

> One-sentence tagline describing what it does and for whom.

## Quick Start
<The minimum steps to go from zero to running. Copy-pasteable.>

## What it does
<2-3 paragraphs: problem, solution, key features. No marketing fluff.>

## Installation
<Prerequisites, then step-by-step install commands.>

## Usage
<Most common use cases with examples first. Edge cases later.>

## Configuration
<Table of all config options: name, type, default, description.>

## API Reference (if applicable)
<Link to generated docs or inline for small APIs.>

## Contributing
<How to set up dev environment. How to run tests. PR process.>

## License
```

## API Documentation

For every public function/endpoint, document:

```
Function: <name>
Purpose: <one sentence — what problem does it solve?>
Parameters:
  - <name> (<type>): <description> [default: <default>]
Returns: <type> — <description>
Throws: <ErrorType> — <when>
Example:
  <working code example>
Notes: <edge cases, performance considerations, deprecation notices>
```

## Code Comments

**Comment the WHY, not the WHAT:**
```javascript
// BAD: Increment counter
counter++;

// GOOD: Compensate for the 0-based index offset in the legacy API response
counter++;
```

**When to comment:**
- Non-obvious business logic or algorithmic choices
- Workarounds for known bugs (link to issue)
- Performance-sensitive sections
- Magic numbers and their origin

**When NOT to comment:**
- Self-explanatory code (`// Get user by id` above `getUserById(id)`)
- Commented-out code (delete it, git has history)
- TODO comments without a ticket number

## Architecture Decision Records (ADRs)

Use ADRs for significant technical decisions. Store in `docs/decisions/`.

```markdown
# ADR-001: <Decision title>

**Date:** YYYY-MM-DD
**Status:** Proposed | Accepted | Deprecated | Superseded by ADR-XXX

## Context
<What is the issue that motivated this decision?>

## Decision
<What was decided?>

## Consequences
<What becomes easier? What becomes harder? What are the trade-offs?>

## Alternatives considered
<What else was considered and why was it rejected?>
```

## Documentation Checklist
- [ ] New public APIs have docstrings / JSDoc
- [ ] README reflects current setup steps (actually tested)
- [ ] Breaking changes documented in CHANGELOG or migration guide
- [ ] Complex logic has inline comments explaining WHY
- [ ] No dead documentation for removed features

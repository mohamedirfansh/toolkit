---
description: "Use when writing or reviewing production code for clarity, safety, and maintainability."
applyTo: "**/*.{ts,tsx,js,jsx,py,go,rb,rs,java,kt,cs}"
---

# Code Quality Instruction

## Defaults
- Prefer the simplest implementation that satisfies requirements.
- Make behavior explicit rather than relying on side effects.
- Add or update tests for non-trivial logic changes.
- Handle error paths intentionally; do not swallow exceptions.

## Review Checklist
- Is naming clear and domain-oriented?
- Are edge cases and invalid inputs handled?
- Is there unnecessary complexity that can be removed?
- Are contracts and return shapes consistent?

## Output Style
- Explain important trade-offs in 1-3 bullets.
- When suggesting changes, provide concrete diffs or code blocks.
- If uncertain, call out assumptions explicitly.

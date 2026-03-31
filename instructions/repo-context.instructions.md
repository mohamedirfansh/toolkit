---
description: "Use when modifying an existing codebase to stay aligned with project conventions and avoid regressions."
applyTo: "**/*"
---

# Repository Context Instruction

## Before Editing
- Read nearby files to match existing patterns and naming.
- Preserve public APIs unless a change is required.
- Avoid broad refactors unless explicitly requested.

## While Editing
- Keep changes scoped to the requested task.
- Do not revert unrelated user changes.
- Add brief comments only where logic is non-obvious.

## Verification
- Run relevant lint/test checks when available.
- Report what was validated and what was not run.
- If blocked by missing tools or failing environment, state the blocker clearly.

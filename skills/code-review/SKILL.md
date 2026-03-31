---
name: code-review
description: "Use when reviewing code, pull requests, or diffs to identify correctness, security, performance, readability, and maintainability issues."
---

# Skill: Code Review

## When to use this skill
Activate whenever you are asked to review code, a PR, a diff, or a pull request. Also activate when you've just written code and want to self-review before presenting it.

## Review Protocol

### Phase 1 — Understand intent first
Before commenting on anything, state in 1-2 sentences what the code is trying to do. If you cannot determine its intent, ask before reviewing.

### Phase 2 — Structured review pass
Evaluate every piece of code across these dimensions, in order:

1. **Correctness** — Does it do what it claims? Are there edge cases that break it? Off-by-one errors? Null/undefined handling?
2. **Security** — Injection vulnerabilities, insecure defaults, exposed secrets, missing input validation, improper auth checks.
3. **Performance** — N+1 queries, unnecessary re-renders, blocking I/O in hot paths, missing indexes, memory leaks.
4. **Readability** — Naming clarity, function length, cognitive complexity, magic numbers, unclear conditionals.
5. **Maintainability** — DRY violations, tight coupling, missing tests, missing error handling, unclear contracts.
6. **Style** — Consistency with existing codebase conventions (only flag deviations, not personal preference).

### Phase 3 — Severity classification
Label every finding:

- 🔴 **CRITICAL** — Must fix before merge (security bugs, data loss risk, crashes).
- 🟠 **MAJOR** — Should fix (incorrect logic, missing error handling, significant perf issue).
- 🟡 **MINOR** — Nice to fix (naming, readability, small perf).
- 💡 **SUGGESTION** — Optional improvement or alternative approach.

### Phase 4 — Output format

```
## Code Review: <filename or PR title>

**Summary:** <1-2 sentence intent summary>

### Findings

#### 🔴 CRITICAL
- [line X] <description> — <why it matters> — <suggested fix>

#### 🟠 MAJOR
- [line X] ...

#### 🟡 MINOR
- ...

#### 💡 SUGGESTIONS
- ...

### Verdict
[ ] APPROVE  [ ] REQUEST CHANGES  [ ] NEEDS DISCUSSION

**Reason:** <one sentence>
```

## Rules
- Always provide a suggested fix, not just a problem description.
- Never nitpick style when there is no style guide — only flag genuine inconsistencies.
- Praise good patterns briefly at the end if warranted.
- If a file is >300 lines, ask the author to break the review into smaller chunks.

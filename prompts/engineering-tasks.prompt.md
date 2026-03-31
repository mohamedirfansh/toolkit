# Task Prompts

A collection of reusable task-level prompts for common engineering workflows.

---

## Explain this code

```
Explain what this code does in plain English. Structure your explanation as:

1. **Purpose** — What problem does this solve? What does it produce?
2. **Inputs & outputs** — What does it take in, what does it return?
3. **How it works** — Walk through the key steps at a high level (not line-by-line).
4. **Gotchas** — Any non-obvious behaviour, assumptions, or edge cases?

Assume I'm a competent developer but unfamiliar with this specific codebase.

Code:
<paste code here>
```

---

## Write a test for this function

```
Write comprehensive tests for the following function.

Include tests for:
- The happy path (expected input → expected output)
- Edge cases (empty input, null, zero, max values)
- Error cases (invalid input, missing required fields)
- Boundary conditions (off-by-one, limits)

Use <Jest / Pytest / Go test / RSpec — choose one> as the testing framework.
Name each test to describe the behaviour being tested, not the implementation.

Function:
<paste function here>
```

---

## Convert to async

```
Convert this synchronous code to async/await. 

Requirements:
- Preserve identical behaviour and error handling
- Propagate errors correctly (don't swallow exceptions)
- Don't introduce unnecessary await points
- If there are opportunities to run things in parallel, note them (but only change what's needed for the conversion)

Code:
<paste code here>
```

---

## Add error handling

```
Add proper error handling to this code. 

For each operation that can fail:
1. Identify what can go wrong
2. Decide: should this error be handled locally, or propagated to the caller?
3. Add appropriate handling — catch specific errors, not `catch (e) {}`
4. Ensure resources are cleaned up (files, connections) even on error
5. Log errors with enough context to debug them later

Do NOT catch errors just to silence them. Every catch block must do something meaningful.

Code:
<paste code here>
```

---

## Write a migration

```
Write a database migration for the following schema change.

Requirements:
- Write both the UP migration and the DOWN (rollback) migration
- The migration must be safe to run against a live database with data (zero-downtime if possible)
- If the change is destructive, add a warning comment and make the down migration a no-op if data cannot be recovered
- Use <PostgreSQL / MySQL / SQLite — choose one> syntax

Change needed:
<describe the schema change>

Existing schema (relevant parts):
<paste schema>
```

---

## Optimise this query

```
Optimise the following database query. 

Provide:
1. Analysis of why the current query is slow (with reference to the query plan if provided)
2. The optimised query
3. Any indexes that should be added, with the exact CREATE INDEX statement
4. Explanation of why the optimisation works
5. Any trade-offs (write performance, storage, maintenance)

Query:
<paste query>

Query plan (EXPLAIN output, if available):
<paste here>

Table schemas:
<paste schemas>
```

---

## Write a README

```
Write a README for this project.

Use this structure:
1. Project name + one-line tagline
2. Quick start (copy-pasteable commands to go from zero to running)
3. What it does (2-3 paragraphs, no marketing fluff)
4. Installation (prerequisites + steps)
5. Usage (most common use cases with code examples)
6. Configuration (table of all options)
7. Contributing
8. License

Tone: developer-to-developer. Direct, no filler, examples over descriptions.

Project context:
<describe the project>
```

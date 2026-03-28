# Skill: Test-Driven Development

## When to use this skill
Activate any time you are asked to implement a feature, fix a bug, or write new functionality. TDD is the default mode — not an optional add-on.

## The TDD Cycle (RED → GREEN → REFACTOR)

### 🔴 RED — Write a failing test first
1. Ask yourself: "What is the smallest observable behaviour I need?"
2. Write the test for **that behaviour only**.
3. Run the test and confirm it **fails** with the expected error (not a syntax error).
4. If the test passes before you've written any implementation, the test is wrong — delete it and start over.

### 🟢 GREEN — Write the minimum code to pass
1. Write the **simplest possible code** that makes the failing test pass.
2. Do not write code for cases not yet tested.
3. Run the full test suite. All tests must be green before proceeding.
4. If a previously passing test now fails, fix the regression before moving on.

### 🔵 REFACTOR — Clean up without changing behaviour
1. Improve naming, extract functions, remove duplication.
2. Run the test suite after every change.
3. If tests break during refactor, undo and try a smaller step.

## Rules (Non-negotiable)

- **No implementation before tests.** If you catch yourself writing implementation first, stop and write the test first.
- **One test at a time.** Do not write multiple failing tests at once.
- **Tests must be fast.** If a test takes >100ms, it needs to mock I/O.
- **Delete dead code.** If no test exercises a code path, it shouldn't exist.
- **Tests are documentation.** Test names must describe behaviour, not implementation: `it('returns empty array when user has no orders')` not `it('works')`.

## Anti-patterns to avoid

| Anti-pattern | Why it's wrong | Fix |
|---|---|---|
| Testing implementation details | Breaks on refactor | Test observable behaviour |
| `expect(true).toBe(true)` | Tests nothing | Write a real assertion |
| Mocking everything | Tests the mock, not the code | Only mock I/O and external services |
| Giant test setup | Hides intent | Extract helpers, use factory functions |
| `// TODO: add tests` | Will never happen | Tests or it doesn't exist |

## Output format when implementing with TDD

```
### Test (RED)
<show the failing test>

### Test output
<show the failure message>

### Implementation (GREEN)
<show minimal implementation>

### Test output
<show all passing>

### Refactor (if any)
<show cleanup>
```

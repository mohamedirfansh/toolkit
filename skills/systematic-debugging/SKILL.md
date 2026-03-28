# Skill: Systematic Debugging

## When to use this skill
Activate when facing a bug, unexpected behaviour, test failure, crash, or "it was working and now it isn't" situation. Do NOT guess. Follow this process.

## Phase 1 — Reproduce reliably
**Goal:** Confirm you can make the bug happen consistently.

1. Get the exact reproduction steps.
2. Confirm the bug exists in the **current** codebase (not a stale build).
3. Identify the smallest possible reproduction case.
4. Write the reproduction as a failing test if possible — this becomes your success criterion.

**If you cannot reproduce it:** Do not proceed. Gather more information first.

## Phase 2 — Characterise the failure
Answer these questions before touching any code:

- What is the **expected** behaviour?
- What is the **actual** behaviour?
- When did it **last work**? (Check git log)
- What **changed** since then? (`git diff`, `git bisect` if needed)
- Is it **deterministic** or intermittent?
- What **environment** does it occur in? (OS, runtime version, dependencies)

## Phase 3 — Hypothesise and narrow
Use the scientific method:

1. Form a **single hypothesis** about the root cause.
2. Design an **experiment** to test it (add a log, write an isolated test, change one variable).
3. Run the experiment and **observe**.
4. If disproven, eliminate that hypothesis and form the next one.

**Tracing techniques:**
- Binary search: comment out half the code, see if the bug persists → narrow the suspect zone.
- Rubber duck: explain the code line-by-line out loud (or to the AI).
- Boundary testing: test with empty, nil, max, min, and unexpected type inputs.
- Time travel: `git bisect` to find the exact commit that introduced the bug.

## Phase 4 — Fix and verify
1. Apply the **minimal fix** — do not refactor while fixing.
2. Run the reproduction test → must pass.
3. Run the **full test suite** → nothing new must break.
4. If the fix required a workaround rather than addressing the root cause, open a follow-up ticket.

## Phase 5 — Prevent recurrence
1. Add or update a test that would catch this regression.
2. Consider: is this a symptom of a design problem that needs a larger fix?
3. Document the root cause in the commit message.

## Debug log format (use when reporting progress)

```
🐛 Bug: <one-line description>
📍 Reproduced: yes/no
🔬 Hypothesis: <current theory>
🧪 Experiment: <what I tested>
📊 Result: <what happened>
✅ Root cause: <confirmed cause>
🔧 Fix: <what was changed and why>
```

## Common root causes checklist
- [ ] Off-by-one error (loop bounds, array index)
- [ ] Null / undefined not handled
- [ ] Race condition / async timing
- [ ] Stale cache / build artifact
- [ ] Environment variable missing or wrong
- [ ] Dependency version mismatch
- [ ] Type coercion (JavaScript `==`, Python duck typing)
- [ ] Mutating shared state
- [ ] Wrong default value
- [ ] Missing `await` on async call

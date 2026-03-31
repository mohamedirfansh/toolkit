---
name: git-workflow
description: "Use when handling git operations including branching, commits, pull requests, rebases, merges, and conflict resolution."
---

# Skill: Git Workflow

## When to use this skill
Activate whenever dealing with git operations: branching, committing, PRs, merges, rebases, or resolving conflicts.

## Branch Strategy

### Naming convention
```
<type>/<ticket-id>-<short-description>
```
Types: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `hotfix`

Examples:
- `feat/TK-123-user-authentication`
- `fix/TK-456-null-pointer-on-logout`
- `chore/update-dependencies`

### Branch lifecycle
1. Always branch off from the latest `main` (or `develop` if using gitflow).
2. Keep branches short-lived — aim to merge within 1-2 days.
3. Delete branches after merging.

## Commit Messages (Conventional Commits)

```
<type>(<scope>): <short summary in imperative mood>

[optional body — explain WHY, not WHAT]

[optional footer: BREAKING CHANGE, Fixes #123]
```

**Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`, `ci`

**Rules:**
- Summary ≤72 characters, no period at end.
- Use imperative: "add feature" not "added feature".
- Body explains motivation, not mechanics.
- One logical change per commit.

**Good examples:**
```
feat(auth): add JWT refresh token rotation

Refresh tokens now rotate on each use to prevent token theft.
Old tokens are invalidated immediately after rotation.

Fixes #234
```

```
fix(api): prevent null dereference when user has no profile
```

## Before Every Commit Checklist
- [ ] `git diff --staged` — review what you're actually committing
- [ ] Tests pass locally
- [ ] No debug logs, console.logs, or TODO comments left in
- [ ] No secrets or credentials in the diff
- [ ] Commit message follows convention

## Pull Request Protocol

### Before opening a PR
1. Rebase on latest main: `git fetch origin && git rebase origin/main`
2. Run full test suite.
3. Self-review the diff as if you were the reviewer.

### PR description template
```markdown
## What
<1-2 sentences describing what this PR does>

## Why
<Why this change is needed>

## How
<Notable implementation decisions, trade-offs made>

## Testing
<How you verified this works>

## Screenshots (if UI change)

## Checklist
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] No breaking changes (or BREAKING CHANGE noted)
```

## Conflict Resolution
1. Understand **both sides** of the conflict before resolving.
2. When in doubt, talk to the author of the conflicting code.
3. After resolving, run tests before committing the merge.
4. Never blindly accept "ours" or "theirs" — understand the change.

## Useful Commands
```bash
# Interactive rebase to clean up commits before PR
git rebase -i origin/main

# Find the commit that introduced a bug
git bisect start
git bisect bad HEAD
git bisect good <last-known-good-tag>

# Undo last commit, keep changes staged
git reset --soft HEAD~1

# Stash with a message
git stash push -m "WIP: half-done feature"

# See what's in a stash
git stash show -p stash@{0}
```

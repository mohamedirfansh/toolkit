# 🧰 toolkit

> My personal AI coding toolkit — skills, agents, instructions, and prompts that I use.

## What is this

This repository contains useful skills, agents, instructions and prompt files I use when I code. Feel free to use them in your own project. I mainly use them with GitHub copilot but they can be used with any weapon of your choice.

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/mohamedirfansh/toolkit/master/install.sh | bash
```

That's it. The installer is interactive, and will guide you through the installation process.

## What's inside

| Category | What | Count |
|---|---|---|
| **Skills** | Behaviour guides for AI agents (code review, TDD, debugging…) | 8 |
| **Agents** | Specialised agent personas (planner, reviewer, debugger) | 3 |
| **Instructions** | Reusable always-on or scoped behavior rules | 2 |
| **Prompts** | Reusable system & task prompts | 3 |

## Where these will end up in other AI coding tools

| Tool | Skills | Agents | Instructions | Prompts |
|---|---|---|---|---|
| **Claude Code** | `.claude/commands` | `.claude/agents` | `.claude/instructions` | `.claude/prompts` |
| **Cursor** | `.cursor/rules` | `.cursor/agents` | `.cursor/rules` | `.cursor/rules` |
| **GitHub Copilot** | `.github/skills` | `.github/agents` | `.github/instructions` | `.github/prompts` |
| **Windsurf** | `.windsurf/rules` | `.windsurf/agents` | `.windsurf/rules` | `.windsurf/rules` |
| **Aider** | `.aider/skills` | `.aider/agents` | `.aider/instructions` | `.aider/prompts` |
| **Generic** | `.toolkit/skills` | `.toolkit/agents` | `.toolkit/instructions` | `.toolkit/prompts` |

## Install scopes

The installer will ask you which scope to use:

| Scope | Where files go |
|---|---|
| **Project** | Current directory (`.claude/`, `.cursor/`, etc.) |
| **Workspace** | `~/.config/toolkit/` |
| **Global** | `~/toolkit/` |

## Skills

### `code-review`
Structured multi-pass review with CRITICAL/MAJOR/MINOR/SUGGESTION severity labels. Always suggests a fix alongside every finding.

### `test-driven-development`
Enforces RED-GREEN-REFACTOR. Includes anti-patterns table and output format for TDD sessions.

### `systematic-debugging`
5-phase scientific debugging process: reproduce → characterise → hypothesise → fix → prevent. Includes common bug pattern checklist.

### `git-workflow`
Branch naming conventions, conventional commits, PR description template, safe merge practices.

### `documentation`
README structure template, API docstring format, inline comment rules, ADR template.

### `security-audit`
Full OWASP Top 10 checklist, secrets detection patterns, security finding report format.

### `refactoring`
Safe refactoring catalogue (Extract Function, Rename, Remove Dead Code…), code smell detector table.

### `performance-analysis`
Profiling tool guide per language, database query analysis, performance report format.

## Agents

### `planner`
Translates vague feature requests into precise implementation plans with explicit file paths, verification steps, and dependency ordering.

### `reviewer`
Two-pass code reviewer: spec compliance first, then code quality. Uses CRITICAL/MAJOR/MINOR/NIT severity scale.

### `debugger`
Scientific method debugger. Forms hypotheses, designs experiments, binary-searches codebases. Never guesses.

## Instructions

### `code-quality`
Scoped coding defaults for readability, maintainability, and explicit error handling across common languages.

### `repo-context`
Repository-aware editing guardrails to preserve conventions, avoid unrelated edits, and improve verification discipline.

## Prompts

### `system/senior-engineer`
System-level persona that defaults to senior engineering practices: clarity, correctness, maintainability, and pragmatic trade-offs.

### `system/socratic-tutor`
System-level teaching persona that guides through questions and incremental hints rather than jumping to direct answers.

### `task/engineering-tasks`
Reusable task templates for common engineering work (explain code, write tests, migrations, query optimisation, README drafting).

## License

MIT

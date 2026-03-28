# Contributing to toolkit

## Adding a new skill

1. Create `skills/<your-skill-name>/SKILL.md`
2. Follow this structure:

```markdown
# Skill: <Name>

## When to use this skill
<Trigger conditions — when should an AI agent activate this?>

## <Main section>
<The actual guidance>

## Output format (if applicable)
<Template for how output should look>

## Rules
<Non-negotiable constraints>
```

**Good skills:**
- Are specific and actionable, not vague principles
- Have clear activation triggers
- Include output format templates
- Are short enough to fit in an agent's context window (aim for <200 lines)

## Adding a new agent

Create `agents/<name>/AGENT.md` with:
- Identity (who the agent is)
- Activation conditions
- Process (step by step)
- Output format

## Adding a new instruction

Create instruction files under `instructions/<name>/` using the `.instructions.md` suffix.

Example:
- `instructions/code-quality/code-quality.instructions.md`

Instructions should:
- State clear activation intent in the frontmatter `description`
- Use a scoped `applyTo` pattern when possible (avoid broad always-on patterns unless needed)
- Define practical rules that are easy to follow in normal coding tasks
- Stay concise to avoid unnecessary context usage

## Adding a new prompt

Create a prompt file under one of these folders:
- `prompts/system/<name>.md` for system/persona prompts
- `prompts/task/<name>.md` for reusable task templates

Prompts should:
- Be specific and reusable (avoid one-off context)
- Have clear structure and expected output format when relevant
- Include placeholders where users should inject project-specific details
- Stay concise so they remain easy to scan and copy

## Submitting

1. Fork the repo
2. Create a branch: `feat/add-<name>-skill`
3. Add your contribution
4. Open a PR with a description of what the skill/agent/instruction/prompt does and when to use it

## Updating toolkit.json

After adding anything, update `toolkit.json` to include the new entry in the appropriate array. The installer uses this for discoverability.

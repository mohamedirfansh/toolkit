# Skill: Refactoring

## When to use this skill
Activate when improving existing code without changing its external behaviour. Refactoring is ONLY safe when tests exist. If tests don't exist, write them first.

## Golden Rule
**Never refactor and add features in the same commit.** Refactor first, feature second.

## When to Refactor
- Before adding a feature to the area of code that needs changing
- When code review reveals a problem
- When you've just fixed a bug and see the structural cause
- When the same code appears 3+ times (Rule of Three)

## Refactoring Catalogue

### Extract Function
**Problem:** Code block that needs a comment to explain it.
```python
# Before
total = 0
for item in cart:
    if item.in_stock:
        total += item.price * (1 - item.discount)

# After
def calculate_cart_total(cart):
    return sum(
        item.price * (1 - item.discount)
        for item in cart
        if item.in_stock
    )
total = calculate_cart_total(cart)
```

### Rename Variable
When the name doesn't reveal intent. Rename aggressively.
`d` → `elapsed_days_since_last_login`
`flag` → `is_email_verified`
`data` → `user_profile_response`

### Replace Magic Number with Named Constant
```typescript
// Before
if (attempts > 3) lockAccount();

// After
const MAX_LOGIN_ATTEMPTS = 3;
if (attempts > MAX_LOGIN_ATTEMPTS) lockAccount();
```

### Extract Class
When a class has too many responsibilities. Apply Single Responsibility Principle.

### Introduce Parameter Object
When a function takes 4+ related parameters, group them into an object/struct.

### Replace Conditional with Polymorphism
When a switch/if-else varies behaviour based on a type field.

### Remove Dead Code
If it's not tested and not called, delete it. Git has history.

## Safe Refactoring Process

```
1. Confirm test suite passes (baseline)
2. Apply ONE refactoring
3. Run tests → must still pass
4. Commit with message: "refactor: <what was done>"
5. Repeat
```

Never do more than one refactoring type between test runs.

## Code Smell Detector

| Smell | Symptom | Refactoring |
|---|---|---|
| Long function | >20 lines | Extract Function |
| Long parameter list | >3 params | Parameter Object |
| Duplicate code | Same logic in 2+ places | Extract Function/Method |
| Large class | >200 lines, many responsibilities | Extract Class |
| Feature envy | Method uses another class's data more than its own | Move Method |
| Data clumps | Same 3 fields always appear together | Extract Class |
| Primitive obsession | Using string/int for domain concept | Introduce Value Object |
| Switch statements | Switch on type | Polymorphism |
| Speculative generality | Unused flexibility "for future use" | YAGNI — delete it |
| Commented-out code | Blocks of `//` | Delete it |

## Refactoring Commit Message Convention
```
refactor(<scope>): <describe what structural change was made>

No behaviour changes. All tests pass.
```

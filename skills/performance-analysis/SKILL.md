---
name: performance-analysis
description: "Use when investigating slow code, high memory usage, poor query performance, or planning measurable performance improvements."
---

# Skill: Performance Analysis

## When to use this skill
Activate when diagnosing slow code, high memory usage, poor database query performance, or conducting a pre-launch performance review.

## Rule #1: Measure Before Optimising
> "Premature optimisation is the root of all evil." — Knuth

Never optimise without a benchmark proving there is a problem. Never optimise without a benchmark proving your fix helped.

## Performance Investigation Process

### Step 1 — Define the metric
- What is slow? (latency, throughput, memory, CPU, bundle size)
- What is the target? (p99 < 200ms, memory < 512MB, FCP < 1.5s)
- What is it now? (measure it)

### Step 2 — Profile, don't guess
Use the right profiling tool:

| Environment | Tool |
|---|---|
| Node.js | `--prof`, clinic.js, `node --cpu-prof` |
| Python | `cProfile`, `py-spy`, `memory_profiler` |
| Browser JS | Chrome DevTools Performance tab |
| Browser rendering | Lighthouse, WebPageTest |
| Database | `EXPLAIN ANALYZE` (Postgres), `EXPLAIN` (MySQL) |
| Go | `pprof` |
| Ruby | rack-mini-profiler, stackprof |

### Step 3 — Find the hot path
Look for:
- The function that appears most in the flame graph
- The query that runs the most / takes the longest
- The render that triggers the most re-paints

### Step 4 — Fix one thing at a time
Optimise the biggest bottleneck. Measure again. Repeat.

## Common Performance Anti-patterns

### Database
- **N+1 query:** Loading a list then querying each item individually → use `JOIN` or eager loading
- **Missing index:** Full table scan on a filtered/sorted column → add index
- **SELECT *:** Fetching unused columns → select only what you need
- **No query timeout:** Slow query can block the pool → always set a timeout
- **Unparameterised queries:** Forces re-parse every time → parameterise

```sql
-- Find slow queries (Postgres)
SELECT query, calls, mean_exec_time, total_exec_time
FROM pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 20;
```

### Backend
- **Synchronous I/O in async context:** Blocks the event loop
- **Missing caching:** Re-computing expensive results on every request
- **Unbounded loops:** Processing millions of records in memory
- **String concatenation in a loop:** Use StringBuilder / join instead
- **Redundant JSON serialisation:** Serialise once, not on every transform step

### Frontend
- **Render on every keystroke:** Debounce/throttle user input handlers
- **Missing React.memo/useMemo:** Re-renders entire tree on state change
- **Importing entire library:** `import _ from 'lodash'` → `import debounce from 'lodash/debounce'`
- **Uncompressed images:** Use WebP, set correct dimensions, lazy load
- **Render-blocking scripts:** Defer or async non-critical scripts
- **Layout thrash:** Reading then writing DOM in a loop → batch reads and writes

## Performance Report Format

```
## Performance Analysis: <scope>

### Baseline
- Metric: <what was measured>
- Current: <measured value>
- Target: <goal>

### Root Cause
<Profiling output / query plan / flame graph summary>

### Hotspot
<File:line or query that is the bottleneck>

### Fix
<Proposed change>

### Expected Improvement
<Projected metric after fix, and basis for projection>

### Validation Plan
<How to confirm the fix worked>
```

## Quick Wins Checklist
- [ ] Database queries have indexes on WHERE/ORDER BY columns
- [ ] N+1 queries eliminated
- [ ] Expensive computations cached (Redis, memory, CDN)
- [ ] Images optimised and lazy-loaded
- [ ] API responses paginated (no unbounded lists)
- [ ] Background jobs used for non-real-time work
- [ ] Connection pooling configured
- [ ] gzip/brotli compression enabled

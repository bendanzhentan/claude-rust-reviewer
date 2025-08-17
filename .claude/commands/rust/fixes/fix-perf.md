# /rust-fix-perf

**Description:** Automatically apply performance optimizations to Rust code

## Parameters
- `file_pattern` (string, optional): File pattern to optimize for performance
- `dry_run` (boolean, optional, default: false): Preview changes without applying them

## Prompt

You are a Rust performance expert tasked with automatically applying performance optimizations.

**OPTIMIZATION APPROACH:**
1. Identify performance issues (same criteria as /rust-perf)
2. Apply safe optimizations that don't change behavior
3. Preserve readability while improving efficiency
4. Flag aggressive optimizations for manual review

**AUTO-OPTIMIZABLE:**
- Remove unnecessary `.clone()` calls
- Add capacity hints to Vec allocations
- Chain iterators instead of collecting
- Replace String concatenation with efficient methods
- Use references instead of owned values where possible

**MANUAL REVIEW REQUIRED:**
- Algorithm changes
- Data structure modifications
- Complex iterator transformations

**OUTPUT FORMAT:**
```
⚡ APPLYING PERFORMANCE FIXES

✅ OPTIMIZATIONS APPLIED:
{file}:{line} - {optimization_description}
Before: {original_code}
After:  {optimized_code}

📈 PERFORMANCE IMPACT:
- Estimated {percentage}% improvement in {metric}

⚠️  MANUAL REVIEW SUGGESTED:
{file}:{line} - {complex_optimization}
  // TODO: Consider {suggestion}

📊 SUMMARY:
- {count} optimizations applied
- Estimated overall improvement: {percentage}%
```

{if dry_run}Show what optimizations would be made without applying them.{endif}

Optimize performance in: {file_pattern}
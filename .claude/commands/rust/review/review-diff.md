# /rust-review-diff

**Description:** Review changes in git diff or between branches

## Parameters
- `branch` (string, optional, default: "main"): Branch to compare against (default: main/master)
- `focus` (string, optional, default: "safety,performance"): Focus areas for reviewing changes

## Prompt

You are reviewing changes in a git diff, focusing on the impact of modifications.

**DIFF-FOCUSED REVIEW:**
- Analyze only changed lines and their context
- Assess impact of modifications on existing code
- Identify potential regressions or improvements
- Focus on change-specific issues

**CHANGE ANALYSIS PRIORITIES:**
1. **Breaking Changes**: API modifications, signature changes
2. **Safety Impact**: New unsafe code, ownership changes
3. **Performance Impact**: Algorithm changes, new allocations
4. **Regression Risk**: Logic changes, error handling modifications

**OUTPUT FORMAT:**
```
🔄 GIT DIFF REVIEW
Comparing: current → {branch} | Files changed: {count}

📊 CHANGE SUMMARY:
+ {lines} added | - {lines} removed | ~ {lines} modified

🎯 CRITICAL CHANGES:
{file}:{line} - {change_type}: {impact_description}

⚡ PERFORMANCE IMPACT:
{file}:{line} - {performance_change}

🔒 SAFETY CONSIDERATIONS:
{file}:{line} - {safety_impact}

✅ POSITIVE CHANGES:
{file}:{line} - {improvement_description}

⚠️  POTENTIAL REGRESSIONS:
{file}:{line} - {regression_risk}

📋 REVIEW CHECKLIST:
- [ ] No new unsafe code without justification
- [ ] Performance impact assessed
- [ ] Error handling maintained
- [ ] Tests updated for changes

🚀 RECOMMENDATION: {approve|request_changes|needs_discussion}
```

**CHANGE IMPACT ASSESSMENT:**
- Low: Formatting, comments, minor refactoring
- Medium: Logic changes, new features, optimizations  
- High: Architecture changes, unsafe code, performance critical paths

**IMPORTANT REVIEW SCOPE:**
- ONLY review production/library code changes
- SKIP test file changes (files ending in `_test.rs`, `test.rs`, or in `tests/` directory)
- SKIP test module changes (code inside `#[cfg(test)]` blocks)
- SKIP doc test changes (code inside documentation examples)
- Focus exclusively on non-test code changes

Review changes against: {branch}
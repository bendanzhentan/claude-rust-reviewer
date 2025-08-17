# /rust-review

**Description:** Comprehensive Rust code review with prioritized recommendations

## Parameters
- `focus` (string, optional, default: "safety,performance,docs,style"): Comma-separated focus areas: safety,performance,docs,style
- `file_pattern` (string, optional): File pattern to review

## Prompt

You are a senior Rust code reviewer conducting a comprehensive analysis.

**REVIEW SCOPE:** {focus}

**COMPREHENSIVE ANALYSIS:**
1. **Safety Review**: Memory safety, ownership, lifetimes
2. **Performance Review**: Optimization opportunities, efficiency
3. **Documentation Review**: API docs, comments, examples
4. **Style Review**: Best practices, idiomatic patterns

**PRIORITIZATION SYSTEM:**
- **CRITICAL**: Security vulnerabilities, memory safety issues
- **HIGH**: Performance problems, API design issues
- **MEDIUM**: Code quality, maintainability concerns
- **LOW**: Style preferences, minor optimizations

**OUTPUT FORMAT:**
```
📋 COMPREHENSIVE RUST REVIEW
Focus: {focus} | Files: {count} | Issues found: {total}

🎯 CRITICAL PRIORITY (Fix immediately):
1. {file}:{line} - {critical_issue}

⚡ HIGH PRIORITY (Significant impact):
2. {file}:{line} - {high_issue}

📈 MEDIUM PRIORITY (Quality improvement):
3. {file}:{line} - {medium_issue}

📝 LOW PRIORITY (Nice to have):
4. {file}:{line} - {low_issue}

🤖 AUTO-FIXABLE:
- {count} issues can be automatically resolved
- Run `/rust-fix-all` to apply fixes

📊 DETAILED ANALYSIS:
Safety: {score}/10 | Performance: {score}/10 | Docs: {score}/10 | Style: {score}/10

📈 PROJECT HEALTH SCORE: {overall_score}/10

🚀 NEXT STEPS:
1. Address critical issues immediately
2. Run auto-fixes for routine improvements
3. Schedule review for high-priority items
```

**SCORING CRITERIA:**
- Safety: Memory safety, ownership correctness
- Performance: Efficiency, optimization opportunities
- Documentation: Coverage, clarity, examples
- Style: Idiomatic patterns, consistency

**IMPORTANT REVIEW SCOPE:**
- ONLY review production/library code
- SKIP test files (files ending in `_test.rs`, `test.rs`, or in `tests/` directory)
- SKIP test modules (code inside `#[cfg(test)]` blocks)
- SKIP doc tests (code inside documentation examples)
- Focus exclusively on non-test code

Review the following Rust code: {file_pattern}
# /alice-rust

**Description:** Detailed review of a single Rust file

## Parameters
- `file_path` (string, required): Path to the specific file to review
- `focus` (string, optional, default: "safety,performance,docs,style"): Focus areas for the review

## Prompt

You are conducting a detailed review of a **single Rust file**.

**CAREFUL REVIEW PROCESS:**
1. **FIRST**: Deeply understand the target file and its role in the crate
2. **SECOND**: Carefully analyze the codebase for potential issues
3. **THIRD**: Think critically about each code pattern and design choice
4. **FINALLY**: Document understanding and report only problematic code

**DEEP UNDERSTANDING PHASE:**
- Thoroughly analyze file's purpose and role within the larger crate
- Understand all dependencies and how other modules interact with this file  
- Identify key data structures, algorithms, and design patterns
- Map out function relationships and call hierarchies
- Understand the file's position in the overall architecture
- Study the intended behavior vs actual implementation

**CAREFUL ANALYSIS REQUIREMENTS:**
- Think deeply about each function's logic and edge cases
- Consider performance implications of every algorithm choice
- Analyze memory safety and ownership patterns carefully  
- Look for subtle bugs and race conditions
- Evaluate API design and usability thoroughly
- Consider maintainability and future evolution

**CAREFUL TARGETED CODE ANALYSIS:**
- Methodically examine each function and data structure (skip simple functions < 4 lines)
- Use deep file/crate understanding to identify subtle problems
- Think critically about performance bottlenecks and optimization opportunities
- Only report code that genuinely needs fixing - ignore good implementations
- Prioritize issues by impact and complexity of fixes
- Focus review effort on complex logic where bugs are more likely

**SYSTEMATIC ISSUE DETECTION - FOCUS ON ACTUAL PROBLEMS:**

## HIGH PRIORITY (Report these):
1. **Real Performance Issues**: 
   - Algorithmic complexity problems (O(n²) or worse where O(n) is possible)
   - Unnecessary work in hot paths (e.g., fetching all items then truncating vs limiting at source)
   - Memory leaks or unbounded growth
   - NOT: micro-optimizations, nested matches, error formatting

2. **Actual Logic Errors**:
   - Code that produces incorrect results
   - Genuine panic risks (NOT when expect() has clear explanations)
   - Resource leaks (files, sockets, locks not released)
   - Data races and deadlocks in concurrent code

3. **Security Vulnerabilities**:
   - SQL injection, command injection
   - Unvalidated user input leading to exploits
   - Exposed secrets or credentials
   - NOT: theoretical integer overflow in config modules

## MEDIUM PRIORITY (Consider reporting):
1. **Refactoring Opportunities**:
   - Complex functions that genuinely need splitting (>100 lines with multiple responsibilities)
   - Inconsistent delegation patterns that create maintenance burden
   - Code duplication that could cause sync issues

2. **Feature Suggestions**:
   - Missing functionality that would improve the system
   - Better error handling strategies
   - Useful validation that's actually missing

## IGNORE (Do NOT report these):
1. **Style Preferences**: Builder patterns, const usage, formatting choices, wildcard imports, module organization
2. **Theoretical Risks**: Panic possibilities when code has expect() with explanations
3. **Common Rust Patterns**: as_any(), downcast_ref(), standard error handling
4. **Config Module Issues**: Integer overflow in configuration, missing validation in defaults
5. **Non-Critical Path Performance**: Error message formatting, debug/trace code
6. **Well-Understood Trade-offs**: When comments explain the design decision
7. **Already Protected Code**: If debug_assert/assert already guards the condition, don't suggest redundant checks
8. **Minor Code Duplication**: Less than 10 lines of duplicated code that maintains readability
9. **Micro-optimizations**: Optimizations that add complexity without proving 10x+ performance improvement
10. **TODO Comments**: Unless you've verified the condition is actually met (use grep/search to check)

**EVALUATION CRITERIA:**
- **Trust the Developer**: If code has comments explaining assumptions, believe them
- **Prove the Problem**: Only report issues you can demonstrate will cause actual failures
- **Consider Context**: Distinguish between critical paths and non-critical paths
- **Understand Production Code**: This is battle-tested code, not a student project
- **Check for Evidence**: Look for existing tests that validate the behavior
- **Avoid Speculation**: Don't report "potential" issues without concrete scenarios
- **Code Maturity**: If code has been in main branch for 6+ months, assume it's correct unless proven otherwise
- **Cost-Benefit Analysis**: Only suggest changes where benefit clearly outweighs complexity cost

**OUTPUT FORMAT:**

**REPORT OUTPUT:**
Create a detailed report at `.report/{file_path}.md` with the following content:

```markdown
# Code Review Report: {file_path}

**Focus Areas:** {focus}
**Have Reviewed By Human:** false

## 🐛 BUGS (Actual problems that will cause failures)

### [BUG-001] {descriptive_issue_name}
- **Location:** {file_path}:{line}
- **Issue:** {concrete_problem_that_causes_incorrect_behavior}
- **Proof:** {specific_scenario_where_this_fails}
- **Fix:** {exact_code_change_needed}
- **Priority:** HIGH

## ⚡ PERFORMANCE (Provable inefficiencies with O(n) analysis)

### [PERF-001] {descriptive_issue_name}
- **Location:** {file_path}:{line}
- **Current Complexity:** {e.g., O(n) where n is total pool size}
- **Optimal Complexity:** {e.g., O(k) where k is requested count}
- **Impact:** {measurable_impact_in_production_scenario}
- **Fix:** {specific_optimization_with_code}
- **Priority:** HIGH/MEDIUM

## 🔧 REFACTOR (Code organization improvements)

### [REFACTOR-001] {descriptive_issue_name}
- **Location:** {file_path}:{line}
- **Problem:** {maintenance_or_consistency_issue}
- **Benefit:** {concrete_improvement_this_brings}
- **Change:** {specific_refactoring_approach}
- **Priority:** MEDIUM/LOW

## 💡 FEATURE (Missing functionality suggestions)

### [FEATURE-001] {descriptive_issue_name}
- **Location:** {file_path}:{line}
- **Current Gap:** {what_is_missing}
- **Use Case:** {why_this_would_be_valuable}
- **Implementation:** {how_to_add_this_feature}
- **Priority:** MEDIUM/LOW
```

Then provide a console summary:
```
🔍 CAREFUL TARGETED CODE REVIEW COMPLETED: {file_path}
📄 Report generated: .report/{file_path}.md
```

**DEEP VALIDATION STEP:**
After completing the initial review and generating the report, if any issues were found, perform deep validation on each reported issue:

1. **For each issue found** (BUG-001, PERF-001, etc.), use the `/alice-rust-deep` command to validate the issue
2. **Run deep validation**: `/alice-rust-deep .report/{file_path}.md {issue_id}`
3. **This will automatically update the report** with Deep Analysis sections for each issue
4. **The deep validation will classify each issue** as VALID-HIGH/MEDIUM/LOW, QUESTIONABLE, or INVALID-*

**DEEP VALIDATION IMPLEMENTATION:**
```
For each reported issue ID (e.g., BUG-001, PERF-002, CRITICAL-001):
- Execute: /alice-rust-deep {report_file_path} {issue_id}
- This will add Deep Analysis validation to the original report
- Issues marked as INVALID-* can be considered false positives
- Issues marked as VALID-HIGH should be prioritized for fixes
```

**EXAMPLE WORKFLOW:**
1. Generate initial review report with 3 issues: BUG-001, PERF-001, REFACTOR-001
2. Run `/alice-rust-deep .report/crates_pool_src_batcher.md BUG-001`
3. Run `/alice-rust-deep .report/crates_pool_src_batcher.md PERF-001`  
4. Run `/alice-rust-deep .report/crates_pool_src_batcher.md REFACTOR-001`
5. Final report will contain both initial findings and deep validation results

This two-phase approach ensures high-quality issue reporting by eliminating false positives through ultra-deep validation.

**HIGH-VALUE ISSUE CRITERIA:**
Issues must meet these standards to be worth reporting:
1. **Algorithm Complexity**: Must show improvement from O(n²) to O(n) or better
2. **Performance Impact**: Must quantify improvement (e.g., "20,000 operations → 1 lookup")
3. **Logic Errors**: Must provide specific input that produces wrong output
4. **Resource Leaks**: Must identify specific path where resources won't be released

**QUANTIFICATION REQUIREMENTS:**
Every reported issue must answer:
- **Impact Scale**: How many users/operations affected?
- **Performance Gain**: Is improvement 2x, 10x, or more?
- **Cost vs Benefit**: Does the fix complexity justify the improvement?
- **Production Impact**: What's the real-world effect in production scenarios?

**CRITICAL REVIEW GUIDELINES:**
- **QUALITY OVER QUANTITY**: Report 3 high-value issues rather than 10 theoretical ones
- **PROVE IT**: Every issue must have concrete evidence or reproducible scenario
- **TRUST DEVELOPERS**: If code has survived in production, it probably works
- **FOCUS ON HOT PATHS**: Performance only matters where code runs frequently
- **RESPECT COMMENTS**: If a comment explains why something is done, believe it
- **ACTUAL vs THEORETICAL**: Only report what WILL fail, not what MIGHT fail
- **SKIP THE OBVIOUS**: Don't report well-known trade-offs or documented decisions

**ANALYSIS DEPTH REQUIREMENTS:**
- Trace through complex logic paths step by step
- Consider all possible input scenarios and edge cases
- Analyze algorithmic complexity and optimization opportunities
- Examine error handling completeness and correctness
- Evaluate thread safety and concurrency implications
- Check for memory leaks and resource management issues

**IMPORTANT REVIEW SCOPE:**
- ONLY review production/library code
- SKIP test files (files ending in `_test.rs`, `test.rs`, or in `tests/` directory)
- SKIP test modules (code inside `#[cfg(test)]` blocks)
- SKIP doc tests (code inside documentation examples)
- SKIP simple functions with less than 4 lines of code
- Focus exclusively on non-test code with sufficient complexity

Provide detailed analysis of: {file_path}

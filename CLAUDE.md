# Claude Rust Reviewer - Project Memory

## Important: Review-Only Mode
**This tool performs READ-ONLY code review. It will NOT modify your code directly.**
- All issues and suggestions are documented in markdown reports
- Reports are saved in the `.report/` directory
- You decide which changes to implement based on the review findings
- The tool focuses on identifying issues, not automatically fixing them

## Rust Code Review Commands

### Command: /alice-rust
**Description:** Detailed review of a single Rust file

**Parameters:**
- `file_path` (string, required): Path to the specific file to review
- `focus` (string, optional, default: "safety,performance,docs,style"): Focus areas for the review

**Prompt:**

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
   - NOT: micro-optimizations, nested matches, error formatting, iterator chains (iter().filter().collect()), "O(n) + O(n)" iterator patterns that the compiler fuses

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
   - Complex functions that genuinely need splitting (>100 lines with multiple responsibilities) - NOT just nested logic that matches business requirements
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
11. **Iterator Pattern Preferences**: iter().filter().collect() chains - these are idiomatic Rust patterns that are already optimized by the compiler and more elegant than manual loops
12. **Parallel Collection Operations**: Multiple iterator operations that appear to be "2 passes" (e.g., iter() + filter()) - the Rust compiler optimizes these into single-pass operations through iterator fusion
13. **Complex Nested Logic**: Deeply nested if/match statements or complex control flow - sometimes business logic requires complexity and flattening would reduce readability

**EVALUATION CRITERIA:**
- **Trust the Developer**: If code has comments explaining assumptions, believe them
- **Prove the Problem**: Only report issues you can demonstrate will cause actual failures
- **Consider Context**: Distinguish between critical paths and non-critical paths
- **Understand Production Code**: This is battle-tested code, not a student project
- **Check for Evidence**: Look for existing tests that validate the behavior
- **Avoid Speculation**: Don't report "potential" issues without concrete scenarios
- **Code Maturity**: If code has been in main branch for 6+ months, assume it's correct unless proven otherwise
- **Cost-Benefit Analysis**: Only suggest changes where benefit clearly outweighs complexity cost
- **Iterator Fusion**: Rust's compiler optimizes iterator chains (iter().filter().map().collect()) into single-pass operations - don't flag these as "multiple passes"

**OUTPUT FORMAT:**

**REPORT OUTPUT (Read-Only - No Code Modifications):**
Create a detailed review report at `.report/{file_path}.md` with suggested improvements.
**IMPORTANT: This tool only generates reports with suggestions. It does NOT modify any source code files.**

The report will contain:

```markdown
# Code Review Report: {file_path}

**Focus Areas:** {focus}
**Have Reviewed By Human:** false

## 🐛 BUGS (Actual problems that will cause failures)

### [BUG-001] {descriptive_issue_name}
- **Location:** {file_path}:{line}
- **Issue:** {concrete_problem_that_causes_incorrect_behavior}
- **Proof:** {specific_scenario_where_this_fails}
- **Suggested Fix:** {exact_code_change_needed - shown in report only, not applied}
- **Priority:** HIGH

## ⚡ PERFORMANCE (Provable inefficiencies with O(n) analysis)

### [PERF-001] {descriptive_issue_name}
- **Location:** {file_path}:{line}
- **Current Complexity:** {e.g., O(n) where n is total pool size}
- **Optimal Complexity:** {e.g., O(k) where k is requested count}
- **Impact:** {measurable_impact_in_production_scenario}
- **Suggested Fix:** {specific_optimization_with_code - shown in report only, not applied}
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

## 🚨🚨🚨 CRITICAL MANDATORY STEP - DO NOT SKIP 🚨🚨🚨
## **MANDATORY DEEP VALIDATION AND CLEANUP STEP:**

### ⚠️ WARNING: FAILURE TO EXECUTE THIS STEP WILL RESULT IN FALSE POSITIVES ⚠️

After completing the initial review and generating the report, you **ABSOLUTELY MUST**:

1. **🔴 STOP AND COUNT**: Count ALL issues found (BUG-xxx, PERF-xxx, REFACTOR-xxx, FEATURE-xxx)
2. **🔴 FOR EVERY SINGLE ISSUE** without exception, IMMEDIATELY execute `/alice-rust-deep`
3. **🔴 DO NOT PROCEED** to any other task until ALL deep validations are complete
4. **🔴 VALIDATION COMMAND**: `/alice-rust-deep .report/{file_path}.md {issue_id}` 
5. **🔴 REMOVE FALSE POSITIVES**: After ALL validations:
   - Identify ALL issues marked as INVALID-* or QUESTIONABLE
   - COMPLETELY REMOVE these false positive sections from the report
   - Keep ONLY issues marked as VALID-HIGH, VALID-MEDIUM, or VALID-LOW
6. **🔴 UPDATE REPORT**: Clean up the report to show only validated issues

### 📋 **REQUIRED EXECUTION CHECKLIST:**
```
☐ Initial review complete, report written to .report/{file_path}.md
☐ Count total issues found: _____ issues
☐ Execute /alice-rust-deep for EACH issue:
  ☐ Issue #1: /alice-rust-deep .report/{file_path}.md {issue_id_1}
  ☐ Issue #2: /alice-rust-deep .report/{file_path}.md {issue_id_2}
  ☐ Issue #3: /alice-rust-deep .report/{file_path}.md {issue_id_3}
  ☐ ... (continue for ALL issues)
☐ Read updated report with Deep Analysis sections
☐ Remove ALL INVALID-* issues from report
☐ Remove ALL QUESTIONABLE issues from report
☐ Update report summary with final validated issue count
☐ Final report contains ONLY VALID issues
```

### 🔥 **CRITICAL IMPLEMENTATION STEPS:**
```
STEP 1 - INITIAL REVIEW:
- Complete the code review
- Write initial report with all findings
- STOP HERE - DO NOT CONTINUE WITHOUT VALIDATION

STEP 2 - DEEP VALIDATION (MANDATORY):
- For EACH issue (BUG-001, PERF-001, etc.):
  Execute: /alice-rust-deep .report/{file_path}.md {issue_id}
- This MUST be done for EVERY SINGLE ISSUE
- NO EXCEPTIONS - even "obvious" issues need validation

STEP 3 - CLEANUP FALSE POSITIVES:
- Read the validated report
- Find ALL issues marked INVALID-* or QUESTIONABLE
- DELETE these entire sections from the report
- Update issue counts in the summary

STEP 4 - FINAL REPORT:
- Contains ONLY VALID-HIGH/MEDIUM/LOW issues
- All false positives removed
- Accurate, validated findings only
```

### ⚡ **CONCRETE EXAMPLE WITH COMMANDS:**
```bash
# Initial review finds 5 issues
# NOW YOU MUST RUN THESE COMMANDS:

/alice-rust-deep .report/src_main.rs.md BUG-001      # → INVALID-SEMANTICS
/alice-rust-deep .report/src_main.rs.md BUG-002      # → VALID-HIGH
/alice-rust-deep .report/src_main.rs.md PERF-001     # → INVALID-ASSUMPTIONS
/alice-rust-deep .report/src_main.rs.md REFACTOR-001 # → VALID-LOW
/alice-rust-deep .report/src_main.rs.md REFACTOR-002 # → QUESTIONABLE

# After validation, REMOVE from report:
# - BUG-001 (INVALID)
# - PERF-001 (INVALID)
# - REFACTOR-002 (QUESTIONABLE)

# Final report contains ONLY:
# - BUG-002 (VALID-HIGH)
# - REFACTOR-001 (VALID-LOW)
```

### 🛑 **STOP SIGNS - DO NOT IGNORE:**
- 🛑 If you found issues but haven't run /alice-rust-deep → STOP and run it
- 🛑 If you're about to finish without validation → STOP and validate
- 🛑 If you're unsure whether to validate → YES, ALWAYS validate
- 🛑 No issue is too small or obvious to skip validation

### ❌ **COMMON MISTAKES TO AVOID:**
- ❌ Forgetting to run /alice-rust-deep for some issues
- ❌ Assuming an issue is "obviously correct" without validation
- ❌ Leaving INVALID or QUESTIONABLE issues in the final report
- ❌ Not updating the summary after removing false positives
- ❌ Skipping validation because the issue "seems valid"

### ✅ **SUCCESS CRITERIA:**
The review is ONLY complete when:
1. ✅ Every single issue has been validated with /alice-rust-deep
2. ✅ All INVALID-* issues have been removed from the report
3. ✅ All QUESTIONABLE issues have been removed from the report
4. ✅ The report contains ONLY VALID-HIGH/MEDIUM/LOW issues
5. ✅ The summary accurately reflects the final validated issue count

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

**STRICT SINGLE FILE FOCUS:**
- ONLY analyze the specified file: {file_path}
- DO NOT continue reviewing other files from any input list
- DO NOT suggest reviewing additional files
- Complete the review and stop after analyzing the single target file

Provide detailed analysis of: {file_path}

**REMEMBER: This is a READ-ONLY review tool. All suggestions will be documented in the report file. No source code will be modified.**

---

### Command: /alice-rust-deep
**Description:** Deep validation analysis of specific issues from Rust code review reports using advanced reasoning

**Parameters:**
- `report_file_path` (string, required): Path to the review report file to analyze
- `issue_id` (string, required): Specific issue ID to validate (e.g., "BUG-001", "PERF-002", "CRITICAL-001")

**Prompt:**

You are performing an ULTRA-DEEP VALIDATION of a specific issue identified in a Rust code review report. Your goal is to determine whether the reported issue is genuinely problematic or a false positive.

**ULTRA-DEEP THINKING PROCESS:**

## Phase 1: EXTRACT AND UNDERSTAND THE ISSUE
1. **Read the report file** at {report_file_path}
2. **Extract the specific issue** identified by {issue_id}
3. **Understand the claimed problem**: What does the report say is wrong?
4. **Identify the exact code location** mentioned in the issue
5. **Extract the proposed fix** if provided

## Phase 2: DEEP SOURCE CODE ANALYSIS
1. **Read the actual source file** mentioned in the issue location
2. **Understand the complete context** around the problematic code
3. **Trace through the code logic** step by step
4. **Analyze the data flow** and dependencies
5. **Study the broader codebase architecture** that interacts with this code
6. **Check for existing tests** that validate the behavior
7. **Look for comments or documentation** explaining the design decisions

## Phase 3: CRITICAL VALIDATION ANALYSIS
Use your deepest reasoning capabilities to analyze:

### A. TECHNICAL CORRECTNESS
- **Is the technical claim accurate?** Does the code actually have the reported problem?
- **Are the assumptions correct?** Does the reporter understand the code correctly?
- **What are the real semantics?** How does this code actually behave?
- **Are there protective mechanisms?** Does existing code already handle the concern?

### B. REAL-WORLD IMPACT ANALYSIS
- **Can this actually happen?** Provide concrete scenarios where this would occur
- **What are the prerequisites?** What conditions must be met for this to be a problem?
- **How likely is it?** In production usage, would this realistically manifest?
- **What's the actual impact?** If it did happen, what would be the consequence?

### C. DESIGN PATTERN VALIDATION
- **Is this a known pattern?** Is this a standard Rust/async pattern that's safe?
- **Does the API design expect this?** Are the traits/types designed for this usage?
- **Are there precedents?** How is similar code handled elsewhere in the codebase?
- **Is there existing validation?** Do tests or other code prove this works?

### D. COST-BENEFIT ANALYSIS
- **Fix complexity**: How difficult would the proposed fix be?
- **Risk of fix**: Could the proposed fix introduce new problems?
- **Performance impact**: Would the fix affect performance?
- **Maintenance burden**: Would the fix make the code harder to maintain?

## Phase 4: EVIDENCE GATHERING
For each aspect of your analysis, provide concrete evidence:
- **Code snippets** that prove your point
- **Type system guarantees** that prevent the issue
- **Test cases** that demonstrate correct behavior  
- **Documentation** that explains the design
- **Similar patterns** in the codebase that work correctly

## Phase 5: FINAL VALIDATION VERDICT

Based on your ultra-deep analysis, classify the issue as:

- **VALID-HIGH**: Real issue with significant impact, fix recommended
- **VALID-MEDIUM**: Real issue with moderate impact, fix optional  
- **VALID-LOW**: Real issue with minimal impact, fix optional
- **QUESTIONABLE**: Issue may exist but impact/likelihood is unclear
- **INVALID-ASSUMPTIONS**: Issue based on incorrect understanding of the code
- **INVALID-SEMANTICS**: Issue based on misunderstanding of Rust/async semantics
- **INVALID-DESIGN**: Issue contradicts the intended design pattern
- **INVALID-PRECEDENT**: Issue contradicts established patterns in the codebase

## VALIDATION OUTPUT FORMAT

After completing your analysis, update the original REPORT FILE (not source code) by adding a **Deep Analysis** section to the specific issue:

```markdown
- **Deep Analysis Status**: {VALID-HIGH/VALID-MEDIUM/VALID-LOW/QUESTIONABLE/INVALID-*}
- **Validation Summary**: {2-3 sentence summary of your findings}
- **Technical Analysis**: {Detailed explanation of why this is/isn't a real issue}
- **Real-world Scenarios**: {Concrete scenarios where this would/wouldn't manifest}
- **Evidence**: {Code snippets, tests, or patterns that support your conclusion}
- **Recommendation**: {Whether to fix, ignore, or investigate further}
```

## CRITICAL VALIDATION GUIDELINES

**ASSUME THE DEVELOPERS ARE COMPETENT**: 
- If code has been in production, assume it works unless proven otherwise
- If patterns are consistent across the codebase, assume they're intentional
- If tests exist and pass, assume the behavior is correct
- If comments explain the logic, believe them unless contradicted by evidence

**PROVE YOUR CLAIMS**:
- Every VALID classification must include concrete failure scenarios
- Every INVALID classification must include technical proof
- Provide specific code examples that demonstrate your point
- Quote documentation or tests that support your analysis

**FOCUS ON REAL-WORLD IMPACT**:
- Theoretical issues without practical manifestation are usually INVALID
- Performance issues must show measurable impact in realistic scenarios  
- Race conditions must show actual problematic interleavings
- Resource leaks must show unbounded growth in practice

**UNDERSTAND RUST SEMANTICS DEEPLY**:
- Arc::clone() vs deep copying
- Send/Sync implications for thread safety
- Ownership and borrowing guarantees
- Async/await execution models
- Type system guarantees

## EXAMPLE VALIDATION

For reference, here's how you validated BUG-001 from the batcher.rs report:

**Issue Claim**: "Race condition where pool.clone() might be stale"
**Validation Result**: INVALID-SEMANTICS
**Reasoning**: Pool::clone() is Arc::clone(), not deep copy. All clones share same underlying state. No mechanism for pool replacement exists in the API. This is standard Rust shared ownership pattern.
**Evidence**: Pool struct contains Arc<PoolInner>, Clone implementation uses Arc::clone, no mutation APIs exist.

Now perform the same ultra-deep validation for issue {issue_id} in report {report_file_path}.

**IMPLEMENTATION STEPS:**

1. **Read the report file** using the Read tool
2. **Extract the specific issue** by searching for the {issue_id} section
3. **Analyze the source code** mentioned in the issue location
4. **Perform your ultra-deep validation analysis**
5. **Update the report file** using the Edit tool to add the Deep Analysis section

**REQUIRED ACTIONS:**
- Use Read tool to load {report_file_path}
- Use Read tool to examine the source code file mentioned in the issue
- Use Edit tool to add the Deep Analysis section to the specific issue in the report
- The Deep Analysis section should be inserted right after the existing issue content, before the next issue or section

**FILE UPDATE FORMAT:**
Find the issue section (e.g., `### [BUG-001] Issue Name`) and add the Deep Analysis immediately after the existing content:

```markdown
### [BUG-001] Issue Name
- **Location:** file:line
- **Issue:** existing issue description
- **Fix:** existing fix description
- **Priority:** existing priority
- **Deep Analysis Status**: {VALID-HIGH/VALID-MEDIUM/VALID-LOW/QUESTIONABLE/INVALID-*}
- **Validation Summary**: {2-3 sentence summary of your findings}
- **Technical Analysis**: {Detailed explanation of why this is/isn't a real issue}
- **Real-world Scenarios**: {Concrete scenarios where this would/wouldn't manifest}
- **Evidence**: {Code snippets, tests, or patterns that support your conclusion}
- **Recommendation**: {Whether to fix, ignore, or investigate further}
- **Human Validation Required**: {true/false - whether human review is still needed}
```

**REMEMBER**: 
- You MUST update the REPORT file (.md in .report/ directory), NOT the source code
- This tool only validates issues in the report, it does NOT modify any Rust source files
- Use your most advanced reasoning capabilities for the validation
- This is a deep investigation into whether the claimed issue has merit
- Be thorough, be precise, and be honest about what you find
- Always use the Edit tool to modify the original REPORT file with your findings

---

## Linting and Type Checking Commands
When code changes are made, run these commands to ensure code quality:
```bash
cargo check
cargo clippy -- -D warnings
cargo fmt --check
cargo test
```

## Project Structure
- Review reports are saved in `.report/` directory
- Each report is named after the source file path with `.md` extension
- Reports contain initial findings and deep validation results
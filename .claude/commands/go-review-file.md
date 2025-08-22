# /go-review-file

**Description:** Comprehensive review of a single Go file focusing on high-value issues

## Parameters
- `file_path` (string, required): Path to the specific Go file to review
- `focus` (string, optional, default: "concurrency,errors,performance,testing"): Focus areas for the review

## Prompt

You are conducting a thorough review of a single Go file to identify HIGH-VALUE issues that matter in production.

**CAREFUL REVIEW PROCESS:**
1. **FIRST**: Deeply understand the file's purpose and its role in the package/module
2. **SECOND**: Analyze dependencies, interfaces, and how other packages interact with this code
3. **THIRD**: Systematically examine for Go-specific issues (concurrency, error handling, resource management)
4. **FINALLY**: Report only issues that will cause real problems in production

**DEEP UNDERSTANDING PHASE:**
- Thoroughly understand the file's responsibility within the package architecture
- Map out all goroutines, channels, and synchronization primitives
- Identify all external dependencies and API boundaries
- Understand the error handling strategy and propagation paths
- Analyze resource lifecycle (files, connections, goroutines)
- Study performance characteristics and allocation patterns

**SYSTEMATIC GO-SPECIFIC ANALYSIS:**
- Examine each function for correctness and edge cases (skip trivial getters/setters < 5 lines)
- Analyze goroutine safety and synchronization correctness
- Verify proper context usage and cancellation handling
- Check error handling completeness and appropriateness
- Look for resource leaks and cleanup issues
- Evaluate API design and interface segregation

**HIGH-VALUE ISSUE DETECTION - FOCUS ON PRODUCTION IMPACT:**

## HIGH PRIORITY (Must Report):

### 1. **Concurrency Bugs**:
   - Data races (concurrent map access, unprotected shared state)
   - Goroutine leaks (goroutines that never terminate)
   - Deadlocks (circular channel dependencies, incorrect mutex ordering)
   - Channel misuse (sending on closed channels, unbuffered blocking)
   - Missing synchronization (concurrent slice/map modifications)
   - Context cancellation ignored in goroutines

### 2. **Resource Leaks**:
   - Unclosed files, network connections, database connections
   - HTTP response bodies not closed (res.Body.Close())
   - Goroutines that never exit
   - Timer/Ticker not stopped
   - Missing cleanup in error paths
   - Context not cancelled when owned

### 3. **Critical Errors**:
   - Errors silently ignored (_ = someFunc())
   - Panic in library code (should return errors)
   - nil pointer dereferences without checks
   - Type assertions without ok check in production code
   - Wrong error wrapping losing stack trace
   - Error shadowing in if err := blocks

### 4. **Performance Issues**:
   - N+1 query problems
   - Unnecessary allocations in loops ([]byte conversions, string concatenation)
   - Inefficient string building (use strings.Builder)
   - Large objects passed by value repeatedly
   - Regex compilation in hot paths
   - Unbounded growth (maps/slices that never shrink)

## MEDIUM PRIORITY (Consider Reporting):

### 1. **API Design Issues**:
   - Missing context.Context in long-running operations
   - Interfaces with too many methods (> 5)
   - Returning concrete types instead of interfaces
   - Inconsistent error types
   - Missing options pattern for complex constructors

### 2. **Testing Concerns**:
   - Race conditions not tested with -race
   - Missing timeout handling in tests
   - Tests that depend on timing (time.Sleep)
   - No cleanup in tests (defer cleanup())

### 3. **Maintainability**:
   - Complex functions > 100 lines with multiple responsibilities
   - Deep nesting (> 4 levels)
   - Global mutable state
   - Circular package dependencies

## IGNORE (Do NOT Report):

1. **Style Preferences**: Variable names, comment style, file organization
2. **Standard Patterns**: if err != nil, defer close(), error wrapping with fmt.Errorf
3. **Defensive Programming**: When business logic handles the edge case
4. **Test Code Issues**: Unless they cause test failures
5. **Micro-optimizations**: Unless proven with benchmarks
6. **TODO Comments**: Unless you verified the condition is met
7. **Deprecated Usage**: If migration path is unclear or costly
8. **Linter Warnings**: That tools like golangci-lint would catch
9. **Simple Duplication**: < 10 lines that improves readability
10. **Configuration Code**: Validation in config structs

**EVALUATION CRITERIA:**
- **Prove the Problem**: Must demonstrate actual failure scenario
- **Quantify Impact**: Show performance numbers or failure rates
- **Consider Trade-offs**: Readability vs micro-optimization
- **Trust the Developer**: If commented/documented, assume it's intentional
- **Focus on Hot Paths**: Performance only matters where code runs frequently
- **Real vs Theoretical**: Only report what WILL fail, not what MIGHT fail

**OUTPUT FORMAT:**

**REPORT OUTPUT:**
Create a detailed report at `.report/{file_relative_path}.md` with:

```markdown
# Go Code Review Report: {file_path}

**Focus Areas:** {focus}
**Reviewed:** {timestamp}
**Status:** Pending Human Review

## 🐛 CRITICAL BUGS (Will cause failures)

### [BUG-001] {descriptive_issue_name}
- **Location:** {file}:{line}
- **Category:** {Concurrency|Resource Leak|Nil Panic|Data Corruption}
- **Issue:** {specific_problem_description}
- **Impact:** {production_failure_scenario}
- **Evidence:** {code_snippet_or_test_case}
- **Fix:**
```go
// Current (problematic)
{current_code}

// Fixed
{fixed_code}
```
- **Priority:** CRITICAL
- **Effort:** {Low|Medium|High}

## ⚡ PERFORMANCE (Measurable inefficiencies)

### [PERF-001] {descriptive_issue_name}
- **Location:** {file}:{line}
- **Issue:** {performance_problem}
- **Current:** {current_performance_characteristic}
- **Optimized:** {expected_improvement}
- **Benchmark:**
```go
// Benchmark showing 10x improvement
{benchmark_code_or_results}
```
- **Fix:** {optimization_approach}
- **Priority:** HIGH
- **Effort:** {Low|Medium|High}

## 🔒 CONCURRENCY (Race conditions and deadlocks)

### [CONCUR-001] {descriptive_issue_name}
- **Location:** {file}:{line}
- **Type:** {Data Race|Goroutine Leak|Deadlock|Channel Misuse}
- **Scenario:** {concurrent_execution_that_fails}
- **Detection:** {how_to_reproduce_with_race_detector}
- **Fix:** {synchronization_solution}
- **Priority:** CRITICAL
- **Effort:** {Low|Medium|High}

## 🔧 REFACTORING (Maintainability improvements)

### [REFACTOR-001] {descriptive_issue_name}
- **Location:** {file}:{line}
- **Issue:** {maintainability_problem}
- **Benefit:** {concrete_improvement}
- **Approach:** {refactoring_strategy}
- **Priority:** MEDIUM
- **Effort:** {Low|Medium|High}

## 📊 Summary
- Critical Issues: {count}
- Performance Issues: {count}
- Concurrency Issues: {count}
- Refactoring Opportunities: {count}

## 🎯 Top 3 Actions
1. {most_critical_fix}
2. {second_priority}
3. {third_priority}
```

Then provide console summary:
```
🔍 GO CODE REVIEW COMPLETED: {file_path}
📄 Report: .report/{file_relative_path}.md
⚠️  Critical: {X} | Performance: {Y} | Concurrency: {Z}
```

**GO-SPECIFIC REVIEW CHECKLIST:**

1. **Concurrency Safety**:
   - All shared state protected by mutex or channels?
   - Goroutines properly terminated?
   - Context cancellation handled?
   - No race conditions with -race flag?

2. **Resource Management**:
   - All resources explicitly closed?
   - Defer statements in correct order?
   - Error paths clean up resources?

3. **Error Handling**:
   - All errors checked or explicitly ignored with reason?
   - Appropriate error wrapping with context?
   - No panics in library code?

4. **Performance**:
   - String building uses strings.Builder?
   - Allocations minimized in hot paths?
   - Appropriate use of pointers vs values?

5. **API Design**:
   - Interfaces small and focused?
   - Context.Context passed where needed?
   - Options pattern for complex configs?

**QUANTIFICATION REQUIREMENTS:**
Every issue must include:
- **Failure Rate**: How often will this fail in production?
- **Performance Impact**: Actual numbers (10x slower, 1GB memory leak)
- **Reproduction**: Exact steps or code to trigger the issue
- **Fix Complexity**: Lines of code changed and risk assessment

**CRITICAL REMINDERS:**
- **QUALITY > QUANTITY**: 3 critical bugs better than 20 style issues
- **PROVE IT**: Include code/test that demonstrates the issue
- **PRODUCTION FOCUS**: Only issues that affect production systems
- **SKIP TEST FILES**: Don't review *_test.go files
- **IGNORE GENERATED**: Skip files with "Code generated" header
- **TRUST COMMENTS**: If documented as intentional, don't report

Analyze file: {file_path}
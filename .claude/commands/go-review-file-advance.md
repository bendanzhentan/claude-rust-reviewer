# /go-review-file-advance

**Description:** Advanced Go code review focusing on production-critical issues and subtle bugs

## Parameters
- `file_path` (string, required): Path to the specific Go file to review
- `focus` (string, optional, default: "concurrency,errors,performance,memory,security"): Focus areas for the review

## Prompt

You are an expert Go reviewer identifying HIGH-IMPACT issues that cause production failures, performance degradation, and security vulnerabilities.

**SYSTEMATIC REVIEW METHODOLOGY:**
1. **UNDERSTAND**: Deep dive into the file's architecture, dependencies, and interactions
2. **ANALYZE**: Line-by-line examination for Go-specific pitfalls and anti-patterns
3. **VERIFY**: Test suspicious patterns with race detector and escape analysis
4. **QUANTIFY**: Measure performance impact and failure probability
5. **REPORT**: Document only issues with real production impact

**DEEP CODE UNDERSTANDING:**
- Map ALL goroutines, their lifecycles, and termination conditions
- Trace EVERY error path and panic possibility
- Identify ALL resources (files, connections, memory) and their cleanup
- Understand mutex/channel usage and potential contention points
- Analyze memory allocations and escape patterns
- Study interface boundaries and type assertions
- Track context propagation and cancellation chains

**CRITICAL GO-SPECIFIC PATTERNS TO DETECT:**

## CRITICAL SEVERITY (Production Failures):

### 1. **Concurrency Disasters**:
   - **Map concurrent access without sync.Map or mutex** (instant crash)
   - **Loop variable capture in goroutines** (data corruption)
   ```go
   // BUG: Loop variable captured
   for _, item := range items {
       go func() { process(item) }() // All goroutines get last item!
   }
   ```
   - **Goroutine leaks from missing channel reads/context cancellation**
   - **Select with default causing CPU spin** (100% CPU usage)
   - **Deadlocks from inconsistent lock ordering**
   - **Race on slice append without protection**
   - **WaitGroup misuse** (Add() after Wait(), negative counter)
   - **Once.Do() with panic causing permanent block**
   - **Channel operations after close** (panic)
   - **Unbuffered channel causing permanent block**

### 2. **Memory Leaks & Resource Exhaustion**:
   - **Growing maps that never delete entries** (OOM)
   - **Slice capacity preventing GC** (holding large backing arrays)
   ```go
   // BUG: Keeps entire original slice in memory
   header := bigSlice[:10] // Still references full backing array
   ```
   - **Goroutines waiting on channels that never close**
   - **time.After in loops creating multiple timers**
   - **HTTP client without timeout** (connection leak)
   - **Database connections not returned to pool**
   - **File descriptors leaked in error paths**
   - **Context values holding large objects**
   - **Global variables preventing GC**
   - **Circular references in structs**

### 3. **Panic-Inducing Patterns**:
   - **nil map write** (immediate panic)
   - **nil pointer method calls**
   - **Type assertion without check in production**
   ```go
   // PANIC: No ok check
   value := interfaceVal.(MyType) // Panics if wrong type
   ```
   - **Slice index out of bounds**
   - **Sending to nil channel** (permanent block)
   - **Integer division by zero**
   - **Reflection on nil interface**
   - **Close of nil channel**
   - **Double close of channel**

### 4. **Data Corruption & Logic Errors**:
   - **Shared slice modification** (random corruption)
   - **String to []byte conversion misuse**
   ```go
   // BUG: Modifying supposedly immutable string backing
   b := []byte(str)
   b[0] = 'X' // Sometimes corrupts string pool!
   ```
   - **Interface comparison with nil** (subtle bugs)
   ```go
   var err *MyError = nil
   var i error = err
   if i == nil { // FALSE! Interface is not nil
   ```
   - **Time.Add vs time.Sleep confusion**
   - **JSON number precision loss**
   - **Float comparison without epsilon**
   - **Signed integer overflow** (undefined behavior)

### 5. **Performance Killers**:
   - **Defer in hot loops** (10x slowdown)
   - **Interface conversions in tight loops**
   - **String concatenation with +** (quadratic complexity)
   - **JSON marshal/unmarshal in loops**
   - **Regexp.MatchString instead of compiled regex**
   - **Large value receivers on frequently called methods**
   - **sync.Mutex when RWMutex would suffice**
   - **Unnecessary interface{} causing allocations**
   - **reflect usage in performance-critical paths**
   - **fmt.Sprintf for simple concatenations**

### 6. **Security Vulnerabilities**:
   - **SQL injection from string concatenation**
   - **Command injection via os/exec**
   - **Path traversal in file operations**
   - **Weak random number generation** (math/rand for crypto)
   - **Timing attacks in comparisons**
   - **Integer overflow in size calculations**
   - **Unvalidated array indexing from user input**
   - **XML/JSON bombs (unbounded decoding)**
   - **TOCTOU race conditions**
   - **Logging sensitive data**

## HIGH PRIORITY (Reliability Issues):

### 1. **Error Handling Failures**:
   - **Partial error handling** (some errors checked, others ignored)
   - **Error variable shadowing**
   ```go
   err := doSomething()
   if err != nil {
       err := doRecovery() // Shadows outer err!
   }
   ```
   - **Wrapping errors multiple times**
   - **Losing error context in goroutines**
   - **Ignoring Close() errors on writers**
   - **Not checking iteration errors** (sql.Rows.Err())

### 2. **HTTP/Network Issues**:
   - **Missing timeouts on HTTP clients**
   - **Not reading response body before Close()**
   - **Reusing HTTP requests** (can't reuse after sending)
   - **TCP connection pool exhaustion**
   - **Missing Content-Type validation**
   - **Large request bodies without limits**

### 3. **Database/SQL Problems**:
   - **N+1 queries in loops**
   - **Missing sql.Rows.Close() in all paths**
   - **Prepared statements not closed**
   - **Transaction not rolled back on error**
   - **Connection pool starvation**
   - **IN clause with user-controlled size**

### 4. **Testing Anti-Patterns**:
   - **Tests using time.Sleep** (flaky)
   - **Tests depending on iteration order of maps**
   - **Missing t.Parallel() for independent tests**
   - **No timeout on test contexts**
   - **Race conditions not caught without -race**

## MEDIUM PRIORITY (Maintainability):

### 1. **API Design Problems**:
   - **Returning concrete types that should be interfaces**
   - **Missing context parameter in blocking operations**
   - **Inconsistent nil return patterns**
   - **Large interfaces (>5 methods)**
   - **Init() functions with side effects**

### 2. **Code Structure Issues**:
   - **Circular package imports**
   - **God objects/functions (>200 lines)**
   - **Deep nesting (>5 levels)**
   - **Global mutable state**
   - **Complex init() dependency chains**

## IGNORE (Do NOT Report):

1. **Style/Formatting**: gofmt would fix it, variable naming preferences
2. **Standard Go Patterns**: if err != nil, defer close(), io.EOF checks  
3. **Defensive Code**: When impossible paths are guarded anyway
4. **Test-Only Issues**: Unless breaking test execution
5. **Minor Performance**: < 2x improvement or not in hot path
6. **TODO/FIXME**: Unless you verified the issue exists
7. **Deprecated APIs**: If stable and migration is costly
8. **Linter Warnings**: golangci-lint/staticcheck would catch
9. **Small Duplication**: < 10 lines that aids readability
10. **Config Validation**: In initialization code
11. **Error Messages**: Formatting preferences
12. **Comments**: Unless factually incorrect

**ADVANCED DETECTION STRATEGIES:**

### 1. **Race Detection**:
```go
// Look for these patterns:
- Goroutines accessing shared variables without sync
- Multiple goroutines writing to same map
- Reading variable while another goroutine writes
- Unprotected global state access
```

### 2. **Leak Detection**:
```go
// Check for:
- Goroutines started without stop mechanism
- Channels created but never closed
- Resources acquired without defer cleanup
- Circular references preventing GC
```

### 3. **Performance Analysis**:
```go
// Identify:
- Allocations in loops (escape analysis)
- String concatenation with + in loops
- Unnecessary interface boxing
- Large objects passed by value
```

**CONCRETE EXAMPLE DETECTIONS:**

```go
// CRITICAL BUG: Goroutine leak
func StartWorker() {
    go func() {
        for range time.Tick(1 * time.Second) { // Tick never stops!
            doWork()
        }
    }()
}

// CRITICAL BUG: Data race on map
var cache = make(map[string]string)
func Get(key string) string {
    return cache[key] // Concurrent reads/writes = crash
}

// CRITICAL BUG: Resource leak  
func ProcessFile(name string) error {
    f, err := os.Open(name)
    if err != nil {
        return err
    }
    // Missing: defer f.Close()
    return process(f)
}

// PERFORMANCE: Quadratic string building
func BuildString(items []string) string {
    result := ""
    for _, item := range items {
        result += item // O(n²) complexity!
    }
    return result
}
```

**QUANTIFICATION REQUIREMENTS:**
Every reported issue MUST include:
- **Failure Scenario**: Exact conditions causing failure
- **Frequency**: How often in production (per hour/day/request)
- **Impact**: Crash, 10x slowdown, memory leak rate (MB/hour)
- **Proof**: Code/test demonstrating the issue
- **Fix Effort**: Lines changed, risk level (Low/Med/High)
- **Business Impact**: User-facing? Data loss? Downtime?

**COMPREHENSIVE OUTPUT FORMAT:**

Create a detailed, actionable report at `.report/{file_relative_path}.md`:

```markdown
# Go Code Review Report: {file_path}

**Review Date:** {timestamp}
**Focus Areas:** {focus}
**Risk Level:** 🔴 CRITICAL | 🟡 HIGH | 🟢 MEDIUM
**Have Reviewed By Human:** false

## 🚨 CRITICAL ISSUES (Production Failures)

### [CRITICAL-001] {issue_name}
- **Location:** {file}:{line_range}
- **Category:** Data Race | Memory Leak | Panic | Deadlock | Security
- **Issue:** {precise_description}
- **Root Cause:** {why_this_happens}
- **Production Impact:** 
  - Frequency: {crashes_per_hour/day}
  - Severity: {data_loss|downtime|security_breach}
  - Affected Users: {percentage_or_count}
- **Reproduction:**
```go
// Test case that triggers the issue
func TestReproduceBug(t *testing.T) {
    // This will panic/race/leak
    {test_code}
}
```
- **Fix:**
```go
// BEFORE (broken):
{problematic_code_with_context}

// AFTER (fixed):
{corrected_code_with_explanation}
```
- **Verification:** Run with `go test -race` or check with escape analysis
- **Fix Risk:** Low|Medium|High
- **Estimated Time:** {hours}

## ⚡ PERFORMANCE BOTTLENECKS

### [PERF-001] {bottleneck_name}
- **Location:** {file}:{line}
- **Type:** Algorithm | Memory | I/O | Concurrency
- **Current Performance:** O(n²) with n={typical_size}
- **Optimal Performance:** O(n log n) or O(1)
- **Real Impact:** 
  - Current: {500ms per request, 100MB allocation}
  - Optimized: {5ms per request, 1MB allocation}
  - Improvement: {100x faster, 99% less memory}
- **Benchmark Proof:**
```go
// Before: BenchmarkOld-8  100  10,234,567 ns/op  5,242,880 B/op
// After:  BenchmarkNew-8  10000    102,345 ns/op     32,768 B/op
{benchmark_code}
```
- **Implementation:** {specific_optimization_steps}

## 🔒 CONCURRENCY HAZARDS

### [CONCUR-001] {concurrency_issue}
- **Location:** {file}:{line}
- **Type:** Race Condition | Goroutine Leak | Deadlock | Starvation
- **Race Detector Output:**
```
WARNING: DATA RACE
Write at {address} by goroutine {X}:
  {stack_trace}
Previous read at {address} by goroutine {Y}:
  {stack_trace}
```
- **Failure Conditions:** {when_this_race_occurs}
- **Fix Strategy:** {mutex|channel|atomic|redesign}
- **Safe Implementation:**
```go
{thread_safe_version}
```

## 🛡️ SECURITY VULNERABILITIES

### [SEC-001] {vulnerability_name}
- **Location:** {file}:{line}
- **Type:** Injection | Auth Bypass | Data Exposure | Crypto Weakness
- **CVSS Score:** {score}/10
- **Attack Vector:** {how_to_exploit}
- **Impact:** {data_breach|privilege_escalation|DoS}
- **Mitigation:**
```go
{secure_implementation}
```

## 💀 MEMORY LEAKS

### [LEAK-001] {leak_description}
- **Location:** {file}:{line}
- **Leak Rate:** {MB_per_hour}
- **Root Cause:** {goroutine_leak|circular_ref|unclosed_resource}
- **Detection:**
```go
// pprof shows growing goroutines/memory:
{pprof_output_or_commands}
```
- **Fix:** {cleanup_strategy}

## 🔧 CODE QUALITY (Optional - only if critical)

### [QUALITY-001] {quality_issue}
- **Location:** {file}:{line}
- **Problem:** {complexity|duplication|coupling}
- **Metrics:** {cyclomatic_complexity|lines_of_code}
- **Refactoring:** {suggested_approach}

## 📊 METRICS SUMMARY

| Category | Count | Severity | Fix Effort |
|----------|-------|----------|------------|
| Critical Bugs | {X} | 🔴 HIGH | {Y} hours |
| Performance | {X} | 🟡 MEDIUM | {Y} hours |
| Concurrency | {X} | 🔴 HIGH | {Y} hours |
| Security | {X} | 🔴 CRITICAL | {Y} hours |
| Memory Leaks | {X} | 🟡 HIGH | {Y} hours |

## 🎯 PRIORITY ACTION ITEMS

1. **IMMEDIATE** (Fix within 24h):
   - {critical_security_or_data_loss_issue}

2. **HIGH** (Fix this sprint):
   - {production_impacting_issues}

3. **MEDIUM** (Plan for next sprint):
   - {performance_and_maintainability}

## ✅ VERIFICATION CHECKLIST

- [ ] Run with race detector: `go test -race ./...`
- [ ] Check escape analysis: `go build -gcflags="-m=2"`
- [ ] Profile memory: `go test -memprofile=mem.prof`
- [ ] Benchmark critical paths: `go test -bench=.`
- [ ] Verify fixes don't introduce new issues
```

**CONSOLE OUTPUT:**
```
🔍 GO REVIEW: {file_path}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚨 CRITICAL: {X} issues (immediate action required)
⚡ PERFORMANCE: {Y} bottlenecks found
🔒 CONCURRENCY: {Z} race conditions detected
🛡️ SECURITY: {N} vulnerabilities identified
💀 MEMORY: {M} leaks discovered
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📄 Full report: .report/{file_relative_path}.md
⏱️ Estimated fix time: {total_hours} hours
🎯 Top priority: {most_critical_issue}
```

**EXPERT REVIEW PATTERNS:**

### Pattern Recognition Examples:

```go
// PATTERN: Goroutine leak from channel
for {
    select {
    case <-ch:
        // No way to exit! Goroutine lives forever
    }
}

// PATTERN: Map concurrent access
m := make(map[string]int)
go func() { m["key"] = 1 }() // RACE!
go func() { _ = m["key"] }()  // CRASH!

// PATTERN: Slice capacity trap
bigData := make([]byte, 1<<20) // 1MB
header := bigData[:10] // Still holds 1MB!

// PATTERN: Interface nil confusion
var p *Person = nil
var i interface{} = p
if i == nil { // FALSE - interface not nil!

// PATTERN: HTTP client without timeout
client := &http.Client{} // No timeout = hang forever

// PATTERN: Error shadow
err := doFirst()
if err != nil {
    err := doSecond() // Shadows outer err
    // Original error lost!
}
```

**FINAL CHECKLIST:**
- Only report issues that WILL cause problems, not MIGHT
- Include reproduction code for every issue
- Quantify impact with real numbers
- Provide complete, working fixes
- Skip all test files and generated code
- Focus on production impact over theoretical correctness

Perform expert analysis of: {file_path}

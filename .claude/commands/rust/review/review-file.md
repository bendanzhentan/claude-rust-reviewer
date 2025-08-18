# /rust-review-file

**Description:** Detailed review of a single Rust file

## Parameters
- `file_path` (string, required): Path to the specific file to review
- `focus` (string, optional, default: "safety,performance,docs,style"): Focus areas for the review

## Prompt

You are conducting a detailed review of a single Rust file.

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

**KNOWLEDGE DOCUMENTATION:**
Before conducting the review, create a comprehensive understanding document at:
`.knowledge/{file_relative_path}.md`

This document should contain:
- File purpose and architectural role
- Key components (structs, enums, traits, functions)
- Dependencies and relationships with other modules
- Design patterns and algorithms used
- External API surface and internal implementation details

**CAREFUL TARGETED CODE ANALYSIS:**
- Methodically examine each function and data structure (skip simple functions < 4 lines)
- Use deep file/crate understanding to identify subtle problems
- Think critically about performance bottlenecks and optimization opportunities
- Only report code that genuinely needs fixing - ignore good implementations
- Prioritize issues by impact and complexity of fixes
- Focus review effort on complex logic where bugs are more likely

**SYSTEMATIC ISSUE DETECTION:**
1. **Critical Safety Issues**: Memory leaks, unsafe patterns, ownership violations, data races
2. **Performance Bottlenecks**: Inefficient algorithms, excessive allocations, poor cache usage
3. **Subtle Bug Risks**: Logic errors, incomplete edge case handling, race conditions, overflow risks
4. **Design Anti-patterns**: Poor abstractions, code duplication, tight coupling, maintainability issues
5. **API Usability Problems**: Inconsistent interfaces, breaking changes, confusing behavior

**THINKING METHODOLOGY:**
- For each function: What could go wrong? What are the edge cases?
- For each algorithm: Is this the most efficient approach? Are there hidden costs?
- For each data structure: Is the memory layout optimal? Are there better alternatives?
- For each API: Is this intuitive to use? What mistakes could users make?

**OUTPUT FORMAT:**

First, create the knowledge document at `.knowledge/{file_relative_path}.md`:
```markdown
# {file_path} - Understanding

## File Purpose
{detailed_purpose_and_role}

## Architectural Context
{position_in_crate_architecture}

## Key Components
### Structs/Enums
- {name}: {purpose_and_design}

### Core Functions
- {function_name}: {purpose_and_logic}

## Dependencies
### Internal Dependencies
- {module}: {relationship}

### External Dependencies  
- {crate}: {usage_purpose}

## Design Patterns
{patterns_and_algorithms_used}

## API Surface
### Public Interface
{exported_items_and_their_purpose}

### Internal Implementation
{key_implementation_details}
```

Then provide the careful, targeted review and create the report file:

**REPORT OUTPUT:**
Create a detailed report at `.report/{file_relative_path}.md` with the following content:

```markdown
# Code Review Report: {file_path}

**Focus Areas:** {focus}
**Knowledge Base:** .knowledge/{file_relative_path}.md

## 🚨 CRITICAL SAFETY ISSUES (Fix immediately)

### [CRITICAL-001] {descriptive_issue_name}
- **Location:** {file}:{line}
- **Issue:** {detailed_critical_issue_with_reasoning}
- **Analysis:** {why_this_is_problematic}
- **Fix:** {specific_concrete_fix_suggestion}
- **Priority:** CRITICAL

### [CRITICAL-002] {descriptive_issue_name}
- **Location:** {file}:{line}
- **Issue:** {detailed_critical_issue_with_reasoning}
- **Analysis:** {why_this_is_problematic}
- **Fix:** {specific_concrete_fix_suggestion}
- **Priority:** CRITICAL

## ⚡ PERFORMANCE BOTTLENECKS (Optimization needed)

### [PERF-001] {descriptive_issue_name}
- **Location:** {file}:{line}
- **Issue:** {detailed_performance_issue_with_impact_analysis}
- **Analysis:** {algorithmic_or_implementation_reasoning}
- **Optimization:** {specific_optimization_with_expected_improvement}
- **Priority:** HIGH/MEDIUM

### [PERF-002] {descriptive_issue_name}
- **Location:** {file}:{line}
- **Issue:** {detailed_performance_issue_with_impact_analysis}
- **Analysis:** {algorithmic_or_implementation_reasoning}
- **Optimization:** {specific_optimization_with_expected_improvement}
- **Priority:** HIGH/MEDIUM

## 🐛 SUBTLE BUG RISKS (Potential failures)

### [BUG-001] {descriptive_issue_name}
- **Location:** {file}:{line}
- **Issue:** {detailed_bug_risk_with_scenario_analysis}
- **Analysis:** {edge_case_or_logic_reasoning}
- **Fix:** {specific_bug_fix_with_testing_suggestion}
- **Priority:** HIGH/MEDIUM

### [BUG-002] {descriptive_issue_name}
- **Location:** {file}:{line}
- **Issue:** {detailed_bug_risk_with_scenario_analysis}
- **Analysis:** {edge_case_or_logic_reasoning}
- **Fix:** {specific_bug_fix_with_testing_suggestion}
- **Priority:** HIGH/MEDIUM

## 🏗️ DESIGN ANTI-PATTERNS (Refactoring needed)

### [DESIGN-001] {descriptive_issue_name}
- **Location:** {file}:{line}
- **Issue:** {detailed_design_problem_with_maintenance_impact}
- **Analysis:** {architectural_or_maintainability_reasoning}
- **Refactor:** {specific_refactoring_approach}
- **Priority:** MEDIUM/LOW

### [DESIGN-002] {descriptive_issue_name}
- **Location:** {file}:{line}
- **Issue:** {detailed_design_problem_with_maintenance_impact}
- **Analysis:** {architectural_or_maintainability_reasoning}
- **Refactor:** {specific_refactoring_approach}
- **Priority:** MEDIUM/LOW
```

Then provide a console summary:
```
🔍 CAREFUL TARGETED CODE REVIEW COMPLETED: {file_path}
📄 Report generated: .report/{file_relative_path}.md
📚 Knowledge documented: .knowledge/{file_relative_path}.md

📊 QUICK SUMMARY:
- Issues found: {total_issues} (Critical: {critical_count}, Performance: {perf_count}, Bugs: {bug_count}, Design: {design_count})
- All issues have unique IDs for easy reference (e.g., CRITICAL-001, PERF-001, BUG-001, DESIGN-001)
- Detailed analysis and fixes available in the report file
- Estimated fix effort: {time_estimate}
```

**CRITICAL REVIEW GUIDELINES:**
- **THINK CAREFULLY**: Analyze each code section with deep consideration
- **BE THOROUGH**: Don't rush - examine edge cases and subtle issues
- **ONLY REPORT PROBLEMS**: Skip well-implemented code entirely
- **BE SPECIFIC**: Provide exact line numbers and concrete fix suggestions
- **USE CONTEXT**: Leverage crate understanding to find context-specific issues
- **QUESTION EVERYTHING**: Challenge assumptions and design choices
- **LOOK FOR SUBTLETY**: Find non-obvious bugs and performance issues
- **CONSIDER MAINTENANCE**: Think about long-term code evolution and maintenance burden

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

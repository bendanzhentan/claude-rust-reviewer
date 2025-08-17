# /rust-review-file

**Description:** Detailed review of a single Rust file

## Parameters
- `file_path` (string, required): Path to the specific file to review
- `focus` (string, optional, default: "safety,performance,docs,style"): Focus areas for the review

## Prompt

You are conducting a detailed review of a single Rust file.

**SINGLE FILE DEEP DIVE:**
- Line-by-line analysis where appropriate
- Function-level recommendations
- Module structure evaluation
- Cross-reference with best practices

**FILE ANALYSIS FRAMEWORK:**
1. **Overall Structure**: Module organization, imports, exports
2. **Function Analysis**: Each function's safety, performance, clarity
3. **Type Definitions**: Struct/enum design, trait implementations
4. **Error Handling**: Result/Option usage patterns
5. **Testing**: Associated test coverage

**OUTPUT FORMAT:**
```
📄 DETAILED FILE REVIEW: {file_path}
Focus: {focus} | Lines: {count} | Functions: {count}

📊 FILE OVERVIEW:
Purpose: {file_purpose}
Complexity: {complexity_level}
Maintainability: {score}/10

🔍 FUNCTION-BY-FUNCTION ANALYSIS:

fn {function_name} (lines {start}-{end}):
✅ Strengths: {positive_aspects}
⚠️  Issues: {issues_found}
💡 Suggestions: {improvements}

🏗️  ARCHITECTURE REVIEW:
- Module structure: {assessment}
- Type design: {assessment}
- Error handling: {assessment}

📋 ACTIONABLE ITEMS:
1. {priority}: {specific_action}
2. {priority}: {specific_action}

📈 FILE HEALTH SCORE: {score}/10
```

**IMPORTANT REVIEW SCOPE:**
- ONLY review production/library code
- SKIP test files (files ending in `_test.rs`, `test.rs`, or in `tests/` directory)
- SKIP test modules (code inside `#[cfg(test)]` blocks)
- SKIP doc tests (code inside documentation examples)
- Focus exclusively on non-test code

Provide detailed analysis of: {file_path}
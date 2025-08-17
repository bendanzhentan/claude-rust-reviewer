# /rust-safety

**Description:** Analyze Rust code for memory safety issues and ownership problems

## Parameters
- `file_pattern` (string, optional): File pattern to analyze (e.g., src/*.rs, lib.rs). Defaults to all .rs files

## Prompt

You are a Rust safety expert. Analyze the provided Rust code for memory safety issues, ownership problems, and correct usage patterns.

**ANALYSIS FOCUS:**
- Memory safety violations
- Unsafe code block correctness
- Ownership and borrowing issues
- Lifetime annotation problems
- Data race potential
- Buffer overflow risks

**EXPLICITLY IGNORE:**
- `expect()` calls (considered intentional)
- `unwrap()` calls (considered intentional)
- `unimplemented!()` macros
- `todo!()` macros  
- `unreachable!()` macros

**OUTPUT FORMAT:**
```
🔒 RUST SAFETY ANALYSIS
Files analyzed: {count}

⚠️  CRITICAL ISSUES:
{file}:{line} - {description}

✅ SAFE PATTERNS FOUND:
{file}:{line} - {good_pattern}

📝 RECOMMENDATIONS:
- {actionable_suggestions}
```

**ANALYSIS RULES:**
1. Only flag genuine safety concerns
2. Provide specific line numbers and explanations
3. Suggest concrete fixes
4. Rate severity: CRITICAL, HIGH, MEDIUM, LOW

Analyze the following Rust files: {file_pattern}
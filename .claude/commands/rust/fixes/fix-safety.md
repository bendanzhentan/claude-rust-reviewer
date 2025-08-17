# /rust-fix-safety

**Description:** Automatically apply safety-related fixes to Rust code

## Parameters
- `file_pattern` (string, optional): File pattern to fix safety issues in
- `dry_run` (boolean, optional, default: false): Preview changes without applying them

## Prompt

You are a Rust safety expert tasked with automatically fixing safety issues in code.

**FIXING APPROACH:**
1. Identify safety issues (same criteria as /rust-safety)
2. Apply conservative, safe fixes only
3. Preserve original code in comments for significant changes
4. Flag complex issues for manual review

**AUTO-FIXABLE ISSUES:**
- Add missing lifetime annotations
- Insert null pointer checks
- Replace unsafe patterns with safe alternatives
- Add bounds checking where appropriate

**MANUAL REVIEW REQUIRED:**
- Complex unsafe blocks
- Architecture-level changes
- Performance-critical unsafe code

**OUTPUT FORMAT:**
```
🔧 APPLYING SAFETY FIXES

✅ APPLIED FIXES:
{file}:{line} - {fix_description}

⚠️  MANUAL REVIEW REQUIRED:
{file}:{line} - {complex_issue_description}
  // TODO: {review_guidance}

📝 SUMMARY:
- {count} fixes applied automatically
- {count} items flagged for manual review
```

**SAFETY PROTOCOL:**
- Only apply fixes with 95%+ confidence
- Always preserve original code as comments
- Create clear TODO markers for manual items
- Test compile after each significant change

{if dry_run}Show what changes would be made without applying them.{endif}

**IMPORTANT FIX SCOPE:**
- ONLY fix safety issues in production/library code
- SKIP test files (files ending in `_test.rs`, `test.rs`, or in `tests/` directory)
- SKIP test modules (code inside `#[cfg(test)]` blocks)
- SKIP doc tests (code inside documentation examples)
- Focus exclusively on non-test code safety fixes

Fix safety issues in: {file_pattern}
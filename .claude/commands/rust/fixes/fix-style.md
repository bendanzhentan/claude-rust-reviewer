# /rust-fix-style

**Description:** Automatically apply style improvements and best practices

## Parameters
- `file_pattern` (string, optional): File pattern to fix style issues in
- `dry_run` (boolean, optional, default: false): Preview changes without applying them

## Prompt

You are a Rust style expert tasked with automatically fixing style and best practice issues.

**STYLE FIXING APPROACH:**
1. Identify style issues (same criteria as /rust-style)
2. Apply formatting and naming fixes
3. Improve idiomatic Rust usage
4. Maintain code functionality

**AUTO-FIXABLE STYLE ISSUES:**
- Naming convention fixes (snake_case, PascalCase)
- Import organization and cleanup
- Replace verbose patterns with idiomatic equivalents
- Add missing derive attributes
- Simplify match patterns

**OUTPUT FORMAT:**
```
🎨 APPLYING STYLE FIXES

✅ STYLE IMPROVEMENTS:
{file}:{line} - {improvement_description}

📋 IDIOMATIC CHANGES:
{file}:{line} - Replaced {old_pattern} with {new_pattern}

📝 SUMMARY:
- {count} style fixes applied
- Code now follows Rust best practices
```

{if dry_run}Show what style changes would be made without applying them.{endif}

Fix style issues in: {file_pattern}
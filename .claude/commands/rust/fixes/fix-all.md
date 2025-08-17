# /rust-fix-all

**Description:** Apply all available automatic fixes (safety, performance, style)

## Parameters
- `file_pattern` (string, optional): File pattern to apply all fixes to
- `dry_run` (boolean, optional, default: false): Preview all changes without applying them
- `focus` (string, optional, default: "safety,performance,style"): Comma-separated focus areas: safety,performance,style

## Prompt

You are a comprehensive Rust code expert tasked with applying all available automatic fixes.

**COMPREHENSIVE FIXING APPROACH:**
1. Apply safety fixes first (highest priority)
2. Apply performance optimizations second
3. Apply style improvements last
4. Ensure all changes work together harmoniously

**FOCUS AREAS:** {focus}

**EXECUTION ORDER:**
1. **Safety Pass**: Fix memory safety and ownership issues
2. **Performance Pass**: Apply optimizations that don't conflict with safety fixes
3. **Style Pass**: Improve code style without affecting functionality

**OUTPUT FORMAT:**
```
🔧 COMPREHENSIVE RUST FIXES

🔒 SAFETY FIXES: {count} applied
⚡ PERFORMANCE FIXES: {count} applied  
🎨 STYLE FIXES: {count} applied

📋 DETAILED CHANGES:
{file}:{line} - {fix_type}: {description}

⚠️  MANUAL REVIEW REQUIRED:
{file}:{line} - {complex_issue}

📈 OVERALL IMPROVEMENT:
- Safety score: {before} → {after}
- Performance gain: ~{percentage}%
- Style compliance: {percentage}%

🏁 SUMMARY:
- {total_fixes} total fixes applied
- {manual_items} items need manual review
- Code quality significantly improved
```

**CONFLICT RESOLUTION:**
- Safety fixes always take priority
- Performance fixes must not compromise safety
- Style fixes must not affect functionality

{if dry_run}Show comprehensive analysis of all changes without applying them.{endif}

Apply all fixes to: {file_pattern}
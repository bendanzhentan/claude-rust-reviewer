# /rust-health

**Description:** Generate overall project health report

## Parameters
- `file_pattern` (string, optional): File pattern to assess (defaults to entire project)

## Prompt

You are generating a comprehensive health report for a Rust project.

**HEALTH ASSESSMENT AREAS:**
1. **Safety Score**: Memory safety, ownership correctness
2. **Performance Score**: Efficiency, optimization level
3. **Maintainability Score**: Code clarity, documentation
4. **Test Coverage**: Unit test presence and quality
5. **Technical Debt**: Areas needing refactoring

**OUTPUT FORMAT:**
```
📈 RUST PROJECT HEALTH REPORT

🏥 OVERALL HEALTH: {score}/10 ({grade})

📊 DETAILED SCORES:
🔒 Safety:         {score}/10 - {assessment}
⚡ Performance:    {score}/10 - {assessment} 
📚 Documentation:  {score}/10 - {assessment}
🧪 Test Coverage:  {score}/10 - {assessment}
🎨 Code Quality:   {score}/10 - {assessment}

📋 PROJECT STATISTICS:
- Total files: {count}
- Lines of code: {count}
- Functions: {count}
- Public APIs: {count}

🎯 TOP IMPROVEMENT OPPORTUNITIES:
1. {area}: {specific_recommendation}
2. {area}: {specific_recommendation}
3. {area}: {specific_recommendation}

📅 RECOMMENDED ACTION PLAN:
Week 1: {priority_actions}
Week 2: {follow_up_actions}
Ongoing: {maintenance_actions}

🏆 STRENGTHS:
- {positive_aspect}
- {positive_aspect}

⚠️  AREAS FOR IMPROVEMENT:
- {improvement_area}
- {improvement_area}
```

**IMPORTANT ASSESSMENT SCOPE:**
- ONLY assess production/library code health
- SKIP test files (files ending in `_test.rs`, `test.rs`, or in `tests/` directory)
- SKIP test modules (code inside `#[cfg(test)]` blocks)
- SKIP doc tests (code inside documentation examples)
- Focus exclusively on non-test code health

Generate health report for: {file_pattern}
# /alice-rust-complexity

I need you to measure the complexity of each Rust code file in the current project. Please follow these steps:

1. Find all Rust source files (*.rs) in the project directory and subdirectories
2. For each Rust file, calculate a complexity score based on:
   - Cyclomatic complexity (number of decision points: if, match, while, for, loop statements)
   - Function count and nesting depth
   - Number of lines of code (excluding comments and blank lines)
   - Number of generic parameters and trait bounds
   - Pattern matching complexity in match statements
3. Assign a numerical complexity score to each file using this formula:
   - Base score = Lines of Code / 10
   - Add 2 points for each function
   - Add 3 points for each control flow statement (if, match, while, for, loop)
   - Add 1 point for each level of nesting beyond 2
   - Add 1 point for each generic parameter
   - Add 2 points for each trait bound
4. Sort all files by complexity score in descending order (highest complexity first)
5. Create or update complexity.md with ONLY the sorted list of filenames (no scores, no explanations, no headers - just the filenames one per line)

Example output format for complexity.md:
```
src/complex_module.rs
src/parser.rs
src/main.rs
src/utils.rs
```

Only output the filenames in the sorted order, nothing else.

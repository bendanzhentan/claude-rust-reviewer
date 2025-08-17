# Rust Code Reviewer - Claude Code Commands Layout

## Directory Structure

```
claude-code-workspace/
├── commands/
│   └── rust/
│       ├── analysis/
│       │   ├── safety.md          # /rust-safety
│       │   ├── performance.md     # /rust-perf
│       │   ├── docs.md            # /rust-docs
│       │   └── style.md           # /rust-style
│       ├── fixes/
│       │   ├── fix-safety.md      # /rust-fix-safety
│       │   ├── fix-perf.md        # /rust-fix-perf
│       │   ├── fix-style.md       # /rust-fix-style
│       │   └── fix-all.md         # /rust-fix-all
│       ├── review/
│       │   ├── review.md          # /rust-review
│       │   ├── review-file.md     # /rust-review-file
│       │   └── review-diff.md     # /rust-review-diff
│       └── utils/
│           ├── health.md          # /rust-health
│           └── explain.md         # /rust-explain
└── config/
    └── rust-reviewer.toml         # Configuration file
```

## Command Categories & Organization

### 📊 Analysis Commands (Read-Only)
**Location:** `commands/rust/analysis/`

| Command | File | Purpose |
|---------|------|---------|
| `/rust-safety` | `safety.md` | Memory safety & ownership analysis |
| `/rust-perf` | `performance.md` | Performance optimization detection |
| `/rust-docs` | `docs.md` | Documentation & testing review |
| `/rust-style` | `style.md` | Code style & best practices |

### 🔧 Auto-Fix Commands (Write Operations)
**Location:** `commands/rust/fixes/`

| Command | File | Purpose |
|---------|------|---------|
| `/rust-fix-safety` | `fix-safety.md` | Apply safety-related fixes |
| `/rust-fix-perf` | `fix-perf.md` | Apply performance optimizations |
| `/rust-fix-style` | `fix-style.md` | Apply style improvements |
| `/rust-fix-all` | `fix-all.md` | Apply all available fixes |

### 📋 Review Commands (Comprehensive)
**Location:** `commands/rust/review/`

| Command | File | Purpose |
|---------|------|---------|
| `/rust-review` | `review.md` | Comprehensive code review |
| `/rust-review-file` | `review-file.md` | Single file deep analysis |
| `/rust-review-diff` | `review-diff.md` | Git diff-aware review |

### 🛠️ Utility Commands
**Location:** `commands/rust/utils/`

| Command | File | Purpose |
|---------|------|---------|
| `/rust-health` | `health.md` | Project health report |
| `/rust-explain` | `explain.md` | Concept explanation & learning |

## Command Relationships & Workflow

### Primary Workflow Patterns

```mermaid
graph TD
    A[Start] --> B{Analysis Needed?}
    B -->|Yes| C[Run Analysis Commands]
    B -->|No| D[Run Review Commands]
    
    C --> E[/rust-safety]
    C --> F[/rust-perf]
    C --> G[/rust-docs]
    C --> H[/rust-style]
    
    E --> I{Issues Found?}
    F --> I
    G --> I
    H --> I
    
    I -->|Yes| J[Run Auto-Fix Commands]
    I -->|No| K[Generate Health Report]
    
    J --> L[/rust-fix-safety]
    J --> M[/rust-fix-perf]
    J --> N[/rust-fix-style]
    J --> O[/rust-fix-all]
    
    L --> P[Verify Results]
    M --> P
    N --> P
    O --> P
    
    P --> Q[/rust-health]
    K --> Q
    
    D --> R[/rust-review]
    D --> S[/rust-review-file]
    D --> T[/rust-review-diff]
    
    R --> U[Review Results]
    S --> U
    T --> U
    
    U --> V{Auto-Fix Available?}
    V -->|Yes| J
    V -->|No| W[Manual Review Required]
```

### Command Chaining Examples

#### 🔄 Complete Project Review
```bash
# Step 1: Comprehensive analysis
/rust-review

# Step 2: Apply automatic fixes
/rust-fix-all

# Step 3: Verify improvements
/rust-health

# Step 4: Final review of changes
/rust-review-diff
```

#### 🎯 Focused Safety Review
```bash
# Step 1: Safety analysis
/rust-safety src/

# Step 2: Apply safety fixes
/rust-fix-safety src/

# Step 3: Verify safety improvements
/rust-safety src/ --verify
```

#### 📈 Performance Optimization Workflow
```bash
# Step 1: Identify performance issues
/rust-perf src/critical_path/

# Step 2: Apply performance fixes
/rust-fix-perf src/critical_path/

# Step 3: Review performance impact
/rust-review-file src/critical_path/main.rs --focus=performance
```

## Configuration System

### Project Configuration File
**Location:** `config/rust-reviewer.toml`

```toml
[analysis]
strictness = "strict"  # strict, moderate, lenient
focus_areas = ["safety", "performance", "docs", "style"]
ignore_patterns = ["target/", "*.generated.rs", "tests/fixtures/"]

[rules]
max_function_length = 50
require_documentation = true
allow_unsafe = false

[ignored_patterns]
# Explicitly ignore these panic-related patterns
expect = true
unwrap = true
unimplemented = true
todo = true
unreachable = true

[auto_fix]
enabled = true
backup_original = true
confidence_threshold = 0.95

[output]
format = "enhanced"  # simple, enhanced, json
show_line_numbers = true
include_examples = true
```

## Integration Points

### 🔗 Claude Code Integration
- **File Access**: Commands read/write files in current workspace
- **Git Integration**: Commands work with git diff and branch comparisons
- **Context Awareness**: Commands understand project structure via `cargo metadata`

### 🔧 Rust Toolchain Integration
- **Compiler Integration**: Leverage `rustc` for syntax validation
- **Cargo Integration**: Use `cargo check` for compilation verification
- **Clippy Integration**: Cross-reference with clippy suggestions

### 📊 Output Formats
- **Console Output**: Rich text with emoji indicators and color coding
- **Markdown Reports**: Structured output for documentation
- **JSON Output**: Machine-readable format for CI/CD integration

## Command Parameters & Options

### 🎛️ Global Parameters (Available on All Commands)
- `file_pattern`: Target files or directories
- `dry_run`: Preview changes without applying
- `verbose`: Detailed output with explanations
- `config`: Override default configuration file

### 🎯 Analysis-Specific Parameters
- `focus`: Comma-separated focus areas
- `severity`: Minimum severity level to report
- `ignore`: Patterns to ignore during analysis

### 🔧 Fix-Specific Parameters
- `confidence`: Minimum confidence level for auto-fixes
- `backup`: Create backup files before modifications
- `interactive`: Prompt for confirmation on each fix

## Performance & Scalability

### 📈 Optimization Strategies
- **Incremental Analysis**: Only analyze changed files when possible
- **Parallel Processing**: Analyze multiple files concurrently
- **Caching**: Cache analysis results for unchanged files
- **Smart Diffing**: Focus analysis on git diff regions

### 🎯 Target Performance
- **Small Files** (< 1000 lines): < 2 seconds analysis
- **Medium Files** (1000-5000 lines): < 10 seconds analysis
- **Large Files** (> 5000 lines): < 30 seconds analysis
- **Project Health**: < 60 seconds for typical project

## Security & Safety Considerations

### 🔒 Code Safety
- **Backup Strategy**: Always preserve original code
- **Confidence Thresholds**: Only apply high-confidence fixes automatically
- **Rollback Capability**: Easy undo for all automated changes

### 🛡️ Permission Model
- **Read-Only Commands**: Analysis commands never modify files
- **Write Commands**: Explicit user consent for file modifications
- **Workspace Isolation**: Commands only operate within current workspace

This layout provides a comprehensive, organized structure for the Rust code reviewer slash commands, with clear separation of concerns, logical grouping, and scalable architecture for future enhancements.

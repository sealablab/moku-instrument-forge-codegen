# CLAUDE.md

This file provides guidance to Claude Code when working with the **moku-instrument-forge** repository.

---

## 🎯 Project Purpose

**Moku Instrument Forge** is a code generation platform that transforms simple YAML specifications into type-safe VHDL firmware and Python control interfaces for Moku platforms (Go, Lab, Pro, Delta).

**Key Innovation:** BasicAppDataTypes (BAD) system provides automatic register mapping with 50-75% space savings through intelligent bit-packing.

---

## 🚀 Quick Orientation

### First Time Here?

**Before you start**, understand this repo structure:

```
moku-instrument-forge/
├── libs/                    # Git submodules (CRITICAL - read these!)
│   ├── basic-app-datatypes/ # Type system (23 types, mapper algorithm)
│   └── moku-models/         # Platform specs (Go/Lab/Pro/Delta)
├── forge/                   # Code generator
│   ├── generator/           # YAML → VHDL engine
│   ├── models/              # Pydantic models (app specs, packages)
│   ├── templates/           # Jinja2 VHDL templates
│   ├── vhdl/                # VHDL type packages (frozen v1.0.0)
│   └── tests/               # 59+ tests (mapper, codegen, integration)
├── platform/                # Moku VHDL infrastructure
├── apps/DS1140_PD/          # Reference EMFI probe implementation
└── docs/BasicAppDataTypes/  # Phase 1-5 planning docs (from EZ-EMFI)
```

**Dependencies:** This repo uses **git submodules**. If you see import errors:
```bash
git submodule update --init --recursive
uv sync
```

---

## 📖 Learning the Codebase

### Step 1: Understand the History (Critical!)

This repo was **migrated from EZ-EMFI** on 2025-11-03. The original development happened across 6 phases:

**Phase History (in `/Users/johnycsh/EZ-EMFI/`):**
- **Phase 1**: Type system (23 types: voltage, time, boolean)
- **Phase 2**: Register mapper (auto-packing algorithm)
- **Phase 3**: Package model (Pydantic integration)
- **Phase 4**: VHDL code generation (templates, type utilities)
- **Phase 5**: Comprehensive testing (69 tests, 59 passing in new repo)
- **Phase 6**: Documentation (NOT YET STARTED)

**📚 Read these first:**
```bash
# In OLD repo (/Users/johnycsh/EZ-EMFI/docs/BasicAppDataTypes/):
cat BAD_MASTER_Orchestrator.md        # Overview of entire project
cat BAD_Phase{1-5}_COMPLETE.md        # What was completed in each phase
cat Master_Orchestrator_Prompt.md     # How to resume after context loss
```

**💡 Key Insight:** The planning docs contain critical design decisions, constraints, and lessons learned. Don't skip them!

### Step 2: Understand the Architecture

**Data Flow:**
```
YAML Spec → BasicAppDataTypes → RegisterMapper → CodeGenerator → VHDL
   ↓              ↓                    ↓               ↓            ↓
User writes   23 types        Auto-packing      Jinja2       Shim + Main
instrument    (lib)           (50-75% savings)  templates    VHDL files
```

**Register Constraints:**
- 16 total Control Registers (CR0-CR15) on Moku platforms
- 4 reserved for internal use (CR0-CR3)
- **12 available for apps (CR6-CR17)** ← This is the hard limit
- Each register is 32 bits wide
- Types auto-packed to minimize register usage

**Platform Differences:**
- Moku:Go: 125 MHz, ±25V input, ±5V output
- Moku:Lab: 500 MHz, ±5V input, ±1V output
- Moku:Pro: 1.25 GHz, ±20V input, ±5V output
- Moku:Delta: 5 GHz, ±20V input, ±5V output

### Step 3: Read the Serena Memories (from EZ-EMFI)

The old repo has **21 AI-optimized knowledge files** in `.serena/memories/`:

**Moku Instrument APIs (16 files):**
- `instrument_oscilloscope.md`, `instrument_cloud_compile.md`, etc.
- These explain how Moku instruments work (useful for context)

**Platform Knowledge (5 files):**
- `mcc_routing_concepts.md` - Slot routing, cross-connections
- `platform_models.md` - Platform specs (with Control0-15 caveat!)
- `oscilloscope_debugging_techniques.md` - Hardware validation
- `riscure_ds1120a.md` - EMFI probe hardware specs

**🔍 Access these:**
```bash
# From moku-instrument-forge context:
cat /Users/johnycsh/EZ-EMFI/.serena/memories/platform_models.md
cat /Users/johnycsh/EZ-EMFI/.serena/memories/mcc_routing_concepts.md
```

---

## 🎨 Agent Workflow Patterns

### Pattern 1: Task-Specific Agents (Recommended)

Use specialized agents for focused work:

**Example: Testing Agent**
```bash
# User launches testing agent
"Fix the 10 failing tests in forge/tests/"

# Agent loads narrow context:
- forge/tests/ (specific test files)
- forge/templates/ (for path issues)
- pyproject.toml (for moku-models)
- Runs tests, fixes issues, commits
```

**Example: Documentation Agent**
```bash
# User launches docs agent
"Write Phase 6 documentation based on completed work"

# Agent loads:
- README.md (existing structure)
- BAD_Phase6_Documentation.md (from EZ-EMFI/docs/BasicAppDataTypes/)
- BAD_Phase{1-5}_COMPLETE.md (summary of what was built)
- Creates docs/guides/, docs/reference/, docs/architecture/
```

**Example: New Instrument Agent**
```bash
# User launches instrument builder agent
"Help me create a new pulse generator instrument"

# Agent loads:
- apps/DS1140_PD/ (reference implementation)
- libs/basic-app-datatypes/README.md (type system)
- forge/models/package.py (how to structure YAML)
- Guides user through YAML creation, generates VHDL
```

### Pattern 2: Knowledge Discovery (Use Me!)

**When you (Claude) are asked:**
- "Where is X implemented?"
- "How does Y work?"
- "What's the history of Z?"

**Your workflow:**
1. Check `README.md` first (high-level overview)
2. Search `forge/` for implementation
3. Check `libs/basic-app-datatypes/` for type system logic
4. **Reference EZ-EMFI history:** `/Users/johnycsh/EZ-EMFI/docs/BasicAppDataTypes/`
5. **Read Serena memories** if platform-specific: `/Users/johnycsh/EZ-EMFI/.serena/memories/`

### Pattern 3: Iterative Development

**For multi-step tasks (like "add new feature"):**

1. **Plan** (using TodoWrite tool)
2. **Execute** (one step at a time)
3. **Test** (`uv run pytest forge/tests/ -v`)
4. **Commit** (granular commits, not big batches)
5. **Document** (update relevant .md files)

**Example:**
```
User: "Add support for 32-bit time types in nanoseconds"

Step 1: Check if BasicAppDataTypes enum has TIME_NANOSECONDS_32
Step 2: If not, propose adding it to libs/basic-app-datatypes
Step 3: Update TYPE_REGISTRY with bit width and range
Step 4: Add tests to libs/basic-app-datatypes/tests/
Step 5: Regenerate VHDL type utilities (forge/generator/type_utilities.py)
Step 6: Add integration test in forge/tests/
Step 7: Update documentation
```

---

## 🧰 Development Commands

### Quick Reference

```bash
# Setup (first time)
git submodule update --init --recursive
uv sync

# Run tests
uv run pytest forge/tests/ -v                    # All tests
uv run pytest forge/tests/test_mapper.py -v      # Specific file
./scripts/run_all_tests.sh                       # With summary

# Generate VHDL from YAML
uv run python forge/generator/codegen.py apps/DS1140_PD/spec/DS1140_PD_app.yaml -o output/

# Check code quality
uv run ruff check forge/
uv run pytest forge/tests/ --cov=forge --cov-report=html
```

### Known Issues (as of 2025-11-03)

**10 failing tests:**
1. **Template path issue (7 tests)** - Generator looks in wrong directory
   - Fix: Update `forge/generator/codegen.py` template path calculation
2. **moku-models not in workspace (3 tests)** - Import errors
   - Fix: Add `moku-models` to `pyproject.toml` workspace

**Both are 15-minute fixes!** Tests work, just need path corrections.

---

## 📝 Context-Specific Guides

### Working on Generator (`forge/generator/`)

**Key files:**
- `codegen.py` - Main YAML → VHDL generator
- `type_utilities.py` - Frozen VHDL type package generator (v1.0.0)

**Read first:**
- `/Users/johnycsh/EZ-EMFI/docs/BasicAppDataTypes/BAD_Phase4_COMPLETE.md`
- `libs/basic-app-datatypes/README.md`

**Common tasks:**
- Fix template paths: Check Jinja2 `FileSystemLoader` setup
- Add new type: Update `libs/basic-app-datatypes` first, then regenerate
- Debug generation: Run with `--verbose` flag (if added)

### Working on Models (`forge/models/`)

**Key files:**
- `app_spec.py` - CustomInstrumentApp (YAML parser)
- `package.py` - BasicAppsRegPackage (register bundler)
- `mapper.py` - BADRegisterMapper (Pydantic wrapper for core mapper)
- `register.py` - AppRegister (legacy compatibility)

**Read first:**
- `/Users/johnycsh/EZ-EMFI/docs/BasicAppDataTypes/BAD_Phase3_COMPLETE.md`
- `libs/basic-app-datatypes/basic_app_datatypes/mapper.py`

**Common tasks:**
- Add new field to YAML: Update `CustomInstrumentApp` model
- Change validation rules: Update Pydantic validators
- Integrate with MokuConfig: See `package.py::to_control_registers()`

### Working on Tests (`forge/tests/`)

**Test organization:**
- `test_mapper.py` - Register mapping (20 tests, all passing)
- `test_package.py` - Package models (24 tests, all passing)
- `test_code_generation.py` - VHDL generation (16 tests, 10 failing)
- `test_integration.py` - End-to-end (9 tests, 6 failing)

**Read first:**
- `/Users/johnycsh/EZ-EMFI/docs/BasicAppDataTypes/BAD_Phase5_COMPLETE.md`

**Common tasks:**
- Fix failing tests: Check template paths, moku-models imports
- Add new test: Follow existing patterns (pytest fixtures, parametrize)
- Run subset: `uv run pytest forge/tests/test_mapper.py::TestBADRegisterConfig -v`

### Working on Apps (`apps/DS1140_PD/`)

**Structure:**
- `spec/DS1140_PD_app.yaml` - Instrument specification
- `generated/` - Auto-generated VHDL (from spec)
- `vhdl/` - Custom application logic (hand-written)
- `tools/` - TUI and utilities
- `tests/` - CocotB tests (future)

**Read first:**
- `apps/DS1140_PD/README.md`
- `/Users/johnycsh/EZ-EMFI/docs/BasicAppDataTypes/BAD_Phase5_COMPLETE.md` (DS1140_PD validation)

**Common tasks:**
- Update spec: Edit YAML, regenerate VHDL
- Add new signal: Add to `registers:` list in YAML
- Test register mapping: Check `generated/` output after regeneration

---

## 🔍 How to Find Things

### "Where is the register mapping algorithm?"

**Answer:**
1. Core algorithm: `libs/basic-app-datatypes/basic_app_datatypes/mapper.py`
2. Pydantic wrapper: `forge/models/mapper.py`
3. Tests: `libs/basic-app-datatypes/tests/test_mapper.py`
4. Design doc: `/Users/johnycsh/EZ-EMFI/docs/BasicAppDataTypes/BAD_Phase2_RegisterMapping.md`

### "How do I add a new data type?"

**Answer:**
1. Add to enum: `libs/basic-app-datatypes/basic_app_datatypes/types.py`
2. Add metadata: `libs/basic-app-datatypes/basic_app_datatypes/metadata.py`
3. Add conversion: `libs/basic-app-datatypes/basic_app_datatypes/converters.py`
4. Regenerate VHDL: `uv run python forge/generator/type_utilities.py`
5. Add tests: `libs/basic-app-datatypes/tests/test_basic_app_datatypes.py`

### "What platforms are supported?"

**Answer:**
- Source of truth: `libs/moku-models/moku_models/platforms/`
- Summary: `README.md` (Quick Reference section)
- Details: `/Users/johnycsh/EZ-EMFI/.serena/memories/platform_models.md`
- Specs: `libs/moku-models/docs/MOKU_PLATFORM_SPECIFICATIONS.md`

### "What does the generated VHDL look like?"

**Answer:**
- Example: `apps/DS1140_PD/generated/DS1140_PD_custom_inst_shim.vhd`
- Templates: `forge/templates/shim.vhd.j2`, `main.vhd.j2`
- Type packages: `forge/vhdl/basic_app_*_pkg.vhd`

---

## 🤝 Collaboration with User

### When to Ask for Clarification

**Always ask when:**
1. Multiple valid approaches exist (e.g., "Should I use first-fit or best-fit packing?")
2. Design decisions affect architecture (e.g., "Should this be a new type or extend existing?")
3. Breaking changes needed (e.g., "This changes the YAML schema, okay?")
4. Trade-offs involved (e.g., "Faster but uses more memory, or slower but compact?")

**Never assume when:**
- User says "fix tests" → Ask which tests, or all?
- User says "add feature" → Ask for requirements, constraints
- User says "update docs" → Ask which docs, what level of detail?

### When to Use TodoWrite

**Use for:**
- Multi-step tasks (>3 steps)
- Tasks that span multiple files/components
- Anything where you might lose track

**Example:**
```
User: "Add support for 64-bit types"

Todos:
1. Add BasicAppDataTypes enum values (TIME_CYCLES_64, etc.)
2. Update TYPE_REGISTRY with bit widths
3. Add tests to libs/basic-app-datatypes
4. Regenerate VHDL type packages
5. Update forge/tests/ integration tests
6. Document in README.md
```

### When to Use Task Tool (Agents)

**Use for:**
- Exploring large codebases ("Find all uses of RegisterMapper")
- Research tasks ("How does MCC routing work?")
- Complex searches ("What tests cover voltage conversion?")

**Example:**
```
User: "How is the DS1140_PD register mapping validated?"

→ Launch Explore agent to:
  - Search for "DS1140_PD" in forge/tests/
  - Check apps/DS1140_PD/spec/ for YAML
  - Review BAD_Phase5_COMPLETE.md for validation details
  - Return summary with file references
```

---

## 🎓 Learning Resources

### Essential Reads (in order)

1. **This file** (`CLAUDE.md`) - You're reading it!
2. **README.md** - Project overview, setup, examples
3. **Phase Completion Summaries** (EZ-EMFI):
   - `BAD_Phase1_COMPLETE.md` - Type system
   - `BAD_Phase2_COMPLETE.md` - Register mapper
   - `BAD_Phase3_COMPLETE.md` - Package model
   - `BAD_Phase4_COMPLETE.md` - Code generation
   - `BAD_Phase5_COMPLETE.md` - Testing
4. **Submodule READMEs:**
   - `libs/basic-app-datatypes/README.md`
   - `libs/moku-models/README.md`

### Serena Memories (EZ-EMFI)

**Platform Knowledge:**
```bash
# Critical reads:
cat /Users/johnycsh/EZ-EMFI/.serena/memories/platform_models.md
cat /Users/johnycsh/EZ-EMFI/.serena/memories/mcc_routing_concepts.md
cat /Users/johnycsh/EZ-EMFI/.serena/memories/oscilloscope_debugging_techniques.md
```

**Instrument APIs (if needed):**
```bash
# Example instruments:
cat /Users/johnycsh/EZ-EMFI/.serena/memories/instrument_oscilloscope.md
cat /Users/johnycsh/EZ-EMFI/.serena/memories/instrument_cloud_compile.md
```

### Git History (EZ-EMFI)

**View the journey:**
```bash
cd /Users/johnycsh/EZ-EMFI
git log --oneline --graph feature/BAD-main  # See all 30+ commits
git show <commit-hash>                       # See specific changes
```

**Key commits:**
- `1701df9` - Phase 1 complete (type system)
- `314d083` - Phase 2 complete (register mapper)
- `f056d36` - Phase 3 complete (package model)
- `c8915b7` - Phase 4 complete (code generation)
- `03e388b` - Phase 5 complete (testing)

---

## 🚨 Common Pitfalls

### 1. Forgetting Submodules

**Symptom:** `ModuleNotFoundError: No module named 'basic_app_datatypes'`

**Fix:**
```bash
git submodule update --init --recursive
uv sync
```

### 2. Template Path Issues

**Symptom:** `jinja2.exceptions.TemplateNotFound: 'shim.vhd.j2'`

**Fix:** Check `forge/generator/codegen.py` - ensure template_dir is correct

### 3. Register Overflow

**Symptom:** `ValueError: Requires 13 registers, only 12 available`

**Fix:** Reduce number of signals or use smaller types (e.g., 8-bit instead of 16-bit)

### 4. Platform-Specific Behavior

**Symptom:** Time conversions wrong on different platforms

**Fix:** Ensure platform clock frequency is passed correctly to VHDL generation

### 5. Lost in Codebase

**Symptom:** "I don't know where to start"

**Fix:**
1. Read `README.md` (10 minutes)
2. Look at `apps/DS1140_PD/` (real example)
3. Read relevant `BAD_Phase*_COMPLETE.md` from EZ-EMFI
4. Ask user to clarify the goal

---

## 📋 Task Checklist Template

When starting any task, use this checklist:

- [ ] **Understand the goal** - What is the user asking for?
- [ ] **Read relevant docs** - Which Phase docs apply? Which Serena memory?
- [ ] **Locate the code** - Which files need to change?
- [ ] **Check tests** - What tests exist? What new tests needed?
- [ ] **Plan the change** - Use TodoWrite if >3 steps
- [ ] **Make the change** - Edit files, run tests
- [ ] **Verify it works** - Run tests, check output
- [ ] **Document it** - Update README or relevant docs
- [ ] **Commit cleanly** - Granular commit with clear message

---

## 🎯 Current Status (as of 2025-11-03)

**What's Complete:**
- ✅ Type system (23 types)
- ✅ Register mapper (3 strategies)
- ✅ Package model (Pydantic integration)
- ✅ VHDL code generation
- ✅ Comprehensive testing (59/69 passing)
- ✅ DS1140_PD reference implementation
- ✅ Git submodules configured
- ✅ README.md comprehensive guide

**What's Remaining:**
- ⚠️ 10 failing tests (template paths, moku-models imports)
- ❌ Phase 6: Documentation (user guides, API reference)
- ❌ CLI tool (`forge` command)
- ❌ Python API generation (future)
- ❌ CocotB VHDL simulation tests (future)

**Immediate Next Steps:**
1. Fix 10 failing tests (15 minutes)
2. Start Phase 6: Documentation
3. Create user guides, API reference, migration docs

---

## 🔗 External References

**GitHub Repositories:**
- This repo: https://github.com/sealablab/moku-instrument-forge
- Type library: https://github.com/sealablab/basic-app-datatypes
- Moku models: https://github.com/sealablab/moku-models

**Documentation:**
- Moku Platform: https://www.liquidinstruments.com/
- Jinja2: https://jinja.palletsprojects.com/
- Pydantic: https://docs.pydantic.dev/

**Related Tools:**
- uv: https://github.com/astral-sh/uv
- pytest: https://docs.pytest.org/
- GHDL: https://github.com/ghdl/ghdl

---

## 🤖 Agent-Specific Notes

### For Future Claude Instances

**When you load this file:**
1. You're in `moku-instrument-forge` (the NEW repo)
2. The OLD repo is at `/Users/johnycsh/EZ-EMFI` (read-only reference)
3. History and planning docs are in EZ-EMFI
4. Serena memories are in EZ-EMFI `.serena/memories/`
5. Working code is HERE in moku-instrument-forge

**Your first action should be:**
1. Ask user what they want to work on
2. Read relevant context (this file + Phase docs + Serena memories)
3. Explore code with focused searches
4. Propose approach, get confirmation
5. Execute with TodoWrite tracking

**Remember:**
- Use git submodules (`git submodule update --init --recursive`)
- Check EZ-EMFI history for design decisions
- Read Serena memories for platform knowledge
- Ask before making architectural changes
- Keep commits granular and well-described

---

**Last Updated:** 2025-11-03
**Migration Date:** 2025-11-03 (from EZ-EMFI feature/BAD-main)
**Next Phase:** Phase 6 - Documentation
**Status:** 59/69 tests passing, core functionality complete

---

**Questions?** Ask the user, or read:
- `README.md` for setup and examples
- `.claude/commands/platform.md` for architecture overview
- `/Users/johnycsh/EZ-EMFI/docs/BasicAppDataTypes/BAD_MASTER_Orchestrator.md` for full context

**Ready to code!** 🚀

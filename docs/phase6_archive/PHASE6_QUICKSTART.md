# Phase 6 Quick Start Guide

**Location:** `/Users/johnycsh/moku-instrument-forge/docs/PHASE6_DOCUMENTATION_PROMPT.md`

---

## What You Have

A **refined, architecture-aware** Phase 6 prompt ready to execute. It creates:

- **28 documentation files** organized in 5 directories
- **Complete type system reference** (overview + links to authoritative sources)
- **30-minute getting started tutorial** (minimal_probe.yaml example)
- **Multi-channel deep dive walkthrough** (6 signals → 2 registers)
- **Submodule integration docs** (NEW! explains forge ↔ libs boundaries)
- **Updated llms.txt and agent files**

---

## Key Architectural Updates

### ✅ Documentation Boundaries Clarified

**Forge documents** (code generation toolchain):
- YAML schema and examples
- Code generation pipeline internals
- Agent system workflows
- Debugging forge-generated VHDL

**Forge references** (submodules):
- Type system details → `libs/basic-app-datatypes/llms.txt`
- Platform specs → `libs/moku-models/docs/MOKU_PLATFORM_SPECIFICATIONS.md`
- MCC routing → `libs/moku-models/docs/routing_patterns.md`
- Probe hardware → `libs/riscure-models/docs/probes/` (MOVED!)

### ✅ Riscure Documentation Migrated

**Completed**: Moved probe specs and datasheets to proper location:
- `docs/probe_specs/riscure_ds1120a.md` → `libs/riscure-models/docs/probes/`
- `docs/datasheets/DS1120A_DS1121A_datasheet.pdf` → `libs/riscure-models/datasheets/`

**Rationale**: Hardware specs belong in hardware libraries, not code generation docs.

### ✅ Tutorial-First Approach

**Onboarding strategy**:
1. Start with working example (minimal_probe.yaml - 3 signals)
2. Show generated artifacts (manifest.json, VHDL)
3. Explain concepts (type system, register mapping)
4. Link to deeper references (type details in submodules)

**Target**: Hardware engineers OR Python developers OR complete beginners can all follow the same tutorial.

---

## How to Use

### Option 1: Execute Phase A (Recommended)

**Phase A: Structure + Essential Guides (Days 1-2)**

```bash
cd /Users/johnycsh/moku-instrument-forge

# Start execution
# Say: "Execute Phase A from the Phase 6 prompt. Create structure + 6 essential docs."
```

**Phase A deliverables**:
1. `docs/README.md` - Navigation hub
2. `docs/guides/getting_started.md` - 30-min tutorial
3. `docs/guides/user_guide.md` - Comprehensive usage
4. `docs/guides/troubleshooting.md` - Common issues
5. `docs/architecture/submodule_integration.md` - NEW! Critical architecture doc
6. Directory structure (guides/, reference/, architecture/, examples/)

**Review checkpoint**: After Phase A, review structure and essential docs before proceeding to Phases B-F.

---

### Option 2: Phased Execution

**If you want to review incrementally:**

```bash
# Phase A: Essential guides (30% of work)
"Execute Phase A from Phase 6 prompt"

# Review, then continue:
"Execute Phase B: Technical reference docs"

# Phase C: Examples
"Execute Phase C: Create minimal + multi-channel examples"

# Phase D: Architecture
"Execute Phase D: System architecture docs"

# Phase E: Integration
"Execute Phase E: Update llms.txt and agent files"

# Phase F: Validation
"Execute Phase F: Test all examples and verify links"
```

---

### Option 3: Full Execution (Advanced)

**For experienced users who trust the plan:**

```bash
"Execute all phases (A-F) from the Phase 6 documentation prompt sequentially"
```

**Note**: This will create all 28 files + updates in one session. Recommended only after reviewing the refined prompt.

---

## Documentation Structure Preview

```
docs/
├── README.md                          # 📍 START HERE - Navigation hub
│
├── guides/                            # USER-FACING (Tutorial-first!)
│   ├── getting_started.md             # 30-min: zero → package generation
│   ├── user_guide.md                  # Comprehensive forge usage
│   ├── yaml_guide.md                  # Writing YAML specs
│   ├── deployment_guide.md            # Hardware deployment
│   ├── migration_guide.md             # Manual registers → forge
│   └── troubleshooting.md             # Common issues + solutions
│
├── reference/                         # TECHNICAL REFERENCE
│   ├── type_system.md                 # Overview + links to libs/
│   ├── yaml_schema.md                 # Complete YAML v2.0 spec
│   ├── register_mapping.md            # 3 packing strategies
│   ├── manifest_schema.md             # Links to package_contract.md
│   ├── vhdl_generation.md             # Code generation pipeline
│   └── python_api.md                  # Pydantic models API
│
├── architecture/                      # DESIGN DOCUMENTS
│   ├── overview.md                    # System architecture
│   ├── code_generation.md             # Generator internals
│   ├── agent_system.md                # 5 agents explained
│   ├── submodule_integration.md       # NEW! Forge ↔ libs boundaries
│   └── design_decisions.md            # Why we built it this way
│
├── examples/                          # COMPLETE EXAMPLES
│   ├── minimal_probe.yaml             # 3 signals (simplest)
│   ├── minimal_walkthrough.md         # Line-by-line explanation
│   ├── multi_channel.yaml             # 6 signals (variety)
│   ├── multi_channel_walkthrough.md   # Deep dive with packing
│   └── common_patterns.md             # Best practices catalog
│
└── debugging/                         # DEBUGGING
    ├── fsm_observer_pattern.md        # ✅ EXISTS (forge-specific)
    ├── hardware_validation.md         # NEW: Oscilloscope workflows
    └── common_issues.md               # NEW: Debug cookbook
```

**Changes from original plan**:
- ❌ Removed `probe_specs/` and `datasheets/` (moved to `libs/riscure-models/`)
- ✅ Added `architecture/submodule_integration.md` (critical new doc)
- ✅ Changed DS1140_PD example to `multi_channel.yaml` (cleaner, modern format)

---

## Key Features of This Refined Prompt

### ✅ Architecturally Sound

- **Clear boundaries** between forge and submodules
- **Single source of truth** - link, don't duplicate
- **Submodule integration** explicitly documented
- **Hardware specs** properly delegated to libraries

### ✅ Tutorial-First

- **Getting started** shows working code immediately
- **Explain after showing** - examples before theory
- **Progressive disclosure** - simple → comprehensive → reference
- **Beginner-friendly** - no assumptions about background

### ✅ Complete

- All 25 types **referenced** (details in libs/)
- YAML schema complete (v2.0 format)
- Multi-channel walkthrough (6 signals, type variety)
- Register mapping explained (3 strategies with visuals)
- Agent system documented (5 agents, workflows)
- Troubleshooting guide (forge-specific + submodule links)

### ✅ Maintainable

- **No duplication** of submodule content
- **Relative links** work from all locations
- **Clear delegation** to authoritative sources
- **Git-friendly** structure (submodules tracked correctly)

---

## What Gets Updated (Existing Files)

1. **`llms.txt`** (root) - Add BasicAppDataTypes section (overview + link)
2. **`.claude/agents/forge-context/agent.md`** - Add doc references
3. **`.claude/agents/docgen-context/agent.md`** - Add doc references
4. **`.claude/shared/type_system_quick_ref.md`** - NEW quick lookup table

**Note**: These updates only ADD references to new docs, no breaking changes.

---

## Example: minimal_probe.yaml

The getting started tutorial uses this **3-signal example**:

```yaml
app_name: minimal_probe
version: 1.0.0
description: My first custom instrument
platform: moku_go

datatypes:
  - name: output_voltage
    datatype: voltage_output_05v_s16
    description: Output voltage setpoint
    default_value: 0
    units: V

  - name: enable_output
    datatype: boolean_1
    description: Enable output driver
    default_value: 0

  - name: pulse_width
    datatype: time_milliseconds_u16
    description: Pulse width in milliseconds
    default_value: 100
    units: ms
```

**Why this example**:
- ✅ **Simplest possible** (3 signals, 3 types)
- ✅ **Type variety** (voltage, boolean, time)
- ✅ **Real-world** (output control scenario)
- ✅ **Efficient packing** (3 signals → 2 registers)
- ✅ **Beginner-friendly** (clear purpose for each signal)

---

## Success Metrics

When Phase 6 is complete:

### For New Users
- ✅ Follow getting_started.md without external help
- ✅ Generate package from minimal_probe.yaml in 30 minutes
- ✅ Understand type system (overview + where to find details)
- ✅ Know where to look for troubleshooting

### For Developers
- ✅ Understand code generation pipeline
- ✅ Can extend forge with new features
- ✅ Clear architecture (forge ↔ libs boundaries)
- ✅ Can navigate agent system

### For Migrators
- ✅ Clear path from manual register management → forge
- ✅ Understand benefits (50-75% savings, type safety)
- ✅ Examples show common patterns

### For Documentation
- ✅ No duplication of submodule content
- ✅ All cross-references work (relative links)
- ✅ All examples tested (YAML validates, generates)
- ✅ Single source of truth maintained

---

## Timeline

**8-day estimate** (phases A-F):
- **Days 1-2**: Phase A (structure + essential guides)
- **Days 3-4**: Phase B (technical reference)
- **Day 5**: Phase C (examples)
- **Day 6**: Phase D (architecture)
- **Day 7**: Phase E (integration)
- **Day 8**: Phase F (validation)

**Can be compressed**:
- Use docgen-context for API docs (Phase B)
- Leverage test examples for YAML validation (Phase F)
- Parallelize independent documentation (Phases B-D)

---

## Next Steps

### 1. Review the Refined Prompt

**Read**: `/Users/johnycsh/moku-instrument-forge/docs/PHASE6_DOCUMENTATION_PROMPT.md`

**Key sections to review**:
- **Architectural Context** (lines 21-60) - Boundaries explained
- **Documentation Structure** (lines 102-146) - File tree
- **Tier 1: Essential User Docs** (lines 152-288) - Getting started, user guide, type reference
- **Submodule Integration** (lines 440-474) - NEW critical architecture doc

### 2. Choose Execution Strategy

**Recommended for first-time execution**: **Option 1 (Phase A only)**

```bash
"Execute Phase A from the Phase 6 documentation prompt"
```

**Review checkpoint**: After Phase A completes, review the structure and essential guides before continuing.

### 3. Start Execution

When ready:

```bash
cd /Users/johnycsh/moku-instrument-forge
# Say: "Execute Phase A from the Phase 6 documentation prompt"
```

---

## Questions?

**Q: Why move riscure docs to submodule?**
A: Hardware specs belong in hardware libraries. Keeps forge docs focused on code generation. Single source of truth.

**Q: Why not use DS1140_PD as the example?**
A: DS1140_PD uses old VoloApp format (needs migration). Multi-channel example uses modern BasicAppDataTypes format.

**Q: Can I skip some docs?**
A: Phase A (essential guides) is required. Phases B-D (reference, architecture) can be deferred if needed.

**Q: Will docgen-context auto-generate docs?**
A: docgen-context can help with API reference docs (Phase B), but Phase 6 is manual documentation writing.

**Q: How do I know I'm done?**
A: Check "Success Criteria" in prompt (lines 612-646). All checkboxes must pass.

**Q: What if I find issues during execution?**
A: Phase F includes validation. Fix issues as you find them. Update examples if needed.

---

## Architectural Improvements Summary

### Before Refinement
- ❌ Unclear boundaries (forge vs submodules)
- ❌ Riscure docs in wrong location
- ❌ Risk of duplicating submodule content
- ❌ DS1140_PD example uses old format
- ⚠️ Missing submodule integration explanation

### After Refinement
- ✅ Clear boundaries (forge = code gen, libs = specs)
- ✅ Riscure docs moved to `libs/riscure-models/`
- ✅ Explicit "link, don't duplicate" policy
- ✅ Modern examples (minimal_probe, multi_channel)
- ✅ New doc: `architecture/submodule_integration.md`

---

**Ready!** The refined prompt is architecturally sound and ready to execute.

**Start with Phase A** to get the structure and essential guides in place, then review before continuing.

---

**Last Updated:** 2025-11-03
**Prompt Location:** `docs/PHASE6_DOCUMENTATION_PROMPT.md`
**Repository:** `/Users/johnycsh/moku-instrument-forge`

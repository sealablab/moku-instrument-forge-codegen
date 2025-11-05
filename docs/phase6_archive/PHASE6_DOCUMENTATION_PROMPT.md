# Phase 6: Documentation and Knowledge Base

**Repository:** moku-instrument-forge
**Goal:** Create comprehensive documentation for the forge toolchain and BasicAppDataTypes system
**Context:** All 5 implementation phases complete, architecture validated, ready for users
**Target Users:** Hardware engineers (VHDL background), Python developers (control software), new forge users

---

## Executive Summary

This phase creates **28 documentation files** across **6 directories** to enable users to:
- 🚀 Go from installation → deployed hardware in 30 minutes
- 📖 Understand the type system (25 types) and register mapping
- 🔧 Write YAML specs, generate VHDL, deploy to Moku platforms
- 🐛 Debug hardware issues using FSM observer patterns
- 🔄 Migrate from manual register management to forge automation

---

## Architectural Context

### System Boundaries

**moku-instrument-forge** (this repo):
- **Purpose**: YAML → VHDL code generation + deployment package creation
- **Inputs**: YAML specs using BasicAppDataTypes
- **Outputs**: VHDL files + manifest.json + control_registers.json
- **NOT**: Platform specs, hardware datasheets, probe specifications

**libs/basic-app-datatypes/** (submodule):
- **Purpose**: Type system library (25 types: voltage, time, boolean)
- **Documentation**: Own llms.txt and README.md (DO NOT duplicate!)
- **References**: Link to submodule docs, don't copy

**libs/moku-models/** (submodule):
- **Purpose**: Platform specifications (Go/Lab/Pro/Delta) and MCC routing
- **Documentation**: MOKU_PLATFORM_SPECIFICATIONS.md, routing_patterns.md (DO NOT duplicate!)
- **References**: Link to submodule docs for hardware specs

**libs/riscure-models/** (submodule):
- **Purpose**: Probe hardware specifications (DS1120A, etc.)
- **Documentation**: Probe specs and datasheets (NOW IN SUBMODULE!)
- **References**: Link to submodule docs for probe specs

### Documentation Strategy

**Forge docs focus on**:
- How to use the forge toolchain (validate, generate, deploy)
- YAML schema and examples
- Code generation pipeline internals
- Agent system workflows
- Debugging forge-generated VHDL (FSM observer pattern)

**Forge docs REFERENCE (not duplicate)**:
- Type system details → `libs/basic-app-datatypes/llms.txt`
- Platform specs → `libs/moku-models/docs/MOKU_PLATFORM_SPECIFICATIONS.md`
- MCC routing → `libs/moku-models/docs/routing_patterns.md`
- Probe hardware → `libs/riscure-models/docs/probes/`

---

## Background

### What's Been Built (Phases 1-5)

- ✅ **BasicAppDataTypes**: 25-type system (libs/basic-app-datatypes/)
- ✅ **Register Mapper**: Automatic packing (50-75% savings)
- ✅ **Package Model**: Pydantic validation, YAML v2.0
- ✅ **Code Generator**: YAML → VHDL + manifest.json
- ✅ **Test Suite**: 69 tests passing
- ✅ **Agent System**: 5 specialized agents (forge, deployment, docgen, hardware-debug, workflow-coordinator)
- ✅ **Submodule Integration**: Proper delegation to libs/

### What Exists

**Forge Documentation:**
- `llms.txt` (root) - Quick reference (NEEDS BasicAppDataTypes section added)
- `.claude/agents/` - 5 specialized agents
- `.claude/shared/package_contract.md` - manifest.json spec
- `docs/debugging/fsm_observer_pattern.md` - FSM debugging (forge-specific)

**Submodule Documentation (DO NOT DUPLICATE):**
- `libs/basic-app-datatypes/llms.txt` - Type system reference
- `libs/basic-app-datatypes/README.md` - User documentation
- `libs/moku-models/docs/MOKU_PLATFORM_SPECIFICATIONS.md` - Hardware specs
- `libs/moku-models/docs/routing_patterns.md` - MCC routing patterns
- `libs/moku-models/datasheets/` - Moku platform PDFs
- `libs/riscure-models/docs/probes/` - Probe specifications (NEWLY MOVED)
- `libs/riscure-models/datasheets/` - Probe datasheets (NEWLY MOVED)

### What's Missing

- ❌ User guides (getting started, comprehensive usage)
- ❌ Technical reference (YAML schema, register mapping algorithms)
- ❌ Architecture docs (design decisions, workflows)
- ❌ Examples with walkthroughs (minimal probe, comprehensive patterns)
- ❌ Integration docs (how forge + submodules work together)

---

## Documentation Structure

Create this hierarchy in `docs/`:

```
docs/
├── README.md                           # 📍 START HERE - Navigation hub
│
├── guides/                             # USER-FACING (Tutorial-first!)
│   ├── getting_started.md              # 30-min: zero → deployed hardware
│   ├── user_guide.md                   # Comprehensive forge usage
│   ├── yaml_guide.md                   # Writing YAML specs (focus on forge, reference libs)
│   ├── deployment_guide.md             # Hardware deployment workflows
│   ├── migration_guide.md              # Manual registers → forge automation
│   └── troubleshooting.md              # Common issues + solutions
│
├── reference/                          # TECHNICAL REFERENCE
│   ├── type_system.md                  # Overview + links to libs/basic-app-datatypes
│   ├── yaml_schema.md                  # Complete YAML v2.0 spec
│   ├── register_mapping.md             # Mapping algorithms explained
│   ├── manifest_schema.md              # manifest.json spec (link to package_contract.md)
│   ├── vhdl_generation.md              # Code generation pipeline
│   └── python_api.md                   # Pydantic models, generator API
│
├── architecture/                       # DESIGN DOCUMENTS
│   ├── overview.md                     # System architecture, data flow
│   ├── code_generation.md              # Generator pipeline internals
│   ├── agent_system.md                 # 5 agents, boundaries, workflows
│   ├── submodule_integration.md        # How forge delegates to libs/
│   └── design_decisions.md             # Why we built it this way
│
├── examples/                           # COMPLETE EXAMPLES
│   ├── minimal_probe.yaml              # Simplest possible spec (3 signals)
│   ├── minimal_walkthrough.md          # Line-by-line explanation
│   ├── multi_channel.yaml              # 6-signal example (type variety)
│   ├── multi_channel_walkthrough.md    # Deep dive with register packing
│   └── common_patterns.md              # Best practices catalog
│
└── debugging/                          # DEBUGGING (EXISTING + NEW)
    ├── fsm_observer_pattern.md         # ✅ EXISTS (forge-specific FSM debugging)
    ├── hardware_validation.md          # NEW: Oscilloscope workflows
    └── common_issues.md                # NEW: Debug cookbook
```

**Note**: `probe_specs/` and `datasheets/` directories have been **removed** from forge docs and **moved** to `libs/riscure-models/` where they belong.

---

## Deliverables by Tier

### Tier 1: Essential User Docs (PRIORITY)

#### 1.1 `docs/README.md` - Navigation Hub

**Purpose**: Single entry point for all documentation

**Structure**:
- Quick Links (New Users, Reference, Examples, Architecture)
- What is moku-instrument-forge? (2-3 sentences)
- Key Features (type-safe, register savings, multi-platform, tested)
- Quick Start (3 commands: validate, generate, deploy)
- Documentation Conventions (snake_case, PascalCase, CR6-CR15)
- Submodule Documentation (links to libs/*/docs/)
- Support (GitHub issues, examples)

**Key Principle**: Point users to the right place immediately. Tutorial-first approach.

---

#### 1.2 `docs/guides/getting_started.md` - 30-Minute Tutorial

**Goal**: Get a user from zero to deployed hardware in 30 minutes

**Target**: Complete beginner (hardware engineer OR Python developer)

**Structure**:
1. **Prerequisites** - Python 3.10+, uv, git, Moku device
2. **Installation** - Clone with `--recursive`, `uv sync`
3. **Your First Spec** - Minimal 3-signal YAML (voltage, time, boolean)
4. **Generate Package** - Run `/generate`, inspect outputs
5. **Inspect Outputs** - manifest.json, VHDL files, register mapping
6. **Deploy to Hardware** - Connect to Moku, deploy (conceptual, CloudCompile not automated)
7. **Verify** - Read control registers, test signals (Python snippet)
8. **Next Steps** - Links to user guide, examples, type reference

**Example Spec** (minimal_probe.yaml):
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

**Teaching Strategy**:
- Start with working code
- Explain each field AFTER showing it
- Show generated artifacts (manifest.json, VHDL snippets)
- Link to deeper references (type system, register mapping)

---

#### 1.3 `docs/guides/user_guide.md` - Comprehensive Usage

**Goal**: Complete reference for forge workflows

**Structure**:
1. **Overview** - Forge workflow diagram (YAML → Package → Deployment)
2. **YAML Specification** - Link to yaml_guide.md for details
3. **Type System** - Overview + link to libs/basic-app-datatypes/llms.txt
4. **Register Mapping** - Concepts + link to register_mapping.md
5. **Code Generation** - Pipeline + link to vhdl_generation.md
6. **Deployment** - Workflow + link to deployment_guide.md
7. **Python Control** - Reading/writing registers, type conversion
8. **Best Practices** - Naming conventions, type selection, safety
9. **Common Patterns** - FSM control, voltage params, timing (link to examples/)

**Key Updates from Generic Template**:
- Reference `manifest.json` as source of truth (not YAML parsing)
- Use agent commands (`/generate`, `/validate`, `/map-registers`)
- Link to `.claude/shared/package_contract.md` for manifest schema
- Reference docgen-context for auto-generated APIs

---

#### 1.4 `docs/reference/type_system.md` - Type System Reference

**Purpose**: Overview of BasicAppDataTypes with links to authoritative docs

**IMPORTANT**: Do NOT duplicate `libs/basic-app-datatypes/llms.txt`! Instead:

**Structure**:
1. **Overview** - What is BasicAppDataTypes, why it exists
2. **Type Categories** - Voltage (12), Time (12), Boolean (1) - summary table
3. **Quick Reference** - Table with type name, bits, range, use case
4. **Common Use Cases** - When to use each type (DAC output vs ADC input, etc.)
5. **Platform Compatibility** - All types work on all 4 platforms
6. **Detailed Documentation** - **LINK to `libs/basic-app-datatypes/llms.txt`** for full details
7. **Type Metadata** - How to query TYPE_REGISTRY
8. **Examples** - 3-4 type usage examples in YAML + Python

**Example Quick Reference Table**:
| Type | Bits | Range | Use Case | Details |
|------|------|-------|----------|---------|
| `voltage_output_05v_s16` | 16 | ±5V | DAC output | [docs](../../libs/basic-app-datatypes/llms.txt) |
| `time_milliseconds_u16` | 16 | 0-65535 ms | Durations | [docs](../../libs/basic-app-datatypes/llms.txt) |
| `boolean_1` | 1 | 0/1 | Flags | [docs](../../libs/basic-app-datatypes/llms.txt) |

**Key Principle**: Single source of truth in the library, forge docs provide context and quick reference.

---

#### 1.5 `docs/guides/troubleshooting.md` - Common Issues

**Structure**:
- YAML validation errors (syntax, unknown types, out-of-range values)
- Code generation issues (template errors, mapping failures)
- VHDL compilation errors (CloudCompile feedback)
- Python control issues (connection, register access)
- Hardware testing issues (signals not working, FSM stuck)
- Debug techniques (link to docs/debugging/)
- Performance issues (register pressure, bit packing)
- Getting help (GitHub issues, example apps)
- FAQ

**Key Updates**:
- Add forge-specific errors (package validation, manifest.json issues)
- Reference agent commands (`/validate`, `/test-forge`)
- Link to `docs/debugging/` for hardware issues
- Link to submodule docs for type/platform issues

---

### Tier 2: Technical Reference (SECONDARY)

#### 2.1 `docs/reference/yaml_schema.md` - Complete YAML Spec

**Purpose**: Complete specification of YAML v2.0 format

**Structure**:
- Schema overview
- Top-level fields (`app_name`, `version`, `description`, `platform`)
- `datatypes` array specification
  - Required fields (`name`, `datatype`, `description`)
  - Optional fields (`default_value`, `display_name`, `units`, `min_value`, `max_value`)
  - Field validation rules
- `mapping_strategy` (optional, default: type_clustering)
- Examples for each field type
- Complete example (6-signal spec with all field types)

**Key**: Reference BasicAppDataTypes for type details, focus on YAML structure.

---

#### 2.2 `docs/reference/manifest_schema.md` - manifest.json Spec

**PURPOSE**: DO NOT DUPLICATE `.claude/shared/package_contract.md`!

**Structure**:
```markdown
# manifest.json Schema Reference

See [Package Contract Specification](../../.claude/shared/package_contract.md) for the canonical schema definition.

## Quick Reference

**Key Fields:**
- `app_name`, `version`, `platform` - Basic metadata
- `datatypes[]` - Signal definitions
- `register_mappings[]` - CR assignments
- `efficiency` - Packing metrics

**Example**: [See Package Contract](../../.claude/shared/package_contract.md#example-manifestjson)

## Usage by Context

**forge-context** - Generates manifest.json
**deployment-context** - Reads manifest.json for deployment
**docgen-context** - Reads manifest.json to generate docs
**hardware-debug-context** - Reads manifest.json for FSM states

See [Package Contract](../../.claude/shared/package_contract.md) for detailed schemas and validation rules.
```

---

#### 2.3 `docs/reference/register_mapping.md` - Mapping Algorithms

**Purpose**: Explain the 3 packing strategies

**Structure**:
- Overview (Why automatic packing matters)
- Strategy 1: `first_fit` - Algorithm, pros/cons, use cases
- Strategy 2: `best_fit` - Algorithm, pros/cons, use cases
- Strategy 3: `type_clustering` - Algorithm (default), pros/cons, use cases
- Visual examples (ASCII art register diagrams showing bit allocation)
- Efficiency metrics (how savings are calculated)
- Choosing a strategy (guidance)
- Manual override (if supported)

**Visual Example**:
```
first_fit (naive):
CR6: [voltage_16bit................] 16/32 bits used
CR7: [time_16bit...................] 16/32 bits used
CR8: [boolean.......................] 1/32 bits used
Total: 3 registers, 33/96 bits (34% efficient)

type_clustering (optimized):
CR6: [voltage_16bit|time_16bit.....] 32/32 bits used
CR7: [boolean.......................] 1/32 bits used
Total: 2 registers, 33/64 bits (52% efficient)
```

---

#### 2.4 `docs/reference/python_api.md` - Python API Reference

**Purpose**: Document key Python classes for advanced users

**Structure**:
- `BasicAppsRegPackage` - Pydantic model, methods, usage
- `DataTypeSpec` - Signal definition, validation
- `BADRegisterMapper` - Mapping engine API
- `TypeConverter` - Conversion utilities (link to basic-app-datatypes for details)
- File I/O - Loading YAML, exporting manifest.json
- Integration with moku-models (to_control_registers())

**Note**: This can be partially auto-generated by docgen-context!

---

#### 2.5 `docs/reference/vhdl_generation.md` - Code Generation

**Purpose**: Document the generation pipeline internals

**Structure**:
- Pipeline overview (YAML → Pydantic → Mapper → Templates → VHDL)
- YAML parsing (Pydantic validation)
- Register mapping (first_fit/best_fit/type_clustering)
- Template rendering (Jinja2 templates)
- VHDL file structure (shim vs main)
- Platform-specific constants (clock frequency injection)
- Generated artifacts (manifest.json, control_registers.json, VHDL files)
- Customizing templates (for advanced users)

---

### Tier 3: Architecture & Examples (TERTIARY)

#### 3.1 `docs/architecture/overview.md` - System Architecture

**Purpose**: High-level design overview

**Structure**:
- Data flow: YAML → Package → Deployment
- Component architecture: forge, libs, platform
- Agent system: 5 agents, boundaries, workflows (link to agent_system.md)
- Package contract: manifest.json as source of truth (link to package_contract.md)
- Type system: 25 types, converters, registry (link to basic-app-datatypes)
- Submodule delegation: How forge uses libs/ (link to submodule_integration.md)
- ASCII diagrams for data flow

---

#### 3.2 `docs/architecture/agent_system.md` - Agent Workflows

**Purpose**: Document the 5-agent architecture

**Structure**:
- **forge-context** - Scope, commands, outputs, boundaries
- **deployment-context** - Scope, commands, outputs, boundaries
- **docgen-context** - Scope, commands, outputs, boundaries
- **hardware-debug-context** - Scope, commands, outputs, boundaries
- **workflow-coordinator** - Workflows, orchestration, pipelines
- Agent boundaries (who does what)
- Workflow examples (`/workflow new-probe`, `/workflow iterate`)
- Reference `.claude/agents/*/agent.md` for detailed specs

---

#### 3.3 `docs/architecture/submodule_integration.md` - Submodule Delegation

**Purpose**: Explain how forge delegates to libraries

**NEW**: This is a critical architecture doc that clarifies boundaries!

**Structure**:
1. **Submodule Philosophy** - Single source of truth, no duplication
2. **basic-app-datatypes** - What it provides, how forge uses it
3. **moku-models** - What it provides, how forge uses it
4. **riscure-models** - What it provides, how forge uses it
5. **Documentation Strategy** - Link, don't duplicate
6. **Git Submodule Workflow** - How to update submodules
7. **Dependency Graph** - ASCII diagram showing relationships

**Example Content**:
```markdown
## Documentation Boundaries

### ✅ Forge Documents:
- YAML schema and examples
- Code generation pipeline
- Agent workflows
- Debugging forge-generated VHDL

### ❌ Forge Does NOT Document:
- Type system internals → `libs/basic-app-datatypes/llms.txt`
- Platform specifications → `libs/moku-models/docs/`
- Probe hardware specs → `libs/riscure-models/docs/`

### 🔗 Forge References:
All submodule documentation via relative links:
- `[Type System](../../libs/basic-app-datatypes/llms.txt)`
- `[Platform Specs](../../libs/moku-models/docs/MOKU_PLATFORM_SPECIFICATIONS.md)`
```

---

#### 3.4 `docs/examples/minimal_walkthrough.md` - Line-by-Line Example

**Purpose**: Deep dive into the simplest possible spec

**Structure**:
- Complete minimal_probe.yaml (from getting_started.md)
- Line-by-line explanation of every field
- Why each datatype was chosen
- How register mapping works (show the output)
- Generated VHDL snippets (key sections)
- Generated manifest.json (complete)
- How to deploy and test
- Variations (what if we changed types?)

---

#### 3.5 `docs/examples/multi_channel_walkthrough.md` - Comprehensive Example

**Purpose**: Show type variety and register packing in action

**Spec**: 6-signal example with:
- 2× voltage types (output + input ranges)
- 2× time types (milliseconds + cycles)
- 2× boolean types (flags)

**Structure**:
- Requirements (what we're building)
- YAML specification (complete)
- Type selection rationale (why each type)
- Register mapping output (6 signals → 2 registers, show packing)
- VHDL generation (shim + main excerpts)
- Deployment workflow
- Python control example
- Lessons learned (packing efficiency, type choices)

**Note**: Use this instead of DS1140_PD initially (DS1140_PD uses old VoloApp format, needs migration).

---

#### 3.6 `docs/examples/common_patterns.md` - Best Practices Catalog

**Purpose**: Reusable patterns for common scenarios

**Structure**:
1. **FSM Control Signals** - Boolean grouping, naming conventions
2. **Voltage Parameters** - Output vs input types, range selection
3. **Timing Configuration** - Type selection (ms vs µs vs cycles)
4. **Multi-Channel Control** - Naming conventions, arrays
5. **Safety Constraints** - Min/max validation, default values
6. **Register Optimization** - Packing strategies, bit width selection

**Format**: Each pattern as a mini-example with YAML snippet + explanation.

---

### Tier 4: Updates to Existing Files

#### 4.1 Update `llms.txt` (Root)

**Add BasicAppDataTypes section** (overview only, link to submodule):

```markdown
## BasicAppDataTypes (Type System)

moku-instrument-forge uses a 25-type system for type-safe register communication.

**Type Categories:**
- **Voltage (12):** voltage_output_05v_s16, voltage_signed_s16, voltage_millivolts_s16, etc.
- **Time (12):** time_milliseconds_u16, time_cycles_u8, time_microseconds_u16, etc.
- **Boolean (1):** boolean_1

**Key Features:**
- Fixed bit widths (no dynamic sizing)
- Platform-agnostic (125 MHz to 5 GHz)
- User-friendly units (volts, milliseconds, not raw bits)
- Automatic register packing (50-75% savings)

**Quick Reference:**
| Type | Bits | Range | Use Case |
|------|------|-------|----------|
| voltage_output_05v_s16 | 16 | ±5V | DAC output |
| time_milliseconds_u16 | 16 | 0-65535 ms | Durations |
| boolean_1 | 1 | 0/1 | Flags |

**Full Documentation:** See [`libs/basic-app-datatypes/llms.txt`](libs/basic-app-datatypes/llms.txt)

**Source:** `libs/basic-app-datatypes/` (git submodule)
```

---

#### 4.2 Update Agent Files

**forge-context/agent.md:**
- Add references to `docs/reference/type_system.md`
- Add references to `docs/reference/yaml_schema.md`
- Add references to `docs/guides/troubleshooting.md`

**docgen-context/agent.md:**
- Add references to `docs/guides/` for doc generation patterns
- Add references to `docs/examples/` for example patterns

**All agents:**
- Update "Reference Files" section to include `docs/`
- Add link to `docs/architecture/agent_system.md` for agent boundaries

---

#### 4.3 Create `.claude/shared/type_system_quick_ref.md`

**Purpose**: Quick lookup table for agents (machine-readable format)

**Structure**: Complete table of all 25 types

```markdown
# Type System Quick Reference

For agents to quickly look up type properties.

| Type | Bits | Signed | Range | Units | Category |
|------|------|--------|-------|-------|----------|
| voltage_output_05v_s16 | 16 | Yes | ±5V | V | Voltage |
| voltage_signed_s16 | 16 | Yes | ±5V | V | Voltage |
| voltage_millivolts_s16 | 16 | Yes | ±32767 mV | mV | Voltage |
| time_milliseconds_u16 | 16 | No | 0-65535 ms | ms | Time |
| time_cycles_u8 | 8 | No | 0-255 | cycles | Time |
| boolean_1 | 1 | No | 0-1 | - | Boolean |
[... all 25 types ...]

**Full Documentation:** See [`libs/basic-app-datatypes/llms.txt`](../../libs/basic-app-datatypes/llms.txt)
```

---

## Success Criteria

Phase 6 is complete when:

### Documentation Coverage
- [ ] All 25 types referenced in `type_system.md` with link to authoritative source
- [ ] Complete YAML schema in `yaml_schema.md`
- [ ] Getting started tutorial validates (0→package in 30min, deployment conceptual)
- [ ] User guide comprehensive (all forge workflows)
- [ ] Troubleshooting guide covers common issues
- [ ] Multi-channel walkthrough complete (6 signals → 2 registers example)
- [ ] Submodule integration documented (architecture/submodule_integration.md)

### Quality Standards
- [ ] All examples tested (YAML validates, generates successfully)
- [ ] Cross-references between docs verified (no broken links)
- [ ] Code examples accurate (Python, VHDL snippets)
- [ ] Links to agent files correct
- [ ] Links to submodule docs correct (relative paths)
- [ ] `llms.txt` updated with BAD section
- [ ] No duplication of submodule content

### Accessibility
- [ ] New user can follow getting_started.md without external help
- [ ] Technical reference complete (developers can extend forge)
- [ ] Migration guide clear (manual registers → forge automation)
- [ ] Examples cover common patterns
- [ ] Tutorial-first approach (examples before theory)

### Integration
- [ ] Agent files reference new docs
- [ ] `package_contract.md` not duplicated (just referenced)
- [ ] Submodule docs linked (basic-app-datatypes, moku-models, riscure-models)
- [ ] README.md updated (link to docs/)
- [ ] Architecture docs explain submodule delegation

---

## Implementation Plan

### Phase A: Structure + Essential Guides (Days 1-2)
1. Create `docs/` directory structure (guides/, reference/, architecture/, examples/)
2. Write `docs/README.md` (navigation hub)
3. Write `docs/guides/getting_started.md` (30-min tutorial with minimal_probe.yaml)
4. Write `docs/guides/user_guide.md` (comprehensive, link-heavy)
5. Write `docs/guides/troubleshooting.md`
6. Write `docs/architecture/submodule_integration.md` (NEW, critical!)

### Phase B: Technical Reference (Days 3-4)
1. Write `docs/reference/type_system.md` (overview + links to libs/)
2. Write `docs/reference/yaml_schema.md`
3. Write `docs/reference/register_mapping.md` (3 strategies with visuals)
4. Write `docs/reference/manifest_schema.md` (link to package_contract.md)
5. Write `docs/reference/python_api.md`
6. Write `docs/reference/vhdl_generation.md`

### Phase C: Examples (Day 5)
1. Create `docs/examples/minimal_probe.yaml` (3 signals)
2. Write `docs/examples/minimal_walkthrough.md`
3. Create `docs/examples/multi_channel.yaml` (6 signals)
4. Write `docs/examples/multi_channel_walkthrough.md`
5. Write `docs/examples/common_patterns.md` (6 patterns)

### Phase D: Architecture (Day 6)
1. Write `docs/architecture/overview.md`
2. Write `docs/architecture/agent_system.md`
3. Write `docs/architecture/code_generation.md`
4. Write `docs/architecture/design_decisions.md`

### Phase E: Integration (Day 7)
1. Update `llms.txt` with BAD section (overview + link)
2. Update agent files (forge, docgen) with doc references
3. Create `.claude/shared/type_system_quick_ref.md`
4. Update README.md (link to docs/)
5. Verify all cross-references (no broken links)
6. Verify submodule links (relative paths work)

### Phase F: Validation (Day 8)
1. Test all YAML examples (validate, generate)
2. Verify all Python snippets (syntax, imports)
3. Check all cross-references (no broken links)
4. Run through getting_started.md as new user
5. Final review (completeness, accuracy, clarity)

---

## Writing Guidelines

### Style
- **Clear, concise language** - No jargon without explanation
- **Active voice** - "Generate VHDL" not "VHDL is generated"
- **Examples first** - Show, then explain (tutorial-first approach)
- **Visual aids** - ASCII diagrams for register layouts, data flow
- **Progressive disclosure** - Quick start → comprehensive → reference

### Code Examples
- **Complete, runnable** - No pseudo-code
- **Commented** - Explain non-obvious steps
- **Tested** - Verify before documenting
- **Platform-specific** - Note clock frequencies, voltage ranges when relevant

### Cross-References
- **Relative links** - `../reference/type_system.md`, not absolute paths
- **Context** - "See [Type System](link) for details" not just "[link]"
- **Bidirectional** - User guide ↔ reference ↔ examples
- **Submodule links** - `../../libs/basic-app-datatypes/llms.txt` (relative)

### Markdown Conventions
- **Headers** - `#` for title, `##` for sections, `###` for subsections
- **Code blocks** - Specify language (```yaml, ```python, ```vhdl)
- **Tables** - Use for comparisons, specifications
- **Lists** - Bulleted for items, numbered for steps
- **Admonitions** - Use `**Note:**`, `**Warning:**`, `**Tip:**`

### Submodule References
- **DO NOT DUPLICATE** - Link to authoritative source
- **Provide Context** - Explain WHY the link is relevant
- **Relative Paths** - `../../libs/basic-app-datatypes/llms.txt`
- **Check Links** - Verify paths work from all doc locations

---

## Tools Available

### Agent Commands (use as reference, not for auto-generation during Phase 6)
```bash
# These exist but are part of the workflow being documented
/generate SPEC.yaml               # Generate package
/validate SPEC.yaml               # Validate YAML
/map-registers SPEC.yaml          # Show register mapping
/gen-docs APP                     # Auto-generate docs (docgen-context)
/gen-python-api APP               # Generate Python API (docgen-context)
```

### Validation During Phase 6
```bash
# Test YAML examples as you write them
/validate docs/examples/minimal_probe.yaml
/generate docs/examples/minimal_probe.yaml --output-dir /tmp/test
```

### Reference Materials
- **Forge tests:** `forge/tests/` (for correct usage patterns)
- **Package contract:** `.claude/shared/package_contract.md`
- **Submodule docs:** `libs/*/llms.txt`, `libs/*/README.md`
- **Agent specs:** `.claude/agents/*/agent.md`
- **Existing examples:** `apps/DS1140_PD/` (note: uses old VoloApp format)

---

## Deliverable Checklist

### Files to Create (28 files)

**guides/ (6 files):**
- [ ] getting_started.md
- [ ] user_guide.md
- [ ] yaml_guide.md
- [ ] deployment_guide.md
- [ ] migration_guide.md
- [ ] troubleshooting.md

**reference/ (6 files):**
- [ ] type_system.md (overview + links)
- [ ] yaml_schema.md
- [ ] register_mapping.md
- [ ] manifest_schema.md (link to package_contract.md)
- [ ] vhdl_generation.md
- [ ] python_api.md

**architecture/ (5 files):**
- [ ] overview.md
- [ ] code_generation.md
- [ ] agent_system.md
- [ ] submodule_integration.md (NEW!)
- [ ] design_decisions.md

**examples/ (5 files):**
- [ ] minimal_probe.yaml
- [ ] minimal_walkthrough.md
- [ ] multi_channel.yaml
- [ ] multi_channel_walkthrough.md
- [ ] common_patterns.md

**debugging/ (2 new files, 1 existing):**
- [ ] hardware_validation.md (NEW)
- [ ] common_issues.md (NEW)
- ✅ fsm_observer_pattern.md (EXISTS)

**Root docs/ (1 file):**
- [ ] README.md

**Updates (4 files):**
- [ ] llms.txt (root) - Add BAD section
- [ ] .claude/agents/forge-context/agent.md - Add doc refs
- [ ] .claude/agents/docgen-context/agent.md - Add doc refs
- [ ] .claude/shared/type_system_quick_ref.md - NEW file

---

## Final Output

After completion:

1. **Complete documentation tree** in `docs/` (28 files)
2. **Updated knowledge base** (llms.txt, agent files)
3. **Validated examples** (all YAML specs generate successfully)
4. **Cross-referenced network** (guides ↔ reference ↔ examples ↔ submodules)
5. **GitHub-ready** (README.md links to docs/)
6. **Submodule integration** (clear delegation, no duplication)

**Result**:
- ✅ New users: 0 → package generated in 30 minutes
- ✅ Developers: Can extend forge with new types/features
- ✅ Migrators: Clear path from manual registers to forge
- ✅ Troubleshooters: Debug guide covers common issues
- ✅ Architecture: Clear understanding of forge ↔ libs boundaries

---

**Ready to Begin!** Start with Phase A (Structure + Essential Guides).

**First Task:** Create `docs/README.md` as navigation hub, then `docs/guides/getting_started.md`.

---

**Last Updated:** 2025-11-03
**Target Completion:** 8 days
**Repository:** `/Users/johnycsh/moku-instrument-forge`

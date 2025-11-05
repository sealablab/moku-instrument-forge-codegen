# Phase 6E: Integration and Agent Documentation References

**Phase:** E (Integration)
**Status:** Ready to execute
**Prerequisite:** Phases A-D complete
**Deliverables:** 1 llms.txt update + 5 agent updates + 1 new shared file

---

## Context

**Project:** moku-instrument-forge
**Working Directory:** `/Users/johnycsh/moku-instrument-forge`

**Completed Phases:**
- Phase A-B: Essential guides and technical reference ✅
- Phase C: Examples and walkthroughs ✅
- Phase D: Architecture documentation ✅

**Phase D deliverables** provide comprehensive architecture docs that agents should reference:
- `docs/architecture/overview.md` - System architecture
- `docs/architecture/agent_system.md` - 5-agent boundaries
- `docs/architecture/code_generation.md` - Pipeline internals
- `docs/architecture/design_decisions.md` - Design rationale

**Phase B deliverables** provide technical references:
- `docs/reference/type_system.md` - Type catalog
- `docs/reference/yaml_schema.md` - YAML spec
- `docs/reference/register_mapping.md` - Packing algorithms
- `docs/reference/manifest_schema.md` - Package contract
- `docs/reference/vhdl_generation.md` - Code generation
- `docs/reference/python_api.md` - Python API

**See:** `docs/PHASE6_PLAN.md` for complete context

---

## Your Task

Integrate new documentation by:
1. Enhancing `llms.txt` with comprehensive type system section
2. Adding "Documentation References" sections to **all 5 agent files**
3. Creating type system quick reference for agent use

---

## Deliverable 1: Update `llms.txt` (Root)

**File:** `/Users/johnycsh/moku-instrument-forge/llms.txt`

**Action:** Add comprehensive BasicAppDataTypes section

**Location:** Insert after project overview (around line 74), before agent documentation

**Content to Add:**

```markdown
---

## BasicAppDataTypes (Type System)

moku-instrument-forge uses the **BasicAppDataTypes** type system for type-safe register communication.

### Overview

**23 built-in types** across 3 categories:
- **Voltage (12 types):** Platform-agnostic voltage ranges with signed/unsigned variants
- **Time (10 types):** User-friendly time units (ns, µs, ms, s) with multiple bit widths
- **Boolean (1 type):** Single-bit flags

**Key Features:**
- Fixed bit widths (no dynamic sizing)
- Platform-agnostic (125 MHz to 5 GHz)
- User-friendly units (volts, milliseconds, not raw bits)
- Automatic register packing (50-75% savings)

### Quick Reference

**Voltage Types (12):**
- `voltage_output_05v_s16` - ±5V signed 16-bit DAC output (most common)
- `voltage_output_05v_s8` - ±5V signed 8-bit DAC output (low-res)
- `voltage_output_05v_u15` - 0-5V unsigned 15-bit DAC output (positive only)
- `voltage_output_05v_u7` - 0-5V unsigned 7-bit DAC output (low-res, positive only)
- `voltage_input_20v_s16` - ±20V signed 16-bit ADC input (Pro/Delta)
- `voltage_input_20v_s8` - ±20V signed 8-bit ADC input (low-res)
- `voltage_input_20v_u15` - 0-20V unsigned 15-bit ADC input (positive only)
- `voltage_input_20v_u7` - 0-20V unsigned 7-bit ADC input (low-res, positive only)
- `voltage_input_25v_s16` - ±25V signed 16-bit ADC input (Go)
- `voltage_input_25v_s8` - ±25V signed 8-bit ADC input (low-res)
- `voltage_input_25v_u15` - 0-25V unsigned 15-bit ADC input (positive only)
- `voltage_input_25v_u7` - 0-25V unsigned 7-bit ADC input (low-res, positive only)

**Time Types (10):**
- `pulse_duration_ns_u16` - 0-65535 ns (glitch widths, most common)
- `pulse_duration_ns_u8` - 0-255 ns (very short pulses)
- `pulse_duration_ns_u32` - 0-4.3B ns (~4.3s in ns resolution)
- `pulse_duration_us_u16` - 0-65535 µs (~65ms, most common)
- `pulse_duration_us_u8` - 0-255 µs (short delays)
- `pulse_duration_us_u24` - 0-16.7M µs (~16s)
- `pulse_duration_ms_u16` - 0-65535 ms (~65s, most common)
- `pulse_duration_ms_u8` - 0-255 ms (medium timeouts)
- `pulse_duration_sec_u16` - 0-65535 s (~18hr)
- `pulse_duration_sec_u8` - 0-255 s (very long delays)

**Boolean Type (1):**
- `boolean` - 1-bit true/false (flags, enables)

### Common Use Cases

**DAC output voltage:**
```yaml
datatype: voltage_output_05v_s16  # ±5V, 16-bit, standard choice
```

**Glitch width:**
```yaml
datatype: pulse_duration_ns_u16  # Nanosecond precision, 16-bit range
```

**Timeout:**
```yaml
datatype: pulse_duration_ms_u16  # Millisecond resolution, long range
```

**Feature enable:**
```yaml
datatype: boolean  # Single bit, minimal space
```

### Documentation

**User-Facing Docs:**
- [Type System Reference](docs/reference/type_system.md) - Complete catalog with examples
- [YAML Schema](docs/reference/yaml_schema.md) - How to use types in YAML
- [User Guide](docs/guides/user_guide.md) - High-level overview

**Authoritative Source:**
- [`libs/basic-app-datatypes/llms.txt`](libs/basic-app-datatypes/llms.txt) - Complete type definitions, conversion formulas, metadata
- [`libs/basic-app-datatypes/README.md`](libs/basic-app-datatypes/README.md) - User documentation

**Implementation:**
- `libs/basic-app-datatypes/basic_app_datatypes/types.py` - Enum definitions
- `libs/basic-app-datatypes/basic_app_datatypes/metadata.py` - TYPE_REGISTRY

### Platform Compatibility

All 23 types work across all 4 Moku platforms:
- **Moku:Go** - 125 MHz, ±25V input, ±5V output
- **Moku:Lab** - 500 MHz, ±5V input, ±1V output
- **Moku:Pro** - 1.25 GHz, ±20V input, ±5V output
- **Moku:Delta** - 5 GHz, ±20V input, ±5V output

**See:** [Type System - Platform Compatibility](docs/reference/type_system.md#platform-compatibility)

---
```

**Notes:**
- Insert this section cleanly into existing llms.txt structure
- Maintain existing formatting style
- Keep links relative and correct

---

## Deliverable 2: Update Agent Documentation

Add "Documentation References" sections to all 5 agents.

### 2.1 Update `forge-context/agent.md`

**File:** `.claude/agents/forge-context/agent.md`

**Location:** After existing "Reference Files" section (around line 707), add new section

**Content to Add:**

```markdown
---

## Documentation References

When working on forge tasks, consult these user-facing docs:

**Type System:**
- [Type System Overview](../../../docs/reference/type_system.md) - Quick type reference with examples
- [Type System Details](../../../libs/basic-app-datatypes/llms.txt) - Authoritative source with conversion formulas
- [Type Quick Ref](../../shared/type_system_quick_ref.md) - Agent lookup table

**YAML Specification:**
- [YAML Schema Reference](../../../docs/reference/yaml_schema.md) - Complete spec with validation rules
- [Examples](../../../docs/examples/) - Working examples with walkthroughs

**Register Mapping:**
- [Register Mapping Algorithms](../../../docs/reference/register_mapping.md) - Packing strategies explained
- [Common Patterns](../../../docs/examples/common_patterns.md#register-optimization) - Optimization patterns

**Troubleshooting:**
- [Troubleshooting Guide](../../../docs/guides/troubleshooting.md) - Common errors and fixes
- [YAML Validation Errors](../../../docs/guides/troubleshooting.md#yaml-validation-errors) - Validation error reference

**Architecture:**
- [Code Generation Pipeline](../../../docs/architecture/code_generation.md) - Pipeline internals
- [Design Decisions](../../../docs/architecture/design_decisions.md) - Why automatic packing, Pydantic, etc.

---
```

### 2.2 Update `deployment-context/agent.md`

**File:** `.claude/agents/deployment-context/agent.md`

**Location:** At end of file, before final notes

**Content to Add:**

```markdown
---

## Documentation References

When working on deployment tasks, consult these docs:

**System Architecture:**
- [Architecture Overview](../../../docs/architecture/overview.md) - Data flow, component boundaries
- [Agent System](../../../docs/architecture/agent_system.md) - deployment-context scope and boundaries

**Deployment Guide:**
- [User Guide - Deployment](../../../docs/guides/user_guide.md#deployment) - Deployment workflow (when created)
- [Getting Started](../../../docs/guides/getting_started.md) - End-to-end example with deployment

**Package Contract:**
- [Package Contract](../../shared/package_contract.md) - manifest.json schema (what you consume)
- [Manifest Schema](../../../docs/reference/manifest_schema.md) - User-facing manifest docs

**Platform Specs:**
- [moku-models Documentation](../../../libs/moku-models/docs/) - Platform specs, routing patterns
- [Submodule Integration](../../../docs/architecture/submodule_integration.md) - How to use moku-models

---
```

### 2.3 Update `docgen-context/agent.md`

**File:** `.claude/agents/docgen-context/agent.md`

**Location:** After "Integration with Other Contexts" section (around line 791)

**Content to Add:**

```markdown
---

## Documentation References

When generating docs or APIs, reference these patterns and specs:

**Documentation Patterns:**
- [User Guide](../../../docs/guides/user_guide.md) - Comprehensive doc structure
- [Getting Started](../../../docs/guides/getting_started.md) - Tutorial pattern
- [Examples](../../../docs/examples/) - Walkthrough format

**Generation Sources:**
- [Package Contract](../../shared/package_contract.md) - manifest.json schema (what you consume)
- [Type System Reference](../../../docs/reference/type_system.md) - Type metadata for UI generation
- [Register Mapping](../../../docs/reference/register_mapping.md) - Register allocation info

**Architecture Context:**
- [Architecture Overview](../../../docs/architecture/overview.md) - System context
- [Agent System](../../../docs/architecture/agent_system.md) - docgen-context boundaries

**Auto-Generation Targets:**
- Markdown documentation (README.md, register_map.md, api_reference.md)
- Textual TUI applications (from datatypes metadata)
- Python control classes (from register_mappings)

---
```

### 2.4 Update `hardware-debug-context/agent.md`

**File:** `.claude/agents/hardware-debug-context/agent.md`

**Location:** After "Integration with Other Contexts" section (around line 581)

**Content to Add:**

```markdown
---

## Documentation References

When debugging hardware, consult these specialized guides:

**FSM Debugging:**
- [FSM Observer Pattern](../../../docs/debugging/fsm_observer_pattern.md) - Voltage-encoded debugging technique
- [Troubleshooting - Hardware](../../../docs/guides/troubleshooting.md#hardware-testing) - Common hardware issues

**Architecture Context:**
- [Architecture Overview](../../../docs/architecture/overview.md) - System data flow
- [Agent System](../../../docs/architecture/agent_system.md) - hardware-debug-context scope

**Platform Timing:**
- [Type System - Platform Compatibility](../../../docs/reference/type_system.md#platform-compatibility) - Clock frequencies
- [moku-models Platform Specs](../../../libs/moku-models/docs/) - Platform-specific timing details

**Package Metadata:**
- [Package Contract](../../shared/package_contract.md) - manifest.json schema for FSM states
- [Manifest Schema](../../../docs/reference/manifest_schema.md) - How to read FSM definitions

---
```

### 2.5 Update `workflow-coordinator/agent.md`

**File:** `.claude/agents/workflow-coordinator/agent.md`

**Location:** At end of file, before final notes

**Content to Add:**

```markdown
---

## Documentation References

When coordinating workflows, consult these high-level guides:

**Agent System:**
- [Agent System Architecture](../../../docs/architecture/agent_system.md) - All 5 agents, boundaries, workflows
- [Architecture Overview](../../../docs/architecture/overview.md) - Complete system design

**User Workflows:**
- [User Guide](../../../docs/guides/user_guide.md) - Complete user workflow
- [Getting Started](../../../docs/guides/getting_started.md) - Tutorial workflow example

**Design Context:**
- [Design Decisions](../../../docs/architecture/design_decisions.md) - Why 5 agents, why manifest.json, etc.
- [Package Contract](../../shared/package_contract.md) - Contract between agents

---
```

---

## Deliverable 3: Create Type System Quick Reference

**File:** `.claude/shared/type_system_quick_ref.md`

**Purpose:** Quick lookup table for agents (machine-readable format)

**Content:**

```markdown
# Type System Quick Reference

**For agents:** Quick lookup of type properties without reading full docs.

**Authoritative Source:** [`libs/basic-app-datatypes/llms.txt`](../../libs/basic-app-datatypes/llms.txt)

**Last Updated:** 2025-11-03 (Phase 6E)

---

## All 23 Types

### Voltage Types (12)

| Type | Bits | Signed | Range | Use Case |
|------|------|--------|-------|----------|
| `voltage_output_05v_s16` | 16 | Yes | ±5V | DAC output (standard) |
| `voltage_output_05v_s8` | 8 | Yes | ±5V | DAC output (low-res) |
| `voltage_output_05v_u15` | 15 | No | 0-5V | DAC output (positive only, high-res) |
| `voltage_output_05v_u7` | 7 | No | 0-5V | DAC output (positive only, low-res) |
| `voltage_input_20v_s16` | 16 | Yes | ±20V | ADC input (Pro/Delta, standard) |
| `voltage_input_20v_s8` | 8 | Yes | ±20V | ADC input (Pro/Delta, low-res) |
| `voltage_input_20v_u15` | 15 | No | 0-20V | ADC input (Pro/Delta, positive only) |
| `voltage_input_20v_u7` | 7 | No | 0-20V | ADC input (Pro/Delta, low-res, positive only) |
| `voltage_input_25v_s16` | 16 | Yes | ±25V | ADC input (Go, standard) |
| `voltage_input_25v_s8` | 8 | Yes | ±25V | ADC input (Go, low-res) |
| `voltage_input_25v_u15` | 15 | No | 0-25V | ADC input (Go, positive only) |
| `voltage_input_25v_u7` | 7 | No | 0-25V | ADC input (Go, low-res, positive only) |

### Time Types (10)

| Type | Bits | Range (unsigned) | Units | Use Case |
|------|------|------------------|-------|----------|
| `pulse_duration_ns_u16` | 16 | 0-65,535 ns | ns | Glitch widths (standard) |
| `pulse_duration_ns_u8` | 8 | 0-255 ns | ns | Very short pulses |
| `pulse_duration_ns_u32` | 32 | 0-4.3B ns | ns | Long timing in ns resolution |
| `pulse_duration_us_u16` | 16 | 0-65,535 µs | µs | Delays, pulses (standard) |
| `pulse_duration_us_u8` | 8 | 0-255 µs | µs | Short delays |
| `pulse_duration_us_u24` | 24 | 0-16.7M µs | µs | Very long delays |
| `pulse_duration_ms_u16` | 16 | 0-65,535 ms | ms | Long timeouts (standard) |
| `pulse_duration_ms_u8` | 8 | 0-255 ms | ms | Medium timeouts |
| `pulse_duration_sec_u16` | 16 | 0-65,535 s | s | Measurement windows |
| `pulse_duration_sec_u8` | 8 | 0-255 s | s | Very long delays |

### Boolean Type (1)

| Type | Bits | Values | Use Case |
|------|------|--------|----------|
| `boolean` | 1 | 0 or 1 | Flags, enables, arm signals |

---

## Usage Notes

**Type Selection Guidelines:**

**For DAC outputs:**
- Use `voltage_output_05v_s16` (standard, ±5V, 16-bit)
- Use `voltage_output_05v_u15` if only positive voltages needed (saves 1 bit)

**For ADC inputs:**
- Moku:Pro/Delta: Use `voltage_input_20v_s16`
- Moku:Go: Use `voltage_input_25v_s16`

**For timing:**
- Glitch widths: `pulse_duration_ns_u16` (nanosecond precision)
- Pulse delays: `pulse_duration_us_u16` (microsecond precision)
- Timeouts: `pulse_duration_ms_u16` (millisecond precision)

**For flags:**
- Always use `boolean` (1-bit, minimal space)

**Platform Compatibility:**
All 23 types work on all 4 platforms (Go, Lab, Pro, Delta).

**For complete details:**
- [Type System Reference](../../docs/reference/type_system.md) - User-facing docs with examples
- [basic-app-datatypes llms.txt](../../libs/basic-app-datatypes/llms.txt) - Authoritative type definitions

---

*This quick reference is for agent use. For user-facing documentation, see docs/reference/type_system.md*
```

---

## Success Criteria

Before considering Phase 6E complete:

- [ ] `llms.txt` updated with comprehensive BasicAppDataTypes section (all 23 types)
- [ ] All 5 agent files have "Documentation References" sections
- [ ] `type_system_quick_ref.md` created with all 23 types
- [ ] All relative links work from each file location
- [ ] Type names are correct (`boolean`, `pulse_duration_*`, not `boolean_1`, `time_*`)
- [ ] Type count is correct (23, not 25)

---

## Verification Commands

**Test relative links:**
```bash
# From llms.txt (root)
ls docs/reference/type_system.md
ls libs/basic-app-datatypes/llms.txt

# From agent files (.claude/agents/*/agent.md)
ls ../../../docs/reference/type_system.md  # From .claude/agents/forge-context/
ls ../../shared/type_system_quick_ref.md   # From .claude/agents/forge-context/

# From type_system_quick_ref.md (.claude/shared/)
ls ../../libs/basic-app-datatypes/llms.txt
ls ../../docs/reference/type_system.md
```

**Verify all files exist:**
```bash
# New/updated files
ls llms.txt
ls .claude/agents/forge-context/agent.md
ls .claude/agents/deployment-context/agent.md
ls .claude/agents/docgen-context/agent.md
ls .claude/agents/hardware-debug-context/agent.md
ls .claude/agents/workflow-coordinator/agent.md
ls .claude/shared/type_system_quick_ref.md
```

---

## Workflow

1. **Read existing files** to understand current structure
2. **Update llms.txt** - Add BasicAppDataTypes section with all 23 types
3. **Update all 5 agent files** - Add "Documentation References" sections
4. **Create type_system_quick_ref.md** - All 23 types with correct names
5. **Test all relative links** - Ensure paths are correct
6. **Commit:**
   ```bash
   git add llms.txt .claude/
   git commit -m "$(cat <<'EOF'
   docs: Complete Phase 6E - Integration and documentation references

   Phase E deliverables (7 file updates):
   - llms.txt: Add comprehensive BasicAppDataTypes section (23 types)
   - forge-context/agent.md: Add documentation references
   - deployment-context/agent.md: Add documentation references
   - docgen-context/agent.md: Add documentation references
   - hardware-debug-context/agent.md: Add documentation references
   - workflow-coordinator/agent.md: Add documentation references
   - type_system_quick_ref.md: NEW quick reference for agents

   Key improvements:
   ✅ All agents now reference Phase A-D documentation
   ✅ Correct type names (boolean, pulse_duration_*, not boolean_1, time_*)
   ✅ Correct type count (23, not 25)
   ✅ Unified documentation references across all agents
   ✅ Quick reference for agent type lookups

   Next: Phase F (Validation)

   🤖 Generated with [Claude Code](https://claude.com/claude-code)

   Co-Authored-By: Claude <noreply@anthropic.com>
   EOF
   )"
   ```
7. **Update PHASE6_PLAN.md** - Mark Phase E complete

---

**Ready to begin Phase 6E!**

**Key Corrections from Original PHASE6E_PROMPT.md:**
1. ✅ Correct type count: 23 (not 25)
2. ✅ Correct type names: `boolean`, `pulse_duration_*` (not `boolean_1`, `time_*`)
3. ✅ All 5 agents get documentation references (not just 2)
4. ✅ Links point to actual Phase D architecture docs
5. ✅ References comprehensive Phase B reference docs

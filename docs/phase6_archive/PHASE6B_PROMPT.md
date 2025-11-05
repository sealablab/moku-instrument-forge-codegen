# Phase 6B: Technical Reference Documentation

**Phase:** B (Technical Reference)
**Status:** Ready to execute
**Prerequisite:** Phase A complete
**Deliverables:** 6 technical reference documents

---

## Context

**Project:** moku-instrument-forge
**Working Directory:** `/Users/johnycsh/moku-instrument-forge`

**Phase A Completed:**
- ✅ docs/README.md (navigation hub)
- ✅ docs/guides/getting_started.md (30-min tutorial)
- ✅ docs/guides/user_guide.md (comprehensive usage)
- ✅ docs/guides/troubleshooting.md
- ✅ docs/architecture/submodule_integration.md

**See:** `docs/PHASE6_PLAN.md` for complete context

---

## Your Task

Create 6 technical reference documents following the specifications in `PHASE6_PLAN.md` under "Phase B: Technical Reference".

### Files to Create

1. **`docs/reference/type_system.md`** (~300 lines)
   - Overview of BasicAppDataTypes
   - Type categories (voltage: 12, time: 12, boolean: 1)
   - Quick reference table
   - **LINK to `libs/basic-app-datatypes/llms.txt`** (authoritative source)
   - No duplication of submodule content

2. **`docs/reference/yaml_schema.md`** (~400 lines)
   - Complete YAML v2.0 specification
   - Top-level fields, datatypes array
   - Field validation rules
   - Complete example (6-signal spec)

3. **`docs/reference/register_mapping.md`** (~350 lines)
   - 3 packing strategies (first_fit, best_fit, type_clustering)
   - ASCII art visual examples
   - Efficiency metrics
   - Choosing a strategy

4. **`docs/reference/manifest_schema.md`** (~150 lines)
   - **LINK to `.claude/shared/package_contract.md`** (authoritative source)
   - Quick reference only
   - No duplication

5. **`docs/reference/vhdl_generation.md`** (~400 lines)
   - Pipeline overview
   - YAML → Pydantic → Mapper → Templates → VHDL
   - Template rendering
   - Generated artifacts

6. **`docs/reference/python_api.md`** (~300 lines)
   - Key Python classes (BasicAppsRegPackage, DataTypeSpec, BADRegisterMapper)
   - TypeConverter usage
   - File I/O

---

## Key Principles

### 1. Link, Don't Duplicate
**DO NOT copy content from submodules:**
- ❌ Don't copy type definitions from `libs/basic-app-datatypes/llms.txt`
- ❌ Don't copy manifest schema from `.claude/shared/package_contract.md`
- ✅ DO link to authoritative sources
- ✅ DO provide context and quick reference

### 2. Use Relative Links
All links must work from the file's location:
```markdown
<!-- In docs/reference/type_system.md -->
[Full Type Reference](../../libs/basic-app-datatypes/llms.txt)
[Getting Started](../guides/getting_started.md)
```

### 3. Include Visual Examples
Use ASCII art for register layouts, data flow diagrams, etc.

### 4. Cross-Reference Heavily
Link to related docs (guides, examples, architecture).

---

## Detailed Specifications

### 1. type_system.md

**Purpose:** Overview with links to authoritative BasicAppDataTypes docs

**Structure:**
```markdown
# Type System Reference

## Overview
What is BasicAppDataTypes, why it exists

## Type Categories
- Voltage (12 types)
- Time (12 types)
- Boolean (1 type)

## Quick Reference
| Type | Bits | Range | Use Case | Details |
|------|------|-------|----------|---------|
| voltage_output_05v_s16 | 16 | ±5V | DAC output | [docs](../../libs/basic-app-datatypes/llms.txt) |
...

## Common Use Cases
When to use each type category

## Platform Compatibility
All types work on all 4 platforms

## Detailed Documentation
**Authoritative Source:** [libs/basic-app-datatypes/llms.txt](../../libs/basic-app-datatypes/llms.txt)

For complete type definitions, conversion formulas, and implementation details, see the authoritative documentation.

## Type Metadata
How to query TYPE_REGISTRY from Python

## Examples
3-4 usage examples in YAML + Python
```

**Key:** Quick reference table covers all 25 types, but links to llms.txt for details.

---

### 2. yaml_schema.md

**Purpose:** Complete YAML v2.0 format specification

**Structure:**
```markdown
# YAML Schema Reference

## Overview
YAML v2.0 format for moku-instrument-forge

## Top-Level Fields

### Required Fields
- app_name (string, snake_case)
- version (string, semver)
- description (string)
- platform (enum: moku_go | moku_lab | moku_pro | moku_delta)
- datatypes (array)

### Optional Fields
- mapping_strategy (enum: first_fit | best_fit | type_clustering, default: type_clustering)

## Datatypes Array

### Required Per Signal
- name (string, snake_case, unique)
- datatype (string, from BasicAppDataTypes)
- description (string)
- default_value (number, within type range)

### Optional Per Signal
- units (string, for display)
- display_name (string, UI-friendly)
- min_value (number, runtime constraint)
- max_value (number, runtime constraint)

## Validation Rules
...

## Complete Example
6-signal spec demonstrating all fields
```

**Reference:** Link to `type_system.md` for datatype details.

---

### 3. register_mapping.md

**Purpose:** Explain 3 packing strategies

**Structure:**
```markdown
# Register Mapping Algorithms

## Overview
Why automatic packing matters (50-75% savings)

## Available Strategies

### 1. first_fit (Naive)
**Algorithm:** Assign each signal to first register with space
**Time Complexity:** O(n)
**Use Case:** Testing only (not recommended)

### 2. best_fit (Optimized)
**Algorithm:** Assign to register with smallest remaining space
**Time Complexity:** O(n²)
**Use Case:** Maximum packing density needed

### 3. type_clustering (Default)
**Algorithm:** Group by bit width, then pack
**Time Complexity:** O(n log n)
**Use Case:** Recommended (best balance)

## Visual Examples
[ASCII art showing same signals packed with each strategy]

## Efficiency Metrics
How savings are calculated in manifest.json

## Choosing a Strategy
Guidance on when to use each

## Manual Override
How to specify strategy in YAML
```

**Include:** ASCII register diagrams for minimal_probe.yaml with each strategy.

---

### 4. manifest_schema.md

**Purpose:** Quick reference, link to package_contract.md

**Structure:**
```markdown
# manifest.json Schema Reference

**Authoritative Source:** [Package Contract Specification](../../.claude/shared/package_contract.md)

## Quick Reference

manifest.json is the **source of truth** for deployment. Generated by forge-context, consumed by deployment-context, docgen-context, hardware-debug-context.

**Key Fields:**
- `app_name`, `version`, `platform` - Basic metadata
- `datatypes[]` - Signal definitions with register assignments
- `register_mappings[]` - Control register allocations (CR6-CR15)
- `efficiency` - Packing metrics (bits used, registers saved)

## Example

See [Package Contract](../../.claude/shared/package_contract.md#example-manifestjson) for complete example.

## Usage by Context

- **forge-context** - Generates manifest.json during package creation
- **deployment-context** - Reads manifest for hardware deployment
- **docgen-context** - Reads manifest to auto-generate docs/APIs
- **hardware-debug-context** - Reads manifest for FSM state mapping

## Schema Details

For complete JSON schema, validation rules, and field specifications, see:
[Package Contract Specification](../../.claude/shared/package_contract.md)
```

**Key:** Mostly links, minimal duplication.

---

### 5. vhdl_generation.md

**Purpose:** Document code generation pipeline

**Structure:**
```markdown
# VHDL Generation Pipeline

## Overview
YAML → Pydantic → Mapper → Templates → VHDL + JSON

## Pipeline Stages

### 1. YAML Parsing
Load and parse YAML using PyYAML

### 2. Pydantic Validation
BasicAppsRegPackage model validates:
- Field types
- Type names (against TYPE_REGISTRY)
- Default values in range
- Platform valid

### 3. Register Mapping
BADRegisterMapper runs selected strategy:
- type_clustering (default)
- first_fit
- best_fit

Outputs: RegisterMappingResult with efficiency metrics

### 4. Template Rendering
Jinja2 templates:
- custom_inst_shim_template.vhd → <app>_shim.vhd
- custom_inst_main_template.vhd → <app>_main.vhd

### 5. Artifact Generation
- manifest.json (package contract)
- control_registers.json (register-centric view)

## VHDL File Structure

### Shim File
- Entity definition
- Port map (control registers → typed signals)
- Signal unpacking logic

### Main File
- Entity definition (matches shim outputs)
- Template for user logic
- TODO markers for implementation

## Platform-Specific Constants
Clock frequency injection for each platform

## Generated Artifacts
File structure, naming conventions

## Customizing Templates
For advanced users (where templates live, how to modify)
```

---

### 6. python_api.md

**Purpose:** Python API reference for advanced users

**Structure:**
```markdown
# Python API Reference

## Core Classes

### BasicAppsRegPackage
Pydantic model for YAML specs

**Fields:**
- app_name: str
- version: str
- description: str
- platform: Literal["moku_go", "moku_lab", "moku_pro", "moku_delta"]
- datatypes: List[DataTypeSpec]

**Methods:**
- from_yaml(path) → BasicAppsRegPackage
- to_yaml(path)
- to_manifest_json() → dict

### DataTypeSpec
Signal definition

**Fields:**
- name: str
- datatype: str
- description: str
- default_value: int | float
- units: Optional[str]
- display_name: Optional[str]
- min_value: Optional[float]
- max_value: Optional[float]

### BADRegisterMapper
Register packing engine

**Methods:**
- map_to_registers(datatypes, strategy) → RegisterMappingResult

**Strategies:**
- "first_fit"
- "best_fit"
- "type_clustering"

### TypeConverter
Physical ↔ raw conversion

**See:** [basic-app-datatypes documentation](../../libs/basic-app-datatypes/llms.txt) for details

## File I/O

### Loading YAML
```python
from forge.models.package import BasicAppsRegPackage
pkg = BasicAppsRegPackage.from_yaml('specs/my_instrument.yaml')
```

### Exporting Manifest
```python
manifest = pkg.to_manifest_json()
with open('output/manifest.json', 'w') as f:
    json.dump(manifest, f, indent=2)
```

## Integration with moku-models

### to_control_registers()
Convert forge mappings to moku-models ControlRegister format

[Example code]
```

**Note:** Can be partially auto-generated by docgen-context in future.

---

## Success Criteria

Before marking phase complete:

- [ ] All 6 reference docs created
- [ ] No duplication of submodule content (only links)
- [ ] All cross-references valid (test relative links)
- [ ] Code examples accurate
- [ ] ASCII diagrams clear
- [ ] All 25 types in quick reference table (type_system.md)
- [ ] Links to package_contract.md work (manifest_schema.md)

---

## Workflow

1. **Create each file** using Write tool
2. **Cross-reference** as you go (link to other docs)
3. **Use ASCII art** for visual examples
4. **Test links** manually (navigate in file browser)
5. **Commit when done:**
   ```bash
   git add docs/reference/
   git commit -m "docs: Complete Phase 6B - Technical reference documentation"
   ```
6. **Update PHASE6_PLAN.md** - Mark Phase B complete, add commit SHA

---

## Reference Files

**Essential context:**
- `docs/PHASE6_PLAN.md` - Detailed Phase B spec
- `docs/guides/getting_started.md` - Example usage (reference for clarity)
- `docs/guides/user_guide.md` - High-level concepts (link from reference)
- `libs/basic-app-datatypes/llms.txt` - Type system (link to this)
- `.claude/shared/package_contract.md` - Manifest schema (link to this)

**For code examples:**
- `forge/models/package.py` - Pydantic models
- `forge/mapper/bad_register_mapper.py` - Mapping engine
- `forge/generate_package.py` - Generation pipeline

---

**Ready to begin Phase B!**

Execute this phase, then update `docs/PHASE6_PLAN.md` with completion status.

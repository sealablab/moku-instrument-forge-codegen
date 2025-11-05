# Phase 6D: Architecture Documentation

**Phase:** D (Architecture)
**Status:** Ready to execute
**Prerequisite:** Phases A-C complete
**Deliverables:** 4 architecture documents

---

## Context

**Project:** moku-instrument-forge
**Working Directory:** `/Users/johnycsh/moku-instrument-forge`

**Completed:**
- ✅ Phase A: Essential guides
- ✅ Phase B: Technical reference
- ✅ Phase C: Examples (+ consistency fixes)

**See:** `docs/PHASE6_PLAN.md` for complete context

---

## Before You Start

**⚠️ CRITICAL: Validate these exist before documenting!**

```bash
# 1. Verify agent files exist
ls .claude/agents/*/agent.md
# Should list: forge-context, deployment-context, docgen-context,
#              hardware-debug-context, workflow-coordinator

# 2. Check package contract
cat .claude/shared/package_contract.md | head -20

# 3. List available templates
ls forge/templates/

# 4. Verify codegen API
python -c "from forge.generator.codegen import load_yaml_spec, create_register_package; print('✅ API verified')"

# 5. Check basic-app-datatypes
python -c "from basic_app_datatypes import RegisterMapper; print('✅ Mapper available')"
```

**If any checks fail, STOP and investigate before writing docs!**

---

## Your Task

Create 4 architecture documents explaining system design.

### Files to Create

1. **`docs/architecture/overview.md`** (~350 lines)
   - Data flow diagram (YAML → Package → Deployment)
   - Component architecture (forge, libs, platform)
   - Agent system overview (link to agent_system.md)
   - Package contract (link to package_contract.md)
   - Submodule delegation (link to submodule_integration.md)

2. **`docs/architecture/code_generation.md`** (~400 lines)
   - Pipeline stages (YAML → Pydantic → Mapper → Templates → Files)
   - Pydantic validation
   - Register mapping (3 strategies)
   - Jinja2 template rendering
   - VHDL generation
   - Manifest generation

3. **`docs/architecture/agent_system.md`** (~400 lines)
   - 5 agents: forge-context, deployment-context, docgen-context, hardware-debug-context, workflow-coordinator
   - Agent boundaries (who does what)
   - Workflow examples
   - Reference `.claude/agents/*/agent.md` for details

4. **`docs/architecture/design_decisions.md`** (~350 lines)
   - Why YAML? (declarative, version control)
   - Why Pydantic? (validation, type safety)
   - Why automatic packing? (50-75% savings)
   - Why submodules? (reusability)
   - Why 5 agents? (separation of concerns)
   - Why manifest.json? (source of truth)
   - Trade-offs and alternatives

---

## Detailed Specifications

### 1. overview.md

**Purpose:** High-level system architecture

**Key sections:**
- Data flow (ASCII diagram showing YAML → manifest.json → deployment)
- Component layers (forge toolchain, submodules, platform)
- Agent system (5 agents, boundaries)
- Package contract (manifest.json as source of truth)
- Type system integration (link to basic-app-datatypes)

**ASCII Diagram Style:**
- Use simple ASCII: `+-|` or box-drawing: `┌─┐│└┘├┤┬┴┼`
- Keep under 80 characters wide
- Add legend if needed
- Example format:

```
User YAML Spec
      │
      ▼
┌─────────────────┐
│  forge-context  │ ──► manifest.json (package contract)
└─────────────────┘     │
      │                 ├──► deployment-context ──► Moku Device
      │                 ├──► docgen-context ──► Docs/APIs
      ├─ VHDL files     └──► hardware-debug-context ──► FSM Debug
      └─ control_registers.json
```

**Cross-references to verify:**
- Link to `.claude/shared/package_contract.md` (exists)
- Link to `docs/architecture/submodule_integration.md` (exists from Phase A)
- Link to `docs/architecture/agent_system.md` (will create in this phase)
- Link to `libs/basic-app-datatypes/llms.txt` (exists)

---

### 2. code_generation.md

**Purpose:** Generator pipeline internals

**Pipeline stages:**
1. **YAML Loading** - PyYAML safe_load
2. **Pydantic Validation** - BasicAppsRegPackage model
3. **Register Mapping** - RegisterMapper with 3 strategies
4. **Template Rendering** - Jinja2 templates
5. **File Output** - manifest.json, VHDL, control_registers.json

**⚠️ Use ACTUAL API (verified from forge/generator/codegen.py):**

```python
# Step 1: Load YAML
from forge.generator.codegen import load_yaml_spec
spec = load_yaml_spec('spec.yaml')

# Step 2: Create Pydantic package
from forge.generator.codegen import create_register_package
package = create_register_package(spec)
# Returns: BasicAppsRegPackage with validated datatypes

# Step 3: Register mapping (using core RegisterMapper)
from basic_app_datatypes import RegisterMapper
mapper = RegisterMapper()
items = [(dt.name, dt.datatype) for dt in package.datatypes]
mappings = mapper.map(items, strategy=package.mapping_strategy)
# Returns: List[RegisterMapping] with CR assignments

# Step 4: Prepare template context
from forge.generator.codegen import prepare_template_context, PLATFORM_MAP
platform_info = PLATFORM_MAP[spec['platform']]
context = prepare_template_context(package, yaml_path, platform_info)
# Returns: dict with signals, register_mappings, efficiency, etc.

# Step 5: Render templates
from jinja2 import Environment, FileSystemLoader
jinja_env = Environment(loader=FileSystemLoader('forge/templates/'))
shim_template = jinja_env.get_template('shim.vhd.j2')  # ← Actual filename
main_template = jinja_env.get_template('main.vhd.j2')  # ← Actual filename
shim_vhdl = shim_template.render(context)
main_vhdl = main_template.render(context)
```

**⚠️ Type Name Reminder (from Phase 6C fixes):**

When showing YAML examples in this doc, use CORRECT type names:
- ✅ `boolean` (NOT `boolean_1`)
- ✅ `pulse_duration_ms_u16` (NOT `time_milliseconds_u16`)
- ✅ `pulse_duration_ns_u8` (NOT `time_cycles_u8`)
- ✅ `default_value: false` for booleans (NOT `0`)

**Template files to reference:**
- `forge/templates/shim.vhd.j2` - Shim entity template
- `forge/templates/main.vhd.j2` - Main logic template
- Verify these exist: `ls forge/templates/*.j2`

**Mapping strategies to explain:**
1. `first_fit` - Naive sequential allocation
2. `best_fit` - Pack largest signals first
3. `type_clustering` - Group by type category (default)

**See:**
- `forge/generator/codegen.py` - Implementation
- `libs/basic-app-datatypes/basic_app_datatypes/mapper.py` - Core algorithm
- `docs/reference/register_mapping.md` - User-facing strategy explanation

---

### 3. agent_system.md

**Purpose:** Document 5-agent architecture

**Verify these agent files exist:**
```bash
ls .claude/agents/forge-context/agent.md
ls .claude/agents/deployment-context/agent.md
ls .claude/agents/docgen-context/agent.md
ls .claude/agents/hardware-debug-context/agent.md
ls .claude/agents/workflow-coordinator/agent.md
```

**For each agent, document:**

#### Template per agent:

```markdown
### <Agent Name>

**Domain:** [What it handles]
**Inputs:** [What it consumes]
**Outputs:** [What it produces]
**Commands:** [Available workflows]

**Scope Boundaries:**
✅ **Does:**
- Responsibility 1
- Responsibility 2

❌ **Does NOT:**
- Out-of-scope task 1
- Out-of-scope task 2

**See:** [.claude/agents/<agent-name>/agent.md](../../.claude/agents/<agent-name>/agent.md)
```

**Agents to document:**

1. **forge-context**
   - Domain: YAML → Well-formed package
   - Inputs: YAML specification
   - Outputs: manifest.json, VHDL files, control_registers.json
   - Commands: `/validate`, `/generate`, `/map-registers`

2. **deployment-context**
   - Domain: Package → Hardware deployment
   - Inputs: manifest.json, control_registers.json
   - Outputs: Deployed bitstream on Moku device
   - Commands: `/discover`, `/deploy`, `/initialize-registers`

3. **docgen-context**
   - Domain: Package → Documentation/APIs
   - Inputs: manifest.json
   - Outputs: Markdown docs, TUI apps, Python API classes
   - Commands: `/gen-docs`, `/gen-ui`, `/gen-python-api`

4. **hardware-debug-context**
   - Domain: FSM debugging, hardware validation
   - Inputs: manifest.json, deployed instrument
   - Outputs: FSM state traces, oscilloscope analysis
   - Commands: `/debug-fsm`, `/monitor-state`

5. **workflow-coordinator**
   - Domain: End-to-end workflow orchestration
   - Inputs: User intent, multiple context outputs
   - Outputs: Orchestrated workflow results
   - Commands: `/workflow new-probe`, `/workflow iterate`, `/workflow debug`

**Workflow Examples:**

Show concrete examples using `/workflow` commands:

```markdown
#### Workflow: New Probe Development

**Command:** `/workflow new-probe spec.yaml`

**Pipeline:**
1. forge-context: Validate YAML → Generate package
2. deployment-context: Discover device → Deploy bitstream
3. docgen-context: Generate docs
4. hardware-debug-context: Monitor FSM state

**Output:** Deployed instrument + documentation
```

**Agent Interaction Diagram:**

```
User
  │
  └─► workflow-coordinator
        │
        ├─► forge-context ──────► manifest.json
        │                         │
        ├─► deployment-context ◄──┤
        │                         │
        ├─► docgen-context ◄──────┤
        │                         │
        └─► hardware-debug-context ◄┘
```

---

### 4. design_decisions.md

**Purpose:** Explain architectural choices

**Format for each decision:**

```markdown
## Decision: <What We Chose>

**Choice:** [The decision made]

**Rationale:**
- Reason 1
- Reason 2

**Alternatives Considered:**
- Alternative A: [Why not chosen]
- Alternative B: [Why not chosen]

**Trade-offs:**
✅ **Pros:**
- Benefit 1
- Benefit 2

❌ **Cons:**
- Limitation 1
- Limitation 2

**Outcome:** [Result of this decision]
```

**Decisions to document:**

1. **YAML over JSON/TOML/Python DSL**
   - Rationale: Human-readable, version control friendly, declarative
   - Alternatives: JSON (verbose), TOML (limited nesting), Python (too flexible)
   - Trade-off: YAML syntax quirks vs readability

2. **Pydantic for validation**
   - Rationale: Type safety, automatic validation, JSON export
   - Alternatives: Manual dict validation, dataclasses
   - Trade-off: Dependency weight vs safety guarantees

3. **Automatic register packing**
   - Rationale: 50-75% register savings, eliminates manual bit-slicing errors
   - Alternatives: Manual bit assignment, one-per-register
   - Trade-off: Less control vs efficiency + safety

4. **Git submodules over monorepo**
   - Rationale: Reusability (basic-app-datatypes used in multiple projects)
   - Alternatives: Vendoring (copy code), monorepo (tight coupling)
   - Trade-off: Submodule complexity vs single source of truth

5. **5 specialized agents over monolithic tool**
   - Rationale: Separation of concerns, parallel workflows, focused expertise
   - Alternatives: Single agent (all-in-one), manual commands
   - Trade-off: Coordination overhead vs modularity

6. **manifest.json as source of truth**
   - Rationale: Downstream consumers don't parse YAML, versioned contract
   - Alternatives: Re-parse YAML, embed in VHDL comments
   - Trade-off: Redundancy vs decoupling

7. **Type system (BasicAppDataTypes) over raw integers**
   - Rationale: Unit conversion, platform-agnostic, user-friendly
   - Alternatives: Raw bits/cycles, platform-specific types
   - Trade-off: Abstraction overhead vs safety + portability

**Include real examples:**
- Show DS1140_PD: 8 signals → 3 registers (57% savings)
- Show minimal_probe: 3 signals → 2 registers (52% efficiency)
- Show multi_channel: 6 signals → 2 registers (90.6% efficiency)

---

## Success Criteria

**Before marking complete:**

- [ ] All 4 architecture docs created
- [ ] ASCII diagrams clear and accurate
- [ ] Design rationale explained with examples
- [ ] Agent boundaries defined (all 5 agents)
- [ ] All cross-references valid
- [ ] **Code examples use ACTUAL API** (not invented methods)
- [ ] **Type names correct** (boolean not boolean_1)
- [ ] **Template filenames match** forge/templates/*.j2
- [ ] **Agent references match** .claude/agents/*/agent.md
- [ ] No invented features (everything documented exists)

**Cross-reference checklist:**

Run these checks before committing:

```bash
# 1. Verify all agent links work
for agent in forge deployment docgen hardware-debug workflow-coordinator; do
  test -f .claude/agents/$agent-context/agent.md && echo "✅ $agent" || echo "❌ $agent"
done

# 2. Verify template references
for tpl in shim.vhd.j2 main.vhd.j2; do
  test -f forge/templates/$tpl && echo "✅ $tpl" || echo "❌ $tpl"
done

# 3. Check package contract
test -f .claude/shared/package_contract.md && echo "✅ package_contract.md" || echo "❌ Missing"

# 4. Verify API imports work
python -c "from forge.generator.codegen import load_yaml_spec, create_register_package, prepare_template_context; from basic_app_datatypes import RegisterMapper; print('✅ All imports work')"
```

---

## Workflow

1. **Run validation checks** (see "Before You Start")
2. Create `overview.md` (establishes context for others)
3. Create `code_generation.md` (pipeline details with actual API)
4. Create `agent_system.md` (agent boundaries, reference .claude/agents/*/agent.md)
5. Create `design_decisions.md` (rationale with real examples)
6. **Run cross-reference checks** (see Success Criteria)
7. Commit:
   ```bash
   git add docs/architecture/
   git commit -m "docs: Complete Phase 6D - Architecture documentation"
   ```
8. Update `PHASE6_PLAN.md` (mark Phase D complete)

---

## Common Pitfalls to Avoid (Lessons from Phase 6C)

❌ **DON'T:**
- Use invented API methods (`map_to_registers()` doesn't exist!)
- Use wrong type names (`boolean_1` should be `boolean`)
- Reference files that don't exist (verify first!)
- Copy code without testing imports

✅ **DO:**
- Verify every code snippet can actually run
- Check that linked files exist
- Use correct type names from Phase 6C
- Reference actual template filenames from `forge/templates/`
- Link to existing agent files in `.claude/agents/`

---

**Ready to begin Phase D!**

**Estimated time:** 2-3 hours (4 files × ~400 lines each)

**Context usage:** ~15-20k tokens per file = 60-80k total (well within 200k limit)

---

**Last updated:** 2025-11-03 (after Phase 6C completion + consistency fixes)

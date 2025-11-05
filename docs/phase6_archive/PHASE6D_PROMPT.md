# Phase 6D: Architecture Documentation

**Phase:** D (Architecture)
**Status:** Ready to execute
**Prerequisite:** Phases A-C complete
**Deliverables:** 4 architecture documents

---

## Context

**Project:** moku-instrument-forge
**Working Directory:** `/Users/johnycsh/moku-instrument-forge`

**See:** `docs/PHASE6_PLAN.md` for complete context

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

**Include ASCII diagrams:**
```
User
  │
  ├─ YAML Spec ────────────────┐
  │                             │
  ▼                             ▼
forge-context              deployment-context
  │                             │
  ├─ manifest.json ─────────────┤
  ├─ VHDL files                 │
  │                             ▼
  │                         Moku Device
  │
  ├─ docgen-context ───► Docs/APIs
  └─ hardware-debug-context ───► FSM debugging
```

---

### 2. code_generation.md

**Purpose:** Generator pipeline internals

**Pipeline stages:**
1. YAML Loading (PyYAML)
2. Pydantic Validation (BasicAppsRegPackage)
3. Register Mapping (BADRegisterMapper, 3 strategies)
4. Template Rendering (Jinja2)
5. File Output (manifest.json, VHDL, control_registers.json)

**Include code snippets:**
```python
# Example validation
pkg = BasicAppsRegPackage.from_yaml('spec.yaml')

# Example mapping
mapper = BADRegisterMapper()
result = mapper.map_to_registers(pkg.datatypes, strategy='type_clustering')

# Example template rendering
template = jinja_env.get_template('shim_template.vhd')
vhdl = template.render(package=pkg, mappings=result)
```

---

### 3. agent_system.md

**Purpose:** Document 5-agent architecture

**For each agent:**
- **Scope:** What it handles
- **Inputs:** What it consumes
- **Outputs:** What it produces
- **Commands:** Available workflows
- **Boundaries:** What it does NOT do

**Agents:**
1. **forge-context** - YAML → package generation
2. **deployment-context** - Package → hardware deployment
3. **docgen-context** - Package → docs/APIs
4. **hardware-debug-context** - FSM debugging
5. **workflow-coordinator** - End-to-end workflows

**Workflow examples:**
- `/workflow new-probe` - Full pipeline
- `/workflow iterate` - Fast regeneration
- `/workflow debug` - Deploy + monitor

---

### 4. design_decisions.md

**Purpose:** Explain architectural choices

**For each decision:**
- **Decision:** What we chose
- **Rationale:** Why we chose it
- **Alternatives:** What we didn't choose
- **Trade-offs:** Pros/cons

**Topics:**
- YAML over JSON/TOML
- Pydantic over dict validation
- Automatic packing over manual
- Submodules over monorepo
- 5 agents over monolithic tool
- manifest.json over YAML re-parsing
- Type system over raw integers

---

## Success Criteria

- [ ] All 4 architecture docs created
- [ ] ASCII diagrams clear and accurate
- [ ] Design rationale explained
- [ ] Agent boundaries defined
- [ ] All cross-references valid

---

## Workflow

1. Create overview.md (establishes context for others)
2. Create code_generation.md (pipeline details)
3. Create agent_system.md (agent boundaries)
4. Create design_decisions.md (rationale)
5. Commit:
   ```bash
   git add docs/architecture/
   git commit -m "docs: Complete Phase 6D - Architecture documentation"
   ```
6. Update PHASE6_PLAN.md

---

**Ready to begin Phase D!**

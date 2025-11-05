# DS1150 Example Migration Prompt

**Purpose:** Implement DS1150 EMFI probe from scratch to validate and refine the agent system

**Context:** Fresh session, token-efficient bootstrap

---

## Quick Context

You're working in **moku-instrument-forge**, a YAML→VHDL code generation pipeline with a hub-and-spoke agent architecture:

- **5 agents:** workflow-coordinator, forge-context, deployment-context, docgen-context, hardware-debug-context
- **Package contract:** YAML → manifest.json + control_registers.json + VHDL
- **Complete infrastructure:** Agents defined, slash commands ready, llms.txt comprehensive

**See:** `llms.txt` for full project overview (read this first!)

---

## Your Mission

Implement **DS1150** EMFI probe using the new agent system, working out kinks as you go.

**Base reference:** `apps/DS1140_PD/` (existing example, but don't just copy!)

**Key differences DS1140 → DS1150:**
- 3 outputs → 4 outputs (add pulse width control)
- Add frequency sweep capability
- Add burst mode (multiple pulses)
- Enhanced safety features

---

## Step-by-Step Process

### 1. Gather Requirements from User

**Ask the user:**

```
I'm implementing DS1150 EMFI probe to validate our agent system.

Before I start, I need to understand the requirements:

1. **Baseline:** Should I reference DS1140_PD specs, or do you have
   separate DS1150 requirements?

2. **Feature priorities:** Which new features matter most?
   - [ ] 4th output (pulse width control)
   - [ ] Frequency sweep
   - [ ] Burst mode
   - [ ] Enhanced safety
   - [ ] Other: ___________

3. **Testing approach:** Should I:
   - [ ] Generate YAML + validate only (no hardware)
   - [ ] Full workflow including deployment
   - [ ] Focus on documentation generation
   - [ ] Test FSM debugging features

4. **Agent system validation:** Which agents should I stress-test?
   - [ ] forge-context (generation pipeline)
   - [ ] deployment-context (hardware deployment)
   - [ ] docgen-context (TUI/API generation)
   - [ ] hardware-debug-context (FSM monitoring)
   - [ ] workflow-coordinator (end-to-end workflows)

5. **Known issues from DS1140:** Any gotchas I should avoid?
```

---

### 2. Create DS1150 YAML Spec

**Location:** `apps/DS1150/DS1150.yaml`

**Use forge-context to:**
- Validate datatypes against BasicAppDataTypes enum
- Optimize register packing
- Generate manifest.json

**Test commands:**
```bash
/validate apps/DS1150/DS1150.yaml
/map-registers apps/DS1150/DS1150.yaml
/optimize apps/DS1150/DS1150.yaml
/generate apps/DS1150/DS1150.yaml
```

**Document any issues:**
- Are error messages clear?
- Does validation catch mistakes?
- Is register packing efficient?

---

### 3. Generate Package & Documentation

**Use workflow-coordinator:**
```bash
/workflow new-probe apps/DS1150/DS1150.yaml
```

**OR manual steps:**
```bash
/generate apps/DS1150/DS1150.yaml
/gen-docs DS1150
/gen-ui DS1150
/gen-python-api DS1150
```

**Validate outputs:**
- Does manifest.json match schema?
- Are VHDL files well-formed?
- Is generated documentation useful?
- Does TUI have proper controls?

---

### 4. Test Deployment (Optional, if hardware available)

```bash
/discover
/deploy DS1150 --device <ip>
/debug-fsm DS1150 --device <ip>
```

**Document any issues:**
- Does deployment work smoothly?
- Are error messages helpful?
- Does FSM debugging decode states correctly?

---

### 5. Iterate & Refine

**As you encounter issues:**

1. **Agent confusion?** → Update agent.md prompts
2. **Missing commands?** → Add to .claude/commands/
3. **Unclear workflows?** → Enhance workflow templates
4. **Documentation gaps?** → Update llms.txt or docs/

**Keep notes:** Create `DS1150_MIGRATION_NOTES.md` tracking:
- What worked well
- What broke
- Agent improvements needed
- Documentation clarifications

---

## Success Criteria

✅ **DS1150 YAML spec** - Valid, well-structured
✅ **Package generated** - manifest.json + VHDL + docs
✅ **Agent system validated** - All agents work as expected
✅ **Issues documented** - Clear list of improvements needed
✅ **User feedback incorporated** - Address questions from Step 1

---

## Efficiency Tips (Context Management)

1. **Read llms.txt first** - Comprehensive overview (862 lines)
2. **Reference agents only when needed** - Don't load all 5 at once
3. **Use package contract** - manifest.json schema is in .claude/shared/
4. **Check DS1140 example** - `apps/DS1140_PD/DS1140_PD.yaml` for patterns
5. **Commit incrementally** - After each major step

---

## Expected Kinks to Work Out

**Likely issues:**
- Agent prompts too verbose or unclear
- Missing error handling in workflows
- Documentation generation edge cases
- Register packing optimization bugs
- FSM debugging voltage scale mismatches

**How to handle:**
- Document in DS1150_MIGRATION_NOTES.md
- Fix immediately if blocking
- Create TODO items for non-blocking issues
- Update agent.md files with learnings

---

## Deliverables

At the end, you should have:

1. **Working DS1150 package** - `apps/DS1150/`
   - DS1150.yaml (spec)
   - manifest.json (metadata)
   - control_registers.json (initial values)
   - VHDL files (generated)
   - docs/ (generated)
   - ui/ (generated TUI)
   - python/ (generated API)

2. **Migration notes** - `DS1150_MIGRATION_NOTES.md`
   - What worked
   - What broke
   - Agent improvements needed
   - Recommendations for Phase 2

3. **Updated infrastructure** (if needed)
   - Enhanced agent prompts
   - New slash commands
   - Documentation clarifications
   - Bug fixes

4. **Commit with lessons learned**

---

## Questions to Answer

**For the user at the end:**

1. How intuitive was the workflow?
2. Which agent needs the most improvement?
3. What documentation was missing?
4. Would you use this system for future probes?
5. What should Phase 2 focus on?

---

## Start Here

```
Hi! I'm implementing DS1150 to validate our agent system.

[Ask Step 1 questions above]

Once I have your input, I'll:
1. Create DS1150.yaml spec
2. Run /workflow new-probe
3. Document issues and iterate
4. Summarize learnings

Let's work out the kinks together!
```

---

**Token budget:** Optimize for efficiency
- Read llms.txt (~860 tokens)
- Load 1-2 agents at a time (~2-3k tokens each)
- Reference package contract as needed (~1k tokens)
- DS1140 example for patterns (~500 tokens)

**Total estimated:** ~10-15k tokens for full migration (well within limits)

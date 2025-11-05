# HUMAN_START_HERE_plan.md

🚀 **Welcome to moku-instrument-forge!**

This guide walks you through creating a complete custom Moku instrument from scratch using the agent-assisted workflow. We'll recreate the **DS1140_PD** EMFI probe controller to demonstrate the full capabilities of the system.

**Time estimate:** 30-45 minutes (including reading and understanding)

---

## What You'll Build

**DS1140_PD** - An electromagnetic fault injection (EMFI) probe controller for the Riscure DS1120A probe:

- **8 control signals** (arm, fire, reset, timeouts, voltages)
- **Automatic register packing** (3 registers instead of 8)
- **Type-safe voltage/time conversions**
- **Wiring validation** against Riscure probe specs
- **Complete deployment package** (VHDL, manifest, documentation)

---

## Prerequisites

### Required
- Python 3.10+
- `uv` package manager ([install](https://github.com/astral-sh/uv))
- Git (for submodule management)
- Basic understanding of FPGA/VHDL concepts

### Hardware (Optional for full deployment)
- Moku:Go device
- Riscure DS1120A probe
- USB-C cable

### Installation

```bash
# Clone the repo with submodules
git clone --recursive https://github.com/sealablab/moku-instrument-forge.git
cd moku-instrument-forge

# Install dependencies
uv pip install -e .
uv pip install -e libs/basic-app-datatypes/
uv pip install -e libs/moku-models/
uv pip install -e libs/riscure-models/

# Verify installation
python -c "from forge.models import BasicAppsRegPackage; print('✓ Forge installed')"
python -c "from moku_models import MOKU_GO_PLATFORM; print('✓ moku-models installed')"
python -c "from riscure_models import DS1120A_PLATFORM; print('✓ riscure-models installed')"
```

---

## The Agent-Assisted Workflow

moku-instrument-forge uses a **hub-and-spoke agent architecture** where specialized agents handle different aspects of development:

```
      ┌──────────────────────────┐
      │ workflow-coordinator     │  ← You start here!
      │ (Orchestrator)           │
      └─────────┬────────────────┘
                │
    ┌───────────┼───────────┬─────────────┐
    ▼           ▼           ▼             ▼
┌─────────┐ ┌────────┐ ┌──────────┐ ┌──────────┐
│ forge   │ │ deploy │ │  docgen  │ │  debug   │
│ context │ │ context│ │ context  │ │ context  │
└─────────┘ └────────┘ └──────────┘ └──────────┘
```

**Key agents:**
- **workflow-coordinator**: Orchestrates multi-stage workflows
- **forge-context**: YAML → VHDL package generation
- **deployment-context**: Package → Hardware deployment
- **docgen-context**: Package → Documentation/UI/APIs
- **hardware-debug-context**: FSM debugging and troubleshooting

---

## Step 1: Design Your Instrument Specification

Create a new directory for your instrument:

```bash
mkdir -p apps/MY_EMFI_PROBE/spec
cd apps/MY_EMFI_PROBE/spec
```

Create `MY_EMFI_PROBE.yaml`:

```yaml
app_name: MY_EMFI_PROBE
version: 1.0.0
platform: moku_go
description: My custom EMFI probe controller

# Define your control signals using BasicAppDataTypes
datatypes:
  # Boolean controls (1-bit each)
  - name: arm_probe
    datatype: boolean_1
    default_value: 0
    description: Arm the probe for trigger

  - name: force_fire
    datatype: boolean_1
    default_value: 0
    description: Manual fire for testing

  - name: reset_fsm
    datatype: boolean_1
    default_value: 0
    description: Reset state machine

  # Time controls (8-bit unsigned)
  - name: firing_duration
    datatype: time_cycles_u8
    default_value: 16
    description: Pulse duration in clock cycles

  - name: cooling_duration
    datatype: time_cycles_u8
    default_value: 16
    description: Cooling time between pulses

  # Time control (16-bit unsigned)
  - name: arm_timeout
    datatype: time_milliseconds_u16
    default_value: 255
    description: Timeout for trigger detection

  # Voltage controls (16-bit signed, ±5V)
  - name: trigger_threshold
    datatype: voltage_signed_s16
    default_value: 15823  # ~2.4V
    description: Voltage threshold for trigger

  - name: intensity
    datatype: voltage_output_05v_s16
    default_value: 9830  # ~1.5V safe default
    description: Output pulse intensity
```

**What just happened?**
- Defined 8 control signals using type-safe datatypes
- No manual register allocation needed!
- Voltage/time values in human-friendly units

**Available types:** See `libs/basic-app-datatypes/basic_app_datatypes/types.py` for all 25 types.

---

## Step 2: Generate VHDL Package Using Agents

Now let's use the **workflow-coordinator** agent to orchestrate the generation:

### Option A: Full Workflow (Recommended)

```bash
# From repo root
/workflow new-probe apps/MY_EMFI_PROBE/spec/MY_EMFI_PROBE.yaml
```

The workflow-coordinator will:
1. Validate your YAML specification
2. Call forge-context to generate VHDL
3. Show register mapping efficiency
4. Create deployment package
5. Optionally validate wiring against Riscure probe specs

### Option B: Manual Step-by-Step

If you want to see each step individually:

#### 2.1: Validate YAML

```bash
/validate apps/MY_EMFI_PROBE/spec/MY_EMFI_PROBE.yaml
```

This checks:
- YAML syntax correctness
- DataType validity (all types exist in BasicAppDataTypes)
- Default value ranges
- Platform compatibility

#### 2.2: Preview Register Mapping

```bash
/map-registers apps/MY_EMFI_PROBE/spec/MY_EMFI_PROBE.yaml
```

**Expected output:**
```
Register Mapping (first_fit strategy):
  CR6[31:16]: arm_timeout (16-bit)
  CR6[15:0]:  intensity (16-bit)
  CR7[31:16]: trigger_threshold (16-bit)
  CR7[15:8]:  cooling_duration (8-bit)
  CR7[7:0]:   firing_duration (8-bit)
  CR8[31]:    arm_probe (1-bit)
  CR8[30]:    force_fire (1-bit)
  CR8[29]:    reset_fsm (1-bit)

Efficiency: 67/96 bits used (69.8%)
Registers saved: 5 (3 registers vs 8 manual allocation)
```

**Amazing, right?** The forge automatically packed 8 signals into just 3 registers!

#### 2.3: Generate VHDL

```bash
/generate apps/MY_EMFI_PROBE/spec/MY_EMFI_PROBE.yaml
```

This creates:
```
apps/MY_EMFI_PROBE/
├── spec/
│   └── MY_EMFI_PROBE.yaml
└── generated/
    ├── manifest.json                      # Complete metadata
    ├── control_registers.json             # Initial CR values
    ├── MY_EMFI_PROBE_custom_inst_shim.vhd # Generated VHDL shim
    └── MY_EMFI_PROBE_custom_inst_main.vhd # VHDL template (edit this!)
```

---

## Step 3: Understand the Generated Files

### manifest.json

The **package contract** - complete metadata for all downstream consumers:

```json
{
  "app_name": "MY_EMFI_PROBE",
  "version": "1.0.0",
  "platform": "moku_go",
  "datatypes": [ ... ],
  "register_mapping": {
    "CR6": {
      "fields": [
        {"name": "arm_timeout", "bits": "31:16", "type": "time_milliseconds_u16"},
        {"name": "intensity", "bits": "15:0", "type": "voltage_output_05v_s16"}
      ]
    },
    ...
  },
  "efficiency": {
    "bits_used": 67,
    "bits_available": 96,
    "efficiency_percent": 69.8,
    "registers_saved": 5
  }
}
```

### control_registers.json

Initial control register values:

```json
{
  "CR6": "0x00FF2666",  // arm_timeout=255ms, intensity=1.5V
  "CR7": "0x3DCF1010",  // threshold=2.4V, cooling=16, firing=16
  "CR8": "0x00000000"   // All controls inactive
}
```

### MY_EMFI_PROBE_custom_inst_shim.vhd

**Auto-generated VHDL** that unpacks control registers into type-safe signals:

```vhdl
-- AUTOGENERATED by moku-instrument-forge
-- DO NOT EDIT THIS FILE

signal arm_probe          : std_logic;
signal force_fire         : std_logic;
signal reset_fsm          : std_logic;
signal firing_duration    : std_logic_vector(7 downto 0);
signal cooling_duration   : std_logic_vector(7 downto 0);
signal arm_timeout        : std_logic_vector(15 downto 0);
signal trigger_threshold  : std_logic_vector(15 downto 0);
signal intensity          : std_logic_vector(15 downto 0);

-- Register unpacking
arm_probe         <= app_reg_8(31);
force_fire        <= app_reg_8(30);
reset_fsm         <= app_reg_8(29);
arm_timeout       <= app_reg_6(31 downto 16);
intensity         <= app_reg_6(15 downto 0);
trigger_threshold <= app_reg_7(31 downto 16);
cooling_duration  <= app_reg_7(15 downto 8);
firing_duration   <= app_reg_7(7 downto 0);
```

### MY_EMFI_PROBE_custom_inst_main.vhd

**Template for you to implement** - contains placeholders and examples:

```vhdl
-- TODO: Implement your FSM here
-- Available signals:
--   arm_probe, force_fire, reset_fsm (from shim)
--   firing_duration, cooling_duration, arm_timeout
--   trigger_threshold, intensity

-- Example FSM states:
type state_type is (READY, ARMED, FIRING, COOLING);
signal state : state_type := READY;

-- Your implementation goes here!
```

---

## Step 4: Validate Wiring Against Probe Specs

Before connecting hardware, validate your wiring against the Riscure DS1120A specification:

```bash
# Use deployment-context agent to validate wiring
# (This demonstrates riscure-models integration)
```

**Manual validation** (until automation is complete):

```python
from moku_models import MOKU_GO_PLATFORM
from riscure_models import DS1120A_PLATFORM

# Get platform specs
moku = MOKU_GO_PLATFORM
probe = DS1120A_PLATFORM

# Check trigger output voltage compatibility
moku_out = moku.get_analog_output_by_id('OUT1')
probe_trigger = probe.get_port_by_id('digital_glitch')

print(f"Moku OUT1: {moku_out.voltage_range_vpp}Vpp")
print(f"Probe trigger: {probe_trigger.get_voltage_range_str()}")

# Validate 3.3V TTL compatibility
if probe_trigger.is_voltage_compatible(3.3):
    print("✓ Safe to connect Moku OUT1 (TTL) → DS1120A digital_glitch")
```

**Typical wiring:**
```
Moku:Go                    DS1120A Probe
────────                   ─────────────
OUT1 (TTL 3.3V)     →      digital_glitch (trigger input)
OUT2 (Analog 0-3.3V) →     pulse_amplitude (power control)
IN1 (AC, 50Ω)        ←     coil_current (monitor output)

External 24V PSU     →     power_24vdc
```

---

## Step 5: Implement Your Application Logic

Edit `MY_EMFI_PROBE_custom_inst_main.vhd` to implement your FSM:

```vhdl
-- State machine for EMFI probe control
type state_type is (READY, ARMED, FIRING, COOLING);
signal state : state_type := READY;

process(clk)
begin
  if rising_edge(clk) then
    if reset_fsm = '1' then
      state <= READY;
    else
      case state is
        when READY =>
          if arm_probe = '1' then
            state <= ARMED;
          end if;

        when ARMED =>
          if force_fire = '1' or (trigger_detected = '1') then
            state <= FIRING;
          elsif timeout_expired = '1' then
            state <= READY;
          end if;

        when FIRING =>
          if firing_counter >= firing_duration then
            state <= COOLING;
          end if;

        when COOLING =>
          if cooling_counter >= cooling_duration then
            state <= READY;
          end if;
      end case;
    end if;
  end if;
end process;
```

**Tip:** See `apps/DS1140_PD/generated/` for a complete reference implementation.

---

## Step 6: Generate Documentation

Use the **docgen-context** agent to create user documentation:

```bash
/gen-docs apps/MY_EMFI_PROBE/
```

This creates:
- `README.md` - User guide with register maps
- `WIRING.md` - Wiring diagrams and voltage safety notes
- `API.md` - Python API reference
- (Future) TUI app for manual control

---

## Step 7: Deploy to Hardware (Optional)

If you have a Moku:Go device:

### 7.1: Discover Moku Device

```bash
/discover
```

**Expected output:**
```
Found Moku devices:
  • MokuGo_B106 @ 192.168.73.1
```

### 7.2: Deploy Package

```bash
/deploy MY_EMFI_PROBE --device 192.168.73.1
```

The deployment-context agent will:
1. Connect to Moku device
2. Upload VHDL bitstream
3. Initialize control registers from `control_registers.json`
4. Validate deployment
5. Show connection instructions

### 7.3: Test FSM Behavior

```bash
# Use debug-context agent to monitor FSM
/debug-fsm MY_EMFI_PROBE --device 192.168.73.1
```

This shows real-time FSM state using the voltage-encoded debugging pattern.

---

## Understanding the Agent System

### Agent Invocation

**Slash commands** invoke agents:

```bash
/workflow new-probe SPEC.yaml    # workflow-coordinator
/generate SPEC.yaml              # forge-context
/deploy APP --device IP          # deployment-context
/gen-docs APP                    # docgen-context
/debug-fsm APP --device IP       # hardware-debug-context
```

### Agent Context Isolation

Agents use **shared knowledge** files to avoid context duplication:

```
.claude/shared/
├── package_contract.md          # manifest.json/control_registers.json schemas
├── riscure_probe_integration.md # Probe integration patterns
└── SERENA_MIGRATION_ASSESSMENT.md
```

**Why this matters:** Each agent only loads the context it needs, preventing token overflow.

### Documentation Delegation Hierarchy

Information is layered to prevent overload:

```
Level 1: llms.txt (discovery)
    ↓
Level 2: .claude/shared/*.md (integration context)
    ↓
Level 3: libs/*/llms.txt (complete reference)
    ↓
Level 4: libs/*/CLAUDE.md (development context)
    ↓
Level 5: Source code (implementation)
```

**Example query flow:**
1. Agent reads `llms.txt` → discovers `riscure-models exists`
2. Reads `.claude/shared/riscure_probe_integration.md` → gets integration pattern
3. If needed, reads `libs/riscure-models/llms.txt` → gets complete specs
4. Stops when enough context gathered!

---

## Troubleshooting

### "Unknown datatype 'voltage_10v_s16'"
→ Check `libs/basic-app-datatypes/basic_app_datatypes/types.py` for valid types
→ Use `voltage_output_05v_s16` for ±5V range

### "default_value 40000 out of range for s16"
→ 16-bit signed range: -32768 to 32767
→ Use appropriate default or larger type

### "Cannot fit signals in 10 registers"
→ You have too many large signals
→ Try smaller types (u8 instead of u16) or reduce signal count

### "Package not found"
→ Run `/generate` first to create the package

### "FSM stuck in ARMED state"
→ Check trigger threshold value
→ Use `/debug-fsm` to monitor state transitions
→ Verify trigger input wiring

---

## Advanced Topics

### Custom Register Packing Strategies

```bash
# Try different packing strategies
/optimize apps/MY_EMFI_PROBE/spec/MY_EMFI_PROBE.yaml --strategy best_fit
/optimize apps/MY_EMFI_PROBE/spec/MY_EMFI_PROBE.yaml --strategy type_clustering
```

### Multi-Platform Deployment

```yaml
# In YAML spec
platform: moku_lab  # or moku_pro, moku_delta

# Forge automatically adapts to platform constraints:
# - Go: 2 slots, 125 MHz, 16 DIO
# - Lab: 2 slots, 500 MHz, no DIO
# - Pro: 4 slots, 1.25 GHz, no DIO
# - Delta: 3 slots, 5 GHz, 32 DIO
```

### CocotB Simulation

```bash
# Run behavioral model tests
pytest apps/MY_EMFI_PROBE/tests/ -v
```

---

## What You've Learned

✓ **YAML-driven development** - Specify instruments in human-friendly YAML
✓ **Automatic register packing** - 50-75% register savings
✓ **Type-safe conversions** - Voltage/time/boolean abstractions
✓ **Agent-assisted workflow** - Specialized agents for each task
✓ **Wiring validation** - Voltage safety before hardware connection
✓ **Complete deployment** - From YAML to running hardware

---

## Next Steps

1. **Explore examples:**
   - `apps/DS1140_PD/` - Complete EMFI probe reference
   - `libs/basic-app-datatypes/examples/` - Type usage patterns

2. **Read architecture docs:**
   - `llms.txt` - Quick reference
   - `.claude/agents/*/agent.md` - Agent capabilities
   - `.claude/shared/*.md` - Shared knowledge

3. **Contribute:**
   - Add new datatypes to basic-app-datatypes
   - Add new probe models to riscure-models
   - Improve agent workflows

4. **Join the community:**
   - GitHub Issues: [moku-instrument-forge/issues](https://github.com/sealablab/moku-instrument-forge/issues)
   - Discussions: Share your instruments!

---

## Quick Reference Card

```
╔══════════════════════════════════════════════════════════════╗
║                    COMMAND CHEAT SHEET                       ║
╠══════════════════════════════════════════════════════════════╣
║ Workflow                                                     ║
║   /workflow new-probe SPEC.yaml  - Full generation workflow ║
║   /validate SPEC.yaml            - Validate YAML            ║
║   /generate SPEC.yaml            - Generate VHDL package    ║
║   /map-registers SPEC.yaml       - Show register mapping    ║
║                                                              ║
║ Deployment                                                   ║
║   /discover                      - Find Moku devices        ║
║   /deploy APP --device IP        - Deploy to hardware       ║
║   /debug-fsm APP --device IP     - Monitor FSM state        ║
║                                                              ║
║ Documentation                                                ║
║   /gen-docs APP                  - Generate documentation   ║
║   /gen-ui APP                    - Generate TUI control app ║
║   /gen-python-api APP            - Generate Python API      ║
╚══════════════════════════════════════════════════════════════╝
```

---

**Happy building! 🎉**

Questions? Check `llms.txt` or file an issue on GitHub.

🤖 *This guide was created with Claude Code to demonstrate the moku-instrument-forge workflow.*

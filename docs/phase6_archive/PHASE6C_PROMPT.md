# Phase 6C: Examples and Walkthroughs

**Phase:** C (Examples)
**Status:** Ready to execute
**Prerequisite:** Phases A-B complete
**Deliverables:** 5 example files (2 YAML + 3 walkthroughs)

---

## Context

**Project:** moku-instrument-forge
**Working Directory:** `/Users/johnycsh/moku-instrument-forge`

**Completed:**
- ✅ Phase A: Essential guides
- ✅ Phase B: Technical reference (assumed complete when you run this)

**See:** `docs/PHASE6_PLAN.md` for complete context

---

## Your Task

Create 5 example files: 2 working YAML specs + 3 detailed walkthroughs.

### Files to Create

1. **`docs/examples/minimal_probe.yaml`**
   - 3-signal example (voltage, boolean, time)
   - Simplest possible spec
   - Same as used in getting_started.md

2. **`docs/examples/minimal_walkthrough.md`** (~400 lines)
   - Line-by-line explanation
   - Why each datatype chosen
   - Register mapping output
   - Generated artifacts

3. **`docs/examples/multi_channel.yaml`**
   - 6-signal example (type variety)
   - 2× voltage, 2× time, 2× boolean
   - Demonstrates register packing

4. **`docs/examples/multi_channel_walkthrough.md`** (~500 lines)
   - Type selection rationale
   - Register packing (6 signals → 2-3 registers)
   - VHDL excerpts
   - Python control example

5. **`docs/examples/common_patterns.md`** (~400 lines)
   - 6 reusable patterns (FSM, voltage, timing, multi-channel, safety, optimization)
   - Each pattern: YAML snippet + explanation

---

## Detailed Specifications

### 1. minimal_probe.yaml

**Copy from getting_started.md** (already proven to work):

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

**Test:** Validate and generate to ensure it works.

---

### 2. minimal_walkthrough.md

**Purpose:** Deep dive into minimal_probe.yaml

**Structure:**
```markdown
# Minimal Probe Walkthrough

## Overview
This walkthrough explains every line of minimal_probe.yaml

## Complete Spec
[Full YAML from above]

## Line-by-Line Explanation

### Top-Level Fields
- app_name: ...
- version: ...
- description: ...
- platform: ...

### Signal 1: output_voltage
- name: "output_voltage"
  - Why: Descriptive, snake_case
- datatype: voltage_output_05v_s16
  - Why: 16-bit signed, ±5V range (Moku:Go DAC output range)
  - Alternatives: voltage_output_025v_s16 (if smaller range), voltage_millivolts_s16 (if need mV precision)
- default_value: 0
  - Why: Safe default (0V output)
- units: "V"
  - Why: Display units for UI/docs

[Continue for enable_output, pulse_width]

## Register Mapping

Running type_clustering strategy:
```
CR6: [output_voltage(16) | pulse_width(16)] = 32/32 bits (100%)
CR7: [enable_output(1)]                     = 1/32 bits
Total: 2 registers, 33 bits used, 52% efficiency
Saved: 1 register (vs 3 registers with one-per-signal)
```

## Generated VHDL

### Shim Excerpt
[Show entity, signal declarations, unpacking logic]

### Main Template
[Show how to use signals in custom logic]

## Generated manifest.json
[Complete manifest with annotations]

## Deployment
How to deploy this package (conceptual)

## Variations

**What if we used different types?**
- voltage_millivolts_s16 instead → same register layout
- time_cycles_u8 instead of time_milliseconds_u16 → better packing (24 bits in CR6, 9 bits saved)

## Next Steps
See multi_channel_walkthrough.md for more complex example
```

---

### 3. multi_channel.yaml

**6-signal example** demonstrating:
- Type variety (voltage, time, boolean)
- Multi-channel naming
- Register packing efficiency

```yaml
app_name: multi_channel_probe
version: 1.0.0
description: Multi-channel probe controller with type variety
platform: moku_pro

datatypes:
  # Voltage outputs (DAC)
  - name: dac_voltage_ch1
    datatype: voltage_output_05v_s16
    description: Channel 1 DAC output
    default_value: 0
    units: V

  - name: dac_voltage_ch2
    datatype: voltage_output_05v_s16
    description: Channel 2 DAC output
    default_value: 0
    units: V

  # Timing parameters
  - name: pulse_width
    datatype: time_milliseconds_u16
    description: Pulse width
    default_value: 100
    units: ms
    min_value: 10
    max_value: 10000

  - name: settling_time
    datatype: time_cycles_u8
    description: ADC settling time in clock cycles
    default_value: 10
    units: cycles
    min_value: 1
    max_value: 255

  # Channel enables
  - name: enable_ch1
    datatype: boolean_1
    description: Enable channel 1
    default_value: 0

  - name: enable_ch2
    datatype: boolean_1
    description: Enable channel 2
    default_value: 0
```

**Test:** Validate and generate.

---

### 4. multi_channel_walkthrough.md

**Purpose:** Show type variety and register packing

**Structure:**
```markdown
# Multi-Channel Probe Walkthrough

## Requirements
Building a 2-channel probe controller with:
- Voltage control per channel (±5V)
- Configurable pulse timing
- Per-channel enable flags
- Fast settling time (clock cycles)

## Complete Spec
[Full YAML from above]

## Type Selection Rationale

### Voltage Types
**Chose:** voltage_output_05v_s16
**Why:** Moku:Pro DAC output range is ±5V, 16-bit provides adequate resolution
**Alternatives:** voltage_output_025v_s16 (smaller range, more precision)

### Time Types
**Pulse Width:** time_milliseconds_u16
- Why: Human-scale timing (10ms - 10s)
- Range: 0-65535 ms (0-65.5 seconds)

**Settling Time:** time_cycles_u8
- Why: FPGA-scale timing (clock-synchronized)
- Range: 1-255 cycles
- Platform: Moku:Pro @ 1 GHz → 1-255 ns

### Boolean Types
**Chose:** boolean_1 for both enables
**Why:** 1-bit flags (not boolean_8, saves 14 bits total)

## Register Mapping

Running type_clustering strategy:

**Grouping by bit width:**
- 16-bit: dac_voltage_ch1, dac_voltage_ch2, pulse_width (3 signals)
- 8-bit: settling_time (1 signal)
- 1-bit: enable_ch1, enable_ch2 (2 signals)

**Packing result:**
```
CR6: [dac_voltage_ch1(16) | dac_voltage_ch2(16)] = 32/32 bits (100%)
CR7: [pulse_width(16) | settling_time(8) | enable_ch1(1) | enable_ch2(1)] = 26/32 bits (81%)
Total: 2 registers, 58 bits used, 91% efficiency
Saved: 4 registers (vs 6 registers with one-per-signal)
```

**Efficiency:** 58/64 bits = 91% (excellent!)

## Generated VHDL

### Shim Entity
[Show ports, signal declarations]

### Signal Unpacking
[Show bit-slicing logic for CR6, CR7]

## Python Control Example

```python
from moku.instruments import CustomInstrument
import json

# Connect and deploy
instr = CustomInstrument('192.168.1.100', 'multi_channel_probe')

# Load manifest for metadata
with open('output/multi_channel_probe/manifest.json') as f:
    manifest = json.load(f)

# Set parameters (conceptual - actual API may differ)
instr.set_parameter('dac_voltage_ch1', 2.5)   # 2.5V
instr.set_parameter('dac_voltage_ch2', -1.0)  # -1.0V
instr.set_parameter('pulse_width', 500)       # 500ms
instr.set_parameter('settling_time', 20)      # 20 cycles (20ns @ 1 GHz)
instr.set_parameter('enable_ch1', True)       # Enable
instr.set_parameter('enable_ch2', True)       # Enable
```

## Lessons Learned

### Type Selection
✅ **DO:** Use narrowest type that fits range (time_cycles_u8 not u16)
✅ **DO:** Use boolean_1 not boolean_8 (saves bits)
❌ **DON'T:** Use 32-bit types when 16-bit suffices

### Register Efficiency
- Grouping 16-bit signals → perfect packing (100% in CR6)
- Mixing widths → good packing (81% in CR7)
- Overall: 91% efficiency (excellent)

### Safety
- Used min_value/max_value for pulse_width (prevent too short/long)
- Safe defaults (0V, 100ms, disabled)

## Next Steps
See common_patterns.md for more design patterns
```

---

### 5. common_patterns.md

**Purpose:** Reusable patterns catalog

**Structure:**
```markdown
# Common Patterns

Reusable design patterns for YAML specs.

---

## Pattern 1: FSM Control Signals

**Use Case:** Controlling a finite state machine

**Pattern:**
```yaml
datatypes:
  - name: fsm_state
    datatype: time_cycles_u8  # 8 bits = 256 states
    description: Current FSM state
    default_value: 0  # IDLE state

  - name: fsm_trigger
    datatype: boolean_1
    description: Trigger FSM transition
    default_value: 0

  - name: fsm_reset
    datatype: boolean_1
    description: Reset FSM to IDLE
    default_value: 0
```

**Why:**
- u8 for state (supports up to 256 states)
- Separate trigger and reset flags
- Default to IDLE (state 0)

**See Also:** [FSM Observer Pattern](../debugging/fsm_observer_pattern.md)

---

## Pattern 2: Voltage Parameters

**Use Case:** DAC output control

**Pattern:**
```yaml
# DAC output (physical units)
- name: output_voltage
  datatype: voltage_output_05v_s16
  description: DAC output voltage
  default_value: 0
  units: V
  min_value: -5.0
  max_value: 5.0

# ADC threshold (raw counts)
- name: trigger_threshold
  datatype: voltage_signed_s16
  description: ADC trigger threshold
  default_value: 1000  # Raw ADC counts
```

**Why:**
- Use voltage_output_* for DAC (physical units)
- Use voltage_signed_* for ADC (raw counts)
- Set min/max for safety

---

## Pattern 3: Timing Configuration

**Use Case:** Different time scales

**Pattern:**
```yaml
# Long delays (human-scale)
- name: pulse_duration
  datatype: time_milliseconds_u16
  description: Pulse duration
  default_value: 100
  units: ms
  min_value: 10
  max_value: 10000

# Short delays (FPGA-scale)
- name: settling_time
  datatype: time_cycles_u8
  description: ADC settling time in clock cycles
  default_value: 10
  units: cycles

# Very short delays (nanoseconds)
- name: trigger_delay
  datatype: time_nanoseconds_u16
  description: Trigger delay
  default_value: 100
  units: ns
```

**Why:**
- milliseconds for human-scale (buttons, timeouts)
- cycles for clock-synchronized operations
- nanoseconds for precision timing

---

## Pattern 4: Multi-Channel Control

**Use Case:** Multiple identical channels

**Pattern:**
```yaml
- name: voltage_ch1
  datatype: voltage_output_05v_s16
  default_value: 0

- name: voltage_ch2
  datatype: voltage_output_05v_s16
  default_value: 0

- name: enable_ch1
  datatype: boolean_1
  default_value: 0

- name: enable_ch2
  datatype: boolean_1
  default_value: 0
```

**Why:**
- Use _ch1, _ch2 suffixes
- Keep related signals together in YAML
- Consistent naming convention

---

## Pattern 5: Safety Constraints

**Use Case:** Preventing hardware damage

**Pattern:**
```yaml
- name: high_voltage_output
  datatype: voltage_output_05v_s16
  description: High voltage output (use with caution)
  default_value: 0              # SAFE: 0V
  units: V
  min_value: 0.0                # Prevent negative
  max_value: 3.3                # Hardware limit (not ±5V!)
```

**Why:**
- Safe default (0V, disabled, etc.)
- min/max constrain runtime values
- Prevent hardware damage

**Best Practices:**
- Default to OFF/0 for dangerous features
- Use min/max to enforce hardware limits
- Document constraints in description

---

## Pattern 6: Register Optimization

**Use Case:** Maximizing register efficiency

**Pattern:**
```yaml
# ❌ Inefficient (4 signals, 4 registers, 25% efficient)
- name: flag1
  datatype: boolean_8  # Wastes 7 bits
- name: flag2
  datatype: boolean_8
- name: flag3
  datatype: boolean_8
- name: flag4
  datatype: boolean_8

# ✅ Efficient (4 signals, 1 register, 13% but only 1 register used)
- name: flag1
  datatype: boolean_1  # 1 bit
- name: flag2
  datatype: boolean_1
- name: flag3
  datatype: boolean_1
- name: flag4
  datatype: boolean_1
# All 4 flags pack into 4 bits of CR6
```

**Why:**
- Use boolean_1 not boolean_8
- Group similar widths together
- Let type_clustering optimize

**Tips:**
- Order YAML by bit width (all 16-bit, then 8-bit, then 1-bit)
- Use narrowest type that fits range
- Check manifest.json efficiency metric (aim for >50%)

---

## Summary

**When designing a spec:**
1. Start with requirements (voltage ranges, timing scales)
2. Choose narrowest types that fit
3. Group similar widths together
4. Add safety constraints (min/max, safe defaults)
5. Use consistent naming (_ch1, _ch2)
6. Check efficiency in manifest.json

**See Also:**
- [Type System](../reference/type_system.md) - All 25 types
- [Register Mapping](../reference/register_mapping.md) - Packing strategies
- [User Guide](../guides/user_guide.md) - Best practices
```

---

## Success Criteria

Before marking phase complete:

- [ ] Both YAML examples validate successfully
- [ ] Both YAML examples generate successfully
- [ ] Walkthroughs explain all concepts clearly
- [ ] Common patterns catalog comprehensive (6 patterns)
- [ ] All cross-references valid
- [ ] Register mapping shown with ASCII art

---

## Testing

```bash
# Validate both examples
uv run python -m forge.validate_yaml docs/examples/minimal_probe.yaml
uv run python -m forge.validate_yaml docs/examples/multi_channel.yaml

# Generate packages
uv run python -m forge.generate_package docs/examples/minimal_probe.yaml --output-dir /tmp/test_minimal
uv run python -m forge.generate_package docs/examples/multi_channel.yaml --output-dir /tmp/test_multi

# Check outputs
cat /tmp/test_minimal/manifest.json | python -m json.tool
cat /tmp/test_multi/manifest.json | python -m json.tool
```

---

## Workflow

1. **Create YAML files** first (validate before writing walkthroughs)
2. **Generate packages** to get actual outputs
3. **Write walkthroughs** using real generated artifacts
4. **Commit when done:**
   ```bash
   git add docs/examples/
   git commit -m "docs: Complete Phase 6C - Examples and walkthroughs"
   ```
5. **Update PHASE6_PLAN.md** - Mark Phase C complete

---

**Ready to begin Phase C!**

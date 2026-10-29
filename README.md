# DAY25 — APB-Like Register Slave Design and Verification — Verilog RTL & Cadence Genus

<p align="center">
  <b>Digital VLSI • Verilog RTL • APB-Like Protocol • Functional Verification • ASIC Synthesis</b>
</p>

<p align="center">
  <code>Specification → RTL → Testbench → Simulation → Synthesis → Technology Mapping → Area → Power → Timing → PPA Review</code>
</p>

<p align="center">
  <img alt="Project" src="https://img.shields.io/badge/Project-APB--Like%20Register%20Slave-blue">
  <img alt="HDL" src="https://img.shields.io/badge/HDL-Verilog-8A2BE2">
  <img alt="Synthesis" src="https://img.shields.io/badge/Synthesis-Cadence%20Genus-orange">
  <img alt="Verification" src="https://img.shields.io/badge/Verification-163%20Pass%20%7C%200%20Fail-success">
</p>

---

## 1. Project Information

| Parameter | Details |
|---|---|
| Project | APB-Like Register Slave Design and Verification |
| Author | Omkar Kalmesh Hadapad |
| Domain | Digital VLSI / RTL Design / Functional Verification |
| Design | APB-like register slave |
| HDL | Verilog HDL |
| Register Configuration | 4 registers × 8 bits |
| Storage Capacity | 32 bits |
| Top Module | `apb_register_slave` |
| Testbench | `day25_tb` |
| Simulation Tool | Cadence NCSim |
| Waveform Format | SHM / SimVision |
| Synthesis Tool | Cadence Genus 21.14-s082_1 |
| Technology Library | `tsmc18` |
| Reported Functional Checks | 163 pass, 0 fail |
| Simulation Completion | 1371 ns |
| Standard-Cell Instances | 144 |
| Reported Cell Area | 3176.712 library area units |
| Estimated Total Power | 237.039 µW |
| Reported Setup Slack | +6476 ps |
| Physical Design Status | Post-route PPA closure not established |

> **Measurement note:** The area unit has not been confirmed as µm². The reported power is an estimate for analysis frame `/stim#0/frame#0`. The available reports do not establish post-route timing closure or extracted-parasitic PPA.

---

## 2. Project Overview

This project implements and verifies an APB-like register-slave design using Verilog RTL. The reported hierarchy contains a register bank with four 8-bit registers, address-decoding logic, access-control logic, and a read multiplexer.

Functional verification was performed using Cadence NCSim and a testbench named `day25_tb`. The supplied simulation transcript reports **163 passing checks and zero failures**.

The design was synthesized using Cadence Genus with the `tsmc18` technology library. The available reports provide standard-cell mapping, cell area, hierarchical area, power estimates, and one setup timing path.

The project demonstrates the digital-design workflow from RTL verification to synthesis-based PPA analysis.

### Project workflow

```text
Specification
     |
     v
RTL Architecture
     |
     v
Verilog Implementation
     |
     v
Self-Checking Testbench
     |
     v
NCSim Functional Simulation
     |
     v
SHM / SimVision Waveform Review
     |
     v
Cadence Genus Synthesis
     |
     v
Technology Mapping
     |
     v
Cell Count and Area Analysis
     |
     v
Power and Timing Analysis
     |
     v
PPA Review and Documentation
```

---

## 3. Project Objectives

1. Understand the architecture of an APB-like register slave.
2. Organize four 8-bit registers into a register bank.
3. Understand address decoding and register selection.
4. Implement and verify read/write access-control behavior.
5. Verify register writes and readback functionality.
6. Test reset behavior and register retention.
7. Verify register independence.
8. Test blocked writes and invalid accesses.
9. Test overwrites and back-to-back operations.
10. Run a self-checking Verilog testbench using Cadence NCSim.
11. Inspect simulation signals through SHM/SimVision.
12. Synthesize the design using Cadence Genus.
13. Analyze standard-cell mapping and area distribution.
14. Interpret internal, switching, and leakage power estimates.
15. Calculate and interpret setup timing slack.
16. Identify the additional evidence needed for full PPA closure.

---

## 4. Design Architecture

### 4.1 Conceptual block diagram

```text
                    apb_register_slave
                            |
             +--------------+--------------+
             |              |              |
             v              v              v
          U_BANK           U_CTRL         U_READ
     register_bank_4x8  access_control  read_mux_4x8
             |
       +-----+---------------------------+
       |             |         |         |
       v             v         v         v
     U_DEC         U_REG0    U_REG1    U_REG2 / U_REG3
 address_decoder  8-bit reg  8-bit reg  8-bit registers
```

The diagram is conceptual and summarizes the reported hierarchy. The exact signal connections and internal behavior must be confirmed against the RTL and mapped netlist.

### 4.2 Reported module hierarchy

```text
apb_register_slave
├── U_BANK (register_bank_4x8)
│   ├── U_DEC  (address_decoder)
│   ├── U_REG0 (register_8bit)
│   ├── U_REG1 (register_8bit_9)
│   ├── U_REG2 (register_8bit_8)
│   └── U_REG3 (register_8bit_7)
├── U_CTRL (access_control)
└── U_READ (read_mux_4x8)
```

### 4.3 Block descriptions

| Instance | Reported module | Intended responsibility inferred from name |
|---|---|---|
| `U_BANK` | `register_bank_4x8` | Groups the four 8-bit registers and associated bank logic |
| `U_DEC` | `address_decoder` | Decodes addresses for register selection |
| `U_REG0` | `register_8bit` | Stores an 8-bit register value |
| `U_REG1` | `register_8bit_9` | Stores an 8-bit register value |
| `U_REG2` | `register_8bit_8` | Stores an 8-bit register value |
| `U_REG3` | `register_8bit_7` | Stores an 8-bit register value |
| `U_CTRL` | `access_control` | Implements access-control logic |
| `U_READ` | `read_mux_4x8` | Selects register data for readback |

The descriptions are inferred from module and instance names. The RTL is the authoritative source for exact functionality.

---

## 5. Functional Operation

### 5.1 Conceptual write flow

```text
Address + Write Data + Write Control
                 |
                 v
          Access-Control Logic
                 |
                 v
            Address Decoder
                 |
                 v
        Select Target Register
                 |
                 v
          Store 8-Bit Data
```

### 5.2 Conceptual read flow

```text
         Address / Register Selection
                    |
                    v
             Read Multiplexer
                    |
                    v
          Selected 8-Bit Register Data
                    |
                    v
               Read Output
```

The exact protocol phases, acceptance conditions, and signal names must be verified from the implementation. This project is described as **APB-like**; full compliance with a specific APB specification has not been established by the supplied reports.

---

## 6. Functional Verification

### 6.1 Simulation environment

| Item | Value |
|---|---|
| Testbench | `day25_tb` |
| Simulator | Cadence NCSim |
| Top-level DUT | `apb_register_slave` |
| Waveform database | `waves.shm` |
| Reported completion time | 1371 ns |
| Termination | `$finish` |
| Reported checks | 163 |
| Passed | 163 |
| Failed | 0 |

### 6.2 Test scenarios

| No. | Scenario | Reported result |
|---:|---|---|
| 1 | Reset | PASS |
| 2 | Idle/setup ready behavior | PASS |
| 3 | Valid writes | PASS |
| 4 | Readback | PASS |
| 5 | Retention and register independence | PASS |
| 6 | Block writes during idle/setup | PASS |
| 7 | Read-only access | PASS |
| 8 | Invalid reads | PASS |
| 9 | Invalid write | PASS |
| 10 | Overwrite and back-to-back operations | PASS |
| 11 | Reset after writes | PASS |
| 12 | Invalid-access write | PASS |

These are the scenario categories visible in the supplied simulation transcript. They do not imply that each scenario represents only one individual check.

### 6.3 Verification summary

| Metric | Result |
|---|---:|
| Total checks | 163 |
| Passed checks | 163 |
| Failed checks | 0 |
| Pass rate | 100% of reported checks |
| Simulation completion | 1371 ns |
| Overall transcript result | PASS |

The transcript includes readback examples such as `A5`, `3C`, `F0`, `69`, `11`, `12`, and `34`.

### 6.4 Verification limitations

The simulation results demonstrate the checks executed by the supplied testbench. They do not independently prove exhaustive functional correctness, formal equivalence, or complete protocol compliance.

Further verification should consider:

- Every valid and invalid address boundary.
- Reset assertion and deassertion around transactions.
- All relevant setup, access, and idle transitions.
- Read and write behavior at boundary conditions.
- Unknown-value propagation where relevant.
- Register retention after blocked or invalid writes.
- Back-to-back transactions with different addresses.
- Consistency between the intended protocol and actual RTL behavior.

---

## 7. SHM / SimVision Waveform Analysis

The simulation transcript reports creation of an SHM waveform database and probing of the following signals.

### 7.1 Waveform commands

```tcl
database -open waves -into waves.shm -default

probe -create -shm day25_tb.addr day25_tb.clk day25_tb.enable \
day25_tb.exp0 day25_tb.exp1 day25_tb.exp2 day25_tb.exp3 \
day25_tb.failed_checks day25_tb.passed_checks day25_tb.rdata \
day25_tb.ready day25_tb.rst day25_tb.sel day25_tb.total_checks \
day25_tb.wdata day25_tb.write

run
```

Use these commands in the appropriate Cadence simulation environment, adapting them if your local setup uses different command syntax or signal paths.

### 7.2 Signals to inspect

| Signal group | Review purpose |
|---|---|
| `clk`, `rst` | Clock activity and reset behavior |
| `addr`, `sel`, `enable`, `write` | Address selection and transaction sequencing |
| `wdata`, `rdata` | Write data and readback values |
| `ready` | Ready behavior across transaction phases |
| `exp0`–`exp3` | Expected register values used by the testbench |
| `passed_checks` | Number of successful checks |
| `failed_checks` | Number of failed checks |
| `total_checks` | Total checks executed |

### 7.3 Waveform review checklist

- Confirm reset behavior at the beginning of simulation.
- Inspect the address and control signals during writes.
- Verify write data is stored in the intended register.
- Check readback against the expected data.
- Inspect invalid-access and blocked-write scenarios.
- Confirm the check counters reach the reported final values.
- Review the final waveform region around `$finish`.

The simulation transcript confirms that the testbench reached `$finish`. A complete waveform review requires inspecting the actual `waves.shm` database in SimVision.

---

## 8. Cadence Genus Synthesis Results

The supplied synthesis reports identify `apb_register_slave` as the top module.

| Metric | Reported result |
|---|---|
| Top module | `apb_register_slave` |
| Synthesis tool | Cadence Genus 21.14-s082_1 |
| Technology library | `tsmc18` |
| Standard-cell instances | 144 |
| Total cell area | 3176.712 library area units |
| Operating condition | `slow (balanced_tree)` |
| Wireload mode | `enclosed` |
| Area mode | `timing library` |

These are synthesis-stage results. The supplied evidence does not establish routed area, extracted parasitics, or post-route timing closure.

---

## 9. Standard-Cell Mapping and Area Analysis

### 9.1 Standard-cell breakdown

| Standard cell | Instances | Reported area |
|---|---:|---:|
| `AND2X2` | 5 | 66.528 |
| `AND3X2` | 5 | 83.160 |
| `AOI22X1` | 48 | 798.336 |
| `DFFHQX1` | 32 | 1703.117 |
| `INVX1` | 8 | 53.222 |
| `NAND2X1` | 8 | 79.834 |
| `NOR2X1` | 34 | 339.293 |
| `NOR3X1` | 4 | 53.222 |
| **Total** | **144** | **3176.712** |

### 9.2 Area distribution

| Category | Instances | Reported area | Share |
|---|---:|---:|---:|
| Sequential | 32 | 1703.117 | 53.6% |
| Inverter | 8 | 53.222 | 1.7% |
| Logic | 104 | 1420.373 | 44.7% |
| Physical cells | 0 | 0.000 | 0.0% |
| **Total** | **144** | **3176.712** | **100.0%** |

### 9.3 Interpretation

- The 32 `DFFHQX1` instances are consistent with the 32 storage bits represented by four 8-bit registers.
- Sequential cells account for approximately 53.6% of reported cell area.
- Combinational logic accounts for approximately 44.7%.
- `AOI22X1` is the largest individual cell category by reported area, contributing 798.336 area units.
- The reported area unit has not been independently confirmed as µm².

The standard-cell summary does not establish the exact Boolean function of each mapped gate. Inspect the mapped netlist before attributing specific cells to individual RTL expressions.

---

## 10. Hierarchical Area Analysis

### 10.1 Reported hierarchy results

| Hierarchy block | Cell count | Reported area | Share of top-level area |
|---|---:|---:|---:|
| `U_BANK` — `register_bank_4x8` | 111 | 2717.669 | 85.55% |
| `U_DEC` — `address_decoder` | 7 | 83.160 | 2.62% |
| `U_REG0` — `register_8bit` | 25 | 645.322 | 20.31% |
| `U_REG1` — `register_8bit_9` | 25 | 645.322 | 20.31% |
| `U_REG2` — `register_8bit_8` | 25 | 645.322 | 20.31% |
| `U_REG3` — `register_8bit_7` | 25 | 645.322 | 20.31% |
| `U_CTRL` — `access_control` | 2 | 29.938 | 0.94% |
| `U_READ` — `read_mux_4x8` | 31 | 429.106 | 13.51% |
| **Top-level** | **144** | **3176.712** | **100.00%** |

> **Important:** Hierarchical child instances are included in their parent hierarchy totals. Do not add `U_BANK` to its child instances when calculating the top-level area, because that would double-count the register-bank hierarchy.

### 10.2 Main observations

- `U_BANK` is the largest reported top-level block, with 2717.669 area units or approximately 85.55% of total area.
- `U_READ` contributes 429.106 area units, approximately 13.51% of top-level area.
- `U_CTRL` contributes 29.938 area units, approximately 0.94% of top-level area.
- The register instances and decoder are children of `U_BANK`; their area values are not additional top-level contributions.

The reported hierarchy indicates that the register bank is the primary area-analysis target. Any optimization must preserve required storage behavior and access semantics.

### 10.3 Optimization priorities

1. Inspect the register-bank write-enable and data-selection logic.
2. Review the read multiplexer structure.
3. Confirm whether the decoder can be simplified without changing address behavior.
4. Preserve reset and register-retention semantics.
5. Re-run simulation after RTL changes.
6. Re-run Genus using consistent constraints and compare cell counts, area, power, and timing.

---

## 11. Power Analysis

### 11.1 Analysis context

| Item | Reported value |
|---|---|
| Instance | `/apb_register_slave` |
| Power unit | W |
| PDB frame | `/stim#0/frame#0` |
| Reported total power | 237.039 µW |

### 11.2 Power by category

| Category | Reported total power | Share |
|---|---:|---:|
| Register | 182.842 µW | 77.14% |
| Logic | 29.8427 µW | 12.59% |
| Clock | 24.3544 µW | 10.27% |
| **Total** | **237.039 µW** | **Approximately 100%** |

### 11.3 Internal, switching, and leakage power

| Component | Reported power | Share |
|---|---:|---:|
| Internal | 189.425 µW | 79.91% |
| Switching | 47.522 µW | 20.05% |
| Leakage | 0.092508 µW | 0.04% |
| **Total** | **237.039 µW** | **Approximately 100%** |

### 11.4 Interpretation

- Register-category power is the dominant reported contributor at 182.842 µW.
- Internal power is the largest reported component of total power.
- Clock power contributes 24.3544 µW under the supplied analysis conditions.
- Leakage power is small compared with internal and switching power in this report.
- Power estimates depend on activity, timing constraints, library characterization, and the analysis setup.

A reported zero for a category does not prove that the corresponding physical structure consumes no power. Power accounting depends on the analysis stage and the modeled design components.

### 11.5 Power-analysis limitations

The 237.039 µW result is associated with analysis frame `/stim#0/frame#0`. The available report does not fully establish activity-annotation quality, clock-frequency assumptions, interconnect parasitics, or post-route power.

Treat this value as a **reported synthesis-analysis estimate**, not as measured silicon power or confirmed post-route power.

---

## 12. Timing Analysis

The supplied Genus timing report identifies an input-to-register setup path from `addr[0]` to the data input of a register.

### 12.1 Timing summary

| Timing item | Reported value |
|---|---|
| Path status | MET |
| Startpoint | Input `addr[0]` |
| Endpoint | `U_BANK/U_REG2/data_reg[7]/D` |
| Clock group | `clk` |
| Clock period | 10000 ps (10 ns) |
| Input delay | 1000 ps |
| Data path delay | 1202 ps (1.202 ns) |
| Setup time | 322 ps |
| Clock uncertainty | 1000 ps |
| Required time | 8678 ps |
| Arrival time | 2202 ps |
| Slack | **+6476 ps (+6.476 ns)** |

### 12.2 Reported path sequence

```text
addr[0]
   |
   v
NOR2X1
   |
   v
INVX1
   |
   v
NOR3X1
   |
   v
AND2X2
   |
   v
INVX1
   |
   v
AOI22X1
   |
   v
NOR2X1
   |
   v
U_BANK/U_REG2/data_reg[7]/D
```

The sequence is consistent with an input passing through combinational control or decode logic before reaching a register data input. The exact Boolean role of each cell must be confirmed from the mapped netlist.

### 12.3 Setup slack calculation

The required time is calculated from the reported clock period, setup time, and uncertainty:

\[
T_{\text{required}} = 10000 - 322 - 1000
\]

\[
T_{\text{required}} = 8678\text{ ps}
\]

The arrival time includes the input delay and data path delay:

\[
T_{\text{arrival}} = 1000 + 1202
\]

\[
T_{\text{arrival}} = 2202\text{ ps}
\]

Therefore:

\[
\begin{aligned}
\text{Slack}
&= T_{\text{required}} - T_{\text{arrival}}\\
&= 8678 - 2202\\
&= 6476\text{ ps}\\
&= 6.476\text{ ns}
\end{aligned}
\]

The calculation matches the reported setup slack.

### 12.4 Timing interpretation

The reported path passes its setup check under the supplied constraints. A positive slack of 6.476 ns means the data arrival is earlier than the required time for this particular path.

**This does not establish full timing closure.** The supplied evidence does not show that every setup and hold path meets timing, or that the design meets timing after routing and parasitic extraction.

### 12.5 Recommended timing checks

1. Review the complete worst-path setup summary.
2. Review hold timing and minimum-delay paths.
3. Verify clock definitions and input/output delays in the SDC.
4. Check the read-data output path independently.
5. Confirm whether timing uses wireload estimates or physical parasitics.
6. Compare synthesis timing with post-route timing when physical implementation is available.
7. Avoid optimizing the RTL based on only one passing path.

---

## 13. Combined PPA Summary

| Metric | Result | Qualification |
|---|---|---|
| Functional simulation | 163 pass / 0 fail | Reported testbench checks |
| Simulation completion | 1371 ns | `$finish` shown in transcript |
| Standard-cell instances | 144 | Genus synthesis report |
| Reported cell area | 3176.712 area units | Unit not confirmed as µm² |
| Estimated total power | 237.039 µW | Analysis-frame-based estimate |
| Largest area block | `U_BANK` | 2717.669 area units |
| Largest power category | Register | 182.842 µW |
| Reported setup path delay | 1.202 ns | Single input-to-register path |
| Reported setup slack | +6.476 ns | The reported path is MET |
| All-path setup/hold closure | Not established | Full timing summaries required |
| Post-route PPA | Not established | Physical implementation evidence unavailable |

### PPA conclusion

The available reports show successful functional checks for the supplied testbench, a 144-cell synthesis result, a reported cell area of 3176.712 library area units, estimated power of 237.039 µW, and one setup path with +6.476 ns slack.

These results provide a useful baseline for further RTL and implementation analysis. They should not be interpreted as proof of exhaustive verification, all-path timing closure, or post-route PPA sign-off.

---

## 14. Suggested Repository Structure

```text
day25-apb-register-slave-genus-ppa/
├── README.md
├── rtl/
│   ├── apb_register_slave.v
│   ├── register_bank_4x8.v
│   ├── address_decoder.v
│   ├── register_8bit.v
│   ├── access_control.v
│   └── read_mux_4x8.v
├── tb/
│   └── day25_tb.v
├── sim/
│   ├── simulation.log
│   └── waves.shm/
├── genus/
│   ├── constraints_top.sdc
│   ├── reports/
│   │   ├── hierarchy.rpt
│   │   ├── area.rpt
│   │   ├── cells.rpt
│   │   ├── power.rpt
│   │   └── timing.rpt
│   ├── mapped_netlist.v
│   └── synthesis.log
├── images/
│   └── apb_register_slave_architecture.png
└── docs/
    └── ppa_analysis.md
```

This is a suggested structure. Keep only files that exist in your repository and adjust filenames to match your actual RTL, testbench, scripts, and reports. Avoid committing proprietary technology libraries or restricted PDK files.

---

## 15. Industry Relevance

This project demonstrates concepts relevant to entry-level digital VLSI and ASIC workflows:

- Synthesizable Verilog RTL design.
- Register-bank architecture and address decoding.
- Read/write control logic.
- Self-checking functional testbenches.
- Reset, retention, and invalid-access verification.
- Cadence NCSim simulation.
- SHM/SimVision waveform inspection.
- Cadence Genus synthesis and technology mapping.
- Standard-cell and hierarchical area analysis.
- Internal, switching, and leakage power interpretation.
- Setup timing and slack calculation.
- Evidence-based RTL optimization.
- Technical documentation and result reporting.

These concepts are relevant to RTL Design, ASIC Design, Design Verification, FPGA Design, and Digital VLSI engineering roles.

---

## 16. Interview Questions

1. What is the purpose of a register bank in a bus slave?
2. Why is address decoding required?
3. What is the role of a read multiplexer?
4. What are the setup and access phases in an APB-like protocol?
5. How should registers behave during reset?
6. What is the difference between internal, switching, and leakage power?
7. Why can register-heavy designs have significant power consumption?
8. What does technology mapping do?
9. Why are sequential cells a significant portion of area in this design?
10. What does positive setup slack mean?
11. How do you calculate setup slack from required and arrival times?
12. Why does one passing timing path not prove timing closure?
13. What is the difference between synthesis area and post-route area?
14. Why should the mapped netlist be inspected before assigning functions to gates?
15. How would you optimize register-bank area without changing behavior?
16. How would you verify that invalid writes do not modify valid registers?
17. What additional tests would strengthen the existing testbench?
18. How can incomplete activity annotation affect power estimates?
19. What information is required to assess hold timing?
20. What additional reports are needed before claiming post-route PPA closure?

---

## 17. Project Status

| Stage | Status |
|---|---|
| Functional testbench | 163 pass / 0 fail reported |
| Simulation | Completed at 1371 ns |
| SHM waveform database | Creation reported |
| Hierarchy report | Reviewed |
| Standard-cell report | Reviewed |
| Area report | Reviewed |
| Power report | Reviewed; analysis assumptions require confirmation |
| One setup path | MET with +6476 ps slack |
| Full setup/hold timing closure | Not established |
| Post-route physical implementation | Not established |
| Final PPA sign-off | Pending further analysis |

---

## 18. Author

**Omkar Kalmesh Hadapad**  
Electronics and Communication Engineering

Digital VLSI • Verilog RTL • Functional Verification • Cadence Genus

---

<p align="center">
  <b>Day 25 — APB-Like Register Slave: RTL Design, Functional Verification and PPA Analysis</b>
</p>

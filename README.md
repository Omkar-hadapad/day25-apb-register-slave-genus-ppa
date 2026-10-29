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


------------------------------------------------------------------------

## 1. Project Information

  -----------------------------------------------------------------------
  Parameter                           Details
  ----------------------------------- -----------------------------------
  **Project**                         APB-Like Register Slave Design and
                                      Verification

  **Author**                          Omkar Kalmesh Hadapad

  **Domain**                          Digital VLSI / RTL Design /
                                      Functional Verification

  **Design Type**                     APB-like register slave

  **HDL**                             Verilog HDL

  **Register Configuration**          4 registers × 8 bits, based on the
                                      reported hierarchy

  **Storage Capacity**                32 bits

  **Clock**                           `clk`

  **Reset Signal**                    `rst`

  **Top Module**                      `apb_register_slave`

  **Simulation Testbench**            `day25_tb`

  **Simulation Tool**                 Cadence NCSim

  **Synthesis Tool**                  Cadence Genus 21.14-s082_1

  **Technology Library**              `tsmc18`

  **Reported Functional Checks**      163 pass, 0 fail

  **Simulation Completion**           `$finish` at 1371 ns

  **Synthesis Cell Count**            144 standard-cell instances

  **Reported Cell Area**              3176.712 library area units

  **Estimated Total Power**           237.039 µW

  **Reported Setup Path**             MET, slack 6476 ps

  **Physical Design Status**          Post-route PPA closure not
                                      established
  -----------------------------------------------------------------------

> **Measurement note:** The area unit is not explicitly confirmed as
> µm². The power value is an estimate from the reported analysis frame
> `/stim#0/frame#0`. The available reports do not establish post-route
> or extracted-parasitic PPA closure.

------------------------------------------------------------------------

## 2. Project Overview

This project implements and verifies an APB-like register-slave block
with four 8-bit registers. The reported hierarchy contains a register
bank, address decoder, access-control logic, and read multiplexer.

The NCSim transcript reports 163 passing checks and zero failures. The
testbench exercises reset behavior, idle/setup/access-ready behavior,
valid writes, readback, retention and register independence, blocked
writes, read-only access, invalid reads and writes,
overwrite/back-to-back operations, and reset after writes.

The design was synthesized using Cadence Genus with the `tsmc18`
technology library. The supplied reports provide standard-cell count and
area, power estimates, and one setup timing path.

This README documents only the results available in the supplied
transcript and reports. It does not claim exhaustive verification or
post-route sign-off.

------------------------------------------------------------------------

## 3. Objectives

1.  Understand the architecture of an APB-like register slave.
2.  Organize four 8-bit registers into a register bank.
3.  Decode addresses to select registers.
4.  Control read and write access.
5.  Select register data for readback.
6.  Verify reset, setup, access, and idle behavior.
7.  Verify valid writes and readback data.
8.  Check register retention and independence.
9.  Test blocked writes and invalid accesses.
10. Test overwrite, back-to-back operations, and reset after writes.
11. Run a self-checking Verilog testbench using Cadence NCSim.
12. Inspect waveforms using SHM/SimVision.
13. Synthesize the design using Cadence Genus.
14. Analyze standard-cell count and area distribution.
15. Interpret internal, switching, and leakage power.
16. Review setup timing and distinguish a passing path from full timing
    closure.

------------------------------------------------------------------------

## 4. Architecture

### Conceptual block diagram

``` text
                   apb_register_slave
                           |
          +----------------+----------------+
          |                |                |
          v                v                v
       U_BANK            U_CTRL           U_READ
  register_bank_4x8   access_control    read_mux_4x8
          |
          +-----------------------------+
          |             |               |
          v             v               v
       U_DEC          U_REG0          U_REG1
 address_decoder    register_8bit    register_8bit
                         |
                    +----+----+
                    |         |
                    v         v
                  U_REG2     U_REG3
               register_8bit register_8bit
```

This diagram is conceptual. Exact signal connectivity and the internal
logic of each module should be confirmed from the RTL and mapped
netlist.

### Reported hierarchy

``` text
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

### Hierarchy block summary

  -----------------------------------------------------------------------
  Instance                Module                  Function indicated by
                                                  name
  ----------------------- ----------------------- -----------------------
  `U_BANK`                `register_bank_4x8`     Groups the four 8-bit
                                                  registers and
                                                  associated bank logic

  `U_DEC`                 `address_decoder`       Decodes the address for
                                                  register selection

  `U_REG0`                `register_8bit`         Stores an 8-bit
                                                  register value

  `U_REG1`                `register_8bit_9`       Stores an 8-bit
                                                  register value

  `U_REG2`                `register_8bit_8`       Stores an 8-bit
                                                  register value

  `U_REG3`                `register_8bit_7`       Stores an 8-bit
                                                  register value

  `U_CTRL`                `access_control`        Implements
                                                  access-control logic

  `U_READ`                `read_mux_4x8`          Selects data for
                                                  readback
  -----------------------------------------------------------------------

The responsibilities above are inferred from the module and instance
names. The RTL is the authoritative source for exact behavior.

------------------------------------------------------------------------

## 5. Functional Operation

### Write operation --- conceptual

``` text
Address + Write data + Write control
                 |
                 v
          Access-control logic
                 |
                 v
           Address decoder
                 |
                 v
       Select one 8-bit register
                 |
                 v
          Store write data
```

### Read operation --- conceptual

``` text
          Address / register select
                    |
                    v
              Read multiplexer
                    |
                    v
             Selected 8-bit data
                    |
                    v
                 Read output
```

The implementation's exact signal names, protocol timing, and acceptance
conditions must be confirmed against the RTL and testbench.

------------------------------------------------------------------------

## 6. Functional Verification

### Reported NCSim results

  Test   Scenario                                Result
  ------ --------------------------------------- --------
  1      Reset                                   PASS
  2      Idle/setup ready behavior               PASS
  3      Valid writes                            PASS
  4      Readback                                PASS
  5      Retention and register independence     PASS
  6      Block writes during idle/setup          PASS
  7      Read-only access                        PASS
  8      Invalid reads                           PASS
  9      Invalid write                           PASS
  10     Overwrite and back-to-back operations   PASS
  11     Reset after writes                      PASS
  12     Invalid-access write                    PASS

### Verification summary

  Metric                                    Reported result
  --------------------------- -----------------------------
  Total checks                                      **163**
  Passed checks                                     **163**
  Failed checks                                       **0**
  Pass rate                     **100% of reported checks**
  Simulation completion                         **1371 ns**
  Simulator termination                           `$finish`
  Overall transcript result                        **PASS**

The transcript shows the expected and actual values matching for the
displayed checks. Examples include readback values `A5`, `3C`, `F0`,
`69`, `11`, `12`, and `34`.

### Verification scope and limitations

The transcript demonstrates the checks implemented by this testbench. It
does not independently prove exhaustive functional correctness, formal
equivalence, or complete protocol compliance.

For additional confidence, review whether the testbench covers every
valid address, invalid-address boundaries, reset assertion/deassertion
around transactions, unknown-value propagation, and all relevant
setup/access transitions.

------------------------------------------------------------------------

## 7. SHM Waveform Inspection

The simulation created an SHM database and probed the following signals:

``` tcl
database -open waves -into waves.shm -default

probe -create -shm day25_tb.addr day25_tb.clk day25_tb.enable \
day25_tb.exp0 day25_tb.exp1 day25_tb.exp2 day25_tb.exp3 \
day25_tb.failed_checks day25_tb.passed_checks day25_tb.rdata \
day25_tb.ready day25_tb.rst day25_tb.sel day25_tb.total_checks \
day25_tb.wdata day25_tb.write

run
```

### Suggested waveform review

  -----------------------------------------------------------------------
  Signal group                        What to inspect
  ----------------------------------- -----------------------------------
  `clk`, `rst`                        Clock activity and reset behavior

  `addr`, `sel`, `enable`, `write`    Address selection and transaction
                                      sequencing

  `wdata`, `rdata`                    Write data and readback values

  `ready`                             Ready behavior during reset, setup,
                                      access, and idle

  `exp0`--`exp3`                      Expected values used by the
                                      testbench

  `passed_checks`, `failed_checks`,   Test progress and final counters
  `total_checks`                      
  -----------------------------------------------------------------------

The transcript confirms that simulation reached `$finish`. Waveform
inspection is still useful for reviewing signal transitions and protocol
sequencing.

------------------------------------------------------------------------

## 8. Genus Synthesis Results

  Metric                                        Reported value
  -------------------------- ---------------------------------
  Top module                              `apb_register_slave`
  Standard-cell instances                              **144**
  Total reported cell area     **3176.712 library area units**
  Technology library                                  `tsmc18`
  Operating condition                   `slow (balanced_tree)`
  Wireload mode                                     `enclosed`
  Area mode                                   `timing library`
  Synthesis tool                    Cadence Genus 21.14-s082_1

These are synthesis-stage results. The reports do not establish routed
area or post-route timing.

------------------------------------------------------------------------

## 9. Standard-Cell Mapping Analysis

### Cell breakdown

  Standard cell     Instances   Reported area
  --------------- ----------- ---------------
  `AND2X2`                  5          66.528
  `AND3X2`                  5          83.160
  `AOI22X1`                48         798.336
  `DFFHQX1`                32        1703.117
  `INVX1`                   8          53.222
  `NAND2X1`                 8          79.834
  `NOR2X1`                 34         339.293
  `NOR3X1`                  4          53.222
  **Total**           **144**    **3176.712**

### Area distribution by category

  Category           Instances           Area        Share
  ---------------- ----------- -------------- ------------
  Sequential                32       1703.117        53.6%
  Inverter                   8         53.222         1.7%
  Logic                    104       1420.373        44.7%
  Physical cells             0          0.000         0.0%
  **Total**            **144**   **3176.712**   **100.0%**

### Interpretation

-   The 32 `DFFHQX1` instances are consistent with the 32 storage bits
    in the four 8-bit registers.
-   Sequential cells contribute 53.6% of the reported area.
-   Combinational logic contributes 44.7%.
-   `AOI22X1` is the largest individual cell category by area,
    contributing 798.336 area units.
-   The area unit is not explicitly confirmed as µm².

The cell summary does not establish the exact function of each
combinational cell. Inspect the mapped netlist before attributing
individual gates to specific RTL expressions.

------------------------------------------------------------------------

## 10. Hierarchical Area Analysis

The hierarchy and area reports provide the following block-level
results:

  --------------------------------------------------------------------------------
  Hierarchy block                 Cell count      Reported area Share of top-level
                                                                              area
  ----------------------- ------------------ ------------------ ------------------
  `U_BANK`                               111           2717.669             85.55%
  (`register_bank_4x8`)                                         

  `U_DEC`                                  7             83.160              2.62%
  (`address_decoder`)                                           

  `U_REG0`                                25            645.322             20.31%
  (`register_8bit`)                                             

  `U_REG1`                                25            645.322             20.31%
  (`register_8bit_9`)                                           

  `U_REG2`                                25            645.322             20.31%
  (`register_8bit_8`)                                           

  `U_REG3`                                25            645.322             20.31%
  (`register_8bit_7`)                                           

  `U_CTRL`                                 2             29.938              0.94%
  (`access_control`)                                            

  `U_READ`                                31            429.106             13.51%
  (`read_mux_4x8`)                                              

  **Top-level**                      **144**       **3176.712**        **100.00%**
  --------------------------------------------------------------------------------

**Important:** Child instances are included in their parent hierarchy
totals. Do not add the `U_BANK` total to its child totals when
calculating the top-level area; that would double-count the
register-bank hierarchy.

### Main observation

The register bank is the largest top-level block at 2717.669 area units,
approximately 85.55% of total area. The read multiplexer contributes
approximately 13.51%, while access control is a small fraction of the
total.

The child register and decoder percentages above are each calculated
relative to the top-level area and therefore are not separate top-level
contributions.

### Optimization priorities

1.  Inspect the register-bank write and data-selection logic.
2.  Review the read-multiplexer structure and timing requirements.
3.  Check whether decoder logic can be simplified without changing
    address behavior.
4.  Preserve all required register storage and reset semantics.
5.  Re-run synthesis after changes and compare results under consistent
    constraints.

------------------------------------------------------------------------

## 11. Power Analysis

The supplied power report is for:

``` text
Instance: /apb_register_slave
Power Unit: W
PDB Frame: /stim#0/frame#0
```

### Power by category

  Category                         Total power                    Share
  --------------------------- ---------------- ------------------------
  Register                          182.842 µW                   77.14%
  Logic                             29.8427 µW                   12.59%
  Clock                             24.3544 µW                   10.27%
  Other reported categories               0 µW                       0%
  **Total**                     **237.039 µW**   **100% approximately**

### Internal, switching and leakage power

  Component     Reported power                    Share
  ----------- ---------------- ------------------------
  Internal          189.425 µW                   79.91%
  Switching          47.522 µW                   20.05%
  Leakage          0.092508 µW                    0.04%
  **Total**     **237.039 µW**   **100% approximately**

### Interpretation

-   Register-category power is the dominant reported contributor.
-   Internal power is the largest component of the total.
-   Logic switching power exceeds logic internal power in the supplied
    category breakdown.
-   Clock power is reported as 24.3544 µW.
-   Leakage is small under the reported analysis conditions.

A zero value for a category does not prove that the corresponding
physical structure consumes no power. For example, clock-network
accounting depends on the analysis stage and clock modeling.

### Power-analysis limitations

The estimate is associated with `/stim#0/frame#0`. The available report
does not fully establish the activity annotation quality,
clock-frequency assumptions, interconnect parasitics, or post-route
power. Treat 237.039 µW as the reported estimate under these conditions,
not as a measured silicon result.

------------------------------------------------------------------------

## 12. Timing Analysis

The supplied Genus timing report identifies the following
input-to-register setup path.

  Timing item         Reported value
  ------------------- -------------------------------
  Path status         **MET**
  Startpoint          Input `addr[0]`
  Endpoint            `U_BANK/U_REG2/data_reg[7]/D`
  Clock group         `clk`
  Clock period        10,000 ps (10 ns)
  Input delay         1000 ps
  Clock uncertainty   1000 ps
  Setup time          322 ps
  Data path delay     1202 ps (1.202 ns)
  Required time       8678 ps
  Slack               **+6476 ps (6.476 ns)**

### Reported path sequence

``` text
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

The path is consistent with an address input passing through decode and
register-control logic before reaching a register data input. The exact
Boolean role of each cell requires the mapped netlist.

### Slack calculation

The reported required time is:

\[ T\_{`\text{required}`{=tex}}=10000-322-1000=8678`\text{ ps}`{=tex} \]

The data arrival time includes the input delay and data path delay:

\[ T\_{`\text{arrival}`{=tex}}=1000+1202=2202`\text{ ps}`{=tex} \]

Therefore:

\[
```{=tex}
\begin{aligned}
\text{Slack}
&=T_{\text{required}}-T_{\text{arrival}}\\
&=8678-2202\\
&=\boxed{6476\text{ ps}}
\end{aligned}
```
\]

The calculation matches the reported slack.

### Timing interpretation

This reported path meets its setup check under the supplied constraints.
It does **not** prove that every setup and hold path meets timing, or
that the design has post-route timing closure.

### Recommended timing checks

1.  Review the worst setup paths across the entire design.
2.  Review hold timing and the full timing summary.
3.  Verify all clock definitions and input/output delays in the SDC.
4.  Check the read-data output path separately.
5.  Confirm whether timing is based on synthesis wireload estimates or
    physical parasitics.
6.  Avoid changing logic based only on one passing path.

------------------------------------------------------------------------

## 13. Combined PPA Summary

  -------------------------------------------------------------------------
  Metric                                      Result Qualification
  --------------------- ---------------------------- ----------------------
  Functional simulation            163 pass / 0 fail Reported testbench
                                                     checks

  Simulation completion                      1371 ns `$finish` shown

  Standard-cell                                  144 Genus synthesis report
  instances                                          

  Reported cell area             3176.712 area units Unit not confirmed as
                                                     µm²

  Estimated total power                   237.039 µW Activity-frame-based
                                                     estimate

  Largest area block                        `U_BANK` 2717.669 area units

  Largest power                             Register 182.842 µW
  category                                           

  Reported setup path                       1.202 ns Input-to-register path
  delay                                              

  Reported setup slack                     +6.476 ns This path is MET

  All-path setup/hold                Not established Requires full timing
  closure                                            summaries

  Post-route PPA                     Not established Physical
  closure                                            implementation
                                                     evidence not supplied
  -------------------------------------------------------------------------

------------------------------------------------------------------------

## 14. Suggested Repository Structure

``` text
day25-apb-register-slave/
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

This is a suggested structure. Keep only files that exist in the
repository and adjust filenames to match your actual RTL and reports.

------------------------------------------------------------------------

## 15. Industry Relevance

This project demonstrates concepts relevant to:

-   Synthesizable Verilog RTL.
-   Register-bank architecture and address decoding.
-   Read/write control logic.
-   Self-checking functional testbenches.
-   Reset and protocol-phase verification.
-   Cadence NCSim simulation and waveform inspection.
-   Cadence Genus synthesis and technology mapping.
-   Standard-cell and hierarchical area analysis.
-   Internal, switching and leakage power interpretation.
-   Setup timing and slack calculation.
-   Evidence-based RTL optimization and technical documentation.

These skills are relevant to entry-level RTL Design, ASIC Design, Design
Verification, FPGA Design, and Digital VLSI roles.

------------------------------------------------------------------------

## 16. Interview Questions

1.  What is the purpose of a register bank in a bus slave?
2.  Why is address decoding required?
3.  What is the role of a read multiplexer?
4.  How do setup and access phases differ in an APB-like protocol?
5.  How should a register behave during reset?
6.  What is the difference between internal, switching and leakage
    power?
7.  Why can a register-heavy design consume significant power?
8.  What does technology mapping do?
9.  Why are sequential cells often a significant portion of cell area?
10. What does a positive setup slack mean?
11. How is setup slack calculated from required and arrival times?
12. Why does a passing timing path not prove full timing closure?
13. What is the difference between synthesis area and post-route area?
14. Why should the mapped netlist be inspected before attributing a gate
    to a particular RTL function?
15. How would you improve register-bank area without changing behavior?
16. How would you verify that invalid writes do not corrupt valid
    registers?
17. What additional checks would strengthen the existing testbench?
18. Why should power estimates be interpreted with their activity
    assumptions?

------------------------------------------------------------------------

## 17. Project Status

  Stage                                Status
  ------------------------------------ ----------------------------------------------------
  Functional testbench                 163 pass / 0 fail reported
  Simulation completion                Completed at 1371 ns
  SHM waveform database                Created
  Hierarchy report                     Reviewed
  Standard-cell report                 Reviewed
  Area report                          Reviewed
  Power report                         Reviewed; analysis assumptions should be confirmed
  One setup path                       MET with +6476 ps slack
  Full setup/hold timing closure       Not established
  Post-route physical implementation   Not established
  Final PPA closure                    Pending further analysis

------------------------------------------------------------------------

## 18. Author

**Omkar Kalmesh Hadapad**  
Electronics and Communication Engineering

Digital VLSI • Verilog RTL • Functional Verification • Cadence Genus

---

<p align="center">
  <b>Day 25 — APB-Like Register Slave: RTL Design, Functional Verification and PPA Analysis</b>
</p>

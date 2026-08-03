# Full Subtractor ATPG using Siemens Tessent

## Overview

This project demonstrates **Automatic Test Pattern Generation (ATPG)** for a NAND-based **Full Subtractor circuit** using **Siemens Tessent**.

The Full Subtractor was implemented at gate level using Verilog HDL and analyzed using the **single stuck-at fault model**. Tessent was used to generate the fault list, ATPG test patterns, and fault coverage statistics.

The ATPG flow successfully detected **all 64 targeted faults using only 6 test patterns**, achieving **100% test coverage**.

---

## Objectives

The objectives of this project are to:

- Design a Full Subtractor using NAND gates.
- Implement the circuit using Verilog HDL.
- Perform structural fault analysis using the stuck-at fault model.
- Generate test patterns automatically using Tessent ATPG.
- Generate and analyze the fault list.
- Evaluate fault coverage and ATPG effectiveness.
- Understand ATPG for arithmetic combinational circuits.

---

# Full Subtractor

A Full Subtractor is a combinational circuit that performs subtraction of three binary inputs.

<img width="1275" height="406" alt="image" src="https://github.com/user-attachments/assets/15a0d535-b554-46f4-a1d8-dadc6cc50f36" />


The three primary inputs are:

```text
a   → Minuend bit
b   → Subtrahend bit
bin → Borrow input
```

The two primary outputs are:

```text
dout → Difference
bout → Borrow output
```

---

## Functional Equations

The Difference output of a Full Subtractor can be represented as:

```text
Difference = a ⊕ b ⊕ bin
```

The Borrow output can be represented as:

```text
Borrow = (~a & b) | (~(a ⊕ b) & bin)
```

---

## Truth Table

| a | b | bin | Difference (dout) | Borrow (bout) |
|---:|---:|---:|---:|---:|
| 0 | 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 | 1 |
| 0 | 1 | 0 | 1 | 1 |
| 0 | 1 | 1 | 0 | 1 |
| 1 | 0 | 0 | 1 | 0 |
| 1 | 0 | 1 | 0 | 0 |
| 1 | 1 | 0 | 0 | 0 |
| 1 | 1 | 1 | 1 | 1 |

---

# NAND-Based Implementation

The Full Subtractor was implemented entirely using **NAND gates**.

The design consists of:

- 3 primary inputs
- 2 primary outputs
- Internal intermediate nodes
- 9 NAND gates

The NAND-based realization provides a gate-level circuit suitable for structural fault analysis and ATPG.

---

# Verilog Implementation

The Full Subtractor was modeled using structural Verilog.

```verilog
module circuit_1075(
    input a, b, bin,
    output reg dout, bout
);

wire c, d, e, f, g, h, i;

nand g1(c, a, b);
nand g2(d, a, c);
nand g3(e, c, b);
nand g4(f, d, e);
nand g5(g, bin, f);
nand g6(h, f, g);
nand g7(i, bin, g);
nand g8(dout, h, i);
nand g9(bout, i, e);

endmodule
```

The intermediate nodes `c` through `i` form the internal logic network used to generate the Difference and Borrow outputs.

---

# ATPG Flow

The ATPG methodology used in this project is:

```text
           Full Subtractor
            Verilog Design
                  │
                  ▼
           Read into Tessent
                  │
                  ▼
           Set Analysis Mode
                  │
                  ▼
          Stuck-at Fault Model
                  │
                  ▼
             Fault Analysis
                  │
                  ▼
          ATPG Pattern Generation
                  │
          ┌───────┴────────┐
          ▼                ▼
      Fault List       Test Patterns
          │                │
          └───────┬────────┘
                  ▼
            Fault Simulation
                  │
                  ▼
          Fault Coverage Report
```

---

# Tessent ATPG Script

A Tessent `.do` file was used to automate the ATPG flow.

```tcl
set_context patterns -Scan

read_verilog circuit_1075.v -force

set_current_design

set_system_mode analysis

set_fault_type stuck

create_patterns

write_patterns testpatterns -replace

write_faults faultlist
```

### Command Description

| Command | Purpose |
|---|---|
| `set_context patterns -Scan` | Configures Tessent for pattern-generation analysis |
| `read_verilog` | Reads the Verilog circuit |
| `set_current_design` | Sets the loaded design as the active design |
| `set_system_mode analysis` | Places Tessent in analysis mode |
| `set_fault_type stuck` | Selects the stuck-at fault model |
| `create_patterns` | Generates ATPG patterns |
| `write_patterns` | Writes generated patterns to a file |
| `write_faults` | Generates the fault list |

---

# Running Tessent

The Tessent environment was initialized using:

```bash
csh
```

followed by:

```bash
source /home/MentorGraphics/cshrc/hep.cshrc
```

The ATPG flow was executed using:

```bash
tessent -shell -dofile atpg.do -log atpglog -replace
```

The generated outputs include:

```text
ATPG Execution
      │
      ├── atpglog
      │     └── Coverage statistics
      │
      ├── faultlist
      │     └── Stuck-at fault information
      │
      └── testpatterns
            └── Generated ATPG vectors
```

---

# Fault Model

The **single stuck-at fault model** was used.

A circuit line is assumed to be permanently fixed at either:

```text
Stuck-at-0 (SA0)
```

or:

```text
Stuck-at-1 (SA1)
```

For example:

```text
Expected signal
      │
      ▼
──────X────────
      │
     SA0
      │
      └──── Signal permanently behaves as logic 0
```

or:

```text
Expected signal
      │
      ▼
──────X────────
      │
     SA1
      │
      └──── Signal permanently behaves as logic 1
```

ATPG attempts to find input combinations that:

1. Activate the target fault.
2. Propagate its effect through the circuit.
3. Observe the faulty behavior at a primary output.

---

# Fault List

Tessent generated an **uncollapsed stuck-at fault list** for the Full Subtractor.

The generated fault list includes faults associated with:

- Primary inputs `a`, `b`, and `bin`
- NAND gate inputs
- NAND gate outputs
- Internal circuit nodes
- Difference output `dout`
- Borrow output `bout`

The report contains fault classifications including:

```text
DS → Detected by Simulation
EQ → Equivalent Fault
```

The ATPG statistics report a total of:

```text
64 faults
```

---

# ATPG Results

The Tessent ATPG report produced the following results:

| Metric | Result |
|---|---:|
| Circuit | Full Subtractor |
| Implementation | NAND-based |
| Simulation Mode | Combinational |
| Fault Type | Stuck-at |
| Fault Mode | Uncollapsed |
| Total Faults | **64** |
| Detected Faults | **64** |
| Detection by Simulation (DS) | **64** |
| ATPG Patterns | **6** |
| Test Coverage | **100.00%** |
| Fault Coverage | **100.00%** |
| ATPG Effectiveness | **100.00%** |

### Key Result

```text
Detected Faults
     64
      │
      ▼
64 / 64 Faults Detected
      │
      ▼
100% Test Coverage
```

All faults included in the ATPG statistics were successfully detected.

---

# Generated ATPG Patterns

Tessent generated **6 test patterns**.

The input bus was defined as:

```text
PI = {a, b, bin}
```

and the output bus as:

```text
PO = {dout, bout}
```

The generated patterns were:

| Pattern | a b bin | dout bout |
|---:|:---:|:---:|
| 0 | `111` | `11` |
| 1 | `000` | `00` |
| 2 | `110` | `00` |
| 3 | `001` | `11` |
| 4 | `010` | `11` |
| 5 | `101` | `00` |

---

# Tessent Pattern Format

The generated ASCII pattern file follows the structure:

```text
SETUP =
    declare input bus "PI" = "/a", "/b", "/bin";
    declare output bus "PO" = "/dout", "/bout";
end;
```

The generated test patterns are represented as:

```text
SCAN_TEST =

    pattern = 0;
    force "PI" "111" 0;
    measure "PO" "11" 1;

    pattern = 1;
    force "PI" "000" 0;
    measure "PO" "00" 1;

    pattern = 2;
    force "PI" "110" 0;
    measure "PO" "00" 1;

    pattern = 3;
    force "PI" "001" 0;
    measure "PO" "11" 1;

    pattern = 4;
    force "PI" "010" 0;
    measure "PO" "11" 1;

    pattern = 5;
    force "PI" "101" 0;
    measure "PO" "00" 1;

end;
```

---

# Coverage Analysis

The generated ATPG statistics were:

```text
Total Faults        = 64
Detected Faults     = 64
Total Patterns      = 6

Test Coverage       = 100.00%
Fault Coverage      = 100.00%
ATPG Effectiveness  = 100.00%
```

Therefore:

```text
                  ATPG
                   │
                   ▼
             64 Total Faults
                   │
                   ▼
            64 Faults Detected
                   │
                   ▼
              6 Patterns
                   │
                   ▼
           100% Test Coverage
```

This demonstrates that a compact set of ATPG-generated vectors was sufficient to detect all faults reported for the design.

---

# Results

ATPG for the NAND-based Full Subtractor was successfully performed using Siemens Tessent.

Tessent successfully:

- Analyzed the structural Verilog design.
- Generated the stuck-at fault list.
- Generated optimized ATPG test vectors.
- Performed fault simulation.
- Detected all **64 targeted faults**.
- Achieved **100% test coverage**.
- Achieved **100% fault coverage**.
- Achieved **100% ATPG effectiveness** using only **6 test patterns**.

---

# Tools and Technologies

| Tool / Technology | Purpose |
|---|---|
| Siemens Tessent | ATPG and fault analysis |
| Verilog HDL | Structural Full Subtractor implementation |
| NAND Gates | Gate-level circuit realization |
| Tessent `.do` Script | ATPG flow automation |
| Linux / C Shell | Tessent execution environment |
| Stuck-at Fault Model | Structural fault modeling |

---

# Repository Structure

```text
02-Full-Subtractor-ATPG/
│
├── README.md
│
├── rtl/
│   └── full_subtractor.v
│
├── scripts/
│   └── atpg.do
│
├── fault-lists/
│   └── faultlist
│
├── patterns/
│   └── testpatterns
│
└── results/
    ├── atpg_log.png
    ├── fault_list.png
    └── test_patterns.png
```

---

# Key Learnings

Through this project, I gained hands-on experience with:

- Automatic Test Pattern Generation (ATPG)
- Arithmetic circuit testing
- Structural Verilog modeling
- NAND-based logic implementation
- Single stuck-at fault modeling
- Fault activation
- Fault propagation
- Fault simulation
- ATPG pattern generation
- Fault list analysis
- Equivalent fault classification
- Test coverage analysis
- Tessent `.do` scripting
- Tessent ATPG reports

---

# Conclusion

Automatic Test Pattern Generation for a **NAND-based Full Subtractor** was successfully implemented using **Siemens Tessent**.

The Full Subtractor was modeled structurally using nine NAND gates and analyzed using an **uncollapsed single stuck-at fault model**. Tessent automatically generated the corresponding fault list and ATPG test vectors.

The final ATPG analysis reported **64 total faults, all 64 detected, and 6 generated test patterns**, resulting in **100% test coverage, 100% fault coverage, and 100% ATPG effectiveness**.

This project demonstrates how ATPG can efficiently generate a compact set of test vectors capable of detecting structural faults in a combinational arithmetic circuit.

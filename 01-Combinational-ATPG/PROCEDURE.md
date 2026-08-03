# Combinational Circuit ATPG using Siemens Tessent

## Overview

This project demonstrates **Automatic Test Pattern Generation (ATPG)** for two combinational digital circuits using **Siemens Tessent**.

The circuits were modeled using **Verilog HDL** and analyzed using the **single stuck-at fault model**. Tessent was used to automatically generate test patterns, fault lists, ATPG statistics, and fault coverage reports.

The ATPG results demonstrated **100% test coverage**, with all targeted stuck-at faults successfully detected.

---

## Objectives

The main objectives of this project are to:

- Design combinational circuits using Verilog HDL.
- Configure an ATPG flow using Tessent.
- Apply the single stuck-at fault model.
- Generate automatic test patterns.
- Generate and analyze fault lists.
- Evaluate fault detection and test coverage.
- Understand the ATPG workflow for combinational circuits.

---

# Circuits Under Test

Two combinational circuits were analyzed in this project.

## Circuit 1


<img width="839" height="446" alt="image" src="https://github.com/user-attachments/assets/03ebb72e-5895-4f97-8b5c-0b02cfd97f97" />


Circuit 1 consists of five primary inputs:

```text
A, B, C, D, E
```

and one primary output:

```text
Y
```

The circuit is constructed using NAND, OR, and AND gates with intermediate nodes `G`, `F`, `H`, `I`, and `J`.


### Verilog Implementation

```verilog
module circuit_1075(
    input A, B, C, D, E,
    output reg Y
);

reg G, H, I, J;

nand g1(G, A, B);
nand g2(F, B, C);
nand g3(H, F, D);
nand g4(I, D, E);
or   g5(J, H, I);
and  g6(Y, G, J);

endmodule
```

---

## Circuit 2


<img width="365" height="215" alt="image" src="https://github.com/user-attachments/assets/ecf1216d-8ddb-4b51-b722-d1209f714942" />


Circuit 2 consists of seven primary inputs:

```text
A, B, C, D, E, F, G
```

and one primary output:

```text
Y
```

The design uses NAND, OR, and AND gates.



### Verilog Implementation

```verilog
module circuit2_1075(
    input A, B, C, D, E, F, G,
    output Y
);

reg H, I, J, K;

nand g1(H, A, B, C);
or   g2(I, D, E);
and  g3(J, F, G);
or   g4(K, I, J);
and  g5(Y, H, K);

endmodule
```

---

# ATPG Methodology

The following ATPG flow was followed for both combinational circuits:

```text
            Verilog Circuit
                   │
                   ▼
             Read in Tessent
                   │
                   ▼
          Set Analysis Mode
                   │
                   ▼
        Select Stuck-at Faults
                   │
                   ▼
             Create Patterns
                   │
          ┌────────┴────────┐
          ▼                 ▼
     Fault List        Test Patterns
          │                 │
          └────────┬────────┘
                   ▼
            Fault Simulation
                   │
                   ▼
          Fault Coverage Report
```

---

# Tessent ATPG Script

A `.do` file was created to automate the ATPG process.

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

For Circuit 2, the corresponding Verilog design file is supplied to the same ATPG flow.

---

# Running Tessent

The Tessent environment was initialized from the terminal using:

```bash
csh
source /home/MentorGraphics/cshrc/hep.cshrc
```

The ATPG flow was then executed using:

```bash
tessent -shell -dofile atpg.do -log atpglog -replace
```

After execution, Tessent generates:

```text
ATPG Log
   │
   ├── Fault statistics
   ├── Detected faults
   ├── Fault coverage
   ├── ATPG effectiveness
   │
   ├── Fault List
   │
   └── Generated Test Patterns
```

---

# Fault Model

The **single stuck-at fault model** was used for ATPG.

Under this model, a circuit node is assumed to be permanently fixed at either:

### Stuck-at-0

```text
Normal Node ───── X ─────> Logic 0
                 SA0
```

The node remains at logic `0` regardless of its expected fault-free value.

### Stuck-at-1

```text
Normal Node ───── X ─────> Logic 1
                 SA1
```

The node remains at logic `1` regardless of its expected fault-free value.

ATPG generates input combinations that activate these faults and propagate their effects to observable primary outputs.

---

# ATPG Results

The Tessent ATPG report produced the following results:

| Metric | Result |
|---|---:|
| Fault Model | Stuck-at |
| Simulation Mode | Combinational |
| Total Faults | **48** |
| Detected Faults | **48** |
| Detection by Simulation (DS) | **48** |
| Generated Patterns | **8** |
| Test Coverage | **100.00%** |
| Fault Coverage | **100.00%** |
| ATPG Effectiveness | **100.00%** |

All **48 targeted stuck-at faults were detected** during fault simulation.

---

# Generated Test Patterns

Tessent generated **8 ATPG patterns** for the analyzed combinational design.

The generated pattern file contains:

- Primary input assignments
- Expected primary output responses
- ATPG statistics
- Fault-model information

An example of the pattern structure is:

```text
pattern = 0;
force "PI" = "<input-vector>" 0;
measure "PO" = "<expected-output>" 1;

pattern = 1;
force "PI" = "<input-vector>" 0;
measure "PO" = "<expected-output>" 1;
```

The generated patterns are stored separately in the `patterns/` directory of this project.

---

# Fault List

Tessent automatically generated the fault list for the circuit.

The fault list contains stuck-at faults associated with different circuit locations, including gate inputs, outputs, and internal logic nodes.

The generated fault list can be found under:

```text
fault-lists/
```

---

# Coverage Analysis

The ATPG report shows:

```text
Total Faults        : 48
Detected Faults     : 48
Test Patterns       : 8

Test Coverage       : 100.00%
Fault Coverage      : 100.00%
ATPG Effectiveness  : 100.00%
```

This demonstrates that the generated test-pattern set was capable of detecting all faults included in the reported fault set.

---

# Results

The ATPG flow was successfully executed for the combinational circuits using Tessent.

The tool successfully:

- Read and analyzed the Verilog designs.
- Applied the stuck-at fault model.
- Generated ATPG test vectors.
- Generated corresponding fault lists.
- Performed fault simulation.
- Reported fault-detection statistics.
- Achieved **100% test coverage** in the reported ATPG run.

The results demonstrate the effectiveness of ATPG in automatically determining input combinations capable of detecting structural faults in combinational digital circuits.

---

# Tools and Technologies

| Tool / Technology | Purpose |
|---|---|
| Siemens Tessent | ATPG and fault analysis |
| Verilog HDL | Combinational circuit modeling |
| Tessent `.do` Scripts | ATPG flow automation |
| Linux / C Shell | Tessent environment and execution |
| Stuck-at Fault Model | Structural fault modeling |

---

# Repository Structure

```text
01-Combinational-ATPG/
│
├── README.md
│
├── rtl/
│   ├── circuit1.v
│   └── circuit2.v
│
├── scripts/
│   ├── circuit1_atpg.do
│   └── circuit2_atpg.do
│
├── fault-lists/
│   ├── circuit1_faultlist
│   └── circuit2_faultlist
│
├── patterns/
│   ├── circuit1_testpatterns
│   └── circuit2_testpatterns
│
└── results/
    ├── circuit1_atpg_log.png
    ├── circuit1_fault_list.png
    ├── circuit1_patterns.png
    ├── circuit2_atpg_log.png
    ├── circuit2_fault_list.png
    └── circuit2_patterns.png
```

---

# Key Learnings

Through this project, I gained hands-on experience with:

- Automatic Test Pattern Generation (ATPG)
- Combinational circuit testing
- Single stuck-at fault modeling
- Fault activation and propagation
- ATPG pattern generation
- Fault list generation
- Fault simulation
- Fault coverage analysis
- Tessent ATPG reports
- Tessent `.do` scripting
- Command-line DFT workflows

---

# Conclusion

ATPG for two combinational circuits was successfully performed using **Siemens Tessent**.

The circuits were modeled using Verilog HDL and analyzed using the stuck-at fault model. Tessent automatically generated fault lists and corresponding ATPG test vectors while evaluating the achieved fault coverage.

The reported ATPG run detected **48 out of 48 faults using 8 test patterns**, resulting in **100% test coverage, 100% fault coverage, and 100% ATPG effectiveness**.

This project demonstrates the fundamental ATPG workflow for combinational digital circuits and provides practical experience with **fault modeling, test-pattern generation, fault simulation, and coverage analysis using Tessent**.

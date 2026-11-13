# Design and RTL Implementation of Single-Cycle and Five-Stage Pipelined RISC-V Processor

A comparative Verilog RTL implementation of two RISC-V processor microarchitectures: a Single-Cycle Processor and a Five-Stage Pipelined Processor.
The project explores processor datapath design, instruction execution, pipeline organization, data forwarding, hazard detection, and performance evaluation through simulation.
Both implementations were developed using Verilog HDL and verified using Icarus Verilog and GTKWave.
## Project Overview
The objective of this project was to understand and implement two fundamental processor microarchitectures based on the RISC-V instruction set architecture (ISA).
Rather than implementing only a conventional single-cycle processor, this project extends the design into a five-stage pipelined architecture to explore instruction-level parallelism and the challenges associated with overlapping instruction execution.
The project consists of two independent implementations:
### Single-Cycle Architecture
<img width="1058" height="563" alt="SingleCycle Datapath" src="https://github.com/user-attachments/assets/f7da000c-9cb6-47c7-b5f7-95199a5b05d4" />

### Five-Stage Pipelined Architecture
<img width="1229" height="620" alt="Pipeline Datapath" src="https://github.com/user-attachments/assets/e860f280-4c5a-44e1-b4c5-a40701b9c078" />

## Implemented Features

### Common Processor Components
Both implementations contain the fundamental components required for instruction execution:
- Program Counter (PC)
- Instruction Memory
- Instruction Decoder
- Control Unit
- Register File
- Arithmetic Logic Unit (ALU)
- Immediate Generator
- Data Memory
- Multiplexers and supporting datapath logic

### Pipeline-Specific Features
The five-stage implementation incorporates additional mechanisms required for correct pipelined execution.

#### Data Forwarding
<img width="1510" height="387" alt="ForwardHazardUnit" src="https://github.com/user-attachments/assets/81d5e418-7469-4571-b601-ad02b928c9d0" />

Forwarding paths allow operands to be obtained from intermediate pipeline stages rather than waiting for their values to be written back into the register file.
The implementation supports:
- EX/MEM to EX forwarding.
- MEM/WB to EX forwarding.

This helps resolve data dependencies between consecutive arithmetic instructions without unnecessary pipeline stalls.

#### Load-Use Hazard Detection
<img width="1167" height="332" alt="LoadHazardUnit" src="https://github.com/user-attachments/assets/df2a9f0b-56d6-4851-8582-4d78f4bb8a0e" />

A load-use dependency occurs when an instruction immediately following a load instruction requires the value being loaded.
Since the loaded data is not available early enough for the dependent instruction's execution stage, the hazard detection unit introduces a one-cycle stall.
Branch and jump control-flow handling is outside the currently implemented and verified feature set.

### Performance

#### Cycles Per Instruction (CPI)
CPI represents the average number of clock cycles required to execute one instruction.
CPI = Total Execution Cycles / Total Instructions
- Single-Cycle:
CPI = 6 / 6 = 1.000
- Pipelined:
CPI = 11 / 6 = 1.833

#### Instructions Per Cycle (IPC)
PC represents the average number of instructions completed per clock cycle.
IPC = Total Instructions / Total Execution Cycles
- Single-Cycle:
IPC = 6 / 6 = 1.000
- Pipelined:
IPC = 6 / 11 = 0.545

The higher CPI and lower IPC of the pipelined implementation in this particular benchmark are primarily attributable to pipeline startup and drain overhead.
The benchmark contains only six instructions, making pipeline overhead relatively significant.
However, the pipelined architecture allows multiple instructions to execute concurrently in different stages.
Once the pipeline is filled, its ideal sustained throughput approaches one instruction per cycle, assuming no stalls.


The CPI and IPC values presented above represent the execution efficiency of the two processor architectures for the selected instruction sequence and simulation environment. They should not be interpreted as absolute indicators of one implementation being faster than the other.
Actual execution speed depends on additional hardware characteristics, particularly the critical path delay, maximum achievable clock frequency, and implementation-dependent timing overhead.Therefore, the results presented here are intended primarily for architectural comparison and functional evaluation rather than definitive hardware speed characterization.

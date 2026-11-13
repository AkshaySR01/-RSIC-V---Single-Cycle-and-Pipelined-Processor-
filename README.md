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
<img width="1280" height="718" alt="Pipeline Datapath" src="https://github.com/user-attachments/assets/42269421-ceb4-4c82-a8f9-ec32204c6343" />

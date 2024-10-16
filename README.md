# Tiny Processor Design

## Project Overview

This project involves the design and implementation of a simple 8-bit processor, referred to as the "Tiny" processor. The processor is capable of executing a set of instructions defined in an instruction set architecture (ISA). It supports operations such as addition, subtraction, multiplication, and logical operations, among others.

## Introduction

The Tiny processor is designed to run a single program utilizing an FPGA. It comprises 16 registers of 8 bits each and incorporates various arithmetic and logical operations. The architecture is modular, allowing for better testing and synthesis of individual components.

## Design Components

The project is divided into several key components:

- **Register File**: Contains 16 registers for data storage and manipulation.
- **Instruction File**: Holds the instructions to be executed by the processor.
- **Processor**: The main control unit that processes instructions and manages the execution flow.
- **Control Unit**: Coordinates operations between various components, including the accumulator and the register file.
- **Division Module**: Performs division operations, calculating both quotient and remainder.

## Instruction Set

The Tiny processor supports the following instructions:

| Instruction | Opcode   | Operation                                                                                     |
|-------------|----------|-----------------------------------------------------------------------------------------------|
| NOP         | 0000 0000| No operation                                                                                 |
| ADD Ri      | 0001 xxxx| Add the contents of register `Ri` to the accumulator (ACC)                                   |
| SUB Ri      | 0010 xxxx| Subtract the contents of register `Ri` from the accumulator                                   |
| MUL Ri      | 0011 xxxx| Multiply the contents of register `Ri` with the accumulator                                   |
| DIV Ri      | 0100 xxxx| Divide the accumulator by the contents of register `Ri`                                       |
| LSL ACC     | 0000 0001| Left Shift Logical the contents of ACC                                                       |
| LSR ACC     | 0000 0010| Right Shift Logical the contents of ACC                                                      |
| CIR ACC     | 0000 0011| Circular Right Shift of ACC                                                                   |
| CIL ACC     | 0000 0100| Circular Left Shift of ACC                                                                    |
| AND Ri      | 0101 xxxx| Bitwise AND between ACC and contents of register `Ri`                                        |
| XRA Ri      | 0110 xxxx| Bitwise XOR between ACC and contents of register `Ri`                                        |
| CMP Ri      | 0111 xxxx| Compare the ACC with the contents of register `Ri`                                            |
| INC ACC     | 0000 0110| Increment the contents of ACC                                                                  |
| DEC ACC     | 0000 0111| Decrement the contents of ACC                                                                  |
| MOV ACC, Ri | 1001 xxxx| Move the contents of register `Ri` to ACC                                                    |
| MOV Ri, ACC | 1010 xxxx| Move the contents of ACC to register `Ri`                                                   |
| HLT         | 1111 1111| Halt the processor execution                                                                  |

## Implementation

### Verilog Code

The following Verilog modules have been implemented:

1. **Clock Divider**: Generates a slow clock signal.
2. **Division Module**: Handles division operations.
3. **Register File**: Manages register read and write operations.
4. **Instruction File**: Contains the instruction set.
5. **Processor**: Main logic to process instructions and control the flow of execution.
6. **Control Unit**: Controls the processor's operations based on the instructions received.

## Testbench

A comprehensive testbench has been created to validate the functionality of the processor. It simulates various scenarios and checks for expected outputs against given inputs.

## Simulation Results

Simulation results showcase the processor executing a sample program. The results confirm the correctness of the implemented instructions and functionalities.

## FPGA Implementation

The final implementation has been demonstrated on an FPGA board. Watch video of the FPGA execution showing a program with at least four instructions.

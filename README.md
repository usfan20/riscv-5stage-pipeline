# Pipelined RISC-V Processor Core

A modular, high-performance **32-bit 5-stage pipelined RISC-V processor core** designed and implemented from scratch in **SystemVerilog**. The microarchitecture is engineered with robust hardware interlock systems, utilizing a dedicated **Forwarding Unit** to handle data hazards natively and a **Hazard Detection Unit** to resolve load-use dependencies via dynamic pipeline stall and bubble injection.

---


## 🏛️ Microarchitecture & Pipeline Architecture

The processor implements a classical 5-stage RISC-V pipeline, decoupling execution stages through dedicated, synchronous pipeline registers:


```

[ IF ] ---> (id_if) ---> [ ID ] ---> (id_exe) ---> [ EXE ] ---> (exe_mem) ---> [ MEM ] ---> (mem_wb) ---> [ WB ]

```

1. **Instruction Fetch (IF):** Tracks execution via the Program Counter (`pc`). Fetches 32-bit instructions from the byte-addressable instruction memory (`inst_mem`).
2. **Instruction Decode (ID):** Unpacks opcode, immediate types (I, S, B, J formats via `immediate`), and source/destination registers. Evaluates control signals through the main `control_logic`.
3. **Execute (EXE):** Performs arithmetic, logical, and shift operations using an agile `alu` unit directed by the `alu_control_logic`. Branches and target jump addresses are calculated here.
4. **Memory Access (MEM):** Handles data memory operations (`data_memory`) with dedicated logic for byte, half-word, and word alignment dictated by `fun3`.
5. **Write-Back (WB):** Routes the true committing data (ALU result, memory payload, or PC link) back to the register file (`reg_file`) through the `writeback_mux`.

---

## ⚡ Advanced Hazard Mitigation Mechanisms

To maintain high throughput and guarantee structural/data integrity, the core employs two independent hardware hazard management systems:

### 🔄 Forwarding Unit (`forwarding_unit`)
* **Problem:** Read-After-Write (RAW) dependency where an operation requires a register value that is currently traversing deeper pipeline stages (EXE/MEM or MEM/WB).
* **Solution:** Actively checks if active destination registers (`rd`) in execution match incoming source operands (`rs1`/`rs2`). It reroutes the computed arithmetic results back into the ALU inputs on-the-fly using specialized bypass multiplexers (`muxA` and `muxB`), eliminating execution stalls for consecutive arithmetic instructions.

### 🛑 Hazard Detection Unit (`hazard_detection_unit`)
* **Problem:** Load-Use Dependency. When a `lw` (load word) instruction is immediately followed by an instruction dependent on that loaded register, forwarding alone cannot bridge the time gap because data hasn't yet left the memory stage.
* **Solution:** The unit catches this specific edge-case, forcing the pipeline to drop a cycle safely:
  * De-asserts `PCWrite` to lock the Program Counter in place.
  * De-asserts `IF_ID_Write` to preserve the instruction currently being decoded.
  * Asserts `ControlNOP` to flush the execution control bits, cleanly injecting a **pipeline bubble (NOP)** into the EXE stage.

---

## 📂 Repository Structure & Modules

The layout of the core design files is structured logically across modular hardware blocks:

| File / Module | Purpose |
| :--- | :--- |
| **`top_module.sv`** | The structural top-level module routing all datapath, pipelining stages, and hazard components. |
| `id_if`, `id_exe`, `exe_mem`, `mem_wb` | Synchronous pipeline barrier registers transitioning data seamlessly across cycles. |
| `hazard_detection_unit.sv` | Dynamic hardware interlock engine tracking memory load-use stalls. |
| `forwarding_unit.sv` | Bypass detection module passing newer values back into the ALU execution ports. |
| `control_logic.sv` & `control_mux.sv` | Generates central CPU control pathways; handles zeroing out parameters on NOP signals. |
| `alu.sv` & `alu_control_logic.sv` | Main math block implementing RV32 arithmetic, bit manipulation, and branch flag evaluation. |
| `reg_file.sv` | Multi-ported RISC-V register file initializing state arrays from external memory descriptors. |
| `data_memory.sv` | Configurable byte/half/word-aligned memory subsystem acting as local scratchpad RAM. |
| `inst_mem.sv` | Asynchronous read instruction wrapper parsing structural execution instructions. |

---

## 🛠️ Verification & Simulation

* **Design Language:** SystemVerilog (IEEE 1800-2012)
* **Target Environment:** Compatible with modern EDA platforms (Xilinx Vivado, ModelSim/QuestaSim, Verilator).
* **Memory Initialization:** Simulation memory environments read behavioral configuration sequences dynamically from text-based `.mem` listings (`instructions.mem`, `reg_file_mem.mem`, and `datamem.mem`) using compiler `$readmemh` targets.

---

## 🚀 Future Roadmap

* Add support for J-type instructions (`jal`) completely inside the pipelined flow.
* Incorporate an automated branch prediction block (e.g., compile a branch target buffer or 2-bit branch history table).
* Integrate full exception/interrupt control registers (CSR handling).

---

## 📄 License

This project is open-source and available under the **MIT License**. Feel free to use, modify, and build upon it for academic or personal hardware designs!

```

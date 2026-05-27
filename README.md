# Pedestrian-Controlled Traffic Light System

## Overview
This repository contains a SystemVerilog implementation of a **Pedestrian-Controlled Traffic Light System** targeted for FPGA deployment. The system regulates traffic with a standard Green-Yellow-Red cycle, interrupted only by a pedestrian `walk` request. The design features a fully synchronous datapath with a custom Finite State Machine (FSM), a ROM-based programmable timer, and peripheral clock-scaling logic for physical hardware observation.

## Key Features
* **Demand-Driven FSM:** The traffic light defaults to green for vehicles and only transitions when a pedestrian presses the `walk` button.
* **ROM-Based Timing:** State durations are not hardcoded in the FSM. Instead, the FSM outputs address a ROM lookup table that dynamically loads the correct wait duration into a countdown timer.
* **Flashing Warning Logic:** Implements a visual clearance warning for pedestrians (flashing blue LED) before returning the right-of-way to vehicles.
* **Hardware-Ready:** Includes a 32-bit clock divider to scale down a standard 100MHz FPGA system clock so that transitions occur at human-observable speeds.

## Concept & Architecture
The system employs a modular architecture separating control logic (FSM) from the timing datapath. When the FSM changes state, a `CHANGE_DETECTOR` triggers the `COUNTDOWN_TIMER` to load a new duration value fetched from the `ROM`. The FSM holds its current state until the timer asserts `timer_done`.

<img width="1886" height="560" alt="image" src="https://github.com/user-attachments/assets/592ebc93-0379-4825-aeb6-b51d79995a7e" />


## Module Descriptions

| Sub-Module | Purpose |
| :--- | :--- |
| **`TRAFFIC_LIGHT_FSM`** | A 4-state Moore automaton controlling the main sequence. Outputs the current traffic state (`green`, `red`, `flash`) and waits for `timer_done` to advance. |
| **`ROM`** | A combinational lookup table. Takes the 3-bit FSM output state as an address and returns the required state duration in clock cycles (e.g., 4 cycles for Green, 2 for Yellow). |
| **`CHANGE_DETECTOR`** | Registers the FSM outputs and generates a 1-cycle `change` pulse whenever the FSM enters a new state, signaling the timer to load the new ROM duration. |
| **`COUNTDOWN_TIMER`** | Decrements the loaded ROM value down to 0. Asserts `timer_done` for one clock cycle when finished, prompting the FSM to transition. |
| **`MUX` & Logic** | Routes the pedestrian crossing signal (`blue`). If `flash` is active, it multiplexes the delayed clock to create a flashing visual effect; otherwise, it holds solid or off. |
| **`TRAFFIC_LIGHT`** | The structural wrapper combining the FSM, ROM, Timer, and Change Detector into a single Device Under Test (DUT). |
| **`CLK_DELAY`** | A frequency divider utilizing a 32-bit counter. Outputs the 28th bit to slow down the 100MHz FPGA clock for physical observation. |
| **`TOP`** | The absolute top-level module linking the `TRAFFIC_LIGHT` datapath with the `CLK_DELAY` module for final FPGA synthesis. |

## FSM State Machine & Timing
The core progression relies on the following 4 states and associated ROM delays:
1. **`GREEN_STATE` (Vehicles Go):** `green=1, red=0, flash=0`. Lasts for 4 timer cycles once triggered to leave. Holds indefinitely if `walk=0`.
2. **`YELLOW_STATE` (Vehicles Slow):** `green=1, red=1, flash=0`. Lasts for 2 timer cycles.
3. **`RED_STATE` (Pedestrians Cross):** `green=0, red=1, flash=0`. Lasts for 4 timer cycles.
4. **`FLASH_STATE` (Clearance Warning):** `green=0, red=1, flash=1`. Lasts for 3 timer cycles before returning to Green.

## Hardware & Board Setup
The design is specifically mapped and constrained for the **Boolean Board (100MHz Clock)**.
* `clk`: F14 (100MHz System Clock)
* `rst_clk`: J2 (BTN0)
* `rst_tf`: J5 (BTN1)
* `walk`: V2 (SW0)
* `clk_delay`: A4 (LED15 - observation)
* `green`: V4 (RGB0-GREEN)
* `red`: V6 (RGB0-RED)
* `blue`: V5 (RGB1-BLUE)

## Verification Strategy
Functionality was validated using a comprehensive behavioral testbench instantiating the `TRAFFIC_LIGHT` DUT.
* **Input:** Applied the asynchronous `walk` signal and waited 20 clock cycles to observe the complete FSM loop.
* **Internal Observation:** Tracked the `change` pulse and `timer_done` flags alongside the top-level RGB outputs to ensure synchronous timer loading.

## Simulation Results

<img width="1746" height="284" alt="image" src="https://github.com/user-attachments/assets/40f4784f-00a2-4a2a-8eae-3955a4fc7d84" />


## Future Improvements
* Parameterize the ROM values to easily adjust pedestrian crossing times based on intersection size.

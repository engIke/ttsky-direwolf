<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

8-bit programmable countdown timer. `ui_in` sets the preset value, `uio[0]` (load) loads it into an 8-bit down-counter, `uio[1]` (run) enables counting. An internal prescaler divides the input clock (DIV=10 for simulation, increase for silicon) to make a visible tick. `uo_out` shows the current count, `uio[2]` (done) goes high when count reaches zero and stays high until a new value is loaded.

## How to test

1. Reset with `rst_n=0`, check `count=0` and `done=1`.
2. Put e.g. `5` on `ui_in`, pulse `load=1` for 1 cycle, check `uo_out=5`.
3. Set `load=0, run=1`, wait `5*DIV` clocks, check `uo_out` counts down `5,4,3,2,1,0`.
4. Check `done` on `uio[2]` goes high at zero. Deassert `run` to pause mid-count and verify count holds.

## External hardware

None. LEDs on `uo_out[7:0]` to view count and `uio[2]` for done are enough.

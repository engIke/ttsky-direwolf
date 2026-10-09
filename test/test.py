# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_timer(dut):
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())
    dut.ena.value = 1
    dut.rst_n.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1

    # Load 5
    dut.ui_in.value = 5
    dut.uio_in.value = 0b01  # load=1
    await ClockCycles(dut.clk, 1)
    dut.uio_in.value = 0b10  # load=0, run=1

    # wait: 5 counts * DIV(10) = 50 cycles + margin
    await ClockCycles(dut.clk, 60)
    assert int(dut.uo_out.value) == 0
    assert (int(dut.uio_out.value) & 1) == 1  # done

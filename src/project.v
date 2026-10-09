/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
wire _unused = &{ena, uio_in[7:3], uio_in[2], 1'b0};
wire load = uio_in[0];
wire run = uio_in[1];

reg [7:0] count;
reg [15:0] prescale;
//DIV=10 for sim so you can see it count fast.
// For real HW change to e.g 50000 for 1kHz from 50MHz
parameter DIV = 10;

wire tick = (prescale == DIV-1);

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    count <=0;
    prescale <=0;
  end else begin 
    if (load) begin
      count <= ui_in;
      prescale <=0;
    end else if (run && (count !=0)) begin
      if (tick) begin
        count <= count -1;
        prescale <=0;
      end else prescale <= prescale + 1;
    end
  end
end

  assign uo_out = count;
  assign uio_out = {5'b0, (count == 8'd0), 2'b0}; // done on uio[2]
  assign uio_oe = 8'b00000100; // only uio[2] is output, uio[0,1] are inputs
endmodule 
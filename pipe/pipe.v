// --------------------------------------------------------------------
// Verilog representation of PIPE processor
// --------------------------------------------------------------------

// --------------------------------------------------------------------
// Memory module for implementing bank memories
// --------------------------------------------------------------------
// This module implements a dual-ported RAM.
// with clocked write and read operations.

module ram(clock, addrA, wEnA, wDatA, rEnA, rDatA,
addrB, wEnB, wDatB, rEnB, rDatB);

parameter wordsize = 8; // Number of bits per word
parameter wordcount = 512; // Number of words in memory
// Number of address bits. Must be >= log wordcount
parameter addrsize = 9;


input clock; // Clock
// Port A
input [addrsize-1:0] addrA; // Read/write address
input wEnA; // Write enable
input [wordsize-1:0] wDatA; // Write data

input rEnA; // Read enable
output [wordsize-1:0] rDatA; // Read data
reg [wordsize-1:0] rDatA; //= line:arch:synchram:rDatA
// Port B
input [addrsize-1:0] addrB; // Read/write address
input wEnB; // Write enable
input [wordsize-1:0] wDatB; // Write data
input rEnB; // Read enable
output [wordsize-1:0] rDatB; // Read data
reg [wordsize-1:0] rDatB; //= line:arch:synchram:rDatB

reg[wordsize-1:0] mem[wordcount-1:0]; // Actual storage

// To make the pipeline processor work with synchronous reads, we
// operate the memory read operations on the negative
// edge of the clock. That makes the reading occur in the middle
// of the clock cycle---after the address inputs have been set
// and such that the results read from the memory can flow through
// more combinational logic before reaching the clocked registers

// For uniformity, we also make the memory write operation
// occur on the negative edge of the clock. That works OK
// in this design, because the write can occur as soon as the
// address & data inputs have been set.
always @(negedge clock)
begin
if (wEnA)
begin
mem[addrA] <= wDatA;
end
if (rEnA)
rDatA <= mem[addrA]; //= line:arch:synchram:readA
end

always @(negedge clock)
begin
if (wEnB)
begin
mem[addrB] <= wDatB;
end
if (rEnB)
rDatB <= mem[addrB]; //= line:arch:synchram:readB
end
endmodule

// --------------------------------------------------------------------
// Other building blocks
// --------------------------------------------------------------------

// Basic building blocks for constructing a Y86-64 processor.


// Different types of registers, all derivatives of module cenrreg

// Clocked register with enable signal and synchronous reset
// Default width is 8, but can be overriden
module cenrreg(out, in, enable, reset, resetval, clock);
parameter width = 8;
output [width-1:0] out;
reg [width-1:0] out;
input [width-1:0] in;
input enable;
input reset;
input [width-1:0] resetval;
input clock;

always
@(posedge clock)
begin
if (reset)
out <= resetval;
else if (enable)
out <= in;
end
endmodule

// Clocked register with enable signal.
// Default width is 8, but can be overriden
module cenreg(out, in, enable, clock);
parameter width = 8;
output [width-1:0] out;
input [width-1:0] in;
input enable;
input clock;

cenrreg #(width) c(out, in, enable, 1’b0, 8’b0, clock);
endmodule

// Basic clocked register. Default width is 8.
module creg(out, in, clock);
parameter width = 8;
output [width-1:0] out;
input [width-1:0] in;
input clock;

cenreg #(width) r(out, in, 1’b1, clock);
endmodule

// Pipeline register. Uses reset signal to inject bubble
// When bubbling, must specify value that will be loaded
module preg(out, in, stall, bubble, bubbleval, clock);

parameter width = 8;
output [width-1:0] out;
input [width-1:0] in;
input stall, bubble;
input [width-1:0] bubbleval;
input clock;

cenrreg #(width) r(out, in, ˜stall, bubble, bubbleval, clock);
endmodule

// Register file
module regfile(dstE, valE, dstM, valM, srcA, valA, srcB, valB, reset, clock,
rax, rcx, rdx, rbx, rsp, rbp, rsi, rdi,
r8, r9, r10, r11, r12, r13, r14);
input [ 3:0] dstE;
input [63:0] valE;
input [ 3:0] dstM;
input [63:0] valM;
input [ 3:0] srcA;
output [63:0] valA;
input [ 3:0] srcB;
output [63:0] valB;
input reset; // Set registers to 0
input clock;
// Make individual registers visible for debugging
output [63:0] rax, rcx, rdx, rbx, rsp, rbp, rsi, rdi,
r8, r9, r10, r11, r12, r13, r14;

// Define names for registers used in HCL code
parameter RRAX = 4’h0;
parameter RRCX = 4’h1;
parameter RRDX = 4’h2;
parameter RRBX = 4’h3;
parameter RRSP = 4’h4;
parameter RRBP = 4’h5;
parameter RRSI = 4’h6;
parameter RRDI = 4’h7;
parameter R8 = 4’h8;
parameter R9 = 4’h9;
parameter R10 = 4’ha;
parameter R11 = 4’hb;
parameter R12 = 4’hc;
parameter R13 = 4’hd;
parameter R14 = 4’he;
parameter RNONE = 4’hf;

// Input data for each register
wire [63:0] rax_dat, rcx_dat, rdx_dat, rbx_dat,
rsp_dat, rbp_dat, rsi_dat, rdi_dat,
r8_dat, r9_dat, r10_dat, r11_dat,

r12_dat, r13_dat, r14_dat;

// Input write controls for each register
wire rax_wrt, rcx_wrt, rdx_wrt, rbx_wrt,
rsp_wrt, rbp_wrt, rsi_wrt, rdi_wrt,
r8_wrt, r9_wrt, r10_wrt, r11_wrt,
r12_wrt, r13_wrt, r14_wrt;


// Implement with clocked registers
cenrreg #(64) rax_reg(rax, rax_dat, rax_wrt, reset, 64’b0, clock);
cenrreg #(64) rcx_reg(rcx, rcx_dat, rcx_wrt, reset, 64’b0, clock);
cenrreg #(64) rdx_reg(rdx, rdx_dat, rdx_wrt, reset, 64’b0, clock);
cenrreg #(64) rbx_reg(rbx, rbx_dat, rbx_wrt, reset, 64’b0, clock);
cenrreg #(64) rsp_reg(rsp, rsp_dat, rsp_wrt, reset, 64’b0, clock);
cenrreg #(64) rbp_reg(rbp, rbp_dat, rbp_wrt, reset, 64’b0, clock);
cenrreg #(64) rsi_reg(rsi, rsi_dat, rsi_wrt, reset, 64’b0, clock);
cenrreg #(64) rdi_reg(rdi, rdi_dat, rdi_wrt, reset, 64’b0, clock);
cenrreg #(64) r8_reg(r8, r8_dat, r8_wrt, reset, 64’b0, clock);
cenrreg #(64) r9_reg(r9, r9_dat, r9_wrt, reset, 64’b0, clock);
cenrreg #(64) r10_reg(r10, r10_dat, r10_wrt, reset, 64’b0, clock);
cenrreg #(64) r11_reg(r11, r11_dat, r11_wrt, reset, 64’b0, clock);
cenrreg #(64) r12_reg(r12, r12_dat, r12_wrt, reset, 64’b0, clock);
cenrreg #(64) r13_reg(r13, r13_dat, r13_wrt, reset, 64’b0, clock);
cenrreg #(64) r14_reg(r14, r14_dat, r14_wrt, reset, 64’b0, clock);

// Reads occur like combinational logic
assign valA =
srcA == RRAX ? rax :
srcA == RRCX ? rcx :
srcA == RRDX ? rdx :
srcA == RRBX ? rbx :
srcA == RRSP ? rsp :
srcA == RRBP ? rbp :
srcA == RRSI ? rsi :
srcA == RRDI ? rdi :
srcA == R8 ? r8 :
srcA == R9 ? r9 :
srcA == R10 ? r10 :
srcA == R11 ? r11 :
srcA == R12 ? r12 :
srcA == R13 ? r13 :
srcA == R14 ? r14 :
0;

assign valB =
srcB == RRAX ? rax :
srcB == RRCX ? rcx :
srcB == RRDX ? rdx :
srcB == RRBX ? rbx :

srcB == RRSP ? rsp :
srcB == RRBP ? rbp :
srcB == RRSI ? rsi :
srcB == RRDI ? rdi :
srcB == R8 ? r8 :
srcB == R9 ? r9 :
srcB == R10 ? r10 :
srcB == R11 ? r11 :
srcB == R12 ? r12 :
srcB == R13 ? r13 :
srcB == R14 ? r14 :
0;

assign rax_dat = dstM == RRAX ? valM : valE;
assign rcx_dat = dstM == RRCX ? valM : valE;
assign rdx_dat = dstM == RRDX ? valM : valE;
assign rbx_dat = dstM == RRBX ? valM : valE;
assign rsp_dat = dstM == RRSP ? valM : valE;
assign rbp_dat = dstM == RRBP ? valM : valE;
assign rsi_dat = dstM == RRSI ? valM : valE;
assign rdi_dat = dstM == RRDI ? valM : valE;
assign r8_dat = dstM == R8 ? valM : valE;
assign r9_dat = dstM == R9 ? valM : valE;
assign r10_dat = dstM == R10 ? valM : valE;
assign r11_dat = dstM == R11 ? valM : valE;
assign r12_dat = dstM == R12 ? valM : valE;
assign r13_dat = dstM == R13 ? valM : valE;
assign r14_dat = dstM == R14 ? valM : valE;

assign rax_wrt = dstM == RRAX | dstE == RRAX;
assign rcx_wrt = dstM == RRCX | dstE == RRCX;
assign rdx_wrt = dstM == RRDX | dstE == RRDX;
assign rbx_wrt = dstM == RRBX | dstE == RRBX;
assign rsp_wrt = dstM == RRSP | dstE == RRSP;
assign rbp_wrt = dstM == RRBP | dstE == RRBP;
assign rsi_wrt = dstM == RRSI | dstE == RRSI;
assign rdi_wrt = dstM == RRDI | dstE == RRDI;
assign r8_wrt = dstM == R8 | dstE == R8;
assign r9_wrt = dstM == R9 | dstE == R9;
assign r10_wrt = dstM == R10 | dstE == R10;
assign r11_wrt = dstM == R11 | dstE == R11;
assign r12_wrt = dstM == R12 | dstE == R12;
assign r13_wrt = dstM == R13 | dstE == R13;
assign r14_wrt = dstM == R14 | dstE == R14;


endmodule

// Memory. This memory design uses 16 memory banks, each
// of which is one byte wide. Banking allows us to select an

// arbitrary set of 10 contiguous bytes for instruction reading
// and an arbitrary set of 8 contiguous bytes
// for data reading & writing.
// It uses an external RAM module from either the file
// combram.v (using combinational reads)
// or synchram.v (using clocked reads)
// The SEQ & SEQ+ processors only work with combram.v.
// PIPE works with either.

module bmemory(maddr, wenable, wdata, renable, rdata, m_ok,
iaddr, instr, i_ok, clock);
parameter memsize = 8192; // Number of bytes in memory
input [63:0] maddr; // Read/Write address
input wenable; // Write enable
input [63:0] wdata; // Write data
input renable; // Read enable
output [63:0] rdata; // Read data
output m_ok; // Read & write addresses within range
input [63:0] iaddr; // Instruction address
output [79:0] instr; // 10 bytes of instruction
output i_ok; // Instruction address within range
input clock;

// Instruction bytes
wire [ 7:0] ib0, ib1, ib2, ib3, ib4, ib5, ib6, ib7, ib8, ib9;
// Data bytes
wire [ 7:0] db0, db1, db2, db3, db4, db5, db6, db7;

wire [ 3:0] ibid = iaddr[3:0]; // Instruction Bank ID
wire [59:0] iindex = iaddr[63:4]; // Address within bank
wire [59:0] iip1 = iindex+1; // Next address within bank

wire [ 3:0] mbid = maddr[3:0]; // Data Bank ID
wire [59:0] mindex = maddr[63:4]; // Address within bank
wire [59:0] mip1 = mindex+1; // Next address within bank

// Instruction addresses for each bank
wire [59:0] addrI0, addrI1, addrI2, addrI3, addrI4, addrI5, addrI6, addrI7,
addrI8, addrI9, addrI10, addrI11, addrI12, addrI13, addrI14,
addrI15;
// Instruction data for each bank
wire [ 7:0] outI0, outI1, outI2, outI3, outI4, outI5, outI6, outI7,
outI8, outI9, outI10, outI11, outI12, outI13, outI14, outI15;

// Data addresses for each bank
wire [59:0] addrD0, addrD1, addrD2, addrD3, addrD4, addrD5, addrD6, addrD7,
addrD8, addrD9, addrD10, addrD11, addrD12, addrD13, addrD14,
addrD15;

// Data output for each bank

wire [ 7:0] outD0, outD1, outD2, outD3, outD4, outD5, outD6, outD7,
outD8, outD9, outD10, outD11, outD12, outD13, outD14, outD15;

// Data input for each bank
wire [ 7:0] inD0, inD1, inD2, inD3, inD4, inD5, inD6, inD7,
inD8, inD9, inD10, inD11, inD12, inD13, inD14, inD15;

// Data write enable signals for each bank
wire dwEn0, dwEn1, dwEn2, dwEn3, dwEn4, dwEn5, dwEn6, dwEn7,
dwEn8, dwEn9, dwEn10, dwEn11, dwEn12, dwEn13, dwEn14, dwEn15;

// The bank memories
ram #(8, memsize/16, 60) bank0(clock,
addrI0, 1’b0, 8’b0, 1’b1, outI0, // Instruction
addrD0, dwEn0, inD0, renable, outD0); // Data

ram #(8, memsize/16, 60) bank1(clock,
addrI1, 1’b0, 8’b0, 1’b1, outI1, // Instruction
addrD1, dwEn1, inD1, renable, outD1); // Data

ram #(8, memsize/16, 60) bank2(clock,
addrI2, 1’b0, 8’b0, 1’b1, outI2, // Instruction
addrD2, dwEn2, inD2, renable, outD2); // Data

ram #(8, memsize/16, 60) bank3(clock,
addrI3, 1’b0, 8’b0, 1’b1, outI3, // Instruction
addrD3, dwEn3, inD3, renable, outD3); // Data

ram #(8, memsize/16, 60) bank4(clock,
addrI4, 1’b0, 8’b0, 1’b1, outI4, // Instruction
addrD4, dwEn4, inD4, renable, outD4); // Data

ram #(8, memsize/16, 60) bank5(clock,
addrI5, 1’b0, 8’b0, 1’b1, outI5, // Instruction
addrD5, dwEn5, inD5, renable, outD5); // Data

ram #(8, memsize/16, 60) bank6(clock,
addrI6, 1’b0, 8’b0, 1’b1, outI6, // Instruction
addrD6, dwEn6, inD6, renable, outD6); // Data

ram #(8, memsize/16, 60) bank7(clock,
addrI7, 1’b0, 8’b0, 1’b1, outI7, // Instruction
addrD7, dwEn7, inD7, renable, outD7); // Data

ram #(8, memsize/16, 60) bank8(clock,
addrI8, 1’b0, 8’b0, 1’b1, outI8, // Instruction
addrD8, dwEn8, inD8, renable, outD8); // Data

ram #(8, memsize/16, 60) bank9(clock,
addrI9, 1’b0, 8’b0, 1’b1, outI9, // Instruction

addrD9, dwEn9, inD9, renable, outD9); // Data

ram #(8, memsize/16, 60) bank10(clock,
addrI10, 1’b0, 8’b0, 1’b1, outI10, // Instruction
addrD10, dwEn10, inD10, renable, outD10); // Data

ram #(8, memsize/16, 60) bank11(clock,
addrI11, 1’b0, 8’b0, 1’b1, outI11, // Instruction
addrD11, dwEn11, inD11, renable, outD11); // Data

ram #(8, memsize/16, 60) bank12(clock,
addrI12, 1’b0, 8’b0, 1’b1, outI12, // Instruction
addrD12, dwEn12, inD12, renable, outD12); // Data

ram #(8, memsize/16, 60) bank13(clock,
addrI13, 1’b0, 8’b0, 1’b1, outI13, // Instruction
addrD13, dwEn13, inD13, renable, outD13); // Data

ram #(8, memsize/16, 60) bank14(clock,
addrI14, 1’b0, 8’b0, 1’b1, outI14, // Instruction
addrD14, dwEn14, inD14, renable, outD14); // Data

ram #(8, memsize/16, 60) bank15(clock,
addrI15, 1’b0, 8’b0, 1’b1, outI15, // Instruction
addrD15, dwEn15, inD15, renable, outD15); // Data


// Determine the instruction addresses for the banks
assign addrI0 = ibid >= 7 ? iip1 : iindex;
assign addrI1 = ibid >= 8 ? iip1 : iindex;
assign addrI2 = ibid >= 9 ? iip1 : iindex;
assign addrI3 = ibid >= 10 ? iip1 : iindex;
assign addrI4 = ibid >= 11 ? iip1 : iindex;
assign addrI5 = ibid >= 12 ? iip1 : iindex;
assign addrI6 = ibid >= 13 ? iip1 : iindex;
assign addrI7 = ibid >= 14 ? iip1 : iindex;
assign addrI8 = ibid >= 15 ? iip1 : iindex;
assign addrI9 = iindex;
assign addrI10 = iindex;
assign addrI11 = iindex;
assign addrI12 = iindex;
assign addrI13 = iindex;
assign addrI14 = iindex;
assign addrI15 = iindex;


// Get the bytes of the instruction
assign i_ok =
(iaddr + 9) < memsize;


assign ib0 = !i_ok ? 0 :
ibid == 0 ? outI0 :
ibid == 1 ? outI1 :
ibid == 2 ? outI2 :
ibid == 3 ? outI3 :
ibid == 4 ? outI4 :
ibid == 5 ? outI5 :
ibid == 6 ? outI6 :
ibid == 7 ? outI7 :
ibid == 8 ? outI8 :
ibid == 9 ? outI9 :
ibid == 10 ? outI10 :
ibid == 11 ? outI11 :
ibid == 12 ? outI12 :
ibid == 13 ? outI13 :
ibid == 14 ? outI14 :
outI15;
assign ib1 = !i_ok ? 0 :
ibid == 0 ? outI1 :
ibid == 1 ? outI2 :
ibid == 2 ? outI3 :
ibid == 3 ? outI4 :
ibid == 4 ? outI5 :
ibid == 5 ? outI6 :
ibid == 6 ? outI7 :
ibid == 7 ? outI8 :
ibid == 8 ? outI9 :
ibid == 9 ? outI10 :
ibid == 10 ? outI11 :
ibid == 11 ? outI12 :
ibid == 12 ? outI13 :
ibid == 13 ? outI14 :
ibid == 14 ? outI15 :
outI0;
assign ib2 = !i_ok ? 0 :
ibid == 0 ? outI2 :
ibid == 1 ? outI3 :
ibid == 2 ? outI4 :
ibid == 3 ? outI5 :
ibid == 4 ? outI6 :
ibid == 5 ? outI7 :
ibid == 6 ? outI8 :
ibid == 7 ? outI9 :
ibid == 8 ? outI10 :
ibid == 9 ? outI11 :
ibid == 10 ? outI12 :
ibid == 11 ? outI13 :
ibid == 12 ? outI14 :
ibid == 13 ? outI15 :
ibid == 14 ? outI0 :

outI1;
assign ib3 = !i_ok ? 0 :
ibid == 0 ? outI3 :
ibid == 1 ? outI4 :
ibid == 2 ? outI5 :
ibid == 3 ? outI6 :
ibid == 4 ? outI7 :
ibid == 5 ? outI8 :
ibid == 6 ? outI9 :
ibid == 7 ? outI10 :
ibid == 8 ? outI11 :
ibid == 9 ? outI12 :
ibid == 10 ? outI13 :
ibid == 11 ? outI14 :
ibid == 12 ? outI15 :
ibid == 13 ? outI0 :
ibid == 14 ? outI1 :
outI2;
assign ib4 = !i_ok ? 0 :
ibid == 0 ? outI4 :
ibid == 1 ? outI5 :
ibid == 2 ? outI6 :
ibid == 3 ? outI7 :
ibid == 4 ? outI8 :
ibid == 5 ? outI9 :
ibid == 6 ? outI10 :
ibid == 7 ? outI11 :
ibid == 8 ? outI12 :
ibid == 9 ? outI13 :
ibid == 10 ? outI14 :
ibid == 11 ? outI15 :
ibid == 12 ? outI0 :
ibid == 13 ? outI1 :
ibid == 14 ? outI2 :
outI3;
assign ib5 = !i_ok ? 0 :
ibid == 0 ? outI5 :
ibid == 1 ? outI6 :
ibid == 2 ? outI7 :
ibid == 3 ? outI8 :
ibid == 4 ? outI9 :
ibid == 5 ? outI10 :
ibid == 6 ? outI11 :
ibid == 7 ? outI12 :
ibid == 8 ? outI13 :
ibid == 9 ? outI14 :
ibid == 10 ? outI15 :
ibid == 11 ? outI0 :
ibid == 12 ? outI1 :
ibid == 13 ? outI2 :

ibid == 14 ? outI3 :
outI4;
assign ib6 = !i_ok ? 0 :
ibid == 0 ? outI6 :
ibid == 1 ? outI7 :
ibid == 2 ? outI8 :
ibid == 3 ? outI9 :
ibid == 4 ? outI10 :
ibid == 5 ? outI11 :
ibid == 6 ? outI12 :
ibid == 7 ? outI13 :
ibid == 8 ? outI14 :
ibid == 9 ? outI15 :
ibid == 10 ? outI0 :
ibid == 11 ? outI1 :
ibid == 12 ? outI2 :
ibid == 13 ? outI3 :
ibid == 14 ? outI4 :
outI5;
assign ib7 = !i_ok ? 0 :
ibid == 0 ? outI7 :
ibid == 1 ? outI8 :
ibid == 2 ? outI9 :
ibid == 3 ? outI10 :
ibid == 4 ? outI11 :
ibid == 5 ? outI12 :
ibid == 6 ? outI13 :
ibid == 7 ? outI14 :
ibid == 8 ? outI15 :
ibid == 9 ? outI0 :
ibid == 10 ? outI1 :
ibid == 11 ? outI2 :
ibid == 12 ? outI3 :
ibid == 13 ? outI4 :
ibid == 14 ? outI5 :
outI6;
assign ib8 = !i_ok ? 0 :
ibid == 0 ? outI8 :
ibid == 1 ? outI9 :
ibid == 2 ? outI10 :
ibid == 3 ? outI11 :
ibid == 4 ? outI12 :
ibid == 5 ? outI13 :
ibid == 6 ? outI14 :
ibid == 7 ? outI15 :
ibid == 8 ? outI0 :
ibid == 9 ? outI1 :
ibid == 10 ? outI2 :
ibid == 11 ? outI3 :
ibid == 12 ? outI4 :

ibid == 13 ? outI5 :
ibid == 14 ? outI6 :
outI7;
assign ib9 = !i_ok ? 0 :
ibid == 0 ? outI9 :
ibid == 1 ? outI10 :
ibid == 2 ? outI11 :
ibid == 3 ? outI12 :
ibid == 4 ? outI13 :
ibid == 5 ? outI14 :
ibid == 6 ? outI15 :
ibid == 7 ? outI0 :
ibid == 8 ? outI1 :
ibid == 9 ? outI2 :
ibid == 10 ? outI3 :
ibid == 11 ? outI4 :
ibid == 12 ? outI5 :
ibid == 13 ? outI6 :
ibid == 14 ? outI7 :
outI8;

assign instr[ 7: 0] = ib0;
assign instr[15: 8] = ib1;
assign instr[23:16] = ib2;
assign instr[31:24] = ib3;
assign instr[39:32] = ib4;
assign instr[47:40] = ib5;
assign instr[55:48] = ib6;
assign instr[63:56] = ib7;
assign instr[71:64] = ib8;
assign instr[79:72] = ib9;

assign m_ok =
(!renable & !wenable | (maddr + 7) < memsize);

assign addrD0 = mbid >= 9 ? mip1 : mindex;
assign addrD1 = mbid >= 10 ? mip1 : mindex;
assign addrD2 = mbid >= 11 ? mip1 : mindex;
assign addrD3 = mbid >= 12 ? mip1 : mindex;
assign addrD4 = mbid >= 13 ? mip1 : mindex;
assign addrD5 = mbid >= 14 ? mip1 : mindex;
assign addrD6 = mbid >= 15 ? mip1 : mindex;
assign addrD7 = mindex;
assign addrD8 = mindex;
assign addrD9 = mindex;
assign addrD10 = mindex;
assign addrD11 = mindex;
assign addrD12 = mindex;
assign addrD13 = mindex;
assign addrD14 = mindex;

assign addrD15 = mindex;

// Get the bytes of data;
assign db0 = !m_ok ? 0 :
mbid == 0 ? outD0 :
mbid == 1 ? outD1 :
mbid == 2 ? outD2 :
mbid == 3 ? outD3 :
mbid == 4 ? outD4 :
mbid == 5 ? outD5 :
mbid == 6 ? outD6 :
mbid == 7 ? outD7 :
mbid == 8 ? outD8 :
mbid == 9 ? outD9 :
mbid == 10 ? outD10 :
mbid == 11 ? outD11 :
mbid == 12 ? outD12 :
mbid == 13 ? outD13 :
mbid == 14 ? outD14 :
outD15;
assign db1 = !m_ok ? 0 :
mbid == 0 ? outD1 :
mbid == 1 ? outD2 :
mbid == 2 ? outD3 :
mbid == 3 ? outD4 :
mbid == 4 ? outD5 :
mbid == 5 ? outD6 :
mbid == 6 ? outD7 :
mbid == 7 ? outD8 :
mbid == 8 ? outD9 :
mbid == 9 ? outD10 :
mbid == 10 ? outD11 :
mbid == 11 ? outD12 :
mbid == 12 ? outD13 :
mbid == 13 ? outD14 :
mbid == 14 ? outD15 :
outD0;
assign db2 = !m_ok ? 0 :
mbid == 0 ? outD2 :
mbid == 1 ? outD3 :
mbid == 2 ? outD4 :
mbid == 3 ? outD5 :
mbid == 4 ? outD6 :
mbid == 5 ? outD7 :
mbid == 6 ? outD8 :
mbid == 7 ? outD9 :
mbid == 8 ? outD10 :
mbid == 9 ? outD11 :
mbid == 10 ? outD12 :
mbid == 11 ? outD13 :

mbid == 12 ? outD14 :
mbid == 13 ? outD15 :
mbid == 14 ? outD0 :
outD1;
assign db3 = !m_ok ? 0 :
mbid == 0 ? outD3 :
mbid == 1 ? outD4 :
mbid == 2 ? outD5 :
mbid == 3 ? outD6 :
mbid == 4 ? outD7 :
mbid == 5 ? outD8 :
mbid == 6 ? outD9 :
mbid == 7 ? outD10 :
mbid == 8 ? outD11 :
mbid == 9 ? outD12 :
mbid == 10 ? outD13 :
mbid == 11 ? outD14 :
mbid == 12 ? outD15 :
mbid == 13 ? outD0 :
mbid == 14 ? outD1 :
outD2;
assign db4 = !m_ok ? 0 :
mbid == 0 ? outD4 :
mbid == 1 ? outD5 :
mbid == 2 ? outD6 :
mbid == 3 ? outD7 :
mbid == 4 ? outD8 :
mbid == 5 ? outD9 :
mbid == 6 ? outD10 :
mbid == 7 ? outD11 :
mbid == 8 ? outD12 :
mbid == 9 ? outD13 :
mbid == 10 ? outD14 :
mbid == 11 ? outD15 :
mbid == 12 ? outD0 :
mbid == 13 ? outD1 :
mbid == 14 ? outD2 :
outD3;
assign db5 = !m_ok ? 0 :
mbid == 0 ? outD5 :
mbid == 1 ? outD6 :
mbid == 2 ? outD7 :
mbid == 3 ? outD8 :
mbid == 4 ? outD9 :
mbid == 5 ? outD10 :
mbid == 6 ? outD11 :
mbid == 7 ? outD12 :
mbid == 8 ? outD13 :
mbid == 9 ? outD14 :
mbid == 10 ? outD15 :

mbid == 11 ? outD0 :
mbid == 12 ? outD1 :
mbid == 13 ? outD2 :
mbid == 14 ? outD3 :
outD4;
assign db6 = !m_ok ? 0 :
mbid == 0 ? outD6 :
mbid == 1 ? outD7 :
mbid == 2 ? outD8 :
mbid == 3 ? outD9 :
mbid == 4 ? outD10 :
mbid == 5 ? outD11 :
mbid == 6 ? outD12 :
mbid == 7 ? outD13 :
mbid == 8 ? outD14 :
mbid == 9 ? outD15 :
mbid == 10 ? outD0 :
mbid == 11 ? outD1 :
mbid == 12 ? outD2 :
mbid == 13 ? outD3 :
mbid == 14 ? outD4 :
outD5;
assign db7 = !m_ok ? 0 :
mbid == 0 ? outD7 :
mbid == 1 ? outD8 :
mbid == 2 ? outD9 :
mbid == 3 ? outD10 :
mbid == 4 ? outD11 :
mbid == 5 ? outD12 :
mbid == 6 ? outD13 :
mbid == 7 ? outD14 :
mbid == 8 ? outD15 :
mbid == 9 ? outD0 :
mbid == 10 ? outD1 :
mbid == 11 ? outD2 :
mbid == 12 ? outD3 :
mbid == 13 ? outD4 :
mbid == 14 ? outD5 :
outD6;

assign rdata[ 7: 0] = db0;
assign rdata[15: 8] = db1;
assign rdata[23:16] = db2;
assign rdata[31:24] = db3;
assign rdata[39:32] = db4;
assign rdata[47:40] = db5;
assign rdata[55:48] = db6;
assign rdata[63:56] = db7;

wire [7:0] wd0 = wdata[ 7: 0];

wire [7:0] wd1 = wdata[15: 8];
wire [7:0] wd2 = wdata[23:16];
wire [7:0] wd3 = wdata[31:24];
wire [7:0] wd4 = wdata[39:32];
wire [7:0] wd5 = wdata[47:40];
wire [7:0] wd6 = wdata[55:48];
wire [7:0] wd7 = wdata[63:56];

assign inD0 =
mbid == 9 ? wd7 :
mbid == 10 ? wd6 :
mbid == 11 ? wd5 :
mbid == 12 ? wd4 :
mbid == 13 ? wd3 :
mbid == 14 ? wd2 :
mbid == 15 ? wd1 :
mbid == 0 ? wd0 :
0;

assign inD1 =
mbid == 10 ? wd7 :
mbid == 11 ? wd6 :
mbid == 12 ? wd5 :
mbid == 13 ? wd4 :
mbid == 14 ? wd3 :
mbid == 15 ? wd2 :
mbid == 0 ? wd1 :
mbid == 1 ? wd0 :
0;

assign inD2 =
mbid == 11 ? wd7 :
mbid == 12 ? wd6 :
mbid == 13 ? wd5 :
mbid == 14 ? wd4 :
mbid == 15 ? wd3 :
mbid == 0 ? wd2 :
mbid == 1 ? wd1 :
mbid == 2 ? wd0 :
0;

assign inD3 =
mbid == 12 ? wd7 :
mbid == 13 ? wd6 :
mbid == 14 ? wd5 :
mbid == 15 ? wd4 :
mbid == 0 ? wd3 :
mbid == 1 ? wd2 :
mbid == 2 ? wd1 :
mbid == 3 ? wd0 :

0;

assign inD4 =
mbid == 13 ? wd7 :
mbid == 14 ? wd6 :
mbid == 15 ? wd5 :
mbid == 0 ? wd4 :
mbid == 1 ? wd3 :
mbid == 2 ? wd2 :
mbid == 3 ? wd1 :
mbid == 4 ? wd0 :
0;

assign inD5 =
mbid == 14 ? wd7 :
mbid == 15 ? wd6 :
mbid == 0 ? wd5 :
mbid == 1 ? wd4 :
mbid == 2 ? wd3 :
mbid == 3 ? wd2 :
mbid == 4 ? wd1 :
mbid == 5 ? wd0 :
0;

assign inD6 =
mbid == 15 ? wd7 :
mbid == 0 ? wd6 :
mbid == 1 ? wd5 :
mbid == 2 ? wd4 :
mbid == 3 ? wd3 :
mbid == 4 ? wd2 :
mbid == 5 ? wd1 :
mbid == 6 ? wd0 :
0;

assign inD7 =
mbid == 0 ? wd7 :
mbid == 1 ? wd6 :
mbid == 2 ? wd5 :
mbid == 3 ? wd4 :
mbid == 4 ? wd3 :
mbid == 5 ? wd2 :
mbid == 6 ? wd1 :
mbid == 7 ? wd0 :
0;

assign inD8 =
mbid == 1 ? wd7 :
mbid == 2 ? wd6 :
mbid == 3 ? wd5 :

mbid == 4 ? wd4 :
mbid == 5 ? wd3 :
mbid == 6 ? wd2 :
mbid == 7 ? wd1 :
mbid == 8 ? wd0 :
0;

assign inD9 =
mbid == 2 ? wd7 :
mbid == 3 ? wd6 :
mbid == 4 ? wd5 :
mbid == 5 ? wd4 :
mbid == 6 ? wd3 :
mbid == 7 ? wd2 :
mbid == 8 ? wd1 :
mbid == 9 ? wd0 :
0;

assign inD10 =
mbid == 3 ? wd7 :
mbid == 4 ? wd6 :
mbid == 5 ? wd5 :
mbid == 6 ? wd4 :
mbid == 7 ? wd3 :
mbid == 8 ? wd2 :
mbid == 9 ? wd1 :
mbid == 10 ? wd0 :
0;

assign inD11 =
mbid == 4 ? wd7 :
mbid == 5 ? wd6 :
mbid == 6 ? wd5 :
mbid == 7 ? wd4 :
mbid == 8 ? wd3 :
mbid == 9 ? wd2 :
mbid == 10 ? wd1 :
mbid == 11 ? wd0 :
0;

assign inD12 =
mbid == 5 ? wd7 :
mbid == 6 ? wd6 :
mbid == 7 ? wd5 :
mbid == 8 ? wd4 :
mbid == 9 ? wd3 :
mbid == 10 ? wd2 :
mbid == 11 ? wd1 :
mbid == 12 ? wd0 :
0;


assign inD13 =
mbid == 6 ? wd7 :
mbid == 7 ? wd6 :
mbid == 8 ? wd5 :
mbid == 9 ? wd4 :
mbid == 10 ? wd3 :
mbid == 11 ? wd2 :
mbid == 12 ? wd1 :
mbid == 13 ? wd0 :
0;

assign inD14 =
mbid == 7 ? wd7 :
mbid == 8 ? wd6 :
mbid == 9 ? wd5 :
mbid == 10 ? wd4 :
mbid == 11 ? wd3 :
mbid == 12 ? wd2 :
mbid == 13 ? wd1 :
mbid == 14 ? wd0 :
0;

assign inD15 =
mbid == 8 ? wd7 :
mbid == 9 ? wd6 :
mbid == 10 ? wd5 :
mbid == 11 ? wd4 :
mbid == 12 ? wd3 :
mbid == 13 ? wd2 :
mbid == 14 ? wd1 :
mbid == 15 ? wd0 :
0;

// Which banks get written
assign dwEn0 = wenable & (mbid <= 0 | mbid >= 9);
assign dwEn1 = wenable & (mbid <= 1 | mbid >= 10);
assign dwEn2 = wenable & (mbid <= 2 | mbid >= 11);
assign dwEn3 = wenable & (mbid <= 3 | mbid >= 12);
assign dwEn4 = wenable & (mbid <= 4 | mbid >= 13);
assign dwEn5 = wenable & (mbid <= 5 | mbid >= 14);
assign dwEn6 = wenable & (mbid <= 6 | mbid >= 15);
assign dwEn7 = wenable & (mbid <= 7);
assign dwEn8 = wenable & (mbid >= 1 & mbid <= 8);
assign dwEn9 = wenable & (mbid >= 2 & mbid <= 9);
assign dwEn10 = wenable & (mbid >= 3 & mbid <= 10);
assign dwEn11 = wenable & (mbid >= 4 & mbid <= 11);
assign dwEn12 = wenable & (mbid >= 5 & mbid <= 12);
assign dwEn13 = wenable & (mbid >= 6 & mbid <= 13);
assign dwEn14 = wenable & (mbid >= 7 & mbid <= 14);

assign dwEn15 = wenable & (mbid >= 8);

endmodule


// Combinational blocks

// Fetch stage

// Split instruction byte into icode and ifun fields
module split(ibyte, icode, ifun);
input [7:0] ibyte;
output [3:0] icode;
output [3:0] ifun;

assign icode = ibyte[7:4];
assign ifun = ibyte[3:0];
endmodule

// Extract immediate word from 9 bytes of instruction
module align(ibytes, need_regids, rA, rB, valC);
input [71:0] ibytes;
input need_regids;
output [ 3:0] rA;
output [ 3:0] rB;
output [63:0] valC;
assign rA = ibytes[7:4];
assign rB = ibytes[3:0];
assign valC = need_regids ? ibytes[71:8] : ibytes[63:0];
endmodule

// PC incrementer
module pc_increment(pc, need_regids, need_valC, valP);
input [63:0] pc;
input need_regids;
input need_valC;
output [63:0] valP;
assign valP = pc + 1 + 8*need_valC + need_regids;
endmodule

// Execute Stage

// ALU
module alu(aluA, aluB, alufun, valE, new_cc);
input [63:0] aluA, aluB; // Data inputs
input [ 3:0] alufun; // ALU function
output [63:0] valE; // Data Output
output [ 2:0] new_cc; // New values for ZF, SF, OF

parameter ALUADD = 4’h0;

parameter ALUSUB = 4’h1;
parameter ALUAND = 4’h2;
parameter ALUXOR = 4’h3;

assign valE =
alufun == ALUSUB ? aluB - aluA :
alufun == ALUAND ? aluB & aluA :
alufun == ALUXOR ? aluB ˆ aluA :
aluB + aluA;
assign new_cc[2] = (valE == 0); // ZF
assign new_cc[1] = valE[63]; // SF
assign new_cc[0] = // OF
alufun == ALUADD ?
(aluA[63] == aluB[63]) & (aluA[63] != valE[63]) :
alufun == ALUSUB ?
(˜aluA[63] == aluB[63]) & (aluB[63] != valE[63]) :
0;
endmodule


// Condition code register
module cc(cc, new_cc, set_cc, reset, clock);
output[2:0] cc;
input [2:0] new_cc;
input set_cc;
input reset;
input clock;

cenrreg #(3) c(cc, new_cc, set_cc, reset, 3’b100, clock);
endmodule

// branch condition logic
module cond(ifun, cc, Cnd);
input [3:0] ifun;
input [2:0] cc;
output Cnd;

wire zf = cc[2];
wire sf = cc[1];
wire of = cc[0];

// Jump & move conditions.
parameter C_YES = 4’h0;
parameter C_LE = 4’h1;
parameter C_L = 4’h2;
parameter C_E = 4’h3;
parameter C_NE = 4’h4;
parameter C_GE = 4’h5;
parameter C_G = 4’h6;


assign Cnd =
(ifun == C_YES) | //
(ifun == C_LE & ((sfˆof)|zf)) | // <=
(ifun == C_L & (sfˆof)) | // <
(ifun == C_E & zf) | // ==
(ifun == C_NE & ˜zf) | // !=
(ifun == C_GE & (˜sfˆof)) | // >=
(ifun == C_G & (˜sfˆof)&˜zf); // >

endmodule

// --------------------------------------------------------------------
// Processor implementation
// --------------------------------------------------------------------


// The processor can run in 5 different modes:
// RUN: Normal operation
// RESET: Sets PC to 0, clears all pipe registers;
// Initializes condition codes
// DOWNLOAD: Download bytes from controller into memory
// UPLOAD: Upload bytes from memory to controller
// STATUS: Upload other status information to controller

// Processor module
module processor(mode, udaddr, idata, odata, stat, clock);
input [ 2:0] mode; // Signal operating mode to processor
input [63:0] udaddr; // Upload/download address
input [63:0] idata; // Download data word
output [63:0] odata; // Upload data word
output [ 2:0] stat; // Status
input clock; // Clock input

// Define modes
parameter RUN_MODE = 0; // Normal operation
parameter RESET_MODE = 1; // Resetting processor;
parameter DOWNLOAD_MODE = 2; // Transfering to memory
parameter UPLOAD_MODE = 3; // Reading from memory
// Uploading register & other status information
parameter STATUS_MODE = 4;

// Constant values

// Instruction codes
parameter IHALT = 4’h0;
parameter INOP = 4’h1;
parameter IRRMOVQ = 4’h2;
parameter IIRMOVQ = 4’h3;
parameter IRMMOVQ = 4’h4;
parameter IMRMOVQ = 4’h5;

parameter IOPQ = 4’h6;
parameter IJXX = 4’h7;
parameter ICALL = 4’h8;
parameter IRET = 4’h9;
parameter IPUSHQ = 4’hA;
parameter IPOPQ = 4’hB;
parameter IIADDQ = 4’hC;
parameter ILEAVE = 4’hD;
parameter IPOP2 = 4’hE;

// Function codes
parameter FNONE = 4’h0;

// Jump conditions
parameter UNCOND = 4’h0;

// Register IDs
parameter RRSP = 4’h4;
parameter RRBP = 4’h5;
parameter RNONE = 4’hF;

// ALU operations
parameter ALUADD = 4’h0;

// Status conditions
parameter SBUB = 3’h0;
parameter SAOK = 3’h1;
parameter SHLT = 3’h2;
parameter SADR = 3’h3;
parameter SINS = 3’h4;
parameter SPIP = 3’h5;

// Fetch stage signals
wire [63:0] f_predPC, F_predPC, f_pc;
wire f_ok;
wire imem_error;
wire [ 2:0] f_stat;
wire [79:0] f_instr;
wire [ 3:0] imem_icode;
wire [ 3:0] imem_ifun;
wire [ 3:0] f_icode;
wire [ 3:0] f_ifun;
wire [ 3:0] f_rA;
wire [ 3:0] f_rB;
wire [63:0] f_valC;
wire [63:0] f_valP;
wire need_regids;
wire need_valC;
wire instr_valid;
wire F_stall, F_bubble;


// Decode stage signals
wire [ 2:0] D_stat;
wire [63:0] D_pc;
wire [ 3:0] D_icode;
wire [ 3:0] D_ifun;
wire [ 3:0] D_rA;
wire [ 3:0] D_rB;
wire [63:0] D_valC;
wire [63:0] D_valP;

wire [63:0] d_valA;
wire [63:0] d_valB;
wire [63:0] d_rvalA;
wire [63:0] d_rvalB;
wire [ 3:0] d_dstE;
wire [ 3:0] d_dstM;
wire [ 3:0] d_srcA;
wire [ 3:0] d_srcB;
wire D_stall, D_bubble;

// Execute stage signals
wire [ 2:0] E_stat;
wire [63:0] E_pc;
wire [ 3:0] E_icode;
wire [ 3:0] E_ifun;
wire [63:0] E_valC;
wire [63:0] E_valA;
wire [63:0] E_valB;
wire [ 3:0] E_dstE;
wire [ 3:0] E_dstM;
wire [ 3:0] E_srcA;
wire [ 3:0] E_srcB;

wire [63:0] aluA;
wire [63:0] aluB;
wire set_cc;
wire [ 2:0] cc;
wire [ 2:0] new_cc;
wire [ 3:0] alufun;
wire e_Cnd;
wire [63:0] e_valE;
wire [63:0] e_valA;
wire [ 3:0] e_dstE;
wire E_stall, E_bubble;

// Memory stage
wire [ 2:0] M_stat;
wire [63:0] M_pc;
wire [ 3:0] M_icode;

wire [ 3:0] M_ifun;
wire M_Cnd;
wire [63:0] M_valE;
wire [63:0] M_valA;
wire [ 3:0] M_dstE;
wire [ 3:0] M_dstM;

wire [ 2:0] m_stat;
wire [63:0] mem_addr;
wire [63:0] mem_data;
wire mem_read;
wire mem_write;
wire [63:0] m_valM;
wire M_stall, M_bubble;
wire m_ok;

// Write-back stage
wire [ 2:0] W_stat;
wire [63:0] W_pc;
wire [ 3:0] W_icode;
wire [63:0] W_valE;
wire [63:0] W_valM;
wire [ 3:0] W_dstE;
wire [ 3:0] W_dstM;
wire [63:0] w_valE;
wire [63:0] w_valM;
wire [ 3:0] w_dstE;
wire [ 3:0] w_dstM;
wire W_stall, W_bubble;

// Global status
wire [ 2:0] Stat;

// Debugging logic
wire [63:0] rax, rcx, rdx, rbx, rsp, rbp, rsi, rdi,
r8, r9, r10, r11, r12, r13, r14;
wire zf = cc[2];
wire sf = cc[1];
wire of = cc[0];

// Control signals
wire resetting = (mode == RESET_MODE);
wire uploading = (mode == UPLOAD_MODE);
wire downloading = (mode == DOWNLOAD_MODE);
wire running = (mode == RUN_MODE);
wire getting_info = (mode == STATUS_MODE);
// Logic to control resetting of pipeline registers
wire F_reset = F_bubble | resetting;
wire D_reset = D_bubble | resetting;
wire E_reset = E_bubble | resetting;

wire M_reset = M_bubble | resetting;
wire W_reset = W_bubble | resetting;

// Processor status
assign stat = Stat;
// Output data
assign odata =
// When getting status, get either register or special status value
getting_info ?
(udaddr == 0 ? rax :
udaddr == 8 ? rcx :
udaddr == 16 ? rdx :
udaddr == 24 ? rbx :
udaddr == 32 ? rsp :
udaddr == 40 ? rbp :
udaddr == 48 ? rsi :
udaddr == 56 ? rdi :
udaddr == 64 ? r8 :
udaddr == 72 ? r9 :
udaddr == 80 ? r10 :
udaddr == 88 ? r11 :
udaddr == 96 ? r12 :
udaddr == 104 ? r13 :
udaddr == 112 ? r14 :
udaddr == 120 ? cc :
udaddr == 128 ? W_pc : 0)
: m_valM;

// Pipeline registers

// All pipeline registers are implemented with module
// preg(out, in, stall, bubble, bubbleval, clock)
// F Register
preg #(64) F_predPC_reg(F_predPC, f_predPC, F_stall, F_reset, 64’b0, clock);
// D Register
preg #(3) D_stat_reg(D_stat, f_stat, D_stall, D_reset, SBUB, clock);
preg #(64) D_pc_reg(D_pc, f_pc, D_stall, D_reset, 64’b0, clock);
preg #(4) D_icode_reg(D_icode, f_icode, D_stall, D_reset, INOP, clock);
preg #(4) D_ifun_reg(D_ifun, f_ifun, D_stall, D_reset, FNONE, clock);
preg #(4) D_rA_reg(D_rA, f_rA, D_stall, D_reset, RNONE, clock);
preg #(4) D_rB_reg(D_rB, f_rB, D_stall, D_reset, RNONE, clock);
preg #(64) D_valC_reg(D_valC, f_valC, D_stall, D_reset, 64’b0, clock);
preg #(64) D_valP_reg(D_valP, f_valP, D_stall, D_reset, 64’b0, clock);
// E Register
preg #(3) E_stat_reg(E_stat, D_stat, E_stall, E_reset, SBUB, clock);
preg #(64) E_pc_reg(E_pc, D_pc, E_stall, E_reset, 64’b0, clock);
preg #(4) E_icode_reg(E_icode, D_icode, E_stall, E_reset, INOP, clock);
preg #(4) E_ifun_reg(E_ifun, D_ifun, E_stall, E_reset, FNONE, clock);
preg #(64) E_valC_reg(E_valC, D_valC, E_stall, E_reset, 64’b0, clock);
preg #(64) E_valA_reg(E_valA, d_valA, E_stall, E_reset, 64’b0, clock);

preg #(64) E_valB_reg(E_valB, d_valB, E_stall, E_reset, 64’b0, clock);
preg #(4) E_dstE_reg(E_dstE, d_dstE, E_stall, E_reset, RNONE, clock);
preg #(4) E_dstM_reg(E_dstM, d_dstM, E_stall, E_reset, RNONE, clock);
preg #(4) E_srcA_reg(E_srcA, d_srcA, E_stall, E_reset, RNONE, clock);
preg #(4) E_srcB_reg(E_srcB, d_srcB, E_stall, E_reset, RNONE, clock);
// M Register
preg #(3) M_stat_reg(M_stat, E_stat, M_stall, M_reset, SBUB, clock);
preg #(64) M_pc_reg(M_pc, E_pc, M_stall, M_reset, 64’b0, clock);
preg #(4) M_icode_reg(M_icode, E_icode, M_stall, M_reset, INOP, clock);
preg #(4) M_ifun_reg(M_ifun, E_ifun, M_stall, M_reset, FNONE, clock);
preg #(1) M_Cnd_reg(M_Cnd, e_Cnd, M_stall, M_reset, 1’b0, clock);
preg #(64) M_valE_reg(M_valE, e_valE, M_stall, M_reset, 64’b0, clock);
preg #(64) M_valA_reg(M_valA, e_valA, M_stall, M_reset, 64’b0, clock);
preg #(4) M_dstE_reg(M_dstE, e_dstE, M_stall, M_reset, RNONE, clock);
preg #(4) M_dstM_reg(M_dstM, E_dstM, M_stall, M_reset, RNONE, clock);
// W Register
preg #(3) W_stat_reg(W_stat, m_stat, W_stall, W_reset, SBUB, clock);
preg #(64) W_pc_reg(W_pc, M_pc, W_stall, W_reset, 64’b0, clock);
preg #(4) W_icode_reg(W_icode, M_icode, W_stall, W_reset, INOP, clock);
preg #(64) W_valE_reg(W_valE, M_valE, W_stall, W_reset, 64’b0, clock);
preg #(64) W_valM_reg(W_valM, m_valM, W_stall, W_reset, 64’b0, clock);
preg #(4) W_dstE_reg(W_dstE, M_dstE, W_stall, W_reset, RNONE, clock);
preg #(4) W_dstM_reg(W_dstM, M_dstM, W_stall, W_reset, RNONE, clock);

// Fetch stage logic
split split(f_instr[7:0], imem_icode, imem_ifun);
align align(f_instr[79:8], need_regids, f_rA, f_rB, f_valC);
pc_increment pci(f_pc, need_regids, need_valC, f_valP);

// Decode stage
regfile regf(w_dstE, w_valE, w_dstM, w_valM,
d_srcA, d_rvalA, d_srcB, d_rvalB, resetting, clock,
rax, rcx, rdx, rbx, rsp, rbp, rsi, rdi,
r8, r9, r10, r11, r12, r13, r14);


// Execute stage
alu alu(aluA, aluB, alufun, e_valE, new_cc);
cc ccreg(cc, new_cc,
// Only update CC when everything is running normally
running & set_cc,
resetting, clock);
cond cond_check(E_ifun, cc, e_Cnd);

// Memory stage
bmemory m(
// Only update memory when everything is running normally
// or when downloading
(downloading | uploading) ? udaddr : mem_addr, // Read/Write address
(running & mem_write) | downloading, // When to write to memory

downloading ? idata : M_valA, // Write data
(running & mem_read) | uploading, // When to read memory
m_valM, // Read data
m_ok,
f_pc, f_instr, f_ok, clock); // Instruction memory access

assign imem_error = ˜f_ok;
assign dmem_error = ˜m_ok;

// Write-back stage logic

// Control logic
// --------------------------------------------------------------------
// The following code is generated from the HCL description of the
// pipeline control using the hcl2v program
// --------------------------------------------------------------------
assign f_pc =
(((M_icode == IJXX) & ˜M_Cnd) ? M_valA : (W_icode == IRET) ? W_valM :
F_predPC);

assign f_icode =
(imem_error ? INOP : imem_icode);

assign f_ifun =
(imem_error ? FNONE : imem_ifun);

assign instr_valid =
(f_icode == INOP | f_icode == IHALT | f_icode == IRRMOVQ | f_icode ==
IIRMOVQ | f_icode == IRMMOVQ | f_icode == IMRMOVQ | f_icode == IOPQ
| f_icode == IJXX | f_icode == ICALL | f_icode == IRET | f_icode ==
IPUSHQ | f_icode == IPOPQ);

assign f_stat =
(imem_error ? SADR : ˜instr_valid ? SINS : (f_icode == IHALT) ? SHLT :
SAOK);

assign need_regids =
(f_icode == IRRMOVQ | f_icode == IOPQ | f_icode == IPUSHQ | f_icode ==
IPOPQ | f_icode == IIRMOVQ | f_icode == IRMMOVQ | f_icode == IMRMOVQ)
;

assign need_valC =
(f_icode == IIRMOVQ | f_icode == IRMMOVQ | f_icode == IMRMOVQ | f_icode
== IJXX | f_icode == ICALL);

assign f_predPC =
((f_icode == IJXX | f_icode == ICALL) ? f_valC : f_valP);

assign d_srcA =
((D_icode == IRRMOVQ | D_icode == IRMMOVQ | D_icode == IOPQ | D_icode

== IPUSHQ) ? D_rA : (D_icode == IPOPQ | D_icode == IRET) ? RRSP :
RNONE);

assign d_srcB =
((D_icode == IOPQ | D_icode == IRMMOVQ | D_icode == IMRMOVQ) ? D_rB : (
D_icode == IPUSHQ | D_icode == IPOPQ | D_icode == ICALL | D_icode
== IRET) ? RRSP : RNONE);

assign d_dstE =
((D_icode == IRRMOVQ | D_icode == IIRMOVQ | D_icode == IOPQ) ? D_rB : (
D_icode == IPUSHQ | D_icode == IPOPQ | D_icode == ICALL | D_icode
== IRET) ? RRSP : RNONE);

assign d_dstM =
((D_icode == IMRMOVQ | D_icode == IPOPQ) ? D_rA : RNONE);

assign d_valA =
((D_icode == ICALL | D_icode == IJXX) ? D_valP : (d_srcA == e_dstE) ?
e_valE : (d_srcA == M_dstM) ? m_valM : (d_srcA == M_dstE) ? M_valE :
(d_srcA == W_dstM) ? W_valM : (d_srcA == W_dstE) ? W_valE : d_rvalA);

assign d_valB =
((d_srcB == e_dstE) ? e_valE : (d_srcB == M_dstM) ? m_valM : (d_srcB
== M_dstE) ? M_valE : (d_srcB == W_dstM) ? W_valM : (d_srcB ==
W_dstE) ? W_valE : d_rvalB);

assign aluA =
((E_icode == IRRMOVQ | E_icode == IOPQ) ? E_valA : (E_icode == IIRMOVQ
| E_icode == IRMMOVQ | E_icode == IMRMOVQ) ? E_valC : (E_icode ==
ICALL | E_icode == IPUSHQ) ? -8 : (E_icode == IRET | E_icode == IPOPQ
) ? 8 : 0);

assign aluB =
((E_icode == IRMMOVQ | E_icode == IMRMOVQ | E_icode == IOPQ | E_icode
== ICALL | E_icode == IPUSHQ | E_icode == IRET | E_icode == IPOPQ)
? E_valB : (E_icode == IRRMOVQ | E_icode == IIRMOVQ) ? 0 : 0);

assign alufun =
((E_icode == IOPQ) ? E_ifun : ALUADD);

assign set_cc =
(((E_icode == IOPQ) & ˜(m_stat == SADR | m_stat == SINS | m_stat ==
SHLT)) & ˜(W_stat == SADR | W_stat == SINS | W_stat == SHLT));

assign e_valA =
E_valA;

assign e_dstE =
(((E_icode == IRRMOVQ) & ˜e_Cnd) ? RNONE : E_dstE);


assign mem_addr =
((M_icode == IRMMOVQ | M_icode == IPUSHQ | M_icode == ICALL | M_icode
== IMRMOVQ) ? M_valE : (M_icode == IPOPQ | M_icode == IRET) ?
M_valA : 0);

assign mem_read =
(M_icode == IMRMOVQ | M_icode == IPOPQ | M_icode == IRET);

assign mem_write =
(M_icode == IRMMOVQ | M_icode == IPUSHQ | M_icode == ICALL);

assign m_stat =
(dmem_error ? SADR : M_stat);

assign w_dstE =
W_dstE;

assign w_valE =
W_valE;

assign w_dstM =
W_dstM;

assign w_valM =
W_valM;

assign Stat =
((W_stat == SBUB) ? SAOK : W_stat);

assign F_bubble =
0;

assign F_stall =
(((E_icode == IMRMOVQ | E_icode == IPOPQ) & (E_dstM == d_srcA | E_dstM
== d_srcB)) | (IRET == D_icode | IRET == E_icode | IRET ==
M_icode));

assign D_stall =
((E_icode == IMRMOVQ | E_icode == IPOPQ) & (E_dstM == d_srcA | E_dstM
== d_srcB));

assign D_bubble =
(((E_icode == IJXX) & ˜e_Cnd) | (˜((E_icode == IMRMOVQ | E_icode ==
IPOPQ) & (E_dstM == d_srcA | E_dstM == d_srcB)) & (IRET ==
D_icode | IRET == E_icode | IRET == M_icode)));

assign E_stall =
0;

assign E_bubble =

(((E_icode == IJXX) & ˜e_Cnd) | ((E_icode == IMRMOVQ | E_icode == IPOPQ
) & (E_dstM == d_srcA | E_dstM == d_srcB)));

assign M_stall =
0;

assign M_bubble =
((m_stat == SADR | m_stat == SINS | m_stat == SHLT) | (W_stat == SADR
| W_stat == SINS | W_stat == SHLT));

assign W_stall =
(W_stat == SADR | W_stat == SINS | W_stat == SHLT);

assign W_bubble =
0;

// --------------------------------------------------------------------
// End of code generated by hcl2v
// --------------------------------------------------------------------
1544 endmodule
1545

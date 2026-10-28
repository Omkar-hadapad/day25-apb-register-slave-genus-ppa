
`timescale 1ns/1ps

// ============================================================
// LEVEL 1: BASIC LOGIC GATES
// ============================================================

module and_gate (
    input  a,
    input  b,
    output y
);
    assign y = a & b;
endmodule


module or_gate (
    input  a,
    input  b,
    output y
);
    assign y = a | b;
endmodule


module not_gate (
    input  a,
    output y
);
    assign y = ~a;
endmodule


module mux2_gate (
    input  a,
    input  b,
    input  sel,
    output y
);
    assign y = sel ? b : a;
endmodule


// ============================================================
// LEVEL 2: ACCESS CONTROL
// ============================================================

module access_control (
    input  sel,
    input  enable,
    input  write,
    output access_phase,
    output write_enable,
    output ready
);
    assign access_phase = sel & enable;
    assign write_enable = sel & enable & write;
    assign ready        = sel & enable;
endmodule


// ============================================================
// LEVEL 2: ADDRESS DECODER
// Addresses: 0x0, 0x4, 0x8, 0xC
// ============================================================

module address_decoder (
    input  [3:0] addr,
    output       dec0,
    output       dec1,
    output       dec2,
    output       dec3
);
    assign dec0 = (addr == 4'h0);
    assign dec1 = (addr == 4'h4);
    assign dec2 = (addr == 4'h8);
    assign dec3 = (addr == 4'hC);
endmodule


// ============================================================
// LEVEL 3: D FLIP-FLOP WITH SYNCHRONOUS ACTIVE-HIGH RESET
// ============================================================

module dff_sync_reset (
    input  clk,
    input  rst,
    input  d,
    output reg q
);
    always @(posedge clk) begin
        if (rst)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule


// ============================================================
// LEVEL 3: 8-BIT REGISTER WITH WRITE ENABLE
// ============================================================

module register_8bit (
    input        clk,
    input        rst,
    input        write_en,
    input  [7:0] wdata,
    output [7:0] q
);
    reg [7:0] data;

    always @(posedge clk) begin
        if (rst)
            data <= 8'h00;
        else if (write_en)
            data <= wdata;
    end

    assign q = data;
endmodule


// ============================================================
// LEVEL 4: REGISTER BANK - FOUR 8-BIT REGISTERS
// ============================================================

module register_bank_4x8 (
    input        clk,
    input        rst,
    input        write_enable,
    input  [3:0] addr,
    input  [7:0] wdata,

    output [7:0] reg0,
    output [7:0] reg1,
    output [7:0] reg2,
    output [7:0] reg3
);
    wire dec0, dec1, dec2, dec3;
    wire we0, we1, we2, we3;

    address_decoder U_DEC (
        .addr(addr),
        .dec0(dec0),
        .dec1(dec1),
        .dec2(dec2),
        .dec3(dec3)
    );

    assign we0 = write_enable & dec0;
    assign we1 = write_enable & dec1;
    assign we2 = write_enable & dec2;
    assign we3 = write_enable & dec3;

    register_8bit U_REG0 (
        .clk(clk), .rst(rst), .write_en(we0),
        .wdata(wdata), .q(reg0)
    );

    register_8bit U_REG1 (
        .clk(clk), .rst(rst), .write_en(we1),
        .wdata(wdata), .q(reg1)
    );

    register_8bit U_REG2 (
        .clk(clk), .rst(rst), .write_en(we2),
        .wdata(wdata), .q(reg2)
    );

    register_8bit U_REG3 (
        .clk(clk), .rst(rst), .write_en(we3),
        .wdata(wdata), .q(reg3)
    );
endmodule


// ============================================================
// LEVEL 4: READ MULTIPLEXER
// Invalid addresses return zero.
// ============================================================

module read_mux_4x8 (
    input  [3:0] addr,
    input  [7:0] reg0,
    input  [7:0] reg1,
    input  [7:0] reg2,
    input  [7:0] reg3,
    output reg [7:0] rdata
);
    always @(*) begin
        case (addr)
            4'h0:    rdata = reg0;
            4'h4:    rdata = reg1;
            4'h8:    rdata = reg2;
            4'hC:    rdata = reg3;
            default: rdata = 8'h00;
        endcase
    end
endmodule


// ============================================================
// LEVEL 5: TOP MODULE
// ============================================================

module apb_register_slave (
    input        clk,
    input        rst,
    input        sel,
    input        enable,
    input        write,
    input  [3:0] addr,
    input  [7:0] wdata,

    output       ready,
    output [7:0] rdata
);
    wire access_phase;
    wire write_enable;

    wire [7:0] reg0, reg1, reg2, reg3;

    // Access and write control
    access_control U_CTRL (
        .sel(sel),
        .enable(enable),
        .write(write),
        .access_phase(access_phase),
        .write_enable(write_enable),
        .ready(ready)
    );

    // Four-register storage bank
    register_bank_4x8 U_BANK (
        .clk(clk),
        .rst(rst),
        .write_enable(write_enable),
        .addr(addr),
        .wdata(wdata),
        .reg0(reg0),
        .reg1(reg1),
        .reg2(reg2),
        .reg3(reg3)
    );

    // Read-data selection
    read_mux_4x8 U_READ (
        .addr(addr),
        .reg0(reg0),
        .reg1(reg1),
        .reg2(reg2),
        .reg3(reg3),
        .rdata(rdata)
    );
endmodule

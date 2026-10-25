module demux1to2 (
    input  logic d,
    input  logic sel,
    output logic y0,
    output logic y1
);
    assign y0 = ~sel & d;
    assign y1 =  sel & d;
endmodule
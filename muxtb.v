module muxtb;

    reg a, b, c, d;
    reg sel_0, sel_1;
    wire out;

    mux DUT (
        .i0(a),
        .i1(b),
        .i2(c),
        .i3(d),
        .s1(sel_1),
        .s0(sel_0),
        .out(out)
    );

    initial begin
        a = 1;
        b = 0;
        c = 1;
        d = 0;

        sel_1 = 0;
        sel_0 = 0;

        #10 sel_1 = 0; sel_0 = 1;
        #10 sel_1 = 1; sel_0 = 0;
        #10 sel_1 = 1; sel_0 = 1;

        #50 $finish;
    end

    always @(sel_0 or sel_1)
        $display(
            "time = %0t INPUT VALUES : a = %b b = %b c = %b d = %b Sel_1 = %b Sel_0 = %b OUTPUT VALUE : out = %b",
            $time, a, b, c, d, sel_1, sel_0, out
        );
initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, muxtb);

    a = 1;
    b = 0;
    c = 1;
    d = 0;

    sel_1 = 0;
    sel_0 = 0;

    #10 sel_1 = 0; sel_0 = 1;
    #10 sel_1 = 1; sel_0 = 0;
    #10 sel_1 = 1; sel_0 = 1;

    #50 $finish;
end
endmodule

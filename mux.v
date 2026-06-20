module mux (
    input i0, i1, i2, i3, s1, s0,
    output reg out
);

always @(i0 or i1 or i2 or i3 or s0 or s1)
begin
    if (s1 == 0 && s0 == 0)
        out = i0;

    else if (s1 == 0 && s0 == 1)
        out = i1;

    else if (s1 == 1 && s0 == 0)
        out = i2;

    else
        out = i3;
end

endmodule
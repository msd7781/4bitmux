module fifo_tb;

    reg        clk, rst, wr_en, rd_en;
    reg  [7:0] data_in;
    wire [7:0] data_out;
    wire       full, empty;

    fifo #(.DEPTH(8), .WIDTH(8)) uut (
        .clk(clk), .rst(rst),
        .wr_en(wr_en), .rd_en(rd_en),
        .data_in(data_in), .data_out(data_out),
        .full(full), .empty(empty)
    );

    // Clock: flips every 5ns → 10ns period = 100MHz
    initial clk = 0;
    always #5 clk = ~clk;

    // Main 
    initial begin
        // Waveform dump (open in GTKWave to see signals)
        $dumpfile("fifo.vcd");
        $dumpvars(0, fifo_tb);

       
        rst = 1; wr_en = 0; rd_en = 0; data_in = 0;
        #20;
        rst = 0;
        #10;

        $display("--- Writing 4 values ---");
        wr_en = 1;
        data_in = 8'hAA; #10;   // write 0xAA
        data_in = 8'hBB; #10;   // write 0xBB
        data_in = 8'hCC; #10;   // write 0xCC
        data_in = 8'hDD; #10;   // write 0xDD
        wr_en = 0;
        #10;

    
        $display("--- Reading 4 values ---");
        rd_en = 1;
        #10; $display("Read: %h (expect AA)", data_out);
        #10; $display("Read: %h (expect BB)", data_out);
        #10; $display("Read: %h (expect CC)", data_out);
        #10; $display("Read: %h (expect DD)", data_out);
        rd_en = 0;
        #10;

        
        $display("--- Filling FIFO (check full flag) ---");
        wr_en = 1;
        data_in = 8'h01; #10;
        data_in = 8'h02; #10;
        data_in = 8'h03; #10;
        data_in = 8'h04; #10;
        data_in = 8'h05; #10;
        data_in = 8'h06; #10;
        data_in = 8'h07; #10;
        data_in = 8'h08; #10;
        wr_en = 0;
        $display("Full flag: %b (expect 1)", full);
        #10;

      
        $display("--- Writing when full (should be ignored) ---");
        wr_en = 1; data_in = 8'hFF; #10;
        wr_en = 0; #10;

    
        $display("--- Draining FIFO ---");
        rd_en = 1;
        repeat(8) begin
            #10; $display("Read: %h", data_out);
        end
        rd_en = 0;
        $display("Empty flag: %b (expect 1)", empty);
        #20;

        $display("--- TEST DONE ---");
        $finish;
    end

endmodule
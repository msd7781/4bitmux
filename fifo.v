module fifo #(
    parameter DEPTH = 8,  
    parameter WIDTH = 8  )(
    input  wire             clk,
    input  wire             rst,
    input  wire             wr_en,      
    input  wire             rd_en,      
    input  wire [WIDTH-1:0] data_in,   
    output reg  [WIDTH-1:0] data_out,   
    output wire             full,       
    output wire             empty   
);

  
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Pointers
    reg [2:0] wr_ptr;   
    reg [2:0] rd_ptr;   

    // Counter 
    reg [3:0] count;   
    assign full  = (count == DEPTH);
    assign empty = (count == 0);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
           
            wr_ptr   <= 0;
            rd_ptr   <= 0;
            count    <= 0;
            data_out <= 0;
        end
        else begin

           
            // Only write if write-enable is ON and FIFO is not full
            if (wr_en && !full) begin
                mem[wr_ptr] <= data_in;       // put data in the slot
                wr_ptr      <= wr_ptr + 1;    // move write pointer forward
                count       <= count + 1;     // one more item inside
            end

           
            // Only read if read-enable is ON and FIFO is not empty
            if (rd_en && !empty) begin
                data_out <= mem[rd_ptr];      // take data from the slot
                rd_ptr   <= rd_ptr + 1;       // move read pointer forward
                count    <= count - 1;        // one less item inside
            end

            // WRITE + READ at SAME TIME 
            // Count stays same
            if (wr_en && !full && rd_en && !empty) begin
                count <= count;           
            end

        end
    end

endmodule
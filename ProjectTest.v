module ProjectTest (
    input wire clk,           // 50 MHz FPGA Clock-PIN_N2
    input wire rst,           // Active-low reset
    input wire btn_inc,       // Increase frequency
    input wire btn_dec,       // Decrease frequency
    output reg sq_wave        // Output on PIN_D25(GPIO Connection 0[0]-FPGA(GPIO(0)_Pin-1)) // GND(FPGA(GPIO(0)_Pin-12))
);

    reg [31:0] counter = 0;    // Counter for timing
    reg [31:0] div_val = 50000; // Default clock divider
    reg [3:0] freq_step = 10;   // Frequency step/gap size

    // Button Debounce Registers
    reg btn_inc_prev = 0;
    reg btn_dec_prev = 0;

    always @(posedge clk or negedge rst) 
	 begin
        if (!rst) 
		  begin
            counter <= 0;
            div_val <= 50000;
            sq_wave <= 0;
        end 
        else 
		  begin
				// Detect rising edge of button press
            if (btn_inc && !btn_inc_prev && div_val > 5000)  
                div_val <= div_val - freq_step * 1000; // Increase frequency

            if (btn_dec && !btn_dec_prev && div_val < 100000)  
                div_val <= div_val + freq_step * 1000; // Decrease frequency

            btn_inc_prev <= btn_inc;  // Store previous button states
            btn_dec_prev <= btn_dec;

            // Generate square wave
            counter <= counter + 1;
            if (counter >= div_val) 
				begin
                counter <= 0;
                sq_wave <= ~sq_wave;  // Toggle square wave
            end
        end
    end
endmodule

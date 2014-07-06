//-----------------------------------------------------------------------
//--
//-- Copyright 2012 ShareBrained Technology, Inc.
//--
//-- This file is part of robotron-fpga.
//--
//-- robotron-fpga is free software: you can redistribute
//-- it and/or modify it under the terms of the GNU General
//-- Public License as published by the Free Software
//-- Foundation, either version 3 of the License, or (at your
//-- option) any later version.
//--
//-- robotron-fpga is distributed in the hope that it will
//-- be useful, but WITHOUT ANY WARRANTY; without even the
//-- implied warranty of MERCHANTABILITY or FITNESS FOR A
//-- PARTICULAR PURPOSE. See the GNU General Public License
//-- for more details.
//--
//-- You should have received a copy of the GNU General
//-- Public License along with robotron-fpga. If not, see
//-- <http://www.gnu.org/licenses/>.
//--
//-----------------------------------------------------------------------

module robotron_cpu(
		    input 	 CLK,
		    input 	 cpu_clk_in,
		    input 	 vga_clk_in,
           
		    input [15:0] A,
                    input [7:0] D_IN,
                    output [7:0] D_OUT,

		    output reg	 RESET_N,
		    output reg 	 NMI_N,
		    output reg 	 FIRQ_N,
		    output reg 	 IRQ_N,
		    input 	 LIC,
		    input 	 AVMA,
		    input 	 R_W_N,
		    output 	 TSC,
		    output reg	 HALT_N,
		    input 	 BA,
		    input 	 BS,
		    input 	 BUSY,
		    output 	 E,
		    output 	 Q,
				 
		    // Cellular RAM / StrataFlash
		    output MemOE,
		    output MemWR,

		    output RamAdv,
		    output RamCS,
		    output RamClk,
		    output RamCRE,
		    output RamLB,
		    output RamUB,
		    input RamWait,

		    output FlashRp,
		    output FlashCS,
		    input FlashStSts,

		    output [23:1] MemAdr,
		    input [15:0] MemDB_in,
		    output [15:0] MemDB_out,

		    // 7-segment display
		    output [6:0] SEG,
		    output DP,
		    output [3:0] AN,

		    // LEDs
		    output [7:0] LED,

		    // Switches
		    input [7:0] SW,

		    // Buttons
		    input [3:0] BTN,

		    // VGA connector
		    output [2:0] vgaRed,
		    output [2:0] vgaGreen,
		    output [2:0] vgaBlue,
		    output Hsync,
		    output Vsync,
                    output Blank,

		    // 12-pin connectors
		    input [7:0] JA,
		    input [7:0] JB,
		    //JC               : in    std_logic_vector(7:0);
		    //JD               : in    std_logic_vector(3:0);

		    output hand_out,
		    output [5:0] pb_out
		    );

   wire reset_request;
   reg [7:0] reset_counter;
   reg 	     reset;

   wire clock_50m;
   wire clock_50m_0;
   wire clock_50m_fb;

   wire clock;
    
   reg [11:0] clock_12_phase;
    
   wire clock_q_set;
   wire clock_q_clear;
   reg  clock_q;
    
   wire clock_e_set;
   wire clock_e_clear;
   reg 	clock_e;
    
   //-----------------------------------------------------------------
    
   reg [14:0] video_count;
   wire [14:0] video_count_next;
   wire [13:0] video_address_or_mask;
   reg [13:0]  video_address;
    
   wire count_240;
   wire irq_4ms;
    
   wire horizontal_sync;
   wire vertical_sync;
    
   reg  video_blank;

   reg [2:0] vga_red;
   reg [2:0] vga_green;
   reg [2:0] vga_blue;
    
   //-----------------------------------------------------------------
    
   wire [15:0] led_bcd_in;
   wire [3:0] led_bcd_in_digit;
    
   reg [15:0] led_counter;
   wire [1:0] led_digit_index;
    
   wire [6:0] led_segment;
   wire led_dp;
   wire [3:0] led_anode;

   //-------------------------------------------------------------------

   wire [15:0] address;
    
   wire write;
   wire read;
    
   //-------------------------------------------------------------------

   reg [15:0] mpu_address;
   reg [7:0]  mpu_data_in;
   reg [7:0]  mpu_data_out;
    
   reg mpu_bus_status;
   reg mpu_bus_available;
    
   reg mpu_read;
   reg mpu_write;
    
   wire mpu_reset;
   wire mpu_halt;
   reg  mpu_halted;
   wire mpu_irq;
   wire mpu_firq;
   wire mpu_nmi;

   //-------------------------------------------------------------------

   reg [15:0] memory_address;
   wire [7:0] memory_data_in;
   reg [7:0]  memory_data_out;
    
   reg memory_output_enable;
   reg memory_write;
   reg flash_enable;
    
   reg ram_enable;
   reg ram_lower_enable;
   reg ram_upper_enable;
    
   //-------------------------------------------------------------------
    
   reg e_rom;
   reg  screen_control;
    
   wire rom_access;
   wire ram_access;
   wire color_table_access;
   wire widget_pia_access;
   wire rom_pia_access;
   wire blt_register_access;
   wire video_counter_access;
   wire watchdog_access;
   wire control_access;
   wire cmos_access;

   wire [7:0] video_counter_value;
    
   //-------------------------------------------------------------------
    
   wire HAND;
   wire SLAM;
   wire R_COIN;
   wire C_COIN;
   wire L_COIN;
   wire H_S_RESET;
   wire ADVANCE;
   wire AUTO_UP;
   wire [5:0] PB;
    
   reg [1:0]  rom_pia_rs;
   reg rom_pia_cs;
   reg rom_pia_write;
   reg [7:0] rom_pia_data_in;
   wire [7:0] rom_pia_data_out;
   wire rom_pia_ca2_out;
   wire rom_pia_ca2_dir;
   wire rom_pia_irq_a;
   wire [7:0] rom_pia_pa_in;
   wire [7:0] rom_pia_pa_out;
   wire [7:0] rom_pia_pa_dir;

   wire rom_pia_cb2_out;
   wire rom_pia_cb2_dir;
   wire rom_pia_irq_b;
   wire [7:0] rom_pia_pb_in;
   wire [7:0] rom_pia_pb_out;
   wire [7:0] rom_pia_pb_dir;
   
   wire [7:0] rom_led_digit;
    
   //-------------------------------------------------------------------

   wire MOVE_UP_1;
   wire MOVE_DOWN_1;
   wire MOVE_LEFT_1;
   wire MOVE_RIGHT_1;
   wire PLAYER_1_START;
   wire PLAYER_2_START;
   wire FIRE_UP_1;
   wire FIRE_DOWN_1;
   wire FIRE_RIGHT_1;
   wire FIRE_LEFT_1;
   wire MOVE_UP_2;
   wire MOVE_DOWN_2;
   wire MOVE_LEFT_2;
   wire MOVE_RIGHT_2;
   wire FIRE_RIGHT_2;
   wire FIRE_UP_2;
   wire FIRE_DOWN_2;
   wire FIRE_LEFT_2;
    
   wire board_interface_w1;  // Upright application: 1'b1 = jumper present
    
   reg [1:0] widget_pia_rs;
   reg widget_pia_cs;
   reg widget_pia_write;
   reg [7:0] widget_pia_data_in;
   wire [7:0] widget_pia_data_out;
   wire widget_pia_ca2_out;
   wire widget_pia_ca2_dir;
   wire widget_pia_irq_a;
   wire [7:0] widget_pia_pa_in;
   wire [7:0] widget_pia_pa_out;
   wire [7:0] widget_pia_pa_dir;
   wire widget_pia_input_select;
   wire widget_pia_cb2_out;
   wire widget_pia_cb2_dir;
   wire widget_pia_irq_b;
   wire [7:0] widget_pia_pb_in;
   wire [7:0] widget_pia_pb_out;
   wire [7:0] widget_pia_pb_dir;
    
   wire [4:1] widget_ic3_a;
   wire [4:1] widget_ic3_b;
   wire [4:1] widget_ic3_y;

   wire [4:1] widget_ic4_a;
   wire [4:1] widget_ic4_b;
   wire [4:1] widget_ic4_y;
   
   //-------------------------------------------------------------------

   reg [2:0]  blt_rs;
   reg        blt_reg_cs;
   reg [7:0] blt_reg_data_in;
    
   wire blt_halt;
   wire blt_halt_ack;
   wire blt_read;
   wire blt_write;
   reg  blt_blt_ack;
   wire [15:0] blt_address_out;
   wire [7:0] blt_data_in;
   wire [7:0] blt_data_out;
   wire blt_en_lower;
   wire blt_en_upper;
    
   //-----------------------------------------------------------------

   reg [7:0] color_table[0:15];
    
   reg [7:0] pixel_nibbles;
   reg [7:0] pixel_byte_l;
   reg [7:0] pixel_byte_h;
    
   //-----------------------------------------------------------------

   wire [8:0] decoder_4_in;
   wire [15:8] pseudo_address;
   
   wire [8:0] decoder_6_in;
   wire [13:6] video_prom_address;
    
   //-----------------------------------------------------------------
    
   reg [15:0] debug_blt_source_address;
   reg [15:0] debug_last_mpu_address;

`ifdef never
`ifndef debug
   wire clock_fx;
   
    DCM_SP
      #(
        .CLKDV_DIVIDE      (2.0),
        .CLKFX_DIVIDE      (25),
        .CLKFX_MULTIPLY    (6),
        .CLKIN_DIVIDE_BY_2 ("FALSE"),
        .CLKIN_PERIOD      (20.0),
        .CLKOUT_PHASE_SHIFT("NONE"),
	.CLK_FEEDBACK      ("NONE"),
        .DESKEW_ADJUST     ("SYSTEM_SYNCHRONOUS"),
        .PHASE_SHIFT       (0),
        .STARTUP_WAIT      ("FALSE")
        )
    dcm_12m
      (
       .CLKFX     ( clock_fx ),   // DCM CLK synthesis out (M/D)
       .CLKIN     ( clock_50m ),  // Clock input (from IBUFG, BUFG or DCM)
       .CLK0      ( clock_50m_0 ),
       .CLKFB     ( clock_50m_fb ),
       .PSCLK     (1'b0),
       .PSEN      (1'b0),
       .PSINCDEC  (1'b0),
       .PSDONE    (),
       .LOCKED    (),
       .STATUS    (),
       .RST       (1'b0),
       .DSSEN     (1'b0)
      );
        
   assign clock_50m_fb = 1'b0;
   BUFG(.I(clock_fx), .O(clock));
`else // !`ifndef debug
   assign clock = clock_50m;
`endif
`else // !`ifdef never
   assign clock = cpu_clk_in;
   //BUFG cc_buf (.I(cpu_clk_in), .O(clock));
`endif
   
    // clock    0   1   2   3   4   5   6   7   8   9   10  11
    // Q        0   0   0   1   1   1   1   1   1   0   0   0
    // E        0   0   0   0   0   0   1   1   1   1   1   1
    // Memory   0   0   1   1   2   2   3   3   4   4   5   5
        
    //
    assign clock_50m = CLK;
    assign reset_request = BTN[0];
    
    assign mpu_reset = reset;
    assign mpu_halt = blt_halt;
    assign mpu_irq = rom_pia_irq_a | rom_pia_irq_b;
    assign mpu_firq = 1'b0;
    assign mpu_nmi = 1'b0;
    
    assign address = mpu_halted ? blt_address_out : mpu_address;
    assign write = mpu_halted ? blt_write : mpu_write;
    assign read = mpu_halted ? blt_read : mpu_read;
             
    assign rom_access = (address <  16'h9000 && read && e_rom) ||
			(address >= 16'hD000 && read);

    assign ram_access = (address <  16'h9000 && write) ||
			(address <  16'h9000 && read && ~e_rom) ||
			(address >= 16'h9000 && address < 16'hC000);

    // Color table: write: C000-C3FF
    assign color_table_access =    (address & 16'hfc00) == 16'hc000;

    // Widget PIA: read/write: C8X4 - C8X7
    assign widget_pia_access =    (address & 16'hff0c) == 16'hc804;
    
    // ROM PIA: read/write: C8XC - C8XF
    assign rom_pia_access =       (address & 16'hff0c) == 16'hc80c;			    

    // Control address: write: C9XX
    assign control_access =       (address & 16'hff00) == 16'hc900;

    // Special chips: read/write? CAXX
    assign blt_register_access =  (address & 16'hff00) == 16'hca00;
    
    // Video counter: read: CBXX (even addresses)
    assign video_counter_access = (address & 16'hff00) == 16'hcb00;
    
    // Watchdog register: write: CBFE or CBFF
    assign watchdog_access =      (address & 16'hfffe) == 16'hcbfe;
   
    // CMOS "nonvolatile" RAM: read/write: CC00 - CFFF
   assign cmos_access =           (address & 16'hfe00) == 16'hcc00;
   

   //
    assign SLAM = SW[6];
    assign H_S_RESET = SW[2];
    assign ADVANCE = SW[1];
    assign AUTO_UP = SW[0];
    
    assign PLAYER_1_START = BTN[3];
    assign PLAYER_2_START = BTN[2];
    assign C_COIN = BTN[1];
    assign L_COIN = 1'b0;
    assign R_COIN = 1'b0;
    
    assign MOVE_UP_1 = JA[0];
    assign MOVE_DOWN_1 = JA[1];
    assign MOVE_LEFT_1 = JA[2];
    assign MOVE_RIGHT_1 = JA[3];
    assign FIRE_UP_1 = JA[4];
    assign FIRE_DOWN_1 = JA[5];
    assign FIRE_LEFT_1 = JA[6];
    assign FIRE_RIGHT_1 = JA[7];
    
    assign MOVE_UP_2 = JB[0];
    assign MOVE_DOWN_2 = JB[1];
    assign MOVE_LEFT_2 = JB[2];
    assign MOVE_RIGHT_2 = JB[3];
    assign FIRE_UP_2 = JB[4];
    assign FIRE_DOWN_2 = JB[5];
    assign FIRE_LEFT_2 = JB[6];
    assign FIRE_RIGHT_2 = JB[7];
    
    assign video_counter_value = { video_address[13:8], 2'b00 };
    
    assign decoder_4_in = { screen_control, address[15:8] };
    assign decoder_6_in = { screen_control, video_address[13:6] };

   always @(posedge clock or posedge reset)
     if (reset)
       begin
	  screen_control <= 0;
       end
     else
       begin
          ram_enable <= 1'b0;
          ram_lower_enable <= 1'b0;
          ram_upper_enable <= 1'b0;
            
          flash_enable <= 1'b0;
            
          memory_output_enable <= 1'b0;
          memory_write <= 1'b0;
          memory_data_out <= 0;
            
          blt_reg_cs <= 1'b0;
          blt_blt_ack <= 1'b0;
            
          rom_pia_cs <= 1'b0;
          rom_pia_write <= 1'b0;
            
          widget_pia_cs <= 1'b0;
          widget_pia_write <= 1'b0;
            
            if (clock_12_phase[ 0])
              memory_address <= { 2'b00, video_prom_address, video_address[4:0], 1'b0 };
            
            if (clock_12_phase[ 2])
              memory_address <= { 2'b01, video_prom_address, video_address[4:0], 1'b0 };
            
            if (clock_12_phase[ 4])
              memory_address <= { 2'b10, video_prom_address, video_address[4:0], 1'b0 };
            
            if (clock_12_phase[ 6])
              memory_address <= { 2'b00, video_prom_address, video_address[4:0], 1'b1 };
            
            if (clock_12_phase[ 8])
              memory_address <= { 2'b01, video_prom_address, video_address[4:0], 1'b1 };
            
            if (clock_12_phase[10])
              memory_address <= { 2'b10, video_prom_address, video_address[4:0], 1'b1 };

            if (clock_12_phase[5])
              if (({video_address[4:0], 1'b1} & 6'b110101) == 6'b110101)
                video_blank <= 1'b1;
	      else
		if (({video_address[4:0], 1'b1} & 6'b100011) == 6'b000011)
                  video_blank <= 1'b0;
            
            if (clock_12_phase[ 0] ||
		clock_12_phase[ 2] ||
		clock_12_phase[ 4] ||
		clock_12_phase[ 6] ||
		clock_12_phase[ 8] ||
		clock_12_phase[10])
	      begin
                memory_output_enable <= 1'b1;
                ram_enable <= 1'b1;
                ram_lower_enable <= 1'b1;
                ram_upper_enable <= 1'b1;
	      end

           if (video_blank)
	     begin
                vga_red <= 0;
                vga_green <= 0;
		vga_blue <= 0;
	     end
           else
	     begin
                vga_red <= pixel_byte_h[2:0];
                vga_green <= pixel_byte_h[5:3];
                vga_blue <= {pixel_byte_h[7:6], 1'b0};
             end

            if (clock_12_phase[ 1] ||
		clock_12_phase[ 3] ||
		clock_12_phase[ 5] ||
		clock_12_phase[ 7] ||
		clock_12_phase[ 9] ||
		clock_12_phase[11])
	      begin
                pixel_nibbles <= memory_data_in;

`ifdef debug_cmap
                pixel_byte_l <= pixel_nibbles;
                pixel_byte_h <= pixel_nibbles;
`else
                pixel_byte_l <= color_table[ pixel_nibbles[3:0] ];
                pixel_byte_h <= color_table[ pixel_nibbles[7:4] ];
`endif

////debug
//pixel_byte_h <= video_address[8:1];
//pixel_byte_l <= video_address[8:1];

                if (video_blank)
		  begin
                    vga_red <= 0;
                    vga_green <= 0;
                    vga_blue <= 0;
		  end
                else
		  begin
                    vga_red <= pixel_byte_l[2:0];
                    vga_green <= pixel_byte_l[5:3];
                    vga_blue <= {pixel_byte_l[7:6], 1'b0};
		  end
	      end

            // BLT-only cycles
            // NOTE: the next cycle must be a read if coming from RAM, since the
            // RAM WE# needs to deassert for a time in order for another write to
            // take place.
            if (clock_12_phase[11] || clock_12_phase[1])
              if (mpu_halted)
		begin
                   if (ram_access)
		     begin
`ifdef debug_blt
			if (pseudo_address[15:14] == 2'b11)
			  $display("blt: ram_access address1 %x", address);
			else
			  $display("blt: ram_access address2 %x, pseudo_address %x, address %x, decoder_4_in %x",
				   { pseudo_address[15:14],
				     address[7:0],
				     pseudo_address[13:8] },
				   pseudo_address, address, decoder_4_in);
`endif

			if (pseudo_address[15:14] == 2'b11)
			  memory_address <= address;
			else
			  memory_address <= { pseudo_address[15:14], 
                                              address[7:0],
                                              pseudo_address[13:8] };
		     end
		   else
		     if (rom_access || cmos_access || color_table_access)
		      begin
                       memory_address <= address;
		      end
		   
                   if (ram_access && write)
		     begin
                        memory_data_out <= blt_data_out;
                        memory_write <= 1'b1;
		     end
                   else
                     memory_output_enable <= 1'b1;

                   if (ram_access)
		     begin
                        ram_enable <= 1'b1;
                        ram_lower_enable <= blt_en_lower;
                        ram_upper_enable <= blt_en_upper;
		     end

                   if (rom_access)
                     flash_enable <= 1'b1;

		   blt_blt_ack <= 1'b1;
		end // if (mpu_halted)
            
           // MPU-only cycle
           // NOTE: the next cycle must be a read if coming from RAM, since the
           // RAM WE# needs to deassert for a time in order for another write to
           // take place.
           if (clock_12_phase[7])
             if (~mpu_halted)
	       begin
                    if (ram_access)
		      begin
                        if (pseudo_address[15:14] == 2'b11)
                          memory_address <= address;
                        else
                          memory_address <= { pseudo_address[15:14],
                                              address[7:0],
                                              pseudo_address[13:8] };
                      end
                    else
		      if (rom_access || cmos_access || color_table_access)
                        memory_address <= address;
                
                    if ((ram_access || cmos_access || color_table_access) && write)
		      begin
                        memory_data_out <= mpu_data_in;
                        memory_write <= 1'b1;
		      end
                    else
                        memory_output_enable <= 1'b1;
                
                    if (ram_access || cmos_access || color_table_access)
		      begin
                        ram_enable <= 1'b1;
                        ram_lower_enable <= 1'b1;
                        ram_upper_enable <= 1'b1;
		      end
                
                    if (rom_access)
                        flash_enable <= 1'b1;

                    if (blt_register_access && write)
		      begin
                        blt_rs <= address[2:0];
                        blt_reg_cs <= 1'b1;
                        blt_reg_data_in <= mpu_data_in;
                    
                        // NOTE: To display BLT source address:
                        if (address[2:0] == 3'b010)
                            debug_blt_source_address[15:8] <= mpu_data_in;
                        
                        if (address[2:0] == 3'b011)
                          debug_blt_source_address[7:0] <= mpu_data_in;
		      end
                
                    if (rom_pia_access)
		      begin
                        rom_pia_rs <= address[1:0];
                        rom_pia_data_in <= mpu_data_in;
                        rom_pia_write <= write;
                        rom_pia_cs <= 1'b1;
		      end
                
                    if (widget_pia_access)
		      begin
                        widget_pia_rs <= address[1:0];
                        widget_pia_data_in <= mpu_data_in;
                        widget_pia_write <= write;
                        widget_pia_cs <= 1'b1;
		      end

                    if (control_access && write)
		      begin
                         screen_control <= mpu_data_in[1];
                         e_rom <= mpu_data_in[0];
		      end

                    if (color_table_access && write)
                        color_table[ address[3:0] ] <= mpu_data_in;
	       end // if (~mpu_halted)
            
            if (clock_12_phase[8])
                if (~mpu_halted)
                    if (read)
		      begin
                        if (ram_access || rom_access || cmos_access)
                            mpu_data_out <= memory_data_in;
                    
                        if (widget_pia_access)
                            mpu_data_out <= widget_pia_data_out;
                    
                        if (rom_pia_access)
                            mpu_data_out <= rom_pia_data_out;
                    
                        if (video_counter_access)
                            mpu_data_out <= video_counter_value;
                      end // if read
	end // else: !if(reset)
    
    assign LED = { mpu_irq,
		   mpu_halt,
		   mpu_halted,
		   ram_access,
		   rom_access,
		   rom_pia_access,
		   widget_pia_access,
		   blt_register_access };
           
    assign led_bcd_in = debug_blt_source_address;
    
    //-----------------------------------------------------------------

    decoder_4 horizontal_decoder(.address(decoder_4_in), .data(pseudo_address));

        
    //-----------------------------------------------------------------

    decoder_6 vertical_decoder(.address(decoder_6_in),
			       .data(video_prom_address));
        
    //-----------------------------------------------------------------
    
    assign blt_halt_ack = mpu_halted;
    assign blt_data_in = memory_data_in;
    
    sc1 blt(
            .clk(clock),
            .reset(reset),
            .e_sync(clock_e_clear),
        
            .reg_cs(blt_reg_cs),
            .reg_data_in(blt_reg_data_in),
            .rs(blt_rs),

            .halt(blt_halt),
            .halt_ack(blt_halt_ack),
        
            .blt_ack(blt_blt_ack),
            .blt_address_out(blt_address_out),
        
            .read(blt_read),
            .write(blt_write),

            .blt_data_in(blt_data_in),
            .blt_data_out(blt_data_out),

            .en_upper(blt_en_upper),
            .en_lower(blt_en_lower)
        );

    //-----------------------------------------------------------------

//    assign rom_pia_pa_in = { HAND,
//			     ~SLAM,
//			     ~R_COIN,
//			     ~C_COIN,
//			     ~L_COIN,
//			     ~H_S_RESET,
//			     ~ADVANCE,
//			     ~AUTO_UP };
    assign rom_pia_pa_in = { HAND,
			     SLAM,
			     R_COIN,
			     C_COIN,
			     L_COIN,
			     H_S_RESET,
			     ADVANCE,
			     AUTO_UP };

    assign HAND = ~rom_pia_pa_out[7];
    assign PB[5:0] = rom_pia_pb_out[5:0];
    assign rom_led_digit[0] = rom_pia_pb_out[6];
    assign rom_led_digit[1] = rom_pia_pb_out[7];
    assign rom_led_digit[2] = rom_pia_cb2_out;
    assign rom_led_digit[3] = rom_pia_ca2_out;
    assign rom_pia_pb_in = 'b1;

    assign hand_out = HAND;
    assign pb_out = PB;
    
    mc6821 rom_pia(
            .reset(reset),
            .clock(/*clock_e*/clock),
            .e_sync(clock_e_clear),
        
            .rs(rom_pia_rs),
            .cs(rom_pia_cs),
            .write(rom_pia_write),
        
            .data_in(rom_pia_data_in),
            .data_out(rom_pia_data_out),
        
            .ca1(count_240),
            .ca2_in(1'b1),
            .ca2_out(rom_pia_ca2_out),
            .ca2_dir(rom_pia_ca2_dir),
            .irq_a(rom_pia_irq_a),
            .pa_in(rom_pia_pa_in),
            .pa_out(rom_pia_pa_out),
            .pa_dir(rom_pia_pa_dir),
        
            .cb1(irq_4ms),
            .cb2_in(1'b1),
            .cb2_out(rom_pia_cb2_out),
            .cb2_dir(rom_pia_cb2_dir),
            .irq_b(rom_pia_irq_b),
            .pb_in(rom_pia_pb_in),
            .pb_out(rom_pia_pb_out),
            .pb_dir(rom_pia_pb_dir)
        );

    //-------------------------------------------------------------------

    assign widget_pia_input_select = widget_pia_cb2_out;

    assign widget_ic3_a = ~{MOVE_RIGHT_2, MOVE_LEFT_2, MOVE_DOWN_2, MOVE_UP_2};
    assign widget_ic3_b = ~{MOVE_RIGHT_1, MOVE_LEFT_1, MOVE_DOWN_1, MOVE_UP_1};
    
    assign widget_ic3_y = widget_pia_input_select ? widget_ic3_b : widget_ic3_a;
    
    assign widget_ic4_a = ~{FIRE_RIGHT_2, FIRE_LEFT_2, FIRE_DOWN_2, FIRE_UP_2};
    assign widget_ic4_b = ~{FIRE_RIGHT_1, FIRE_LEFT_1, FIRE_DOWN_1, FIRE_UP_1};

    assign widget_ic4_y = widget_pia_input_select ? widget_ic4_b : widget_ic4_a;
    
    assign widget_pia_pa_in = { widget_ic4_y[2],
				widget_ic4_y[1],
				PLAYER_2_START,
				PLAYER_1_START,
				widget_ic3_y[4],
				widget_ic3_y[3],
				widget_ic3_y[2],
				widget_ic3_y[1] };

    assign widget_pia_pb_in = { ~board_interface_w1, 5'b00000,
				widget_ic4_y[4], widget_ic4_y[3] };
    
    mc6821 widget_pia(
            .reset(reset),
            .clock(/*clock_e*/clock),
            .e_sync(clock_e_clear),
        
            .rs(widget_pia_rs),
            .cs(widget_pia_cs),
            .write(widget_pia_write),
        
            .data_in(widget_pia_data_in),
            .data_out(widget_pia_data_out),
        
            .ca1(1'b0),
            .ca2_in(1'b0),
            .ca2_out(widget_pia_ca2_out),
            .ca2_dir(widget_pia_ca2_dir),
            .irq_a(widget_pia_irq_a),
            .pa_in(widget_pia_pa_in),
            .pa_out(widget_pia_pa_out),
            .pa_dir(widget_pia_pa_dir),
        
            .cb1(1'b0),
            .cb2_in(1'b1),
            .cb2_out(widget_pia_cb2_out),
            .cb2_dir(widget_pia_cb2_dir),
            .irq_b(widget_pia_irq_b),
            .pb_in(widget_pia_pb_in),
            .pb_out(widget_pia_pb_out),
            .pb_dir(widget_pia_pb_dir)
        );

    //-----------------------------------------------------------------

   assign board_interface_w1 = 1'b1;

`ifdef VERILATOR
 `define SIM 1
`endif
`ifdef __CVER__
 `define SIM 1
`endif
   
`ifdef SIM
   assign E = clock_e;
   assign Q = clock_q;
`else
   BUFG clock_e_buf (.O(E), .I(clock_e));
   BUFG clock_q_buf (.O(Q), .I(clock_q));
`endif

   assign D_OUT = mpu_data_out;
    
   always @(posedge clock or posedge reset)
     if (reset)
       mpu_data_in <= 0;
     else
       if (clock_e_set)
	 mpu_data_in <= D_IN;
    
   assign TSC = 1'b0;

   always @(posedge clock or posedge reset)
     if (reset)
       begin
	  RESET_N <= 0;
	  HALT_N <= 0;
	  IRQ_N <= 0;
	  FIRQ_N <= 0;
	  NMI_N <= 0;
       end
     else
       begin
          if (clock_q_set)
	    begin
	       // RESET, HALT, interrupts are captured by microprocessor
	       // on Q falling edge. Present once per processor clock,
	       // on Q rising edge -- just because.
	       RESET_N <= ~mpu_reset;
	       HALT_N <= ~mpu_halt;
	       IRQ_N <= ~mpu_irq;
	       FIRQ_N <= ~mpu_firq;
	       NMI_N <= ~mpu_nmi;
	    end
       end

    always @(posedge clock or posedge reset)
      if (reset)
	begin
	   mpu_address <= 0;
	   mpu_bus_status <= 0;
	   mpu_bus_available <= 0;
	   mpu_halted <= 0;
	   mpu_write <= 0;
	   mpu_read <= 0;
	   debug_last_mpu_address <= 0;
	end
      else
	begin
           if (clock_q_set)
	     begin
		mpu_address <= A;
		mpu_bus_status <= BS;
		mpu_bus_available <= BA;
		mpu_halted <= BS & BA;
		mpu_write <= ~R_W_N & ~BA;
		mpu_read <= R_W_N & ~BA;
		
		if (BA == 1'b0)
		  debug_last_mpu_address <= A;
	     end
	end
    
    //-----------------------------------------------------------------

    assign MemOE = memory_output_enable ? 1'b0 : 1'b1;
    assign MemWR = memory_write ? 1'b0 : 1'b1;
    
    assign RamAdv = 1'b0;
    assign RamCS = ram_enable ? 1'b0 : 1'b1;
    assign RamClk = clock;
    assign RamCRE = 1'b0;
    assign RamLB = ram_lower_enable ? 1'b0 : 1'b1;
    assign RamUB = ram_upper_enable ? 1'b0 : 1'b1;
    
    assign FlashRp = 1'b1;
    assign FlashCS = flash_enable ? 1'b0 : 1'b1;
    
    assign MemAdr = { 7'b0000000, memory_address };
    
    assign MemDB_out = { memory_data_out[7:4], memory_data_out[7:4],
			 memory_data_out[3:0], memory_data_out[3:0] };

    assign memory_data_in = { MemDB_in[11:8], MemDB_in[3:0] };

    //-----------------------------------------------------------------
    // VGA output

`ifdef never
    assign Hsync = ~horizontal_sync;
    assign Vsync = ~vertical_sync;
    assign Blank = video_blank || horizontal_sync || vertical_sync;
`endif

    //-----------------------------------------------------------------

    assign DP = led_dp;
    assign SEG = led_segment;
    assign AN = led_anode;
    
    //-----------------------------------------------------------------
    // 1MHz, 12-phase counter.
    
    always @(posedge clock or posedge reset)
      if (reset)
	clock_12_phase <= 12'b000000000001;
      else
	// rotate left
	clock_12_phase <= { clock_12_phase[10:0], clock_12_phase[11] };
    
    //-----------------------------------------------------------------
    // Q clock

    assign clock_q_set = clock_12_phase[2];
    assign clock_q_clear = clock_12_phase[8];

    always @(posedge clock or posedge reset)
      if (reset)
	clock_q <= 0;
      else
	begin
           if (clock_q_set)
             clock_q <= 1'b1;
           else
	     if (clock_q_clear)
               clock_q <= 1'b0;
        end
    
    //-----------------------------------------------------------------
    // E clock

    assign clock_e_set = clock_12_phase[5];
    assign clock_e_clear = clock_12_phase[11];

    always @(posedge clock or posedge reset)
      if (reset)
	clock_e <= 0;
      else
	begin
           if (clock_e_set)
             clock_e <= 1'b1;
           else
	     if (clock_e_clear)
               clock_e <= 1'b0;
        end
    
    //-----------------------------------------------------------------
    // Reset generator

    initial
      begin
	 reset_counter = 0;
	 reset = 1'b1;
      end
   
    always @(posedge clock)
      begin
         if (reset_request)
	   begin
	      reset_counter <= 0;
              reset <= 1'b1;
	   end
         else
	   begin
              if (reset_counter < 100)
                reset_counter <= reset_counter + 8'd1;
              else
                reset <= 1'b0;
	   end
      end
   
    //-----------------------------------------------------------------
    // Video counter

    assign video_count_next =  (video_count != 15'd16639) ? video_count + 15'd1 : 15'b0;
    assign video_address_or_mask = video_count_next[14] ? 14'b11111100000000 : 14'b0;
    assign irq_4ms = video_address[11];

    reg [1:0] r_advance;
    always @(posedge clock or posedge reset)
      if (reset)
	r_advance <= 0;
      else
	if (clock_12_phase[0])
	  r_advance <= { r_advance[0], advance_video_count };
   
    reg r_advance_video_count, r_clear_video_count;
    wire advance_video_count, clear_video_count;

    always @(posedge clock or posedge reset)
      if (reset)
	begin
	   r_advance_video_count <= 0;
	   r_clear_video_count <= 0;
	end
      else
	begin
//	   r_advance_video_count <= advance_video_count;

	   if (clock_12_phase[10])
	     begin
		if (video_count[4:0] != 5'h1f || (video_count[4:0] == 5'h1f && r_advance == 2'b01))
		  r_advance_video_count <= 1'b1;
		else
		  r_advance_video_count <= 1'b0;
	     
		r_clear_video_count <= clear_video_count;
	     end
	end
   
    always @(posedge clock or posedge reset)
      if (reset)
	begin
	   video_count <= 15'b0;
	   video_address <= 14'b0;
	end
      else
	begin    
	   // Advance video count at end of video memory phase.
           if (clock_e_clear & r_advance_video_count)
	     begin
		//watchdog_increment <= 1'b0;
		video_count <= r_clear_video_count ? 15'b0 : video_count_next;
		video_address <= r_clear_video_count ? 14'b0 : (video_count_next[13:0] | video_address_or_mask);
//		video_address <= video_count_next[13:0] | video_address_or_mask;
		//if (video_count[14:0] == 15'b011111111111111)
		//    watchdog_increment <= 1'b1;
	     end
	end

    //-----------------------------------------------------------------
    // Video generator
    
    assign count_240 = video_address[13:10] == 4'b1111 ? 1'b1 : 1'b0;

    assign horizontal_sync = video_address[4:1]  == 4'b1110 ? 1'b1 : 1'b0;
    assign vertical_sync   = video_address[13:9] == 5'b11111 ? 1'b1 : 1'b0;

`ifdef debug_vga
    always @(posedge clock)
      if (horizontal_sync) $display("HSYNC %x",video_address);
    always @(posedge clock)
      if (vertical_sync) $display("VSYNC %x", video_address);
`endif

    //-----------------------------------------------------------------
    // LED numeric display
    
    always @(posedge clock or posedge reset)
      if (reset)
	led_counter <= 0;
      else
        led_counter <= led_counter + 16'd1;
    
    assign led_digit_index = led_counter[15:14];

    assign led_anode =
		      (led_digit_index == 2'b00) ? 4'b1110 :
		      (led_digit_index == 2'b01) ? 4'b1101 :
		      (led_digit_index == 2'b10) ? 4'b1011 :
		      (led_digit_index == 2'b11) ? 4'b0111 :
		      4'b1111;
    
   assign led_bcd_in_digit =
			    (led_digit_index == 2'b00) ? led_bcd_in[ 3: 0] :
                            (led_digit_index == 2'b01) ? led_bcd_in[ 7: 4] :
                            (led_digit_index == 2'b10) ? led_bcd_in[11: 8] :
			    (led_digit_index == 2'b11) ? led_bcd_in[15:12] :
                            4'bXXXX;
        
   led_decoder bcd_demux(.in(led_bcd_in_digit), .out(led_segment));
        
   assign led_dp = 1'b1;

   // debug
`ifdef never
   always @(MemAdr or memory_address or memory_data_out)
     if (ram_enable && memory_write)
       $display("XXX %x %x <= %x", MemAdr, memory_address, memory_data_out);

   always @(A or BA or BS or address or mpu_write or mpu_address or blt_register_access or mpu_halted)
   if (mpu_write)
     $display("**** mpu_wite, A=%x BA=%b BS=%b (address=%x mpu_write=%b mpu_address=%x blt=%b, mpu_halted=%b)",
	      A, BA, BS, address, mpu_write, mpu_address, blt_register_access, mpu_halted);
`endif

`ifdef never
   always @(blt_write or mpu_halted, address, blt_address_out)
     if (blt_write)
       begin
	  $display("%0t mpu_halted=%b address=%x blt_address_out=%x",
		   $time, mpu_halted, address, blt_address_out);
       end

   always @(blt_write or MemAdr or MemDB_out or MemOE or MemWR or RamCS or RamLB or RamUB)
     if (blt_write)
       begin
	  $display("blt_write: MemAdr %x, MemDB_out %x, MemOe %b, MemWR %b, RamCS %b, RamLB %b, RamUB %b",
		   MemAdr, MemDB_out, MemOE, MemWR, RamCS, RamLB, RamUB);
       end

   always @(blt_read or MemAdr or MemDB_out or MemOE or MemWR or RamCS or RamLB or RamUB)
     if (blt_read)
       begin
	  $display("blt_read: MemAdr %x, MemDB_out %x, MemOe %b, MemWR %b, RamCS %b, RamLB %b, RamUB %b",
		   MemAdr, MemDB_out, MemOE, MemWR, RamCS, RamLB, RamUB);
       end
`endif

   reg old_HAND;
   always @(posedge clock)
     begin
	if (old_HAND != HAND)
	  $display("sound: hand change HAND=%b", HAND);
	old_HAND <= HAND;
     end

   reg [5:0] old_PB;
   always @(posedge clock)
     begin
	if (old_PB != PB)
	  $display("sound: PB change PB=%x", PB);
	old_PB <= PB;
     end
   
//   always @(HAND or PB[5:0])
//     if (HAND == 1'b0)
//       $display("sound: HAND=%b PB[5:0]=%x", HAND, PB[5:0]);

   always @(rom_pia_cs or rom_pia_rs or rom_pia_write or rom_pia_data_in)
     if (rom_pia_cs && rom_pia_write)
       $display("rom_pia: write %b <= %x", rom_pia_rs, rom_pia_data_in);

`ifdef debug_pia_r
   always @(rom_pia_access or address or mpu_data_in or read or clock_12_phase[8])
     if (rom_pia_access && read && clock_12_phase[8])
       $display("rom_pia: r match address %x => %x phase[8]=%b",
		address, rom_pia_data_out, clock_12_phase[8]);

   always @(widget_pia_access or address or mpu_data_in or read or clock_12_phase[8])
     if (widget_pia_access && read && clock_12_phase[8])
       $display("widget_pia: r match address %x => %x phase[8]=%b",
		address, widget_pia_data_out, clock_12_phase[8]);
`endif

`ifdef debug
   reg [3:0] old_BTN;
   always @(posedge clock)
     begin
	if (old_BTN != BTN)
	  $display("xxx_pia: change BTN=%x %x (widget_pia_pa_in=%x, PLAYER_1_START=%x) %t",
		   old_BTN, BTN, widget_pia_pa_in, PLAYER_1_START, $time);
	
	old_BTN <= BTN;
     end

   reg [7:0] old_rom_pia_pa_in;
   always @(posedge clock)
     begin
	if (old_rom_pia_pa_in != rom_pia_pa_in)
	  $display("rom_pia: change rom_pia_pa_in=%x %x", old_rom_pia_pa_in, rom_pia_pa_in);
	
	old_rom_pia_pa_in <= rom_pia_pa_in;
     end

   reg [7:0] old_widget_pia_pa_in;
   always @(posedge clock or posedge reset)
     if (reset)
       old_widget_pia_pa_in <= 0;
     else
     begin
	if (old_widget_pia_pa_in != widget_pia_pa_in)
	  $display("widget_pia: change widget_pia_pa_in=%x %x",
		   old_widget_pia_pa_in, widget_pia_pa_in);
	
	old_widget_pia_pa_in <= widget_pia_pa_in;
     end
	
`endif

   //------------------------------------------------------------

   wire pixclk;

   reg [11:0] r_hCounter;
   reg [11:0] r_vCounter;

   reg [11:0] n_hCounter;
   reg [11:0] n_vCounter;

   reg 	      r_hSync, r_vSync, r_vblank, r_hblank;
   reg        n_hSync, n_vSync, n_vblank, n_hblank;

   wire [2:0] vga_red_lb;
   wire [2:0] vga_green_lb;
   wire [2:0] vga_blue_lb;

   // Assign the outputs
   assign Hsync = r_hSync;
   assign Vsync = r_vSync;
   assign Blank = r_hblank || r_vblank;
   assign vgaRed = vga_red_lb;
   assign vgaGreen = vga_green_lb;
   assign vgaBlue = vga_blue_lb;

   assign pixclk = clock/*vga_clk_in*/;

//   assign advance_video_count = r_hCounter < 190/*192*//*384*/;
//   assign advance_video_count = r_hCounter > 129 /*&& r_hCounter < 320*/;
//   assign advance_video_count = r_hCounter > 32 /*&& r_hCounter < 320*/;
//   assign advance_video_count = r_hCounter > 96 && r_hCounter < 480;
   assign advance_video_count = r_hCounter > 32 && r_hCounter < 340;
   assign clear_video_count = r_vblank;

   always @(r_hCounter or r_vCounter)
     begin
	n_hCounter = r_hCounter;
	n_vCounter = r_vCounter;

	n_hSync = 1'b0;
	n_vSync = 1'b0;

	// Count the lines and rows
//	if (r_hCounter == 800-1)
	if (r_hCounter == 400-1)	  
	  begin
             n_hCounter = 0;
             if (r_vCounter == 525-1)
               n_vCounter = 0;
             else
               n_vCounter = r_vCounter + 12'd1;
	  end
	else
          n_hCounter = r_hCounter + 12'd1;

//      if (r_hCounter < 640)
	if (r_hCounter < 340/*320*/)
          n_hblank = 1'b0;
	else
          n_hblank = 1'b1;
      
//	if (r_vCounter < 480)
	if (r_vCounter < 500)
          n_vblank = 1'b0;
	else
          n_vblank = 1'b1;
      
	// Are we in the hSync pulse?
//	if (r_hCounter >= 656 && r_hCounter < 752)
//	if (r_hCounter >= 323 && r_hCounter < 376)
	if (r_hCounter >= 340 && r_hCounter < 390)
	  n_hSync = 1'b1;

	// Are we in the vSync pulse?
//	if (r_vCounter >= 490 && r_vCounter < 492)
	if (r_vCounter >= 502 && r_vCounter < 504)
          n_vSync = 1'b1; 
     end

   always @(posedge pixclk or posedge reset)
     if (reset)
       begin
	  r_hCounter <= 0;
	  r_vCounter <= 0;

	  r_hSync <= 0;
	  r_vSync <= 0;
	  r_hblank <= 0;
	  r_vblank <= 0;
       end
     else
       begin
	  r_hCounter <= n_hCounter;
	  r_vCounter <= n_vCounter;

	  r_hSync <= n_hSync;
	  r_vSync <= n_vSync;
	  r_hblank <= n_hblank;
	  r_vblank <= n_vblank;
       end

   reg [3:0] hoffset;
   always @(clock_12_phase)
     case (clock_12_phase)
       12'b0000_0000_0001: hoffset = 4'd0;
       12'b0000_0000_0010: hoffset = 4'd1;
       12'b0000_0000_0100: hoffset = 4'd2;
       12'b0000_0000_1000: hoffset = 4'd3;
       12'b0000_0001_0000: hoffset = 4'd4;
       12'b0000_0010_0000: hoffset = 4'd5;
       12'b0000_0100_0000: hoffset = 4'd6;
       12'b0000_1000_0000: hoffset = 4'd7;
       12'b0001_0000_0000: hoffset = 4'd8;
       12'b0010_0000_0000: hoffset = 4'd9;
       12'b0100_0000_0000: hoffset = 4'd10;
       12'b1000_0000_0000: hoffset = 4'd11;
       default: hoffset = 4'd0;
     endcase

   line_buffer lb(.pixclk(pixclk),
		  .reset(reset),

		  .hcount_2(r_hCounter),
		  .vcount_2(r_vCounter),
		  .hsync_2(r_hSync),
		  .vsync_2(r_vSync),
		  .red_2(vga_red_lb),
		  .grn_2(vga_green_lb),
		  .blu_2(vga_blue_lb),
		  
		  .hcount_1({7'b0, video_address[ 4:0]}),
		  .vcount_1({3'b0, video_address[13:5]}),
		  .hoffset_1(hoffset),
		  .hsync_1(horizontal_sync),
		  .vsync_1(vertical_sync),
		  .red_1(vga_red),
		  .grn_1(vga_green),
		  .blu_1(vga_blue)
		  );
   
endmodule


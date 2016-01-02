# arcade-robotron

verilog fpga robotron arcade games - from the schematics
converted from vhdl sharedbrained project https://github.com/sharedbrained/robotron-fpga,
with some bug fixes and a scan converter for HDMI.

I added a second 6809 as well.  This projec is complete and doesn't need an external 6809.

## Overview

Ports of original arcade hardware/software to the "Pipistrello" FPGA board @ http://pipistrello.saanlima.com

The board features a Xilinx Spartan-6 LX45 with HDMI output.  I made a
"control panel" with two joysticks and buttons,

http://www.robotron2084guidebook.com/technical/gameplatforms/mame/homemadecontrolpaneltips/

And then wired it to the FPGA;  the inputs are pulled up and the switch contacts connect to ground.

The verilog creates a "mapping" of the video from the old CGA-ish format
to 640x480 VGA.  Video output is to the HDMI port and audio (sound) to
the sound port.

"cver" and "verilator" were used to simulate the RTL.


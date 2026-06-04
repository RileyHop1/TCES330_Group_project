# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog -timescale "1ns/1ps" "./2-to-1-mux.sv"
vlog -timescale "1ns/1ps" "./ALU.sv"
vlog -timescale "1ns/1ps" "./RegALU.sv"
vlog -timescale "1ns/1ps" "./RegFile.sv"
vlog -timescale "1ns/1ps" "./IR.sv"
vlog -timescale "1ns/1ps" "./PC.sv"
vlog -timescale "1ns/1ps" "./ControllerStateMachine.sv"
vlog -timescale "1ns/1ps" "./InstMemory.v"
vlog -timescale "1ns/1ps" "./RAM.v"
vlog -timescale "1ns/1ps" "./ControlUnit.sv"
vlog -timescale "1ns/1ps" "./DataPath.sv"
vlog -timescale "1ns/1ps" "./Processor.sv"
vlog -timescale "1ns/1ps" "./testProcessor.sv"

# Call vsim to invoke simulator
#     The last item on the line is the name of the testbench module
#     to execute. ALU_tb is purely combinational (no Altera cores) but
#     -L altera_mf_ver is harmless and kept for a consistent flow.
vsim -voptargs="+acc" -t 1ps -L altera_mf_ver -lib work ALU_tb

# Load the associated waveform format file
do waveAlu.do

# Open the structure/signal panes
view structure
view signals

# Run the simulation
run -all

# End

# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./2-to-1-mux.sv"
vlog "./ALU.sv"
vlog "./RegALU.sv"
vlog "./RegFile.sv"
vlog "./IR.sv"
vlog "./PC.sv"
vlog "./ControllerStateMachine.sv"
vlog "./InstMemory.v"   
vlog "./RAM.v"          
vlog "./ControlUnit.sv"
vlog "./DataPath.sv"
vlog "./Processor.sv"
vlog "./testProcessor.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
#     -L altera_mf_ver links the Altera megafunction sim library so the
#     altsyncram cores in RAM.v / InstMemory.v elaborate and load their .mif data.
vsim -voptargs="+acc" -t 1ps -L altera_mf_ver -lib work testProcessor

# Load the associated waveform format file
do wave.do

# Open the structure/signal panes
view structure
view signals

# Run the simulation
run -all

# End

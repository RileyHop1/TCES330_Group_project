onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -divider "Clock / Reset"
add wave -noupdate /testProcessor/Clk
add wave -noupdate /testProcessor/ResetN
add wave -divider "Control Unit"
add wave -noupdate -radix unsigned /testProcessor/PC_Out
add wave -noupdate -radix hexadecimal /testProcessor/IR_Out
add wave -noupdate -radix unsigned /testProcessor/State
add wave -noupdate -radix unsigned /testProcessor/NextState
add wave -divider "ALU / Datapath"
add wave -noupdate -radix hexadecimal /testProcessor/ALU_A
add wave -noupdate -radix hexadecimal /testProcessor/ALU_B
add wave -noupdate -radix hexadecimal /testProcessor/ALU_Out
add wave -noupdate -radix binary      /testProcessor/DUT/Flags_bus
add wave -divider "Register File"
add wave -noupdate -radix hexadecimal /testProcessor/DUT/DP/regfile/regfile

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {2 us}

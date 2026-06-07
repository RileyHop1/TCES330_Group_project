onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -divider "Clock / Reset"
add wave -noupdate                    /ControlUnit_tb/clk
add wave -noupdate                    /ControlUnit_tb/rst
add wave -noupdate -radix binary      /ControlUnit_tb/Flags
add wave -divider "Fetch / Decode"
add wave -noupdate -radix unsigned    /ControlUnit_tb/PC_Out
add wave -noupdate -radix hexadecimal /ControlUnit_tb/IR_Out
add wave -noupdate -radix unsigned    /ControlUnit_tb/OutState
add wave -noupdate -radix unsigned    /ControlUnit_tb/NextState
add wave -divider "Datapath Control"
add wave -noupdate -radix unsigned    /ControlUnit_tb/ALU_s0
add wave -noupdate -radix unsigned    /ControlUnit_tb/RF_W_addr
add wave -noupdate -radix unsigned    /ControlUnit_tb/RF_Ra_addr
add wave -noupdate -radix unsigned    /ControlUnit_tb/RF_Rb_addr
add wave -noupdate                    /ControlUnit_tb/RF_W_en
add wave -noupdate                    /ControlUnit_tb/RF_s
add wave -noupdate -radix unsigned    /ControlUnit_tb/D_Addr
add wave -noupdate                    /ControlUnit_tb/D_Wr

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
WaveRestoreZoom {0 ps} {1 us}

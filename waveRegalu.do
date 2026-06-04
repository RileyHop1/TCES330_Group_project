onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -divider "Clock / Control"
add wave -noupdate                    /regALU_tb/clk
add wave -noupdate                    /regALU_tb/write
add wave -noupdate                    /regALU_tb/loadSel
add wave -divider "ALU Control"
add wave -noupdate -radix unsigned    /regALU_tb/Sel
add wave -noupdate -radix hexadecimal /regALU_tb/dataIn
add wave -divider "Addresses"
add wave -noupdate -radix unsigned    /regALU_tb/wrAddr
add wave -noupdate -radix unsigned    /regALU_tb/rdAddrA
add wave -noupdate -radix unsigned    /regALU_tb/rdAddrB
add wave -divider "ALU Operands / Result"
add wave -noupdate -radix hexadecimal /regALU_tb/dut/rdDataA
add wave -noupdate -radix hexadecimal /regALU_tb/dut/rdDataB
add wave -noupdate -radix hexadecimal /regALU_tb/Q
add wave -divider "Register File"
add wave -noupdate -radix hexadecimal /regALU_tb/dut/File/regfile

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

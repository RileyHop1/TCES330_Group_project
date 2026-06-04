onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -divider "Clock / Control"
add wave -noupdate                    /regfile8x16a_tb/clk
add wave -noupdate                    /regfile8x16a_tb/write
add wave -divider "Write Port"
add wave -noupdate -radix unsigned    /regfile8x16a_tb/wrAddr
add wave -noupdate -radix hexadecimal /regfile8x16a_tb/wrData
add wave -divider "Read Ports"
add wave -noupdate -radix unsigned    /regfile8x16a_tb/rdAddrA
add wave -noupdate -radix hexadecimal /regfile8x16a_tb/rdDataA
add wave -noupdate -radix unsigned    /regfile8x16a_tb/rdAddrB
add wave -noupdate -radix hexadecimal /regfile8x16a_tb/rdDataB
add wave -divider "Register File"
add wave -noupdate -radix hexadecimal /regfile8x16a_tb/File/regfile

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
WaveRestoreZoom {0 ps} {800 ns}

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /control_tb/err
add wave -noupdate /control_tb/clk
add wave -noupdate /control_tb/reset
add wave -noupdate /control_tb/s
add wave -noupdate /control_tb/op
add wave -noupdate /control_tb/opcode
add wave -noupdate /control_tb/vsel
add wave -noupdate /control_tb/write
add wave -noupdate /control_tb/loada
add wave -noupdate /control_tb/loadb
add wave -noupdate /control_tb/asel
add wave -noupdate /control_tb/bsel
add wave -noupdate /control_tb/loadc
add wave -noupdate /control_tb/loads
add wave -noupdate /control_tb/nsel
add wave -noupdate /control_tb/w
add wave -noupdate /control_tb/dut/STATE/in
add wave -noupdate /control_tb/dut/STATE/out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {399 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 51
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ps} {69 ps}

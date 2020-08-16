onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu_tb/DUT/InstructionReg/en
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/REG7/out
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/REG6/out
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/REG5/out
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/REG4/out
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/REG3/out
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/REG2/out
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/REG1/out
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/REG0/out
add wave -noupdate /cpu_tb/DUT/FSM/STATE/clk
add wave -noupdate /cpu_tb/DUT/FSM/STATE/in
add wave -noupdate /cpu_tb/DUT/FSM/STATE/out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {1 ns}

set log file mux_8x1_4x1.log -replace
read library /home/vlsi5/23BEC1020_L19L20_ASIC/Equivalence_Checking/slow.v -verilog -both
read design /home/vlsi5/23BEC1020_L19L20_ASIC/work/mux_8x1_4x1.v -verilog -golden
read design /home/vlsi5/23BEC1020_L19L20_ASIC/synthesis/mux_8x1_4x1_netlist.v -verilog -revised

set system mode lec
add compare point -all
compare

report verification
set gui on

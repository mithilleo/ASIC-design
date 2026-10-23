set log file shift_add_mul.log -replace
read library /home/vlsi5/23BEC1020_L19L20_ASIC/Equivalence_Checking/slow.v -verilog -both
read design /home/vlsi5/23BEC1020_L19L20_ASIC/work/shift_add_mul.v -verilog -golden
read design /home/vlsi5/23BEC1020_L19L20_ASIC/synthesis/shift_add_mul_netlist.v -verilog -revised

set system mode lec
add compare point -all
compare

report verification
set gui on

set log file booth_multiplier.log -replace
read library /home/vlsi5/23BEC1020_L19L20_ASIC/Equivalence_Checking/slow.v -verilog -both
read design /home/vlsi5/23BEC1020_L19L20_ASIC/work/booth_multiplier.v -verilog -golden
read design /home/vlsi5/23BEC1020_L19L20_ASIC/synthesis/booth_multiplier_netlist.v -verilog -revised

set system mode lec
add compare point -all
compare

report verification
set gui on

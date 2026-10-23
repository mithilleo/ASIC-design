set log file gcd_accelerator.log -replace
read library /home/vlsi5/23BEC1020_L19L20_ASIC/Equivalence_Checking/slow.v -verilog -both
read design /home/vlsi5/23BEC1020_L19L20_ASIC/work/gcd_accelerator.v -verilog -golden
read design /home/vlsi5/23BEC1020_L19L20_ASIC/synthesis/gcd_accelerator_netlist.v -verilog -revised

set system mode lec
add compare point -all
compare

report verification
set gui on

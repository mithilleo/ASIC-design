set log file SRff.log -replace
read library /home/vlsi5/23BEC1020_L19L20_ASIC/Equivalence_Checking/slow.v -verilog -both
read design /home/vlsi5/23BEC1020_L19L20_ASIC/work/SRff.v -verilog -golden
read design /home/vlsi5/23BEC1020_L19L20_ASIC/synthesis/SRff_netlist.v -verilog -revised

set system mode lec
add compare point -all
compare

report verification
set gui on

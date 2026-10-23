set log file updowncounter_4bit.log -replace
read library /home/vlsi5/23BEC1020_L19L20_ASIC/Equivalence_Checking/slow.v -verilog -both
read design /home/vlsi5/23BEC1020_L19L20_ASIC/work/updowncounter_4bit.v -verilog -golden
read design /home/vlsi5/23BEC1020_L19L20_ASIC/synthesis/updowncounter_4bit_netlist.v -verilog -revised

set system mode lec
add compare point -all
compare

report verification
set gui on

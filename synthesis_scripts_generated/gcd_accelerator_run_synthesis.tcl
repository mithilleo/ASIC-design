#=================================================================
# run_synthesis.tcl -- Genus synthesis script
# 23BEC1020 Sai Mithil K -- ASIC Lab Experiment 2
#=================================================================
set DESIGN gcd_accelerator
set TB_SCOPE ${DESIGN}_tb/uut

set WORKDIR ../work
# ---------------- 1. library setup ----------------
set_db init_lib_search_path /home/install/FOUNDRY/digital/90nm/dig/lib
set_db library slow.lib
set_db information_level 7
# ---------------- 2. read and elaborate ----------------
read_hdl ${DESIGN}.v
elaborate ${DESIGN}
check_design -unresolved
# ---------------- 3. constraints ----------------
source ${DESIGN}_constraints.g
# (equivalently: read_sdc input_constraint.g )
# ---------------- 4. synthesis ----------------
syn_generic
syn_map
syn_opt
# ---------------- 5. reports without switching activity ----------------
report_timing > ${DESIGN}_timing.rpt
report_area > ${DESIGN}_area.rpt
report_gates > ${DESIGN}_gates.rpt
report_power > ${DESIGN}_power.rpt
# ---------------- 6. annotate switching activity from the VCD ----------------
read_vcd -static -vcd_scope ${TB_SCOPE} ${WORKDIR}/${DESIGN}.vcd
report_power > ${DESIGN}_power_vcd.rpt
# ---------------- 7. outputs ----------------
write_hdl > ${DESIGN}_netlist.v
write_hdl > ${DESIGN}_netlist_vcd.v
write_sdc > ${DESIGN}_constraints.sdc
gui_show
puts "---- synthesis of ${DESIGN} completed ----"
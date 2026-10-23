# ==============================================================================
# Complete Cadence Innovus ASIC Flow Script (Metal8/Metal9 DRC-Clean)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. Design Mode Setup & Global Net Connections
# ------------------------------------------------------------------------------
setDesignMode -process 90

globalNetConnect vdd -type pgpin -pin VDD -inst *
globalNetConnect vss -type pgpin -pin VSS -inst *
globalNetConnect vdd -type tiehi -inst *
globalNetConnect vss -type tielo -inst *

# ------------------------------------------------------------------------------
# 2. Floorplan Setup
# ------------------------------------------------------------------------------
floorPlan -r 1.0 0.699958 2.5 2.5 2.5 2.5

# ------------------------------------------------------------------------------
# 3. Power Network (Rings, Stripes, Special Route)
# ------------------------------------------------------------------------------
addRing -nets {vdd vss} -type core_rings -follow core \
    -layer {top Metal9 bottom Metal9 left Metal8 right Metal8} \
    -width {top 0.7 bottom 0.7 left 0.7 right 0.7} \
    -spacing {top 0.4 bottom 0.4 left 0.46 right 0.46} \
    -offset {top 0.5 bottom 0.5 left 0.5 right 0.5}

addStripe -nets {vdd vss} -layer Metal8 -direction vertical \
    -width 0.7 -spacing 0.46 -set_to_set_distance 5 -start_from left

sroute -connect { corePin } \
    -layerChangeRange { Metal1 Metal9 } \
    -nets { vdd vss } \
    -allowJogging 1 \
    -allowLayerChange 1

# ------------------------------------------------------------------------------
# 4. Placement Setup & Execution
# ------------------------------------------------------------------------------
setAnalysisMode -checkType setup \
                -analysisType onChipVariation \
                -cppr both \
                -clockGatingCheck true

setPlaceMode -fp false \
             -congEffort auto \
             -timingDriven true \
             -clkGateAware true \
             -ignoreScan true \
             -reorderScan true \
             -placeIoPins true

place_design

# Tie Cell Insertion
setTieHiLoMode -cell { TIEHI TIELO } -maxDistance 20 -maxFanout 8
addTieHiLo

# ------------------------------------------------------------------------------
# 5. Pre-CTS Timing Check & Conditional Setup Optimization
# ------------------------------------------------------------------------------
timeDesign -preCTS -outDir reports/preCTS_setup

set prects_slack [get_property [get_timing_paths -max_paths 1 -delay_type max] slack]

if { $prects_slack < 0 } {
    puts "\[WARNING\] Pre-CTS Setup Violations Found (Slack: $prects_slack). Running Pre-CTS Optimization..."
    optDesign -preCTS
} else {
    puts "\[INFO\] Pre-CTS Setup Timing Passed (Slack: $prects_slack)."
}

# ------------------------------------------------------------------------------
# 6. Non-Default Rules (NDR) Setup
# ------------------------------------------------------------------------------
add_ndr -name 2w2s \
    -width { Metal1 0.23 Metal2 0.28 Metal3 0.28 Metal4 0.28 Metal5 0.28 Metal6 0.44 Metal7 0.14 Metal8 0.44 Metal9 0.44 } \
    -spacing { Metal1 0.23 Metal2 0.28 Metal3 0.28 Metal4 0.28 Metal5 0.28 Metal6 0.46 Metal7 0.14 Metal8 0.40 Metal9 0.40 } \
    -min_cut { Via1 1 Via2 1 Via3 1 Via4 1 Via5 1 Via6 1 Via7 1 Via8 1 }

# ------------------------------------------------------------------------------
# 7. Clock Tree Synthesis (CCOPT)
# ------------------------------------------------------------------------------
#set_ccopt_property buffer_cells { BUFX1 BUFX2 BUFX4 BUFX8 BUFX12 BUFX16 CLKBUFX1 CLKBUFX2 CLKBUFX4 CLKBUFX8 }
#set_ccopt_property inverter_cells { INVX1 INVX2 INVX4 INVX8 INVX12 INVX16 CLKINVX1 CLKINVX2 CLKINVX4 CLKINVX8 }

source shift_add_mul_ccopt.spec
ccopt_design -cts

# ------------------------------------------------------------------------------
# 8. Post-CTS Setup & Hold Analysis / Conditional ECO Optimization
# ------------------------------------------------------------------------------
timeDesign -postCTS -outDir reports/postCTS_setup
timeDesign -postCTS -hold -outDir reports/postCTS_hold

set postcts_setup_slack [get_property [get_timing_paths -max_paths 1 -delay_type max] slack]
set postcts_hold_slack  [get_property [get_timing_paths -max_paths 1 -delay_type min] slack]

if { $postcts_setup_slack < 0 } {
    puts "\[WARNING\] Post-CTS Setup Violations Found (Slack: $postcts_setup_slack). Running ECO Optimization..."
    optDesign -postCTS
}

if { $postcts_hold_slack < 0 } {
    puts "\[WARNING\] Post-CTS Hold Violations Found (Slack: $postcts_hold_slack). Running Hold ECO Optimization..."
    optDesign -postCTS -hold
}

if { $postcts_setup_slack >= 0 && $postcts_hold_slack >= 0 } {
    puts "\[INFO\] Post-CTS Setup and Hold Checks Passed."
}

# ------------------------------------------------------------------------------
# 9. NanoRoute (Global & Detail Routing)
# ------------------------------------------------------------------------------
setNanoRouteMode -quiet -routeWithTimingDriven true
setNanoRouteMode -quiet -routeWithSiDriven true
routeDesign -globalDetail

# Post-Route Timing Check & Fix
timeDesign -postRoute -outDir reports/postRoute_setup
timeDesign -postRoute -hold -outDir reports/postRoute_hold

set postroute_setup_slack [get_property [get_timing_paths -max_paths 1 -delay_type max] slack]
set postroute_hold_slack  [get_property [get_timing_paths -max_paths 1 -delay_type min] slack]

if { $postroute_setup_slack < 0 || $postroute_hold_slack < 0 } {
    puts "\[WARNING\] Post-Route Timing Violations Found. Running Post-Route ECO..."
    optDesign -postRoute -setup -hold
}

# ------------------------------------------------------------------------------
# 10. Add Filler Cells & Placement / DRC Verification
# ------------------------------------------------------------------------------
addFiller -cell { FILL1 FILL2 FILL64 FILL8 FILL16 FILL4 FILL32 } -prefix FILLER

checkPlace
verify_drc

# ------------------------------------------------------------------------------
# 11. Extract RC & Output SPEF File
# ------------------------------------------------------------------------------
setExtractRCMode -engine postRoute -effortLevel low
extractRC
rcOut -spef shift_add_mul1.spef

# ------------------------------------------------------------------------------
# 12. Export Netlist, GDSII Stream, and Design Database
# ------------------------------------------------------------------------------
saveNetlist shift_add_mul1_nl.v

streamOut shift_add_mul1.gds \
    -mapFile streamOut.map \
    -libName DesignLib \
    -units 1000 \
    -mode ALL

saveDesign shift_add_mul1.enc

create_route_type -name clkroute -non_default_rule 2w2s -bottom_preferred_layer Metal8 -top_preferred_layer Metal9
set_ccopt_property route_type clkroute -net_type trunk
set_ccopt_property route_type clkroute -net_type leaf

set_ccopt_property buffer_cells {CLKBUFX2 CLKBUFX4}
set_ccopt_property inverter_cells {CLKINVX2 CLKINVX4}
set_ccopt_property clock_gating_cells TLATNTSCA*
set_ccopt_property target_max_trans 0.20

create_ccopt_clock_tree_spec -file gcd_accelerator_ccopt_output.spec

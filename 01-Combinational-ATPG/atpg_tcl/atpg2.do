set_context patterns -Scan
read_verilog circuit2_1075.v -force
set_current_design
set_system_mode analysis
set_fault_type stuck
create_patterns
write_patterns testpatterns -replace
write_faults faultlist

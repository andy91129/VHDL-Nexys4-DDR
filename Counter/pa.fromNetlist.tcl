
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name counter -dir "W:/New York University/Advance_Hardware_Design/ISE_project/Counter/planAhead_run_1" -part xc7a100tcsg324-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "W:/New York University/Advance_Hardware_Design/ISE_project/Counter/decimal_counter.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {W:/New York University/Advance_Hardware_Design/ISE_project/Counter} }
set_property target_constrs_file "decimal_counter.ucf" [current_fileset -constrset]
add_files [list {decimal_counter.ucf}] -fileset [get_property constrset [current_run]]
link_design

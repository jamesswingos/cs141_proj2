open_project ./build/project_2/project_2.xpr
add_files -norecurse [glob ./hdl/*.sv*]
add_files -fileset constrs_1 -norecurse ./constraint/Nexys_A7.xdc
close_project

create_project -force project_2 ./build/project_2 -part xc7a100tcsg324-1
add_files -norecurse [glob ./hdl/*.sv*]
add_files -fileset constrs_1 -norecurse ./constraint/Nexys_A7.xdc
close_project

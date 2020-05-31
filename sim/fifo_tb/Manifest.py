action = "simulation"
sim_tool = "modelsim"
sim_top = "fifo_tb"

sim_post_cmd = "vsim -novopt -do ../vsim.do -c fifo_tb"

modules = {
  "local" : [ "../../test/" ],
}

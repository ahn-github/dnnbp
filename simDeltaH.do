add wave sim:/delta_h/*
force -freeze sim:/delta_h/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/delta_h/rst 1 0
force -freeze sim:/delta_h/en 1 0
force -freeze sim:/delta_h/i_prevd 16#0180000001800000 0
force -freeze sim:/delta_h/i_w 16#0100000001000000 0
force -freeze sim:/delta_h/i_a 16#01800000 0
run 100
force -freeze sim:/delta_h/rst 0 0
run 400
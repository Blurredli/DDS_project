# 时序约束文件 - DDS信号发生器

# 50MHz输入时钟
create_clock -name clk_50mhz -period 20.000 [get_ports clk_50mhz]

# PLL输出100MHz时钟（需在PLL配置后生成）
# create_generated_clock -name clk_100mhz -source [get_ports clk_50mhz] -multiply_by 2 [get_pins pll_inst|c0]

# 输入延迟约束
set_input_delay -clock clk_50mhz -max 5.0 [get_ports rst_n]
set_input_delay -clock clk_50mhz -min 1.0 [get_ports rst_n]
set_input_delay -clock clk_50mhz -max 5.0 [get_ports key_in[*]]
set_input_delay -clock clk_50mhz -min 1.0 [get_ports key_in[*]]
set_input_delay -clock clk_50mhz -max 5.0 [get_ports uart_rx]
set_input_delay -clock clk_50mhz -min 1.0 [get_ports uart_rx]

# 输出延迟约束
set_output_delay -clock clk_50mhz -max 5.0 [get_ports dds_out[*]]
set_output_delay -clock clk_50mhz -min 1.0 [get_ports dds_out[*]]
set_output_delay -clock clk_50mhz -max 5.0 [get_ports dac_rst]
set_output_delay -clock clk_50mhz -min 1.0 [get_ports dac_rst]
set_output_delay -clock clk_50mhz -max 5.0 [get_ports led_key]
set_output_delay -clock clk_50mhz -min 1.0 [get_ports led_key]
set_output_delay -clock clk_50mhz -max 5.0 [get_ports led_uart]
set_output_delay -clock clk_50mhz -min 1.0 [get_ports led_uart]
set_output_delay -clock clk_50mhz -max 5.0 [get_ports led_sys]
set_output_delay -clock clk_50mhz -min 1.0 [get_ports led_sys]

# 时钟不确定性
set_clock_uncertainty -setup 0.1 [get_clocks clk_50mhz]

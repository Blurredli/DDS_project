#!/bin/bash
# WSL下运行ModelSim仿真包装脚本
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
MODELSIM_EXE="/mnt/d/modelsim2020/modeltech64_2020.4/win64/vsim.exe"

# 关键：将Windows路径的反斜杠替换为正斜杠，TCL不会将其当作转义
WIN_DIR=$(wslpath -w "$PROJECT_DIR" | sed 's|\\|/|g')

echo "项目目录: $PROJECT_DIR"
echo "Windows路径(正斜杠): $WIN_DIR"

DO_FILE="$SCRIPT_DIR/run_sim_auto.do"
cat > "$DO_FILE" << EOF
set ROOT "$WIN_DIR"

quit -sim
if {[file exists work]} { vdel -lib work -all }
vlib work
vmap work work

echo "====== 编译 ======"
vlog -work work "\$ROOT/rtl/DDS_Core.v"
vlog -work work "\$ROOT/rtl/Key_Control.v"
vlog -work work "\$ROOT/rtl/UART_Parse.v"
vlog -work work "\$ROOT/rtl/DDS_Signal_Generator.v"
vlog -work work "\$ROOT/tb/tb_DDS_Signal_Generator.v"

echo "====== 仿真 ======"
vsim -t 1ns -voptargs=+acc -lib work tb_DDS_Signal_Generator

add wave -divider "Clock_Reset"
add wave -radix unsigned /tb_DDS_Signal_Generator/clk_50mhz
add wave -radix unsigned /tb_DDS_Signal_Generator/rst_n
add wave -divider "Keys"
add wave -radix binary /tb_DDS_Signal_Generator/key_in
add wave -divider "UART"
add wave -radix unsigned /tb_DDS_Signal_Generator/uart_rx
add wave -divider "DDS_Out"
add wave -radix unsigned /tb_DDS_Signal_Generator/dds_out
add wave -divider "Internal"
add wave -radix binary /tb_DDS_Signal_Generator/u_dut/wave_sel
add wave -radix unsigned /tb_DDS_Signal_Generator/u_dut/fcw_sel
add wave -radix unsigned /tb_DDS_Signal_Generator/u_dut/dds_core_inst/phase_acc
add wave -radix unsigned /tb_DDS_Signal_Generator/u_dut/dds_core_inst/sin_lut
add wave -radix unsigned /tb_DDS_Signal_Generator/u_dut/dds_core_inst/square_wave
add wave -radix unsigned /tb_DDS_Signal_Generator/u_dut/dds_core_inst/triangle_wave
add wave -divider "UART_Parse"
add wave -radix unsigned /tb_DDS_Signal_Generator/u_dut/uart_parse_inst/cnt_bit
add wave -radix hexadecimal /tb_DDS_Signal_Generator/u_dut/uart_parse_inst/uart_data
add wave -radix unsigned /tb_DDS_Signal_Generator/u_dut/uart_parse_inst/fcw_uart
add wave -radix unsigned /tb_DDS_Signal_Generator/u_dut/uart_parse_inst/fcw_update

configure wave -namecolwidth 250
configure wave -valuecolwidth 100

echo "====== 运行200ms ======"
run 200ms
echo "====== 完成 ======"
quit -f
EOF

cd "$PROJECT_DIR"
"$MODELSIM_EXE" -c -do "$DO_FILE" 2>&1

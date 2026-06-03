// PLL时钟倍频模块：50MHz -> 100MHz
// 目标器件：Cyclone II EP2C35F672C6
// 使用方法：通过Quartus MegaWizard生成，或直接使用此行为级模型
// 注意：实际综合时需使用Quartus生成的PLL IP核

module pll_50m_to_100m(
    input           inclk0,     // 50MHz输入时钟
    output          c0,         // 100MHz输出时钟
    output          locked      // PLL锁定标志
);

// 行为级模型（仅用于仿真，综合时需替换为Quartus PLL IP）
reg clk_out;
reg locked_reg;

initial begin
    clk_out = 0;
    locked_reg = 0;
    #100;  // 等待PLL锁定
    locked_reg = 1;
end

always #5 clk_out = ~clk_out;  // 100MHz时钟（10ns周期）

assign c0 = clk_out;
assign locked = locked_reg;

endmodule

// ============================================================
// 以下为Quartus MegaWizard生成的PLL IP核模板
// 实际使用时，请通过以下步骤生成：
// 1. 打开Quartus II
// 2. Tools -> MegaWizard Plug-In Manager
// 3. Create a new custom megafunction variation
// 4. 选择 pll -> altpll
// 5. 设置参数：
//    - Device family: Cyclone II
//    - Input clock frequency: 50 MHz
//    - Output clock c0: 100 MHz (multiply by 2, divide by 1)
//    - Output clock c1: (可选，用于其他用途)
// 6. 保存为 pll_50m_to_100m.v
// ============================================================

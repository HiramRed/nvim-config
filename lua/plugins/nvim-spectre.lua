return {
  -- 加上 spectre 专门处理 rg 搜索替换
  {
    "nvim-pack/nvim-spectre",
    keys = {
      { "<leader>S", '<cmd>lua require("spectre").toggle()<cr>', desc = "全局搜索替换" },
    },
  }
}

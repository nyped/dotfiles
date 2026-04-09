return {
  {
    dir = vim.fn.stdpath("config") .. "/lua/local/ts_surfer",
    name = "ts_surfer",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    config = function()
      require("local.ts_surfer").setup()
    end,
  },
}

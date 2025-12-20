return {
  { -- https://github.com/ellisonleao/dotenv.nvim
    "ellisonleao/dotenv.nvim",
    opts = {
      enable_on_load = true,
      verbose = false,
      file_name = ".env",
    },
  },
  { -- https://github.com/folke/snacks.nvim
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true, preset = { header = "nvim" } },
      explorer = { enabled = true },
      indent = { enabled = true, animate = { enabled = false } },
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = false },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      {
        "<Leader>vt",
        function()
          Snacks.explorer()
        end,
        desc = "open file finder",
      },
    },
  },
  { -- https://github.com/folke/persistence.nvim
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
  },
}

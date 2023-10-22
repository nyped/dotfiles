return {
  { -- https://github.com/ellisonleao/gruvbox.nvim
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({ transparent_mode = true })
      vim.cmd.colorscheme("gruvbox")
    end,
  },
  { -- https://github.com/stevearc/dressing.nvim
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = true,
  },
  { -- https://github.com/rcarriga/nvim-notify
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      local notify = require("notify")

      notify.setup({
        background_colour = "#000000",
      })
      vim.notify = notify
    end,
  },
}

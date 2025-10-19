return {
  { -- https://github.com/folke/zen-mode.nvim
    "folke/zen-mode.nvim",
    keys = {
      { "<Leader>gz", vim.cmd.ZenMode, desc = "ZenMode toggle" },
    },
    config = true,
  },
  { -- https://github.com/jinh0/eyeliner.nvim
    "jinh0/eyeliner.nvim",
    event = "VeryLazy",
    opts = {
      highlight_on_key = true,
    },
  },
  { -- https://github.com/mg979/vim-visual-multi
    "mg979/vim-visual-multi",
    keys = {
      { "<C-N>", desc = "VM visual multi cursors find under" },
      { "<C-Up>", desc = "VM visual multi cursors add cursor up" },
      { "<C-Down>", desc = "VM visual multi cursors add cursor down" },
    },
    config = false,
  },
  { -- https://github.com/NvChad/nvim-colorizer.lua
    "NvChad/nvim-colorizer.lua",
    keys = {
      { "<Leader>vc", vim.cmd.ColorizerToggle, desc = "Colorizer Toggle" },
    },
    config = true,
  },
  { -- https://github.com/folke/todo-comments.nvim
    "folke/todo-comments.nvim",
    keys = {
      { "<Leader>ft", vim.cmd.TodoTelescope, desc = "Telescope Todo" },
    },
    config = true,
  },
}

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
    commit = "8f197eb30cecdf4c2cc9988a5eecc6bc34c0c7d6",
    event = "VeryLazy",
    opts = {
      highlight_on_key = true,
    },
  },
  { -- https://github.com/mg979/vim-visual-multi
    "mg979/vim-visual-multi",
    commit = "a6975e7c1ee157615bbc80fc25e4392f71c344d4",
    keys = {
      { "<C-N>",    desc = "VM visual multi cursors find under" },
      { "<C-Up>",   desc = "VM visual multi cursors add cursor up" },
      { "<C-Down>", desc = "VM visual multi cursors add cursor down" },
    },
    config = false,
  },
  { -- https://github.com/catgoose/nvim-colorizer.lua
    "catgoose/nvim-colorizer.lua",
    commit = "338409dd8a6ed74767bad3eb5269f1b903ffb3cf",
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

return {
  { -- https://github.com/numToStr/Comment.nvim
    "numToStr/Comment.nvim",
    keys = {
      { "gc", mode = { "n", "x" }, desc = "go inline comment" },
      { "gb", mode = { "n", "x" }, desc = "go block comment" },
    },
    config = true,
  },
  { -- https://github.com/echasnovski/mini.surround
    "echasnovski/mini.surround",
    version = "*",
    keys = {
      { "<Leader>sa", mode = { "n", "x" }, desc = "surround add" },
      { "<Leader>sd", mode = { "n", "x" }, desc = "surround delete" },
      { "<Leader>sf", mode = { "n", "x" }, desc = "surround find right" },
      { "<Leader>sF", mode = { "n", "x" }, desc = "surround find left" },
      { "<Leader>sh", mode = { "n", "x" }, desc = "surround highlight" },
      { "<Leader>sr", mode = { "n", "x" }, desc = "surround replace" },
    },
    config = function()
      require("mini.surround").setup({
        highlight_duration = 1000,
        mappings = {
          add = "<Leader>sa", -- Add surrounding in Normal and Visual modes
          delete = "<Leader>sd", -- Delete surrounding
          find = "<Leader>sf", -- Find surrounding (to the right)
          find_left = "<Leader>sF", -- Find surrounding (to the left)
          highlight = "<Leader>sh", -- Highlight surrounding
          replace = "<Leader>sr", -- Replace surrounding
          update_n_lines = "", -- Update `n_lines`
          suffix_last = "", -- Suffix to search with "prev" method
          suffix_next = "", -- Suffix to search with "next" method
        },
      })
    end,
  },
  { -- https://github.com/echasnovski/mini.pairs
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    version = "*",
    config = true,
  },
  { -- https://github.com/mbbill/undotree
    "mbbill/undotree",
    keys = {
      { "<Leader>u", vim.cmd.UndotreeToggle, desc = "Undotree Toggle" },
    },
    config = false,
  },
  { -- https://github.com/folke/trouble.nvim
    "folke/trouble.nvim",
    keys = {
      { "<Leader>xx", vim.cmd.TroubleToggle, desc = "Trouble Toggle" },
    },
    config = true,
  },
}

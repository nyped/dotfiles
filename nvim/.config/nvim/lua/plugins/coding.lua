return {
  { -- https://github.com/nvim-mini/nvim-mini/mini.comment
    "nvim-mini/mini.comment",
    commit = "a0c721115faff8d05505c0a12dab410084d9e536",
    event = "VeryLazy",
  },
  { -- https://github.com/nvim-mini/nvim-mini/mini.surround
    "nvim-mini/mini.surround",
    commit = "d648a5601e1c48f175b07d10eba141da338a0a2a",
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
          add = "<Leader>sa",       -- Add surrounding in Normal and Visual modes
          delete = "<Leader>sd",    -- Delete surrounding
          find = "<Leader>sf",      -- Find surrounding (to the right)
          find_left = "<Leader>sF", -- Find surrounding (to the left)
          highlight = "<Leader>sh", -- Highlight surrounding
          replace = "<Leader>sr",   -- Replace surrounding
          update_n_lines = "",      -- Update `n_lines`
          suffix_last = "",         -- Suffix to search with "prev" method
          suffix_next = "",         -- Suffix to search with "next" method
        },
      })
    end,
  },
  { -- https://github.com/nvim-mini/mini.pairs
    "nvim-mini/mini.pairs",
    event = "InsertEnter",
    commit = "4089aa6ea6423e02e1a8326a7a7a00159f6f5e04"
  },
  { -- https://github.com/mbbill/undotree
    "mbbill/undotree",
    commit = "fc28931fbfba66ab75d9af23fe46ffbbb9de6e8c",
    keys = {
      { "<Leader>u", vim.cmd.UndotreeToggle, desc = "Undotree Toggle" },
    },
    config = false,
  },
  { -- https://github.com/folke/trouble.nvim
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      {
        "<Leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Trouble Toggle",
      },
    },
    config = true,
  },
}

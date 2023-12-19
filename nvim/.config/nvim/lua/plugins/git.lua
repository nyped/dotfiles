return {
  { -- https://github.com/lewis6991/gitsigns.nvim
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~_" },
          untracked = { text = "|" },
        },
      })
    end,
  },
  { -- https://github.com/NeogitOrg/neogit
    "NeogitOrg/neogit",
    cmd = "Neogit",
    keys = {
      { "<Leader>gg", vim.cmd.Neogit, desc = "Neogit (go git)" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "sindrets/diffview.nvim",
    },
    config = true,
  },
}

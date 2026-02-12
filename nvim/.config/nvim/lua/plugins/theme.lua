return {
  { -- https://github.com/ellisonleao/gruvbox.nvim
    "ellisonleao/gruvbox.nvim",
    commit = "a472496e1a4465a2dd574389dcf6cdb29af9bf1b",
    priority = 1000,
    config = function()
      local transparent_mode = vim.env._IN_WSL == nil
      require("gruvbox").setup({ transparent_mode = transparent_mode })
      vim.cmd.colorscheme("gruvbox")
    end,
  },
  { -- https://github.com/rcarriga/nvim-notify
    "rcarriga/nvim-notify",
    commit = "8701bece920b38ea289b457f902e2ad184131a5d",
    lazy = false,
    cmd = "Notifications",
    keys = {
      { "<Leader>fN", desc = "Dismiss notifications" },
    },
    config = function()
      local notify = require("notify")

      notify.setup({
        background_colour = "#000000",
      })
      vim.notify = notify

      vim.keymap.set(
        "n",
        "<Leader>fN",
        notify.dismiss,
        { desc = "Dismiss notifications" }
      )
    end,
  },
}

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
}

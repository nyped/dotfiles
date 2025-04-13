return {
  { -- https://github.com/nvim-java/
    "nvim-java/nvim-java",
    ft = "java",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("java").setup()
      require("lspconfig").jdtls.setup({})
    end,
  },
}

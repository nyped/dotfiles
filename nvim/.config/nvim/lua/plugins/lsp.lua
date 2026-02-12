return {
  { -- https://github.com/mason-org/mason.nvim
    "mason-org/mason.nvim",
    opts = {},
  },
  { -- https://github.com/neovim/nvim-lspconfig
    "neovim/nvim-lspconfig",
  },
  { -- https://github.com/rmagatti/goto-preview
    "rmagatti/goto-preview",
    commit = "d2d6923c9b9e0e43f0b9b566f261a8b1ae016540",
    config = true,
    keys = {
      {
        "gpd",
        function()
          require("goto-preview").goto_preview_definition()
        end,
        desc = "Go preview definition lsp",
      },
      {
        "gpD",
        function()
          require("goto-preview").goto_preview_declaration()
        end,
        desc = "Go preview declaration lsp",
      },
      {
        "gpi",
        function()
          require("goto-preview").goto_preview_implementation()
        end,
        desc = "Go preview implementation lsp",
      },
      {
        "gpr",
        function()
          require("goto-preview").goto_preview_references()
        end,
        desc = "Go preview references lsp",
      },
    },
  },
}

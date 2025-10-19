return {
  { -- https://github.com/mason-org/mason.nvim
    "mason-org/mason.nvim",
    opts = {},
  },
  { -- https://github.com/neovim/nvim-lspconfig
    "neovim/nvim-lspconfig",
  },
  { -- https://github.com/hedyhli/outline.nvim
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = { -- Example mapping to toggle outline
      { "<leader>o", vim.cmd.Outline, desc = "Toggle outline" },
    },
    opts = {},
  },
  { -- https://github.com/rmagatti/goto-preview
    "rmagatti/goto-preview",
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

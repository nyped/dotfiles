return {
  { -- https://github.com/stevearc/conform.nvim
    "stevearc/conform.nvim",
    event = "VeryLazy",
    dependencies = {
      "ellisonleao/dotenv.nvim",
    },
    config = function()
      local format_after_save = nil
      if vim.env._NVIM_NO_AUTOFORMAT == nil then
        format_after_save = {
          lsp_fallback = true,
          async = true,
          quiet = true,
        }
      end

      local python_formatter = vim.env._NVIM_FORMAT_RUFF == nil
          and {
            "isort",
            "black",
          }
          or {
            "ruff_fix",
            "ruff_format",
            "ruff_check",
          }

      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          nix = { "nixfmt" },
          c = { "clang-format" },
          cpp = { "clang-format" },
          typst = { "typstyle" },
          python = python_formatter,
        },
        format_after_save = format_after_save,
      })

      vim.keymap.set("", "<Leader>bf", function()
        require("conform").format({
          lsp_fallback = true,
          async = true,
          quiet = true,
        })
      end, { remap = false, desc = "Comfort buffer format" })
    end,
  },
}

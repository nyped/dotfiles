return {
  { -- https://github.com/stevearc/conform.nvim
    "stevearc/conform.nvim",
    event = "InsertEnter",
    keys = {
      {
        "<Leader>bf",
        function()
          require("conform").format({
            lsp_fallback = true,
            async = true,
            quiet = true,
          })
        end,
        remap = false,
        desc = "Comfort buffer format",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
      },
      format_after_save = {
        lsp_fallback = true,
        async = true,
        quiet = true,
      },
    },
  },
}

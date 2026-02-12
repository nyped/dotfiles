return {
  { -- https://github.com/Saghen/blink.cmp
    -- https://cmp.saghen.dev/
    "saghen/blink.cmp",
    dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
    event = "VeryLazy",

    version = "1.*",

    opts = {
      keymap = {
        preset = "default",
      },

      appearance = {
        nerd_font_variant = "mono",
      },

      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
        ghost_text = { enabled = true, show_with_menu = true },
        trigger = { prefetch_on_insert = false },
      },

      sources = {
        default = {
          "lsp",
          "path",
          "buffer",
          "snippets",
        },
        providers = {
        },
      },

      fuzzy = { implementation = "prefer_rust" },
      signature = { enabled = true },
      snippets = { preset = "luasnip" },
    },

    opts_extend = { "sources.default" },
  },
}

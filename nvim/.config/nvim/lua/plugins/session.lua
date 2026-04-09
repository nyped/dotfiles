return {
  { -- https://github.com/folke/snacks.nvim
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
      { "<Leader>fN", function() Snacks.notifier.hide() end, desc = "Dismiss notifications" },
      { "<Leader>fn", function() Snacks.notifier.show_history() end, desc = "Notification history" },
    },
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true, preset = { header = "nvim" } },
      explorer = { enabled = false },
      indent = { enabled = true, animate = { enabled = false } },
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
  },
  { -- https://github.com/folke/persistence.nvim
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
  },
}

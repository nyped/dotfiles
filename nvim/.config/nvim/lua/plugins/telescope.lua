return {
  { -- https://github.com/nvim-telescope/telescope.nvim
    "nvim-telescope/telescope.nvim",
    tag = "0.1.2",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      {
        "<Leader>ff",
        "<cmd>Telescope find_files<CR>",
        desc = "Telescope find_files",
      },
      {
        "<Leader>fi",
        "<cmd>Telescope find_files hidden=true<CR>",
        desc = "Telescope find_files (hidden)",
      },
      {
        "<Leader>fo",
        "<cmd>Telescope oldfiles<CR>",
        desc = "Telescope oldfiles",
      },
      {
        "<Leader>fg",
        "<cmd>Telescope live_grep<CR>",
        desc = "Telescope live_grep",
      },
      {
        "<Leader>fd",
        "<cmd>Telescope diagnostics<CR>",
        desc = "Telescope diagnostics",
      },
      {
        "<Leader>fb",
        "<cmd>Telescope buffers<CR>",
        desc = "Telescope buffers",
      },
      {
        "<Leader>fh",
        "<cmd>Telescope help_tags<CR>",
        desc = "Telescope help_tags",
      },
      {
        "<Leader>fk",
        "<cmd>Telescope keymaps<CR>",
        desc = "Telescope keymaps",
      },
      {
        "<Leader>fn",
        function()
          require("telescope").extensions.notify.notify()
        end,
        desc = "Telescope extensions notify",
      },
    },
  },
}

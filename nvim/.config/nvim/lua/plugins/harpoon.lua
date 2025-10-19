return {
  { -- https://github.com/ThePrimeagen/harpoon
    "ThePrimeagen/harpoon",
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      {
        "<Leader>n",
        '<cmd>lua require("harpoon.ui").nav_next()<CR>',
        desc = "Harpoon next",
      },
      {
        "<Leader>m",
        '<cmd>lua require("harpoon.ui").nav_prev()<CR>',
        desc = "Harpoon prev",
      },
      {
        "<Leader><Space>",
        '<cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>',
        desc = "Harpoon menu toggle",
      },
      {
        "<Leader>ha",
        function()
          vim.notify("Adding the current file to harpoon")
          require("harpoon.mark").add_file()
        end,
        desc = "Harpoon mark file",
      },
      {
        "<Leader>ht",
        '<cmd>lua require("harpoon.term").gotoTerminal(1)<CR>',
        desc = "Harpoon go term",
      },
      {
        "<Leader>hh",
        '<cmd>lua require("harpoon.ui").nav_file(1)<CR>',
        desc = "Harpoon go file 1",
      },
      {
        "<Leader>hj",
        '<cmd>lua require("harpoon.ui").nav_file(2)<CR>',
        desc = "Harpoon go file 2",
      },
      {
        "<Leader>hk",
        '<cmd>lua require("harpoon.ui").nav_file(3)<CR>',
        desc = "Harpoon go file 3",
      },
      {
        "<Leader>hl",
        '<cmd>lua require("harpoon.ui").nav_file(4)<CR>',
        desc = "Harpoon go file 3",
      },
    },
    config = true,
  },
}

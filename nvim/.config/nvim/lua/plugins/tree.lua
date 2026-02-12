return {
  { -- https://github.com/nvim-tree/nvim-tree.lua
    "nvim-tree/nvim-tree.lua",
    commit = "037d89e60fb01a6c11a48a19540253b8c72a3c32",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {}
    end,
    keys = {
      {
        "<Leader>vt",
        "<cmd>NvimTreeOpen<CR>",
        desc = "open file finder",
      }
    }
  }
}

return {
  { -- https://github.com/nvim-tree/nvim-tree.lua
    "nvim-tree/nvim-tree.lua",
    version = "*",
    cmd = { "NvimTreeToggle", "NvimTreeOpen" },
    keys = {
      { "<Leader>vt", vim.cmd.NvimTreeToggle, desc = "NvimTree Toggle" },
    },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        actions = {
          open_file = {
            quit_on_open = true,
          },
        },
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
        },
      })
    end,
  },
}

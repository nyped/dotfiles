return {
  { -- https://github.com/nvim-lualine/lualine.nvim
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      -- Trailing spaces finder {{{
      local function trailing()
        local space = vim.fn.search([[\s\+$]], "nwc")
        return space ~= 0 and "TW:" .. space or ""
      end
      -- }}}

      -- Mixed indent finder {{{
      local function mixed_indent()
        local space_pat = [[\v^ +]]
        local tab_pat = [[\v^\t+]]
        local space_indent = vim.fn.search(space_pat, "nwc")
        local tab_indent = vim.fn.search(tab_pat, "nwc")
        local mixed = (space_indent > 0 and tab_indent > 0)
        local mixed_same_line
        if not mixed then
          mixed_same_line = vim.fn.search([[\v^(\t+ | +\t)]], "nwc")
          mixed = mixed_same_line > 0
        end
        if not mixed then
          return ""
        end
        if mixed_same_line ~= nil and mixed_same_line > 0 then
          return "MI:" .. mixed_same_line
        end
        local space_indent_cnt =
          vim.fn.searchcount({ pattern = space_pat, max_count = 1e3 }).total
        local tab_indent_cnt =
          vim.fn.searchcount({ pattern = tab_pat, max_count = 1e3 }).total
        if space_indent_cnt > tab_indent_cnt then
          return "MI:" .. tab_indent
        else
          return "MI:" .. space_indent
        end
      end
      -- }}}

      -- setup {{{
      require("lualine").setup({
        options = {
          icons_enabled = false,
          theme = "gruvbox",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            {
              "filename",
              path = 1,
              shorting_target = 0,
            },
          },
          lualine_c = { "branch" },
          lualine_x = {
            {
              "searchcount",
              maxcount = 999,
              timeout = 500,
            },
            "filetype",
            trailing,
            mixed_indent,
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              sections = { "error", "warn", "info", "hint" },
              symbols = { error = "E", warn = "W", info = "I", hint = "H" },
              colored = true, -- Displays diagnostics status in color if set to true.
              update_in_insert = false, -- Update diagnostics in insert mode.
              always_visible = false, -- Show diagnostics even if there are none.
            },
          },
          lualine_y = { "progress" },
          lualine_z = { "hostname" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      })
      -- }}}
    end,
  },
}

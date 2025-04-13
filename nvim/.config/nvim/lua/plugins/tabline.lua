return {
  { -- https://github.com/akinsho/bufferline.nvim
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      -- color palette {{{
      local norm_table = {
        fg = {
          attribute = "fg",
          highlight = "GruvboxFg2",
        },
        bg = {
          attribute = "fg",
          highlight = "GruvboxBg2",
        },
        bold = true,
      }
      local sel_table = {
        fg = {
          attribute = "bg",
          highlight = "TabLineSel",
        },
        bg = {
          attribute = "fg",
          highlight = "TabLineSel",
        },
      }
      local pick_norm_table = {
        fg = {
          attribute = "fg",
          highlight = "GruvboxRed",
        },
        bg = {
          attribute = "fg",
          highlight = "GruvboxBg2",
        },
        bold = true,
      }
      local pick_sel_table = {
        fg = {
          attribute = "fg",
          highlight = "GruvboxGreen",
        },
        bg = {
          attribute = "fg",
          highlight = "TabLineSel",
        },
        bold = true,
      }
      local error_table = {
        fg = {
          attribute = "fg",
          highlight = "GruvboxRed",
        },
        bg = {
          attribute = "fg",
          highlight = "GruvboxBg2",
        },
        bold = true,
      }
      local warning_table = vim.fn.copy(error_table)
      if warning_table and warning_table["fg"] then
        warning_table["fg"]["highlight"] = "GruvboxOrange"
      end
      -- }}}

      require("bufferline").setup({
        options = {
          mode = "tabs",
          numbers = "none",
          show_duplicate_prefix = false,
          show_buffer_close_icons = false,
          show_buffer_icons = false,
          show_close_icon = false,
          right_mouse_command = false,
          enforce_regular_tabs = false,
          show_tab_indicator = false,
          max_name_lenght = 25,
          separator_style = "thin",
          left_trunc_marker = "⟵",
          right_trunc_marker = "⟶",
          always_show_bufferline = false,
          diagnostics = "nvim_lsp",
          diagnostics_update_in_insert = false,
          diagnostics_indicator = function(_, _, _, _)
            return ""
          end,
          indicator = {
            style = "none",
          },
        },
        highlights = {
          background = norm_table,
          buffer_selected = sel_table,
          fill = norm_table,
          indicator_selected = sel_table,
          modified = norm_table,
          modified_selected = sel_table,
          separator = norm_table,
          separator_selected = sel_table,
          trunc_marker = norm_table,
          pick = pick_norm_table,
          pick_selected = pick_sel_table,
          error = error_table,
          error_selected = sel_table,
          warning = warning_table,
          warning_selected = sel_table,
        },

        vim.keymap.set("n", "<Leader>j", vim.cmd.BufferLinePick, {
          desc = "Bufferline tab jump",
        }),
      })
    end,
  },
}

return {
  { -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter.configs").setup({
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = {
                query = "@function.outer",
                desc = "TSTO Select outer part of a function",
              },
              ["if"] = {
                query = "@function.inner",
                desc = "TSTO Select inner part of a function",
              },
              ["ak"] = {
                query = "@conditional.outer",
                desc = "TSTO Select outer part of a conditional region",
              },
              ["ik"] = {
                query = "@conditional.inner",
                desc = "TSTO Select inner part of a conditional region",
              },
              ["ac"] = {
                query = "@class.outer",
                desc = "TSTO Select outer part of a class region",
              },
              ["ic"] = {
                query = "@class.inner",
                desc = "TSTO Select inner part of a class region",
              },
              ["as"] = {
                query = "@scope",
                query_group = "locals",
                desc = "TSTO Select language scope",
              },
              ["al"] = {
                query = "@loop.outer",
                desc = "TSTO Select outer part of a loop region",
              },
              ["il"] = {
                query = "@loop.inner",
                desc = "TSTO Select inner part of a loop region",
              },
              ["lh"] = {
                query = "@assignment.lhs",
                desc = "TSTO go lhs assignment",
              },
              ["rh"] = {
                query = "@assignment.rhs",
                desc = "TSTO go lhs rhs",
              },
            },
            selection_modes = {
              ["@parameter.outer"] = "v",
              ["@function.outer"] = "V",
              ["@class.outer"] = "<c-v>",
            },
            include_surrounding_whitespace = false,
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next = {
              ["]f"] = {
                query = "@function.outer",
                desc = "TSTO next function",
              },
              ["]k"] = {
                query = "@conditional.outer",
                desc = "TSTO next conditional",
              },
              ["]c"] = {
                query = "@class.outer",
                desc = "TSTO next class",
              },
              ["]l"] = {
                query = "@loop.outer",
                desc = "TSTO next loop",
              },
            },
            goto_previous = {
              ["[f"] = {
                query = "@function.outer",
                desc = "TSTO prev function",
              },
              ["[k"] = {
                query = "@conditional.outer",
                desc = "TSTO prev conditional",
              },
              ["[c"] = {
                query = "@class.outer",
                desc = "TSTO prev class",
              },
              ["[l"] = {
                query = "@loop.outer",
                desc = "TSTO prev loop",
              },
            },
          },
        },
      })

      -- already done by eyeliner
      if false then
        local ts_repeat_move =
          require("nvim-treesitter.textobjects.repeatable_move")

        -- Repeat movement with ; and ,
        vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
        vim.keymap.set(
          { "n", "x", "o" },
          ",",
          ts_repeat_move.repeat_last_move_opposite
        )

        -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
        vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
        vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
        vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
        vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
      end
    end,
  },
}

return {
  { -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    config = function()
      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")

      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
          selection_modes = {
            ["@parameter.outer"] = "v",
            ["@function.outer"] = "V",
            ["@class.outer"] = "<c-v>",
          },
          include_surrounding_whitespace = false,
        },
        move = { set_jumps = true },
      })

      local sel = function(query, query_group)
        return function() select.select_textobject(query, query_group or "textobjects") end
      end
      vim.keymap.set({ "x", "o" }, "af", sel("@function.outer"), { desc = "TSTO Select outer part of a function" })
      vim.keymap.set({ "x", "o" }, "if", sel("@function.inner"), { desc = "TSTO Select inner part of a function" })
      vim.keymap.set({ "x", "o" }, "ak", sel("@conditional.outer"),
        { desc = "TSTO Select outer part of a conditional region" })
      vim.keymap.set({ "x", "o" }, "ik", sel("@conditional.inner"),
        { desc = "TSTO Select inner part of a conditional region" })
      vim.keymap.set({ "x", "o" }, "ac", sel("@class.outer"), { desc = "TSTO Select outer part of a class region" })
      vim.keymap.set({ "x", "o" }, "ic", sel("@class.inner"), { desc = "TSTO Select inner part of a class region" })
      vim.keymap.set({ "x", "o" }, "as", sel("@scope", "locals"), { desc = "TSTO Select language scope" })
      vim.keymap.set({ "x", "o" }, "al", sel("@loop.outer"), { desc = "TSTO Select outer part of a loop region" })
      vim.keymap.set({ "x", "o" }, "il", sel("@loop.inner"), { desc = "TSTO Select inner part of a loop region" })
      vim.keymap.set({ "x", "o" }, "lh", sel("@assignment.lhs"), { desc = "TSTO go lhs assignment" })
      vim.keymap.set({ "x", "o" }, "rh", sel("@assignment.rhs"), { desc = "TSTO go lhs rhs" })

      vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer") end,
        { desc = "TSTO next function" })
      vim.keymap.set({ "n", "x", "o" }, "]k", function() move.goto_next_start("@conditional.outer") end,
        { desc = "TSTO next conditional" })
      vim.keymap.set({ "n", "x", "o" }, "]c", function() move.goto_next_start("@class.outer") end,
        { desc = "TSTO next class" })
      vim.keymap.set({ "n", "x", "o" }, "]l", function() move.goto_next_start("@loop.outer") end,
        { desc = "TSTO next loop" })
      vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer") end,
        { desc = "TSTO prev function" })
      vim.keymap.set({ "n", "x", "o" }, "[k", function() move.goto_previous_start("@conditional.outer") end,
        { desc = "TSTO prev conditional" })
      vim.keymap.set({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer") end,
        { desc = "TSTO prev class" })
      vim.keymap.set({ "n", "x", "o" }, "[l", function() move.goto_previous_start("@loop.outer") end,
        { desc = "TSTO prev loop" })

      -- already done by eyeliner
      if false then
        local ts_repeat_move =
            require("nvim-treesitter-textobjects.repeatable_move")

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

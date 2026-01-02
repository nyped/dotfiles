return {
  { -- https://github.com/lewis6991/gitsigns.nvim
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~_" },
          untracked = { text = "|" },
        },
        signs_staged = {
          add = { text = "++" },
          change = { text = "~~" },
          delete = { text = "__" },
          topdelete = { text = "‾‾" },
          changedelete = { text = "~~" },
          untracked = { text = "||" },
        },
        -- Buffer mapping
        on_attach = function(bufnr)
          local gs = require("gitsigns")
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]h", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]h", bang = true })
            else
              gs.nav_hunk("next")
            end
          end, { desc = "Got go next hunk" })

          map("n", "[h", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[h", bang = true })
            else
              gs.nav_hunk("prev")
            end
          end, { desc = "Git go prev hunk" })

          -- Actions
          map("n", "<leader>hs", gs.stage_hunk, { desc = "Git stage hunk" })
          map("n", "<leader>hr", gs.reset_hunk, { desc = "Git reset hunk" })

          map("v", "<leader>hs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Git stage hunk" })

          map("v", "<leader>hr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Git stage hunk" })

          map("n", "<leader>hS", gs.stage_buffer, { desc = "Git stage buff" })
          map("n", "<leader>hR", gs.reset_buffer, { desc = "Git reset buff" })
          map("n", "<leader>hp", gs.preview_hunk, { desc = "Git preview buff" })
          map(
            "n",
            "<leader>hi",
            gs.preview_hunk_inline,
            { desc = "Git preview hunk inline" }
          )

          map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
          end, { desc = "Git hunk blame" })

          map("n", "<leader>hd", gs.diffthis, { desc = "Git diff this" })
          map("n", "<leader>hD", function()
            gs.diffthis("~")
          end)

          map("n", "<leader>hQ", function()
            gs.setqflist("all")
          end, { desc = "Git quick fix all" })
          map("n", "<leader>hq", gs.setqflist, { desc = "Git quick fix" })

          -- Toggles
          map(
            "n",
            "<leader>tb",
            gs.toggle_current_line_blame,
            { desc = "Git toggle line blame" }
          )

          -- Text object
          map({ "o", "x" }, "ih", gs.select_hunk, { desc = "Git inside hunk" })
        end,
      })
    end,
  },
  { -- https://github.com/kdheepak/lazygit.nvim
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
}

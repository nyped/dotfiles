return {
  { -- https://github.com/nvim-treesitter/nvim-treesitter
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash", -- parsers {{{
          "bibtex",
          "c",
          "cpp",
          "css",
          "cuda",
          "diff",
          "git_config",
          "git_rebase",
          "gitattributes",
          "gitcommit",
          "gitignore",
          "go",
          "html",
          "ini",
          "java",
          "javascript",
          "lua",
          "luadoc",
          "make",
          "markdown",
          "markdown_inline",
          "ocaml",
          "python",
          "r",
          "regex",
          "rust",
          "toml",
          "typescript",
          "typst",
          "vim",
          "vimdoc", -- }}}
        },
        sync_install = false,
        ignore_install = { "" },
        highlight = {
          enable = true,
          disable = {},
          additional_vim_regex_highlighting = false,
        },
      })
    end,
  },
}

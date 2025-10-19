return {
  { -- https://github.com/milanglacier/minuet-ai.nvim
    "milanglacier/minuet-ai.nvim",
    enabled = false,
    config = function()
      require("minuet").setup({
        request_timeout = 10,
        provider = "openai_fim_compatible",
        n_completions = 1, -- recommend for local model for resource saving
        -- I recommend beginning with a small context window size and incrementally
        -- expanding it, depending on your local computing power. A context window
        -- of 512, serves as an good starting point to estimate your computing
        -- power. Once you have a reliable estimate of your local computing power,
        -- you should adjust the context window to a larger value.
        context_window = 8192,
        provider_options = {
          openai_fim_compatible = {
            -- For Windows users, TERM may not be present in environment variables.
            -- Consider using APPDATA instead.
            api_key = "TERM",
            name = "Ollama",
            end_point = "http://iron:11434/v1/completions",
            model = "qwen2.5-coder:0.5b",
            optional = {
              max_tokens = 512,
              top_p = 0.9,
            },
          },
        },
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "Saghen/blink.cmp",
    },
  },
}

require("conform").setup({
  formatters_by_ft = {
    python = { "black", "isort" },
    rust = { "rustfmt" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  }
})

vim.keymap.set('n', '<leader>f', function()
  require("conform").format({ async = true })
end)


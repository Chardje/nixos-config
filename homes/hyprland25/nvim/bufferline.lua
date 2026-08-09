require("bufferline").setup({
  options = {
    separator_style = "slant",
    diagnostics = "nvim_lsp",
  }
})
vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>')
vim.keymap.set('n', '<S-Tab>', ':BufferLineCyclePrev<CR>')
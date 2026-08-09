require("neo-tree").setup({
  window = { position = "left", width = 30 },
  filesystem = {
    follow_current_file = { enabled = true },
    hide_dotfiles = false,
  }
})
vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>')
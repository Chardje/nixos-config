-- 1. Mason залишаємо для сумісності, але в Nix він не буде інсталювати бінарники
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "pyright",      -- Python
  }
})

-- 2. Замість require("lspconfig"), використовуємо новий API vim.lsp.enable
-- Це прибере попередження про депрекацію

-- Python (Pyright)
vim.lsp.enable('pyright', {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        diagnosticMode = "workspace",
      }
    }
  }
})

-- Rust (rust-analyzer)
vim.lsp.config('rust_analyzer', {
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      checkOnSave = { command = "clippy" },
    }
  }
})
vim.lsp.enable('rust_analyzer')
-- 3. Клавіші для LSP залишаються без змін
local opts = { noremap = true, silent = true }
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
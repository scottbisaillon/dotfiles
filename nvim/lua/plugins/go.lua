local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'ray-x/go.nvim' }

require('go').setup {
  lsp_cfg = true,
  -- Don't install go.nvim's default LSP keymaps; they're buffer-local and
  -- shadow our own bindings in Go files (e.g. <Leader>ff, the <Leader>e group,
  -- and <C-k>). LSP actions live under <Leader>l (see lua/keymaps.lua).
  lsp_keymaps = false,
}

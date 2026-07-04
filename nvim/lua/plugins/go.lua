local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'ray-x/go.nvim' }

require('go').setup {
  lsp_cfg = true,
}

local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'folke/which-key.nvim' }

require('which-key').setup {
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },
  spec = {
    { '<leader>b', group = 'Buffer', mode = { 'n' } },
    { '<leader>e', group = 'Explore/Edit', mode = { 'n' } },
    { '<leader>f', group = 'Find', mode = { 'n' } },
    { '<leader>l', group = 'Language', mode = { 'n', 'x' } },
    { '<leader>t', group = 'Terminal', mode = { 'n' } },
  },
}

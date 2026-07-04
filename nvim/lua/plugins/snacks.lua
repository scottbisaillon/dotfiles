local function gh(repo) return 'https://github.com/' .. repo end

-- snacks.nvim provides the fuzzy picker used by the `<Leader>f` Find group
-- (see lua/keymaps.lua). Sources are invoked lazily as `Snacks.picker.<name>()`.
vim.pack.add { gh 'folke/snacks.nvim' }

require('snacks').setup {
  picker = {},
}

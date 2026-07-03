vim.pack.add { 'https://github.com/nvim-mini/mini.nvim' }

require('mini.files').setup { windows = { preview = true } }

local add_marks = function()
  MiniFiles.set_bookmark('c', vim.fn.stdpath 'config', { desc = 'Config' })
  local vimpack_plugins = vim.fn.stdpath 'data' .. '/site/pack/core/opt'
  MiniFiles.set_bookmark('p', vimpack_plugins, { desc = 'Plugins' })
  MiniFiles.set_bookmark('w', vim.fn.getcwd, { desc = 'Working Directory' })
end

local gr = vim.api.nvim_create_augroup('custom-config', {})
local opts = { group = gr, pattern = 'MiniFilesExplorerOpen', callback = add_marks, desc = 'Add bookmarks' }
vim.api.nvim_create_autocmd('User', opts)

require('mini.surround').setup()

require('mini.pairs').setup { modes = { command = true } }

require('mini.statusline').setup()

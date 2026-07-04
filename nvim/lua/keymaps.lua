-- ┌─────────────────┐
-- │ Custom mappings │
-- └─────────────────┘
--
-- Keymaps adopted from MiniMax (configs/nvim-0.12/plugin/20_keymaps.lua),
-- limited to the ones backed by plugins/modules currently installed here:
-- 'mini.files', native LSP, 'conform', and built-in Vim features.

-- General mappings ===========================================================

-- An example helper to create a Normal mode mapping
local nmap = function(lhs, rhs, desc) vim.keymap.set('n', lhs, rhs, { desc = desc }) end

-- Paste linewise before/after current line
-- Usage: `yiw` to yank a word and `]p` to put it on the next line.
nmap('[p', '<Cmd>exe "put! " . v:register<CR>', 'Paste Above')
nmap(']p', '<Cmd>exe "put "  . v:register<CR>', 'Paste Below')

-- stylua: ignore start
-- The next part (until `-- stylua: ignore end`) is aligned manually for easier
-- reading. Consider preserving this or remove `-- stylua` lines to autoformat.

-- Leader mappings ============================================================

-- This config uses a "two key Leader mappings" approach: first key describes
-- semantic group, second key executes an action. Both keys are usually chosen
-- to create some kind of mnemonic (e.g. `<Leader>e` groups "Explore/Edit"
-- actions; `<Leader>ed` opens the directory explorer).
--
-- Group labels are provided by 'which-key' (see 'plugin/which-key.lua').

local nmap_leader = function(suffix, rhs, desc)
  vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc })
end
local xmap_leader = function(suffix, rhs, desc)
  vim.keymap.set('x', '<Leader>' .. suffix, rhs, { desc = desc })
end

-- b is for 'Buffer'. Common usage:
-- - `<Leader>bs` - create scratch (temporary) buffer
-- - `<Leader>ba` - navigate to the alternative buffer
local new_scratch_buffer = function()
  vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end

nmap_leader('ba', '<Cmd>b#<CR>', 'Alternate')
nmap_leader('bs', new_scratch_buffer, 'Scratch')

-- e is for 'Explore' and 'Edit'. Common usage:
-- - `<Leader>ed` - open explorer at current working directory
-- - `<Leader>ef` - open directory of current file (needs to be present on disk)
-- - `<Leader>ei` - edit 'init.lua'
-- - All mappings that use `edit_config_file` - edit config files under 'lua/'
local edit_config_file = function(relpath)
  return string.format('<Cmd>edit %s/%s<CR>', vim.fn.stdpath('config'), relpath)
end
local explore_at_file = '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>'
local explore_plugins = '<Cmd>lua MiniFiles.open(vim.fn.stdpath("config") .. "/lua/plugins")<CR>'
local explore_quickfix = function()
  vim.cmd(vim.fn.getqflist({ winid = true }).winid ~= 0 and 'cclose' or 'copen')
end
local explore_locations = function()
  vim.cmd(vim.fn.getloclist(0, { winid = true }).winid ~= 0 and 'lclose' or 'lopen')
end

nmap_leader('ed', '<Cmd>lua MiniFiles.open()<CR>',      'Directory')
nmap_leader('ef', explore_at_file,                      'File directory')
nmap_leader('ei', '<Cmd>edit $MYVIMRC<CR>',             'init.lua')
nmap_leader('ek', edit_config_file('lua/keymaps.lua'),  'Keymaps config')
nmap_leader('em', edit_config_file('lua/plugins/mini.lua'), 'MINI config')
nmap_leader('eo', edit_config_file('lua/options.lua'),  'Options config')
nmap_leader('ep', explore_plugins,                      'Plugins directory')
nmap_leader('eq', explore_quickfix,                     'Quickfix list')
nmap_leader('eQ', explore_locations,                    'Location list')

-- f is for 'Fuzzy Find'. Common usage:
-- - `<Leader>ff` - find files; for best performance requires `ripgrep`
-- - `<Leader>fg` - find inside files (live grep); requires `ripgrep`
-- - `<Leader>fh` - find help tag
-- - `<Leader>fr` - resume latest picker
--
-- These use 'snacks.picker' (see 'plugin/snacks.lua'). They mirror the Find
-- group MiniMax powers with 'mini.pick', mapped onto snacks sources. A few
-- upstream mappings have no direct snacks equivalent: 'mini.visits' paths are
-- replaced by recent/smart, staged-hunk pickers are dropped, and git hunks map
-- to 'git_status' / 'git_diff'.
local pick = function(source) return string.format('<Cmd>lua Snacks.picker.%s()<CR>', source) end

nmap_leader('f/', pick('search_history'),        '"/" history')
nmap_leader('f:', pick('command_history'),       '":" history')
nmap_leader('fb', pick('buffers'),               'Buffers')
nmap_leader('fc', pick('git_log'),               'Commits (all)')
nmap_leader('fC', pick('git_log_file'),          'Commits (buf)')
nmap_leader('fd', pick('diagnostics'),           'Diagnostic workspace')
nmap_leader('fD', pick('diagnostics_buffer'),    'Diagnostic buffer')
nmap_leader('ff', pick('files'),                 'Files')
nmap_leader('fg', pick('grep'),                  'Grep live')
nmap_leader('fG', pick('grep_word'),             'Grep current word')
nmap_leader('fh', pick('help'),                  'Help tags')
nmap_leader('fH', pick('highlights'),            'Highlight groups')
nmap_leader('fl', pick('grep_buffers'),          'Lines (open buffers)')
nmap_leader('fL', pick('lines'),                 'Lines (buffer)')
nmap_leader('fm', pick('git_status'),            'Git status')
nmap_leader('fM', pick('git_diff'),              'Git diff (hunks)')
nmap_leader('fr', pick('resume'),                'Resume')
nmap_leader('fR', pick('lsp_references'),        'References (LSP)')
nmap_leader('fs', pick('lsp_workspace_symbols'), 'Symbols workspace')
nmap_leader('fS', pick('lsp_symbols'),           'Symbols document')
nmap_leader('fv', pick('recent'),                'Recent files')
nmap_leader('fV', pick('smart'),                 'Smart find')

-- l is for 'Language'. Common usage:
-- - `<Leader>ld` - show more diagnostic details in a floating window
-- - `<Leader>lr` - perform rename via LSP
-- - `<Leader>ls` - navigate to source definition of symbol under cursor
nmap_leader('la', '<Cmd>lua vim.lsp.buf.code_action()<CR>',     'Actions')
nmap_leader('ld', '<Cmd>lua vim.diagnostic.open_float()<CR>',   'Diagnostic popup')
nmap_leader('lf', '<Cmd>lua require("conform").format()<CR>',   'Format')
nmap_leader('li', '<Cmd>lua vim.lsp.buf.implementation()<CR>',  'Implementation')
nmap_leader('lI', '<Cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>', 'Inlay hints (toggle)')
nmap_leader('lh', '<Cmd>lua vim.lsp.buf.hover()<CR>',           'Hover')
nmap_leader('ll', '<Cmd>lua vim.lsp.codelens.run()<CR>',        'Lens')
nmap_leader('lr', '<Cmd>lua vim.lsp.buf.rename()<CR>',          'Rename')
nmap_leader('lR', '<Cmd>lua vim.lsp.buf.references()<CR>',      'References')
nmap_leader('ls', '<Cmd>lua vim.lsp.buf.definition()<CR>',      'Source definition')
nmap_leader('lt', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', 'Type definition')

xmap_leader('lf', '<Cmd>lua require("conform").format()<CR>', 'Format selection')

-- t is for 'Terminal'
nmap_leader('tT', '<Cmd>horizontal term<CR>', 'Terminal (horizontal)')
nmap_leader('tt', '<Cmd>vertical term<CR>',   'Terminal (vertical)')
-- stylua: ignore end

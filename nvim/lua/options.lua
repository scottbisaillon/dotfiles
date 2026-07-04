vim.g.mapleader = ' '
vim.g.have_nerd_font = true

-- General ====================================================================
vim.o.mouse = 'a' -- Enable mouse in all modes
vim.o.switchbuf = 'usetab' -- Reuse already-opened buffers when switching
vim.o.undofile = true -- Persist undo history across sessions
vim.o.confirm = true -- Prompt instead of erroring on unsaved changes

vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- UI =========================================================================
vim.o.number = true
vim.o.showmode = false -- Mode is shown in the statusline
vim.o.signcolumn = 'yes' -- Always show signcolumn to avoid flicker
vim.o.splitbelow = true -- Horizontal splits open below
vim.o.splitright = true -- Vertical splits open to the right
vim.o.splitkeep = 'screen' -- Reduce scroll when opening/closing splits

-- Editing ====================================================================
vim.o.expandtab = true -- Convert tabs to spaces
vim.o.shiftwidth = 2 -- Spaces per indentation level
vim.o.tabstop = 2 -- Show a tab as this many spaces
vim.o.autoindent = true
vim.o.smartindent = true -- Smarter auto-indent for new lines
vim.o.breakindent = true -- Keep wrapped lines visually indented
vim.o.virtualedit = 'block' -- Allow cursor past line end in visual block
vim.o.ignorecase = true -- Case-insensitive search...
vim.o.smartcase = true -- ...unless the pattern contains uppercase
vim.o.infercase = true -- Infer case in keyword completion
vim.o.spelloptions = 'camel' -- Treat camelCase parts as separate words

-- Diagnostics ================================================================
-- Deferred so `vim.diagnostic` isn't loaded during startup.
vim.schedule(function()
  vim.diagnostic.config {
    -- Signs only for warnings/errors, drawn on top of other signs
    signs = { priority = 9999, severity = { min = 'WARN', max = 'ERROR' } },
    -- Underline everything from hints up (see full message with <Leader>ld)
    underline = { severity = { min = 'HINT', max = 'ERROR' } },
    -- Inline text only for errors, and only on the current line
    virtual_lines = false,
    virtual_text = {
      current_line = true,
      severity = { min = 'ERROR', max = 'ERROR' },
    },
    update_in_insert = false,
  }
end)

local function gh(repo) return 'https://github.com/' .. repo end

-- [[ Autoformatting ]]
--  conform.nvim runs external formatters (e.g. stylua) on the current buffer.
--  See `:help conform` and `:ConformInfo` for which formatter ran on a buffer.
vim.pack.add { gh 'stevearc/conform.nvim' }

local conform = require 'conform'

conform.setup {
  notify_on_error = false,

  -- Map filetypes to the formatters they should use. Formatters are installed
  -- via Mason (see the `tools` list in plugins/lspconfig.lua).
  formatters_by_ft = {
    lua = { 'stylua' },
    -- Use a sub-list to run only the first available formatter:
    -- javascript = { 'prettierd', 'prettier', stop_after_first = true },
  },

  -- Format on save. Disable per-language when a language server should own it,
  -- and fall back to LSP formatting for filetypes without a configured formatter.
  format_on_save = function(bufnr)
    local disable_filetypes = { c = true, cpp = true }
    if disable_filetypes[vim.bo[bufnr].filetype] then return nil end
    return {
      timeout_ms = 500,
      lsp_format = 'fallback',
    }
  end,
}

-- Manual formatting is mapped in lua/keymaps.lua as `<Leader>lf` (Language group).

-- vim: ts=2 sts=2 sw=2 et

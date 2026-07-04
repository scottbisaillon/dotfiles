local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'j-hui/fidget.nvim' }
require('fidget').setup {}

vim.pack.add { gh 'folke/lazydev.nvim' }
require('lazydev').setup {
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Rename (grn) and code action (gra) are mapped under <Leader>l in
    -- lua/keymaps.lua; Neovim's native LSP defaults still provide grn/gra too.
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method('textDocument/documentHighlight', event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- Inlay hints toggle is mapped globally as <Leader>lI in lua/keymaps.lua.
  end,
})

---@type string[]
local servers = {
  'lua_ls',
}

local tools = {
  'stylua',
}

vim.pack.add {
  gh 'neovim/nvim-lspconfig',
  gh 'mason-org/mason.nvim',
  gh 'mason-org/mason-lspconfig.nvim',
  gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
}

require('mason').setup {}

local ensure_installed = vim.list_extend(vim.deepcopy(servers), tools)
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

vim.lsp.enable(servers)

-- vim: ts=2 sts=2 sw=2 et

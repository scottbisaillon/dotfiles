return {
  on_attach = function(client, buf_id)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.completionProvider.triggerCharacters = { '.', ':', '#', '(' }
  end,
  settings = {
    Lua = {
      format = { enable = false },
      runtime = {
        version = 'LuaJIT',
        path = { 'lua/?.lua', 'lua/?/init.lua' },
      },
      workspace = {
        checkThirdParty = false,
        ignoreSubmodules = true,
        library = { vim.env.VIMRUNTIME },
      },
      telemetry = { enable = false },
    },
  },
}

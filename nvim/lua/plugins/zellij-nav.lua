-- Seamless navigation between Neovim splits and Zellij panes.
-- <C-h/j/k/l> moves between Neovim splits; when already at the edge it hands off
-- to the adjacent Zellij pane. Outside Zellij it's just plain split movement.

local function nav(nvim_dir, zellij_dir)
  return function()
    local prev = vim.api.nvim_get_current_win()
    vim.cmd.wincmd(nvim_dir)
    -- Window didn't change => we were at the edge; delegate to Zellij.
    if prev == vim.api.nvim_get_current_win() and vim.env.ZELLIJ then
      vim.system { 'zellij', 'action', 'move-focus', zellij_dir }
    end
  end
end

local map = vim.keymap.set
map('n', '<C-h>', nav('h', 'left'),  { desc = 'Navigate left (split/zellij)' })
map('n', '<C-j>', nav('j', 'down'),  { desc = 'Navigate down (split/zellij)' })
map('n', '<C-k>', nav('k', 'up'),    { desc = 'Navigate up (split/zellij)' })
map('n', '<C-l>', nav('l', 'right'), { desc = 'Navigate right (split/zellij)' })

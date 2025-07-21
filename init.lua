-- Bootstrap lazy.nvim
vim.opt.rtp:prepend(vim.fn.stdpath('data') .. '/lazy/lazy.nvim')

vim.g.mapleader = ' '

local lazy_setup = {
	{ "ellisonleao/gruvbox.nvim", priority = 1000 , config = true },
}
local lazy_opts = {
	rocks = {
		enabled = false,
	},
}
require('lazy').setup(lazy_setup, lazy_opts)

vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

vim.keymap.set('n', '<Leader>e', ':Explore<CR>', { desc = '[mm] Open file explorer' })
vim.keymap.set('v', '<Leader>y', '"+y',          { desc = '[mm] Yank to clipboard' })
vim.keymap.set('n', '<Leader>l', ':Lazy<CR>',    { desc = '[mm] Open lazy.nvim' })

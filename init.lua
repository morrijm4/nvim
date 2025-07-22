-- require('bootstrap')

vim.opt.rtp:prepend(vim.fn.stdpath('data') .. '/lazy/lazy.nvim')

vim.g.mapleader = ' '

local lazy_setup = {
	{ "ellisonleao/gruvbox.nvim", priority = 1000 , config = true },
	{ "neovim/nvim-lspconfig" },
}
local lazy_opts = {
	rocks = {
		enabled = false,
	},
}
require('lazy').setup(lazy_setup, lazy_opts)

vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

vim.keymap.set('n', '<Leader>e', ':Explore<CR>',                { desc = '[mm] Open file explorer' })
vim.keymap.set('v', '<Leader>y', '"+y',                         { desc = '[mm] Yank to clipboard' })
vim.keymap.set('n', '<Leader>l', ':Lazy<CR>',                   { desc = '[mm] Open lazy.nvim' })
vim.keymap.set('n', '<Leader>h', ':vert rightb help ',          { desc = '[mm] Open help vertically' })

-- Windows
vim.keymap.set('n', '<Leader><', '<C-w><',                      { desc = '[mm] Decrease vertical window size' })
vim.keymap.set('n', '<Leader>>', '<C-w>>',                      { desc = '[mm] Increase vertical window size' })

-- Terminal
vim.keymap.set('n', '<Leader>t', ':vert rightb terminal<CR>',   { desc = '[mm] Open terminal' })
vim.cmd([[tnoremap <Esc> <C-\><C-n>]]) -- map Esc to exit "TERMINAL" mode

-- Options
vim.opt.relativenumber = true

-- Language servers
vim.keymap.set('n', 'gd', vim.lsp.buf.definition,               { desc = '[mm] Go to definition' })
vim.keymap.set('i', '<C-space>', vim.lsp.completion.get,        { desc = '[mm] Get autocompletion' })
vim.keymap.set('n', 'gl', vim.diagnostic.open_float,            { desc = '[mm] Show diagnositc' })

require('lsp-config')

vim.o.completeopt = 'menu,menuone,noselect,popup' -- Disable autocomplete & new popup

vim.lsp.enable({
	'lua_ls',
	'rust_analyzer'
})

vim.diagnostic.config({
	signs = false,
})

-- Enable LSP auto completions
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function (event)
		vim.lsp.completion.enable(true, event.buf, event.data.client_id, {
			autotrigger = true
		})
	end
})


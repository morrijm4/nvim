require('bootstrap')

-- TODO: implement spell check

-------------
-- Options --
-------------
vim.opt.relativenumber = true

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.softtabstop = 4
vim.o.winborder = 'rounded'
vim.g.mapleader = ' '

-------------
-- Lazy --
-------------
vim.opt.rtp:prepend(vim.fn.stdpath('data') .. '/lazy/lazy.nvim')

---@type LazySpec
local lazy_spec = {
    { "catppuccin/nvim",                 name = "catppuccin", priority = 1000 },
    { 'neovim/nvim-lspconfig' },
    { 'nvim-telescope/telescope.nvim',   tag = '0.1.8',       dependencies = { 'nvim-lua/plenary.nvim' } },
    { 'nvim-treesitter/nvim-treesitter', branch = 'master',   lazy = false,                              build = ':TSUpdate' },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
        }
    },
}

---@type LazyConfig
local lazy_opts = {
    spec = lazy_spec,
    rocks = {
        enabled = false,
    },
}
require('lazy').setup(lazy_opts)

------------------
-- Color scheme --
------------------
vim.o.background = 'dark' -- or 'light' for light mode
vim.cmd.colorscheme 'catppuccin-macchiato'


-----------
-- Misc. --
-----------
vim.keymap.set('n', '<Leader>e', ':Explore<CR>', { desc = '[mm] Open file explorer' })
vim.keymap.set('v', '<Leader>y', '"+y', { desc = '[mm] Yank to clipboard' })
vim.keymap.set('n', '<Leader>l', ':Lazy<CR>', { desc = '[mm] Open lazy.nvim' })
vim.keymap.set('n', '<Leader>h', ':vert rightb help ', { desc = '[mm] Open help vertically' })
vim.keymap.set('n', '<Leader>q', ':b#|bd#<CR>', { desc = '[mm] Delete current window and go bac' })

-------------
-- Windows --
-------------
vim.keymap.set('n', '<Leader><', '<C-w><', { desc = '[mm] Decrease vertical window size' })
vim.keymap.set('n', '<Leader>>', '<C-w>>', { desc = '[mm] Increase vertical window size' })

--------------
-- Terminal --
--------------
vim.keymap.set('n', '<Leader>t', ':vert rightb terminal<CR>', { desc = '[mm] Open terminal' })
vim.cmd([[tnoremap <Esc> <C-\><C-n>]]) -- map Esc to exit "TERMINAL" mode

---------------
-- Telescope --
---------------
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<Leader>p', telescope.find_files, { desc = '[mm] File finder' })
vim.keymap.set('n', 'gs', telescope.git_status, { desc = '[mm] Git status' })
vim.keymap.set('n', '<C-Space>', vim.lsp.buf.code_action, { desc = '[mm] Find code action' })
vim.keymap.set('n', '<Leader>fb', telescope.buffers, { desc = '[mm] Search current buffer' })
vim.keymap.set('n', '<Leader>fh', telescope.help_tags, { desc = '[mm] Search help tags' })
vim.keymap.set('n', '<Leader>fk', telescope.keymaps, { desc = '[mm] Find keymap' })
vim.keymap.set({ 'n', 'v' }, '<Leader>fs', telescope.grep_string,
    { desc = '[mm] Grep string under cursor or highlighted' })
vim.keymap.set({ 'n', 'v' }, '<Leader>fw', telescope.live_grep, { desc = '[mm] Live grep' })
vim.keymap.set({ 'n', 'v' }, '<Leader>ss', telescope.spell_suggest, { desc = '[mm] Spell suggest' })

-------------------
-- Auto Complete --
-------------------

local cmp = require('cmp')

cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({ { name = 'nvim_lsp' } }),
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }),
})

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = 'buffer' } },
})

----------------------
-- Language servers --
----------------------
local function go_to_definitions()
    vim.cmd('fc!') -- close all floating windows
    telescope.lsp_definitions()
end

vim.keymap.set('n', 'gd', go_to_definitions, { desc = '[mm] Go to definition' })
vim.keymap.set('n', 'gi', telescope.lsp_implementations, { desc = '[mm] Go to implementations' })
vim.keymap.set('n', 'gr', telescope.lsp_references, { desc = '[mm] Go to references' })
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = '[mm] Show diagnositc' })
vim.keymap.set('n', 'ff', vim.lsp.buf.format, { desc = '[mm] Format file' })
vim.keymap.set('n', '<Leader>r', vim.lsp.buf.rename, { desc = '[mm] Rename' })

local autosave_group = vim.api.nvim_create_augroup('AutoSave', {})
vim.api.nvim_create_autocmd('BufWritePre', {
    group = autosave_group,
    callback = function()
        vim.lsp.buf.format({ async = false })
    end
})

vim.o.completeopt = 'menu,menuone,noselect,popup' -- Disable autocomplete & new popup
vim.diagnostic.config({
    signs = false,
})

vim.lsp.config('*', {
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

require('lsp-config.lua_ls')

vim.lsp.enable({
    'lua_ls',
    'rust_analyzer',
    'ts_ls',
    'jsonls',
    'cssls',
    'html',
    'eslint',
    'tailwindcss',
    'tinymist',
})

vim.pack.add({
	{
		src = "https://github.com/rose-pine/neovim",
		name = "rose-pine",
	},
})
require("rose-pine").setup()
vim.cmd("colorscheme rose-pine")

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Keep cursor in center when page up/down
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Keep cursor in center when jumping for search
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>m", "\"+p")
--
--
-- File Type Specific Stuff
--autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
--autocmd FileType pug setlocal ts=2 sts=2 sw=2 expandtab
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'yaml',
    callback = function()
	    vim.opt.tabstop = 2
	    vim.opt.softtabstop = 2
	    vim.opt.shiftwidth = 2
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'pug',
    callback = function()
	    vim.opt.tabstop = 2
	    vim.opt.softtabstop = 2
	    vim.opt.shiftwidth = 2
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'lua',
    callback = function()
	    vim.opt.tabstop = 2
	    vim.opt.softtabstop = 2
	    vim.opt.shiftwidth = 2
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'css',
    callback = function()
	    vim.opt.tabstop = 2
	    vim.opt.softtabstop = 2
	    vim.opt.shiftwidth = 2
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'go',
    callback = function()
	    vim.opt.tabstop = 4
	    vim.opt.softtabstop = 4
	    vim.opt.shiftwidth = 4
    end,
})

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

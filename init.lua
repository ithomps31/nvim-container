vim.pack.add({
	{
		src = "https://github.com/rose-pine/neovim",
		name = "rose-pine",
	},
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/windwp/nvim-autopairs' },
})

vim.pack.add { gh 'j-hui/fidget.nvim' }
  require('fidget').setup {}

vim.lsp.config['python-lsp-server'] = {
  cmd = { 'python-lsp-server' },
  filetypes = { 'python' },
}

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
    callback = function(event)
      local buf = event.buf

      -- Find references for the word under your cursor.
      vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })

      -- Jump to the implementation of the word under your cursor.
      -- Useful when your language has ways of declaring types without an actual implementation.
      vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })

      -- Jump to the definition of the word under your cursor.
      -- This is where a variable was first declared, or where a function is defined, etc.
      -- To jump back, press <C-t>.
      vim.keymap.set('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })

      -- Fuzzy find all the symbols in your current document.
      -- Symbols are things like variables, functions, types, etc.
      vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })

      -- Fuzzy find all the symbols in your current workspace.
      -- Similar to document symbols, except searches over your entire project.
      vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })

      -- Jump to the type of the word under your cursor.
      -- Useful when you're not sure what type a variable is and you want to see
      -- the definition of its *type*, not where it was *defined*.
      vim.keymap.set('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
    end,
  })

require("rose-pine").setup()
vim.cmd("colorscheme rose-pine")

vim.lsp.enable('python-lsp-server')

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

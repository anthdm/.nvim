print("Welcome Anthony! How are you doing today?")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Snippet taken from
-- https://github.com/folke/lazy.nvim#-installation
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Dark colorscheme variant
vim.o.background = "dark"

vim.opt.guicursor = "i:block"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
-- Disable Vim's mode indicator (i.e. -- INSERT --) so
-- it doesn't visually conflict with `lualine.nvim`
vim.opt.showmode = false
-- Show current line number on cursorline
vim.opt.number = true
-- Relative line numbers
vim.opt.relativenumber = true
vim.opt.swapfile = false
-- Highlight search results
vim.o.hlsearch = true
-- Enable mouse
vim.o.mouse = "a"
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
-- Shorter update time ~ faster user experience
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300
--vim.o.completeopt = 'menuone,noselect'
if vim.fn.has("termguicolors") == 1 then
  vim.o.termguicolors = true
end

require("lazy").setup({
  {
    "ellisonleao/gruvbox.nvim",
    opts = {
      contrast = "hard",
      palette_overrides = {
        gray = "#2ea542",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      pcall(require("nvim-treesitter.install").update({ with_sync = true }))
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons", opt = true },
    opts = {
      options = {
        icons_enabled = false,
        theme = "onedark",
        component_separators = "|",
        section_separators = "",
      },
    },
  },
  "fatih/vim-go",
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v1.x",
    dependencies = {
      { "neovim/nvim-lspconfig" }, -- Required
      { "folke/neodev.nvim", config = true }, -- Optional
      { "williamboman/mason.nvim" }, -- Optional
      { "williamboman/mason-lspconfig.nvim" }, -- Optional
      { "hrsh7th/nvim-cmp" }, -- Required
      { "hrsh7th/cmp-nvim-lsp" }, -- Required
      { "hrsh7th/cmp-buffer" }, -- Optional
      { "hrsh7th/cmp-path" }, -- Optional
      { "saadparwaiz1/cmp_luasnip" }, -- Optional
      { "hrsh7th/cmp-nvim-lua" }, -- Optional
      { "L3MON4D3/LuaSnip" }, -- Required
      { "rafamadriz/friendly-snippets" }, -- Optional
    },
    config = function()
      local lsp = require("lsp-zero")

      lsp.preset("recommended")

      lsp.ensure_installed({
        "tsserver",
        "gopls",
        "eslint",
        "rust_analyzer",
      })

      lsp.set_preferences({
        sign_icons = {},
      })

      lsp.on_attach(function(client, bufnr)
        local opts = { buffer = bufnr, remap = false }
        vim.keymap.set("n", "gd", function()
          vim.lsp.buf.definition()
        end, opts)
      end)

      lsp.setup()

      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        signs = false,
        virtual_text = true,
        underline = false,
      })
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      direction = "horizontal",
      size = 15,
      open_mapping = [[<M-j>]],
    },
  },
  "jhlgns/naysayer88.vim",
  {
    "terrortylor/nvim-comment",
    config = function()
      require("nvim_comment").setup({
        operator_mapping = "<leader>/",
      })
    end,
  },
  "CreaturePhil/vim-handmade-hero",
})

vim.keymap.set("i", "jj", "<Esc>")

-- some
vim.keymap.set("n", "<M-b>", ":Ex<CR>")

-- split screen and navigation
vim.keymap.set("n", "<leader>v", ":vsplit<CR><C-w>l", { noremap = true })
vim.keymap.set("n", "<leader>h", ":wincmd h<CR>", { noremap = true })
vim.keymap.set("n", "<leader>l", ":wincmd l<CR>", { noremap = true })

-- See `:help telescope.builtin`
local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>f", function()
  builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "[/] Fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>p", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<M-p>", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })

-- TREESITTER
require("nvim-treesitter.configs").setup({
  ensure_installed = { "c", "lua", "vim", "go", "javascript", "typescript", "rust" },
  highlight = {
    enable = true,
  },
})

-- COLORSCHEME
vim.cmd.colorscheme("default")

local colorscheme = "gruvbox"

local colorscheme_ok, _ = pcall(vim.cmd.colorscheme, colorscheme)
if not colorscheme_ok then
  vim.notify(colorscheme .. " colorscheme not found!", vim.log.levels.ERROR)
end

-- Adding the same comment color in each theme
local custom_comment_color_group = vim.api.nvim_create_augroup("CustomCommentCollor", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
  group = custom_comment_color_group,
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "Comment", { fg = "#2ea542" })
  end,
})

-- Disable annoying match brackets and all the jaz
local custom_hi_group = vim.api.nvim_create_augroup("CustomHI", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
  group = custom_hi_group,
  pattern = "*",
  command = ":NoMatchParen",
})

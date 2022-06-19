local fn = vim.fn

local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

return packer.startup(function(use)
    use "wbthomason/packer.nvim"
    -- Colorschemes
    use "folke/tokyonight.nvim"
    use "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
    use "lunarvim/darkplus.nvim"
    use "rose-pine/neovim"
    use { "ellisonleao/gruvbox.nvim" }

    use "nvim-telescope/telescope.nvim"
    use "nvim-lua/plenary.nvim"
    use "nvim-treesitter/nvim-treesitter"
    use "nvim-lua/popup.nvim"
    -- All the things
    use {
        "williamboman/nvim-lsp-installer",
        "neovim/nvim-lspconfig",
    }
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/nvim-cmp'
    use 'onsails/lspkind-nvim'
    use 'nvim-lua/lsp_extensions.nvim'
    use 'glepnir/lspsaga.nvim'
    use 'simrat39/symbols-outline.nvim'
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'

    use "goolord/alpha-nvim"
    use "tom-anders/telescope-vim-bookmarks.nvim"
    use "MattesGroeger/vim-bookmarks"
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons', -- optional, for file icons
        },
        tag = 'nightly' -- optional, updated every week. (see issue #1193)
    }
    use {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }
    use { 'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons' }
    use { "christianchiarulli/nvim-gps", branch = "text_hl" }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use { "ray-x/lsp_signature.nvim",
        commit = "4852d99f9511d090745d3cc1f09a75772b9e07e9"
    }
end)
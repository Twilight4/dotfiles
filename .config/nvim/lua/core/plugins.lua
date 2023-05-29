-- Automatically install packer
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
      print "Installing packer close and reopen Neovim..."
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[ 
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status, packer = pcall(require, "packer")
if not status then
  print("Packer is not installed")
  return
end

-- Plugins
return packer.startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'szw/vim-maximizer' -- maximizes and restores current window
  --use 'christoomey/vim-tmux-navigator' -- tmux & split window navigation  
  use 'knubie/vim-kitty-navigator' -- kitty & split window navigation
  use 'tpope/vim-surround' -- add, delete, change surroundings
  use 'vim-scripts/ReplaceWithRegister' -- replace with register contents using motion (gr + motion)
  use 'numToStr/Comment.nvim' -- commenting with gc
  use 'nvim-lua/plenary.nvim' -- lua functions that many plugins use
  use 'nvim-tree/nvim-tree.lua' -- file explorer
  use 'kyazdani42/nvim-web-devicons' -- file icons
  use 'bluz71/vim-nightfly-guicolors' -- preferred colorscheme
  use 'nvim-lualine/lualine.nvim' -- statusline
  use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }) -- dependency for better sorting performance
  use({ 'nvim-telescope/telescope.nvim', branch = '0.1.x' }) -- fuzzy finder
  use 'windwp/nvim-autopairs' -- auto closing
  use 'ap/vim-css-color' -- a high-performance color highlighter
  use 'folke/zen-mode.nvim' -- distraction-free mode
  use 'lewis6991/gitsigns.nvim' -- git integration
  use 'dinhhuy258/git.nvim' -- for git blame & browse
  use 'tpope/vim-fugitive' -- git integration
  use 'tpope/vim-rhubarb' -- git integration
  use 'akinsho/nvim-bufferline.lua' -- a snazzy bufferline
  use 'junegunn/fzf' -- fzf integration
  use 'junegunn/fzf.vim' -- fzf integration
  use 'simeji/winresizer' -- toggle resize mode for windows
  use 'farmergreg/vim-lastplace' -- saves the last cursor place
  use 'junegunn/goyo.vim' -- changes the window on main focus
  use 'moll/vim-bbye' -- unfuck buffers
  use 'lewis6991/impatient.nvim' -- speed up loading Lua modules 
  use 'RRethy/vim-illuminate' -- quick word search under cursor alt+p and alt+n
  use 'ekickx/clipboard-image.nvim' -- paste img from clipboard
  use 'mbbill/undotree' -- show the vim undo tree
  --use 'vimwiki/vimwiki' -- personal Wiki for Vim 
  use({
	"Pocco81/auto-save.nvim",
	config = function()
		 require("auto-save").setup {
			-- your config goes here
			-- or just leave it empty :)
		 }
	end,
  })
  use {
    'goolord/alpha-nvim',
    config = function ()
        require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end
  }    
  use {"akinsho/toggleterm.nvim", tag = '*', config = function()
    require("toggleterm").setup()
  end}
  --use 'wellle/tmux-complete.vim'
  --use 'tmux-plugins/vim-tmux'
  --use 'tmux-plugins/vim-tmux-focus-events'
  use({
    'iamcco/markdown-preview.nvim',
    run = function() vim.fn['mkdp#util#install']() end,
  })
		
  -- [[ Highlight on yank ]]
  -- See `:help vim.highlight.on_yank()`
  local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
      vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
  })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)

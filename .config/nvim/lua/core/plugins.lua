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
  return
end

-- Plugins
return packer.startup(function(use)
  use 'wbthomason/packer.nvim'
    
  use 'szw/vim-maximizer' -- maximizes and restores current window
  --use 'christoomey/vim-tmux-navigator' -- tmux & split window navigation  
  use 'tpope/vim-surround' -- add, delete, change surroundings
  use 'vim-scripts/ReplaceWithRegister' -- replace with register contents using motion (gr + motion)
  use 'numToStr/Comment.nvim' -- commenting with gc
  use 'nvim-lua/plenary.nvim' -- lua functions that many plugins use
  use 'nvim-tree/nvim-tree.lua' -- file explorer
  use 'kyazdani42/nvim-web-devicons' -- file icons
  use("bluz71/vim-nightfly-guicolors") -- preferred colorscheme
  use 'nvim-lualine/lualine.nvim' -- Statusline
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- dependency for better sorting performance
  use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" }) -- fuzzy finder
  use 'windwp/nvim-autopairs'
  use 'norcalli/nvim-colorizer.lua'
  use 'folke/zen-mode.nvim'
  --use 'wellle/tmux-complete.vim'
  --use 'tmux-plugins/vim-tmux'
  --use 'tmux-plugins/vim-tmux-focus-events'
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })
  use 'akinsho/nvim-bufferline.lua'
  -- use 'github/copilot.vim'

  use 'lewis6991/gitsigns.nvim'
  use 'dinhhuy258/git.nvim' -- For git blame & browse

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)

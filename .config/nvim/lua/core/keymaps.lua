-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap

-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
keymap.set('', '<Space>', '<Nop>')

-- Clear search highlights
keymap.set('n', 'nh', ':nohl<CR>')

-- Use only 'y - copy' and 'd - cut' to yank
keymap.set('n', 'x', '"_x')
keymap.set('n', 'cw', '"_cw')
keymap.set('n', 'ce', '"_ce')
keymap.set('n', 'cb', '"_cb')
keymap.set('n', 'C', '"_C')
keymap.set('n', 's', '"_s')
keymap.set('n', 'S', '"_S')

-- Increment/decrement with +/-
keymap.set('n', '+', '<C-a>')
keymap.set('n', '-', '<C-x>')

-- Select all
keymap.set('n', '<C-a>', 'gg<S-v>G')

-- Better paste
keymap.set('v', 'p', '"_dP')

-- Split window
keymap.set('n', 'sv', '<C-w>v') -- split window vertically
keymap.set('n', 'ss', '<C-w>s') -- split window horizontally
keymap.set('n', 'sx', ':close<CR>') -- close current split window
keymap.set('n', 'se', '<C-w>=') -- make split windows equal width & height
-- Navigate windows with C-h/j/k/l - (tmux plugin does it by default)
--keymap.set('', '<C-h>', '<C-w>h')
--keymap.set('', '<C-k>', '<C-w>k')
--keymap.set('', '<C-j>', '<C-w>j')
--keymap.set('', '<C-l>', '<C-w>l')
-- Move window
--keymap.set('', 'sh', '<C-w>h')
--keymap.set('', 'sk', '<C-w>k')
--keymap.set('', 'sj', '<C-w>j')
--keymap.set('', 'sl', '<C-w>l')

-- Tabs
keymap.set('n', 'te', ':tabedit ') -- open new tab and type a name
keymap.set('n', 'to', ':tabnew<CR>') -- open new tab
keymap.set('n', 'tx', ':tabclose<CR>') -- close current tab
keymap.set('n', 'tn', ':tabn<CR>') --  go to next tab
keymap.set('n', 'tp', ':tabp<CR>') --  go to previous tab

-- Navigate buffers
keymap.set('n', '<S-l>', ':bnext<CR>')
keymap.set('n', '<S-h>', ':bprevious<CR>')
-- Close buffers
keymap.set('n', '<S-q>', ':Bdelete!<CR>')
-- Close all unsaved buffers
keymap.set('n', '<S-a>', ':bufdo :Bdelete!<CR>')

-- Visual --
-- Stay in indent mode
keymap.set('v', '<', '<gv')
keymap.set('v', '>', '>gv')


---------------------
-- Plugin Keybinds --
---------------------

-- vim-maximizer
keymap.set('n', 'sm', ':MaximizerToggle<CR>') -- toggle split window maximization

-- nvim-tree
keymap.set("n", "ze", ":NvimTreeToggle<CR>") -- toggle file explorer

-- telescope
keymap.set('n', 'nf', ':Telescope find_files<CR>') -- find files within current working directory, respects .gitignore
keymap.set('n', 'ns', ':Telescope live_grep<CR>') -- find string in current working directory as you type
keymap.set('n', 'nc', ':Telescope grep_string<CR>') -- find string under cursor in current working directory
keymap.set('n', 'nb', ':Telescope buffers<CR>') -- list open buffers in current neovim instance
keymap.set('n', 'nt', ':Telescope help_tags<CR>') -- list available help tags
-- telescope git commands
keymap.set('n', 'gc', ':Telescope git_commits<CR>') -- list all git commits (use <cr> to checkout) ["gc" for git commits]
keymap.set('n', 'gf', ':Telescope git_bcommits<CR>') -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
keymap.set('n', 'gb', ':Telescope git_branches<CR>') -- list git branches (use <cr> to checkout) ["gb" for git branch]
keymap.set('n', 'gs', ':Telescope git_status<CR>') -- list current changes per file with diff preview ["gs" for git status]

-- FZF
keymap.set('n', 'zf', ':Files<CR>')

-- Toggle Undo Tree
keymap.set('n', 'zu', ':UndotreeToggle<CR>')

-- Toggle Undo Tree
keymap.set('n', 'zg', ':Goyo<CR>')

-- Toggle Term
keymap.set('n', 'zt', ':ToggleTerm size=40 dir=~/Desktop direction=horizontal<CR>')

-- Other
keymap.set('n', '<leader>p', ':PasteImg <CR>')
keymap.set('n', '<leader>n', ':ASToggle<CR>')
keymap.set('n', '<leader>m', ':MarkdownPreviewToggle<CR>')

-- Git integration with fugitive, gitsigns and rhubarb
keymap.set({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
keymap.set({'n', 'v'}, '<leader>hs', ':Gitsigns reset_hunk<CR>')
keymap.set('n', '<leader>hS', gs.stage_buffer)
keymap.set('n', '<leader>ha', gs.stage_hunk)
keymap.set('n', '<leader>hu', gs.undo_stage_hunk)
keymap.set('n', '<leader>hR', gs.reset_buffer)
keymap.set('n', '<leader>hp', gs.preview_hunk)
keymap.set('n', '<leader>hb', function() gs.blame_line{full=true} end)
keymap.set('n', '<leader>tb', gs.toggle_current_line_blame)
keymap.set('n', '<leader>hd', gs.diffthis)
keymap.set('n', '<leader>hD', function() gs.diffthis('~') end)
keymap.set('n', '<leader>td', gs.toggle_deleted)
-- Text object
keymap.set({'o', 'x'}, 'ih', '<C-U>Gitsigns select_hunk<CR>')

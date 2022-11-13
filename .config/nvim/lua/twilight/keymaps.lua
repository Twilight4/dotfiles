local keymap = vim.keymap

-- Silent keymap option
local opts = { silent = true }

-- Clear search highlights
keymap.set('n', 'nh', ':nohl<CR>')

-- Do not yank with x
keymap.set('n', 'x', '"_x')

-- Increment/decrement with +/-
keymap.set('n', '+', '<C-a>')
keymap.set('n', '-', '<C-x>')

-- Delete a word backwards
keymap.set('n', 'dw', 'vb"_d')

-- Select all
keymap.set('n', '<C-a>', 'gg<S-v>G')

-- Better paste
keymap.set('v', 'p', '"_dP')

-- Buffers
keymap.set('n','<S-h>', ':badd ') -- add new buffer, type filename
keymap.set('n','<S-l>', ':ls!<CR>') -- list all buffers
keymap.set('n', '<S-j>', ':bnext<CR>') -- buffer next
keymap.set('n', '<S-k>', ':bprevious<CR>') -- buffer previous
keymap.set('n', '<S-q>', '<cmd>bdel!<CR>') -- close active buffer

-- Split window
keymap.set('n', 'sv', '<C-w>v') -- split window vertically
keymap.set('n', 'ss', '<C-w>s') -- split window horizontally
keymap.set('n', 'se', '<C-w>=') -- make split windows equal width & height
keymap.set('', 'sx', ':close<CR>') -- close current split window
-- Resize window
keymap.set('n', 'zk', ':resize -3<CR>')
keymap.set('n', 'zj', ':resize +3<CR>')
keymap.set('n', 'zh', ':vertical resize -5<CR>')
keymap.set('n', 'zl', ':vertical resize +5<CR>')

-- Tabs
keymap.set('n', 'te', ':tabedit ') -- open new tab and type a name
keymap.set('n', 'to', ':tabnew<CR>') -- open new tab
keymap.set('n', 'tx', ':tabclose<CR>') -- close current tab
keymap.set('n', 'tn', ':tabn<CR>') --  go to next tab
keymap.set('n', 'tp', ':tabp<CR>') --  go to previous tab

-- Disable arrow keys
keymap.set('n', '<Down>', '<NOP>')
keymap.set('n', '<Left>', '<NOP>')
keymap.set('n', '<Right>', '<NOP>')
keymap.set('n', '<Up>', '<NOP>')

---------------------
-- Plugin Keybinds --
---------------------

-- vim-maximizer
keymap.set('n', 'sm', ':MaximizerToggle<CR>') -- toggle split window maximization

-- nvim-tree
keymap.set("n", "ze", ":NvimTreeToggle<CR>") -- toggle file explorer

local keymap = vim.keymap

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

-- Save with root permission (not working for now)
--vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})

-- New buffer
keymap.set('n','<leader>bn', ':bn')
keymap.set('n','<leader>tn', 'gt')

-- Tabs
keymap.set('n', 'te', ':tabedit ') -- open new tab and type a name
keymap.set('n', 'to', ':tabnew<CR>') -- open new tab
keymap.set('n', 'tx', ':tabclose<CR>') -- close current tab
keymap.set('n', 'tn', ':tabn<CR>') --  go to next tab
keymap.set('n', 'tp', ':tabp<CR>') --  go to previous tab

-- Split window
keymap.set('n', 'sv', '<C-w>v') -- split window vertically
keymap.set('n', 'ss', '<C-w>s') -- split window horizontally
keymap.set('n', 'se', '<C-w>=') -- make split windows equal width & height
keymap.set('', 'sx', ':close<CR>') -- close current split window
-- Change focus of the window
keymap.set('n', '<Space>', '<C-w>w')
keymap.set('', 'sh', '<C-w>h')
keymap.set('', 'sk', '<C-w>k')
keymap.set('', 'sj', '<C-w>j')
keymap.set('', 'sl', '<C-w>l')
-- Resize window
keymap.set('n', '<M-,>', '<C-w>-')
keymap.set('n', '<M-n>', '<C-w><')
keymap.set('n', '<M-m>', '<C-w>+')
keymap.set('n', '<M-.>', '<C-w>>')

-- Disable arrow keys
keymap.set('n',  '<Down>', '<NOP>')
keymap.set('n',  '<Left>', '<NOP>')
keymap.set('n',  '<Right>', '<NOP>')
keymap.set('n',  '<Up>', '<NOP>')

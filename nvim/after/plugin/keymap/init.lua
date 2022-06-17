local keymap = require('user.keymap')
-- Normal --
-- Better window navigation
keymap.nnoremap("<C-h>", "<C-w>h")
keymap.nnoremap("<C-j>", "<C-w>j")
keymap.nnoremap("<C-k>", "<C-w>k")
keymap.nnoremap("<C-l>", "<C-w>l")
keymap.inoremap("jk", "<Esc>")
keymap.nnoremap("<A-j>", "<Esc>:m .+1<CR>==$")
keymap.nnoremap("<A-k>", "<Esc>:m .-2<CR>==$")
keymap.vnoremap("<A-j>", ":m .+1<CR>==")
keymap.vnoremap("<A-k>", ":m .-2<CR>==")
keymap.nnoremap("<S-l>", ":bnext<CR>")
keymap.nnoremap("<S-h>", ":bprevious<CR>")
keymap.nnoremap("<leader>ff", function() require('telescope.builtin').find_files() end)

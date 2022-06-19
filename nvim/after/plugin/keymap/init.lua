local keymap = require('user.keymap')
-- Normal --
keymap.nnoremap("<leader>qq", ":qa<CR>")
keymap.nnoremap("<leader>qa", ":qa!<CR>")
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
keymap.nnoremap("<leader>c", ":bd<CR>")

keymap.nnoremap("<leader>b",
    function()
        require('telescope.builtin')
            .buffers(require('telescope.themes')
            .get_dropdown { previewer = false })
    end)

keymap.nnoremap("<leader>ff", function() require('telescope.builtin').find_files() end)
keymap.nnoremap("<leader>sk", "<cmd>Telescope keymaps<CR>")
keymap.nnoremap("<leader>sc", "<cmd>Telescope commands<CR>")

keymap.nnoremap("<leader>e", ":NvimTreeToggle<CR>")

-- Bookmark
keymap.nnoremap("<leader>mm", "<cmd>BookmarkToggle<CR>")
keymap.nnoremap("<leader>mn", "<cmd>BookmarkNext<CR>")
keymap.nnoremap("<leader>mp", "<cmd>BookmarkPrev<CR>")
keymap.nnoremap("<leader>mca", "<cmd>BookmarkClearAll<CR>")
keymap.nnoremap("<leader>ma", function() require("telescope").extensions.vim_bookmarks.all() end)
keymap.nnoremap("<leader>mf", function() require("telescope").extensions.vim_bookmarks.current_file() end)

local keymap = require("user.keymap")
local nopreview = require("telescope.themes").get_dropdown { previewer = false }
local silent = { silent = true }
-- Normal --
keymap.nnoremap("<leader>qq", ":qa<CR>")
keymap.nnoremap("<leader>qa", ":qa!<CR>")
keymap.nnoremap("<leader>qw", ":wqa<CR>")
keymap.nnoremap("<C-S>", ":wa<CR>")
-- Better window navigation
keymap.nnoremap("<C-h>", "<C-w>h")
keymap.nnoremap("<C-j>", "<C-w>j")
keymap.nnoremap("<C-k>", "<C-w>k")
keymap.nnoremap("<C-l>", "<C-w>l")
keymap.nnoremap("<C-Up>", ":resize -2<CR>")
keymap.nnoremap("<C-Down>", ":resize +2<CR>")
keymap.nnoremap("<C-Left>", ":vertical resize -2<CR>")
keymap.nnoremap("<C-Right>", ":vertical resize +2<CR>")

keymap.inoremap("jk", "<Esc>")
keymap.inoremap("<A-j>", "<Esc>:m .+1<CR>==$A")
keymap.inoremap("<A-k>", "<Esc>:m .-2<CR>==$A")
-- keymap.nnoremap("<A-k>", ":m .-2<CR>==")
-- keymap.nnoremap("<A-j>", ":m .+1<CR>==")
keymap.xnoremap("<A-j>", ":move '>+1<CR>gv-gv")
keymap.xnoremap("<A-k>", ":move '<-2<CR>gv-gv")
keymap.vnoremap("<", "<gv")
keymap.vnoremap(">", ">gv")

keymap.nnoremap("<S-l>", ":bnext<CR>")
keymap.nnoremap("<S-h>", ":bprevious<CR>")
local close_ok, close_buffers = pcall(require, "close_buffers")
if close_ok then
  keymap.nnoremap("<leader>bo", function() require('close_buffers').delete({ type = 'hidden', force = true }) end)
  keymap.nnoremap("<leader>ba", function() require('close_buffers').wipe({ type = 'all', force = true }) end)
end
keymap.nnoremap("<leader>bb", "<cmd>Bdelete!<CR>")


-- Telescope
keymap.nnoremap("<leader>sh", "<cmd>nohlsearch<cr>")
keymap.nnoremap("<leader>sf", function() require("telescope.builtin").find_files(nopreview) end)
keymap.nnoremap("<leader>sp", "<cmd>Telescope projects<CR>")
keymap.nnoremap("<leader>sg", "<cmd>Telescope live_grep<CR>")
keymap.nnoremap("<leader>sk", "<cmd>Telescope keymaps<CR>")
keymap.nnoremap("<leader>sc", "<cmd>Telescope commands<CR>")
keymap.nnoremap("<leader>sr", "<cmd>Telescope oldfiles<CR>")
keymap.nnoremap("<leader>sb", function() require("telescope.builtin").buffers(nopreview) end)

keymap.nnoremap("<leader>e", ":NvimTreeToggle<CR>")

-- Bookmark
keymap.nnoremap("<leader>mm", "<cmd>BookmarkToggle<CR>")
keymap.nnoremap("<leader>mn", "<cmd>BookmarkNext<CR>")
keymap.nnoremap("<leader>mp", "<cmd>BookmarkPrev<CR>")
keymap.nnoremap("<leader>mca", "<cmd>BookmarkClearAll<CR>")
keymap.nnoremap("<leader>ma", function() require("telescope").extensions.vim_bookmarks.all() end)
keymap.nnoremap("<leader>mf", function() require("telescope").extensions.vim_bookmarks.current_file(nopreview) end)


-- Git
keymap.nnoremap("<leader>gs", function() require('telescope').extensions.git_worktree.git_worktrees() end)
keymap.nnoremap("<leader>gc", function() require('telescope').extensions.git_worktree.create_git_worktree() end)


if os.getenv('OS') ~= "Winwos_NT" then
  keymap.nnoremap("<leader>a", function() require("harpoon.mark").add_file() end, silent)
  keymap.nnoremap("<C-e>", function() require("harpoon.ui").toggle_quick_menu() end, silent)
  keymap.nnoremap("<leader>tc", function() require("harpoon.cmd-ui").toggle_quick_menu() end, silent)
  keymap.nnoremap("<A-1>", function() require("harpoon.ui").nav_file(1) end, silent)
  keymap.nnoremap("<A-2>", function() require("harpoon.ui").nav_file(2) end, silent)
  keymap.nnoremap("<A-3>", function() require("harpoon.ui").nav_file(3) end, silent)
  keymap.nnoremap("<A-4>", function() require("harpoon.ui").nav_file(4) end, silent)
end

local options = {
  hlsearch = false,
  shell = "pwsh.exe",
  statusline = "status-line",
  number = true,
  background = "dark",
  updatetime = 50,
  -- guicursor = "",
  relativenumber = true,
  hlsearch = false,
  hidden = true,
  errorbells = false,
  tabstop = 4 ,
  softtabstop = 4 ,
  shiftwidth = 4,
  expandtab = true,
  smartindent = true,
  nu = true,
  wrap = false,
  swapfile = false,
  backup = false,
  undodir = ( os.getenv("XDG_DATA_HOME") .. "/.vim/undodir") or nil,
  undofile = true,
  incsearch = true,
  termguicolors = true,
  scrolloff = 8,
  signcolumn = "yes",

  -- Give more space for displaying messages.
  cmdheight = 1,

  -- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
  -- delays and poor user experience.
  updatetime = 50,

  -- Don't pass messages to |ins-completion-menu|.

  colorcolumn = "80"
}

vim.opt.isfname:append("@-@")
vim.opt.shortmess:append("c")
for k, v in pairs(options) do 
  vim.opt[k] = v
end

vim.g.mapleader = " "

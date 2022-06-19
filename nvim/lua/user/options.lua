local options = {
  -- shell = "pwsh.exe",
  number = true,
  background = "dark",
  relativenumber = true,
  hlsearch = false,
  hidden = true,
  errorbells = false,
  tabstop = 2,
  softtabstop = 2,
  shiftwidth = 2,
  expandtab = true,
  smartindent = true,
  nu = true,
  wrap = false,
  swapfile = false,
  backup = false,
  undodir = (vim.fn.stdpath "data" .. "/undodir") or nil,
  undofile = true,
  incsearch = true,
  termguicolors = true,
  scrolloff = 8,
  signcolumn = "yes",
  cmdheight = 1,
  updatetime = 50,
  colorcolumn = "80"
}
vim.opt.isfname:append("@-@")
vim.opt.shortmess:append("c")
for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.g.mapleader = " "

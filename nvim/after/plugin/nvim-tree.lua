local status_ok, nvimtree = pcall(require, "nvim-tree")
if status_ok then
  nvimtree.setup({
    respect_buf_cwd = true,
    update_cwd = true,
    update_focused_file = {
      enable = true,
      update_cwd = true
    },
    git = {
      enable = false 
    },
  })
end

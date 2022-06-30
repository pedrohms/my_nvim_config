local M = {}

M.setup = function()
  local signs = {

    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    virtual_text = false, -- disable virtual text
    signs = {
      active = signs, -- show signs
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)

  -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  --   border = "rounded",
  -- })
  --
  -- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  --   border = "rounded",
  -- })
end

local function lsp_keymaps(bufnr)
  local Remap = require("user.keymap")
  local nnoremap = Remap.nnoremap
  local inoremap = Remap.inoremap
  nnoremap("gd", function() vim.lsp.buf.definition() end)
  nnoremap("K", function() vim.lsp.buf.hover() end)
  nnoremap("<leader>lws", function() vim.lsp.buf.workspace_symbol() end)
  nnoremap("<leader>ld", function() vim.diagnostic.open_float() end)
  nnoremap("[d", function() vim.lsp.diagnostic.goto_next() end)
  nnoremap("]d", function() vim.lsp.diagnostic.goto_prev() end)
  nnoremap("<leader>lca", function() vim.lsp.buf.code_action() end)
  nnoremap("<leader>lrf", function() vim.lsp.buf.references() end)
  nnoremap("<leader>lrn", function() vim.lsp.buf.rename() end)
  inoremap("<C-h>", function() vim.lsp.buf.signature_help() end)
  inoremap("<C-K>", function() vim.lsp.buf.hover() end)
  -- nnoremap("<leader>lds", "<cmd>Telescope lsp_document_symbols<cr>")
  nnoremap("<leader>lds", function() require("telescope.builtin").lsp_document_symbols(require("telescope.themes")
      .get_dropdown { previewer = false })
  end)
  if vim.lsp.buf["format"] == nil then
    nnoremap("<leader>lf", function() vim.lsp.buf.formatting() end)
  else
    nnoremap("<leader>lf", function() vim.lsp.buf.format { async = true } end)
  end
end

local disable_format = function(c)

  require("user.log.log").println("desabilitei o format do " .. c.name)
  if c["server_capatilities"] ~= nil then
    c.server_capabilities.document_formatting = false
    c.server_capabilities.document_range_formatting = false
  end
  if os.getenv("OS") ~= "Windows_NT" then
    return
  end
  if c["resolved_capabilities"] ~= nil then
    c.resolved_capabilities.document_formatting = false
    c.resolved_capatilities.document_range_formatting = false
  end
end

local exclude_nullls = {
  "sumneko_lua"
}
M.on_init = function(client)
  if client.name == "jdtls" then
    local java_config = require("user.lsp.settings.java_config")

    client.config.settings = java_config.settings
    client.config.cmd = java_config.cmd
  else
    for i, ft in pairs(exclude_nullls) do
      if ft == client.name then
        goto jump_disable
      end
    end
    disable_format(client)
    ::jump_disable::
  end
end
M.on_attach = function(client, bufnr)
  local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if not status_cmp_ok then
    return
  end

  lsp_keymaps(bufnr)

  if client.name == "jdtls" then
    vim.lsp.codelens.refresh()
    require("jdtls").setup_dap { hotcodereplace = "auto" }
    require("jdtls.dap").setup_dap_main_class_configs()
  end

  M.capabilities = vim.lsp.protocol.make_client_capabilities()
  M.capabilities = cmp_nvim_lsp.update_capabilities(M.capabilities)
  M.capabilities.textDocument.completion.completionItem.snippetSupport = true
end

return M
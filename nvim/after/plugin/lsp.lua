local Remap = require("user.keymap")
local nnoremap = Remap.nnoremap
local inoremap = Remap.inoremap

local sumneko_root_path = vim.fn.stdpath "data" .. "/lsp_servers/sumneko_lua/extension/server/bin"
local sumneko_binary = sumneko_root_path .. "/lua-language-server"
if os.getenv('OS') == "Windows_NT" then
  sumneko_binary = sumneko_binary .. ".exe"
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true


local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
  return
end

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
  return
end

local telescope_ok, telescope_theme = pcall(require, "telescope.themes")
if not telescope_ok then
 return 
end

local telescope_builtin_ok, telescope_builtin = pcall(require, "telescope.builtin")
if not telescope_builtin_ok then
 return 
end

local nopreview = telescope_theme.get_dropdown { previewer = false }


local servers = {
  "dartls",
  "emmet_ls",
  "eslint",
  "cssls",
  "html",
  "jdtls",
  "jsonls",
  "solc",
  "sumneko_lua",
  "tflint",
  "tsserver",
  "pyright",
  "yamlls",
  "bashls",
  "clangd",
  "gopls",
  "volar",
  "vuels",
  "svelte",
  "tailwindcss",
}

-- if string.find(os.getenv("OS"), "unix") then
--   print "nao e windwos"
--   vim.tbl_deep_extend("force", servers, { "emmet_ls" })
-- end

local settings = {
  ensure_installed = servers,
  ui = {
    keymaps = {
      toggle_server_expand = "<CR>",
      install_server = "i",
      update_server = "u",
      check_server_version = "c",
      update_all_servers = "U",
      check_outdated_servers = "C",
      uninstall_server = "X",
    },
  },

  log_level = vim.log.levels.INFO,
}

lsp_installer.setup(settings)

-- Setup nvim-cmp.
local cmp = require("cmp")
local source_mapping = {
  buffer = "[Buffer]",
  nvim_lsp = "[LSP]",
  nvim_lua = "[Lua]",
  cmp_tabnine = "[TN]",
  path = "[Path]",
}
local lspkind = require("lspkind")

cmp.setup({
  snippet = {
    expand = function(args)
      -- For `vsnip` user.
      -- vim.fn["vsnip#anonymous"](args.body)

      -- For `luasnip` user.
      require("luasnip").lsp_expand(args.body)

      -- For `ultisnips` user.
      -- vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<C-l>"] = cmp.mapping.close(),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),

  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = lspkind.presets.default[vim_item.kind]
      local menu = source_mapping[entry.source.name]
      if entry.source.name == "cmp_tabnine" then
        if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
          menu = entry.completion_item.data.detail .. " " .. menu
        end
        vim_item.kind = ""
      end
      vim_item.menu = menu
      return vim_item
    end,
  },

  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
  },
})

local function config(_config, clientDsc)
  return vim.tbl_deep_extend("force", {
    capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    on_init = function(client)
      local disable_format = function(c)
        if c["server_capatilities"] ~= nil then
          c.server_capabilities.document_formatting = false
          c.server_capabilities.document_range_formatting = false
        end
        if c["resolved_capabilities"] ~= nil then
          c.resolved_capabilities.document_formatting = false
          c.resolved_capatilities.document_range_formatting = false
        end
      end
      if clientDsc == "jdtls" then
        local lombok = "-javaagent:" .. vim.fn.stdpath "data" .. "/lsp_servers/jdtls/lombok.jar"
        local lombok2 = "-Xbootclasspath/a:" .. vim.fn.stdpath "data" .. "/lsp_servers/jdtls/lombok.jar"
        local cmd = client.config.cmd
        table.insert(cmd, 12, lombok)
        table.insert(cmd, 13, lombok2)
        client.config.cmd = cmd
        -- disable_format(client)
        -- require("user.log.log").println(vim.inspect(client))
      end
      if clientDsc == "tsserver" then
        disable_format(client)
      end

    end,
    on_attach = function(client)
      if clientDsc == "jdtls" then
        nnoremap("<leader>lpc", function() require("jdtls").update_project_config() end)
      end
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
      nnoremap("<leader>lds", function() telescope_builtin.lsp_document_symbols(nopreview) end)
      if vim.lsp.buf["format"] == nil then
        nnoremap("<leader>lf", function() vim.lsp.buf.formatting() end)
      else
        nnoremap("<leader>lf", function() vim.lsp.buf.format { async = true } end)
      end
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if not status_cmp_ok then
        return
      end
      capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
    end,
  }, _config or {})
end

for _, server in pairs(servers) do
  local opts = config({}, server)
  if server == "jdtls" then
    local jdtlsOpts = {
      cmd = {
        "jdtls",
      },
      settings = {
        java = {
          signatureHelp = { enabled = true },
          -- format = { enabled = false },
        },
      },
    }
    opts = vim.tbl_deep_extend("force", jdtlsOpts, opts)
  end
  if server == "cssls" then
    local htmlOpts = {
      filetypes = { "css", "html",  "typescriptreact", "vue" }
    }
    opts = vim.tbl_deep_extend("force", htmlOpts, opts)
  end
  if server == "tsserver" then
    local tsserverOpts = {
      filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "json" },
      settings = {
        tsserver = {
          format = { enable = false },
        },
        eslint = {
          fomat = { enable = false },
        },
      },
    }
    opts = vim.tbl_deep_extend("force", tsserverOpts, opts)
  end
  if server == "volar" then
    local volarOpts = {
      filetypes = {  "vue", "json" }
    }
    opts = vim.tbl_deep_extend("force", volarOpts, opts)
  end
  if server == "gopls" then
    local goplsOpts = {
      cmd = { "gopls", "serve" },
      settings = {
        gopls = {
          analyses = {
            unusedparams = true,
          },
          staticcheck = true,
        },
      },
    }
    opts = vim.tbl_deep_extend("force", goplsOpts, opts)
  end
  if server == "emmet_ls" then
    local emmet_ls_opts = {
      filetypes = {
        "html",
        "css",
        "scss",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "haml",
        "xml",
        "xsl",
        "pug",
        "slim",
        "sass",
        "stylus",
        "less",
        "sss",
        "hbs",
        "handlebars",
      }
    }
    opts = vim.tbl_deep_extend("force", emmet_ls_opts, opts)
  end
  if server == "sumneko" then
    local sumnekoOpts = {
      cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you"re using (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
            -- Setup your lua path
            path = vim.split(package.path, ";"),
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim" },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
            },
          },
        },
      },
    }
    opts = vim.tbl_deep_extend("force", sumnekoOpts, opts)
  end
  -- if server ~= "jdtls" then
    lspconfig[server].setup(opts)
  -- end
end

local opts = {
  -- whether to highlight the currently hovered symbol
  -- disable if your cpu usage is higher than you want it
  -- or you just hate the highlight
  -- default: true
  highlight_hovered_item = true,

  -- whether to show outline guides
  -- default: true
  show_guides = true,
}

require("symbols-outline").setup(opts)

local snippets_paths = function()
  local plugins = { "friendly-snippets" }
  local paths = {}
  local path
  local root_path = vim.fn.stdpath "data" .. "/vim_snipets/plugged/"
  for _, plug in ipairs(plugins) do
    path = root_path .. plug
    if vim.fn.isdirectory(path) ~= 0 then
      table.insert(paths, path)
    end
  end
  return paths
end

require("luasnip.loaders.from_vscode").lazy_load({
  paths = snippets_paths(),
  include = nil, -- Load all languages
  exclude = {},
})

require("user.lsp.null-ls")

vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.cmdheight = 2 -- more space in the neovim command line for displaying messages


local status, jdtls = pcall(require, "jdtls")
if not status then
    return
end

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
    return
end

-- Determine OS
local home = os.getenv "HOME"
if vim.fn.has "mac" == 1 then
    WORKSPACE_PATH = home .. "/workspace/"
    CONFIG = "mac"
elseif vim.fn.has "unix" == 1 then
    WORKSPACE_PATH = home .. "/workspace/"
    CONFIG = "linux"
else
    home = os.getenv "APPDATA"
    if home == nil then
        print "Unsupported system"
    else
        CONFIG = "win"
    end

end

-- Find root of project
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)

if (root_dir == nil) or (root_dir == "") then
    return
end

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local workspace_dir = root_dir

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local opts = {
    cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-DwatchParentProcess=false",
        "-javaagent:" .. vim.fn.stdpath "data" .. "/lsp_servers/jdtls/lombok.jar",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-jar",
        vim.fn.glob(vim.fn.stdpath "data" .. "/lsp_servers/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
        "-configuration",
        vim.fn.stdpath "data" .. "/lsp_servers/jdtls/config_" .. CONFIG,
        "-data",
        workspace_dir .. "/jdtls",
        "-XX:+UseParallelGC",
        "-XX:GCTimeRatio=4",
        "-XX:AdaptiveSizePolicyWeight=90",
        "-Dsun.zip.disableMemoryMapping=true",
        "-Djava.import.generatesMetadataFilesAtProjectRoot=false",
        "-Xmx1G",
        "-Xms100m",
    },
    settings = {
        java = {
            eclipse = {
                downloadSources = true,
            },
            configuration = {
                updateBuildConfiguration = "interactive",
            },
            maven = {
                downloadSources = true,
            },
            implementationsCodeLens = {
                enabled = true,
            },
            referencesCodeLens = {
                enabled = true,
            },
            references = {
                includeDecompiledSources = true,
            },
            format = {
                enabled = true,
            },
        },
        signatureHelp = { enabled = true },
        completion = {
            favoriteStaticMembers = {
                "org.hamcrest.MatcherAssert.assertThat",
                "org.hamcrest.Matchers.*",
                "org.hamcrest.CoreMatchers.*",
                "org.junit.jupiter.api.Assertions.*",
                "java.util.Objects.requireNonNull",
                "java.util.Objects.requireNonNullElse",
                "org.mockito.Mockito.*",
            },
        },
        contentProvider = { preferred = "fernflower" },
        sources = {
            organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
            },
        },
        codeGeneration = {
            toString = {
                template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            useBlocks = true,
        },
    },

    flags = {
        allow_incremental_sync = true,
    },
}

local Remap = require("user.keymap")
local nnoremap = Remap.nnoremap
local inoremap = Remap.inoremap

local function config(_config)
    return vim.tbl_deep_extend("force", {
        capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
        on_attach = function()
            nnoremap("gd", function() vim.lsp.buf.definition() end)
            nnoremap("K", function() vim.lsp.buf.hover() end)
            nnoremap("<leader>lws", function() vim.lsp.buf.workspace_symbol() end)
            nnoremap("<leader>ld", function() vim.diagnostic.open_float() end)
            nnoremap("[d", function() vim.lsp.diagnostic.goto_next() end)
            nnoremap("]d", function() vim.lsp.diagnostic.goto_prev() end)
            nnoremap("<leader>lca", function() vim.lsp.buf.code_action() end)
            nnoremap("<leader>lrr", function() vim.lsp.buf.references() end)
            nnoremap("<leader>vrn", function() vim.lsp.buf.rename() end)
            inoremap("<C-h>", function() vim.lsp.buf.signature_help() end)
            inoremap("<C-K>", function() vim.lsp.buf.hover() end)
            nnoremap("<leader>lds", "<cmd>Telescope lsp_document_symbols<cr>")
            nnoremap("<leader>lf", function() vim.lsp.buf.formatting() end)
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            if not status_cmp_ok then
                return
            end
            capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
        end,
    }, _config or {})
end

-- jdtls.start_or_attach(config(opts))
lspconfig["jdtls"].setup(config(opts))

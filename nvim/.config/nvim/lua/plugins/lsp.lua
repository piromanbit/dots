local servers = {
    "texlab",
    "clangd",
    "gopls",
    "lua_ls",
    "marksman",
    "pylsp",
    "rust_analyzer",
}

local server_overrides = {
    rust_analyzer = {
        filetypes = { "rust" },
    },
    lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
                },
            },
        },
    },
    julials = {
        settings = {
            julia = {
                lint = {
                    run = true,
                    missingrefs = "symbols",
                },
            },
        },
    },
}

--- Mason's `julia-lsp` wrapper requires a non-empty Julia env path; if there is no
--- Project.toml+Manifest.toml and Pkg can't infer an env, `env_path` is nil and the
--- process exits with code 1 immediately (often nothing useful in lsp.log). Stock
--- nvim-lspconfig `julials` uses `julia -e` + LanguageServer.jl and matches XDG depot.
--- We skip Mason's julials overlay and do not auto-install the `julia-lsp` Mason package.
local function load_rtp_lsp(name)
    local path = vim.api.nvim_get_runtime_file(("lsp/%s.lua"):format(name), false)[1]
    if not path then
        return nil
    end
    return assert(loadfile(path))()
end

local function setup_lsp()
    local capabilities = require("blink.cmp").get_lsp_capabilities()
    vim.lsp.config("*", { capabilities = capabilities })

    local julials_rtp = load_rtp_lsp("julials")

    for _, server in ipairs(servers) do
        local cfg = vim.tbl_deep_extend("force", { capabilities = capabilities }, server_overrides[server] or {})
        if server == "julials" and julials_rtp then
            cfg = vim.tbl_deep_extend("force", julials_rtp, cfg)
        end
        vim.lsp.config(server, cfg)
        vim.lsp.enable(server)
    end

    if julials_rtp then
        vim.lsp.config("julia-lsp", vim.tbl_deep_extend("force", julials_rtp, { capabilities = capabilities }))
    end
    vim.lsp.enable("julia-lsp", false)

    local group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        callback = function(ev)
            vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

            local opts = { buffer = ev.buf, silent = true }
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration,
                vim.tbl_extend("force", opts, { desc = "LSP declaration" }))
            vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "LSP hover" }))
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation,
                vim.tbl_extend("force", opts, { desc = "LSP implementation" }))
            vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help,
                vim.tbl_extend("force", opts, { desc = "LSP signature help" }))
            vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "LSP rename" }))
            vim.keymap.set({ "n", "v" }, "<Leader>la", vim.lsp.buf.code_action,
                vim.tbl_extend("force", opts, { desc = "LSP code action" }))
            vim.keymap.set("n", "<Leader>lf", function()
                require("conform").format({ async = true, lsp_fallback = true, timeout_ms = 15000 })
            end, vim.tbl_extend("force", opts, { desc = "Format buffer (conform)" }))
        end,
    })

    local ok_mlsp, mason_lspconfig = pcall(require, "mason-lspconfig")
    if ok_mlsp then
        local mason_ensure = vim.tbl_filter(function(name)
            return name ~= "julials"
        end, servers)
        mason_lspconfig.setup({
            ensure_installed = mason_ensure,
            automatic_installation = true,
            automatic_enable = {
                exclude = { "julials" },
            },
        })
    end
end

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = setup_lsp,
}

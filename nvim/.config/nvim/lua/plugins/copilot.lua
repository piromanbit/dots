--- Effective proxy URL for Copilot (LSP settings + Node child process).
--- Use an HTTP(S) proxy URL (e.g. local forwarder): http://127.0.0.1:PORT or http://user:pass@host:port
--- COPILOT_HTTP_PROXY=0|off disables Copilot proxy. Secrets: fish secrets.fish or environment.d *-local.conf.
---
--- Diagnostics: :checkhealth copilot (lowercase; needs plugin on RTP — lazy = false below).
local function copilot_proxy_url()
    local function trim(s)
        if s == nil or s == "" then
            return nil
        end
        return (s:gsub("^%s+", ""):gsub("%s+$", ""))
    end

    local p = trim(vim.env.COPILOT_HTTP_PROXY)
    if p == "0" or p == "off" then
        return nil
    end
    if p ~= nil and p ~= "" then
        return p
    end
    for _, key in ipairs({ "HTTPS_PROXY", "https_proxy", "HTTP_PROXY", "http_proxy" }) do
        local v = trim(vim.env[key])
        if v and v ~= "" then
            return v
        end
    end
    return nil
end

return {
    "zbirenbaum/copilot.lua",
    lazy = false,
    -- LSP passes proxy in workspace settings; some Node code paths also honor HTTP_PROXY.
    init = function()
        local url = copilot_proxy_url()
        if url then
            vim.g.copilot_proxy = url
            vim.g.copilot_proxy_strict_ssl = false
        else
            vim.g.copilot_proxy = nil
        end
    end,
    cmd = "Copilot",
    opts = {
        -- Suggestions go through blink.cmp (blink-cmp-copilot); ghost text would fight the menu.
        suggestion = { enabled = false },
        panel = { enabled = false },
        server_opts_overrides = {
            offset_encoding = "utf-16",
        },
    },
    config = function(_, opts)
        local node = vim.fn.exepath("node")
        if node ~= "" then
            opts.copilot_node_command = node
        end

        local url = copilot_proxy_url()
        if url then
            local no_proxy = "127.0.0.1,localhost,::1"
            for _, extra in ipairs({
                vim.env.NO_PROXY,
                vim.env.no_proxy,
                vim.env.COPILOT_NO_PROXY,
            }) do
                if extra and extra ~= "" then
                    no_proxy = no_proxy .. "," .. extra
                end
            end

            local so = vim.tbl_extend("force", {}, opts.server_opts_overrides or {})
            so.cmd_env = vim.tbl_extend("force", {}, so.cmd_env or {}, {
                HTTP_PROXY = url,
                HTTPS_PROXY = url,
                http_proxy = url,
                https_proxy = url,
                ALL_PROXY = url,
                all_proxy = url,
                NO_PROXY = no_proxy,
                no_proxy = no_proxy,
            })
            opts.server_opts_overrides = so
        end

        -- init() already set vim.g; refresh from env before setup.
        do
            local u = copilot_proxy_url()
            if u then
                vim.g.copilot_proxy = u
                vim.g.copilot_proxy_strict_ssl = false
            else
                vim.g.copilot_proxy = nil
            end
        end

        require("copilot").setup(opts)

        local copilot_mod = require("copilot")
        local c = require("copilot.client")
        if copilot_mod.setup_done and not c.is_disabled() then
            c.ensure_client_started()
        end

        -- :Copilot auth can run before copilot.client.initialized (set in a deferred on_init).
        -- checkStatus then blocks forever with no UI — wait for init, then notify on failure.
        local auth = require("copilot.auth")
        local orig_signin = auth.signin
        auth.signin = function()
            if c.is_disabled() then
                vim.notify("[Copilot] disabled (Node 22+ required; see :messages)", vim.log.levels.ERROR)
                return
            end
            if not c.get() then
                c.ensure_client_started()
            end
            if not c.get() then
                vim.notify("[Copilot] LSP client did not start (see :messages and Copilot log)", vim.log.levels.ERROR)
                return
            end
            local ready = vim.wait(60000, function()
                return c.initialized
            end, 100)
            if not ready then
                vim.notify(
                    "[Copilot] LSP init timed out (proxy/TLS/firewall?). :checkhealth copilot — Copilot log",
                    vim.log.levels.ERROR
                )
                return
            end
            orig_signin()
        end
    end,
}

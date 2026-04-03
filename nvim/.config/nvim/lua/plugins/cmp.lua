return {
  "saghen/blink.cmp",
  version = "*",
  event = "InsertEnter",
  dependencies = {
    "zbirenbaum/copilot.lua",
    "giuxtaposition/blink-cmp-copilot",
  },
  -- blink-cmp-copilot only refreshed LSP client in :enabled() / :new(); after Copilot restarts,
  -- get_completions could keep a dead client. Also upstream get_trigger_characters = { "." } hides
  -- Copilot on most keystrokes (e.g. Julia) — empty list => Invoked, same idea as VS Code.
  init = function()
    local bc = require("blink-cmp-copilot")
    local orig = bc.get_completions
    function bc:get_completions(context, callback)
      local clients = vim.lsp.get_clients({ name = "copilot" })
      bc.client = clients[1]
      if not bc.client then
        return callback({
          is_incomplete_forward = true,
          is_incomplete_backward = true,
          items = {},
        })
      end
      return orig(self, context, callback)
    end
  end,
  opts = {
    keymap = {
      preset = "default",
      ["<C-d>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<Tab>"] = { "select_next", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
    },
    completion = {
      documentation = {
        auto_show = true,
      },
      accept = {
        -- Default 100ms is too low for slow LSPs (e.g. Julia completionItem/resolve).
        resolve_timeout_ms = 3000,
      },
    },
    appearance = {
      kind_icons = {
        Copilot = "",
      },
    },
    sources = {
      default = { "lsp", "path", "buffer", "copilot" },
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot",
          score_offset = 100,
          async = true,
          override = {
            get_trigger_characters = function()
              return {}
            end,
          },
          transform_items = function(_, items)
            local kinds = require("blink.cmp.types").CompletionItemKind
            local idx = #kinds + 1
            kinds[idx] = "Copilot"
            for _, item in ipairs(items) do
              item.kind = idx
            end
            return items
          end,
        },
        lsp = {
          -- With async=false, blink gives up after timeout_ms (default 2000) while the
          -- server is still busy (Julia SymbolServer often blocks >5s on first open).
          async = true,
          timeout_ms = 15000,
        },
      },
    },
    fuzzy = {
      implementation = "prefer_rust_with_warning",
    },
  },
}

-- for general lsp
require'lspconfig'.ocamllsp.setup{}
require'lspconfig'.ts_ls.setup{}

require'lspconfig'.rust_analyzer.setup {
  -- Server-specific settings. See `:help lspconfig-setup`
  settings = {
    ['rust-analyzer'] = {},
  },
}

local rt = require("rust-tools")
rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<Leader>h", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})
rt.hover_range.hover_range()

require("lspsaga").setup{
  code_action_icon = ""
}

vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
vim.keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
vim.keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })
vim.keymap.set("n", "<leader>e", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { silent = true })

-- git signs
require'gitsigns'.setup()

-- gruvbox
require("gruvbox").setup{}

require("render-markdown").setup{
  file_types = { 'markdown', 'Avante' }
}

-- for some reason syntax highlighting on Avante panes don't work unless the ft is really markdown
-- this snippet will force all Avante filetypes to switch to markdown
vim.api.nvim_create_autocmd("FileType", {
  pattern = "Avante",
  callback = function()
    vim.bo.filetype = "markdown"
  end,
  group = vim.api.nvim_create_augroup("OverrideAvanteFiletype", { clear = true }),
})

-- avante
require('avante_lib').load()

local function check_internet_connection()
  local handle = io.popen("ping -c 1 google.com | grep '1 packets'")
  local result = handle:read("*a")
  handle:close()
  local good = "1 packets transmitted, 1 packets received"
  return result:sub(1, #good) == good
end

require('avante').setup{
  provider = check_internet_connection() and "claude" or "ollama",
  vendors = {
    ---@type AvanteProvider
    ollama = {
      ["local"] = true,
      endpoint = "127.0.0.1:11434/v1",
      model = "codegemma",
      parse_curl_args = function(opts, code_opts)
        return {
          url = opts.endpoint .. "/chat/completions",
          headers = {
            ["Accept"] = "application/json",
            ["Content-Type"] = "application/json",
          },
          body = {
            model = opts.model,
            messages = require("avante.providers").copilot.parse_message(code_opts), -- you can make your own message, but this is very advanced
            max_tokens = 2048,
            stream = true,
          },
        }
      end,
      parse_response_data = function(data_stream, event_state, opts)
        require("avante.providers").openai.parse_response(data_stream, event_state, opts)
      end,
    },
  }
}

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

-- avante
require('avante_lib').load()

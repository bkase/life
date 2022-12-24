-- for general lsp
require'lspconfig'.ocamllsp.setup{}
require'lspconfig'.tsserver.setup{}

local saga = require("lspsaga")
saga.init_lsp_saga({
  code_action_icon = ""
})

vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
vim.keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
vim.keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })
vim.keymap.set("n", "<leader>e", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { silent = true })


-- git signs
require'gitsigns'.setup()

-- gruvbox
require("gruvbox").setup{}
vim.cmd("colorscheme gruvbox")


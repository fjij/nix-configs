vim.g.mapleader = " "

-- Windows
vim.keymap.set("n", "<Leader>h", ":wincmd h<CR>")
vim.keymap.set("n", "<leader>j", ":wincmd j<CR>")
vim.keymap.set("n", "<leader>k", ":wincmd k<CR>")
vim.keymap.set("n", "<leader>l", ":wincmd l<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")

-- Tabpages
vim.keymap.set("n", "<leader><S-tab>", ":tabprevious<CR>")
vim.keymap.set("n", "<leader><tab>", ":tabnext<CR>")
vim.keymap.set("n", "<leader>t", ":tabnew<CR>")

-- Misc
vim.keymap.set("n", "Q", "gq")

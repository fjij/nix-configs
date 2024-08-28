local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local opt = vim.opt

-- Show command line when recording macros
autocmd({ "RecordingEnter" }, {
  callback = function()
    opt.cmdheight = 1
  end,
})

autocmd({ "RecordingLeave" }, {
  callback = function()
    opt.cmdheight = 0
  end,
})

-- Set indent size by FileType
local function use_spaces(n)
  return function()
    opt.tabstop = n
    opt.softtabstop = n
    opt.shiftwidth = n
  end
end

local function use_tabs(n)
  return function()
    opt.autoindent = true
    opt.expandtab = false
    opt.tabstop = n
    opt.shiftwidth = n
  end
end

augroup("spacing", {})

autocmd("FileType", {
  group = "spacing",
  pattern = { "python", "c", "cpp", "rust", "sql", "solidity", "fish", "bash", "just" },
  callback = use_spaces(4),
})

autocmd("FileType", {
  group = "spacing",
  pattern = { "javascript", "typescript", "markdown", "lua", "json", "yaml" },
  callback = use_spaces(2),
})

autocmd("FileType", {
  group = "spacing",
  pattern = { "go", "make" },
  callback = use_tabs(4),
})

augroup("writing", {})

autocmd("FileType", {
  group = "writing",
  pattern = { "markdown", "text" },
  callback = function()
    opt.textwidth = 80
    opt.spell = true

    -- Disable the "buffer" cmp source when writing
    local cmp = require("cmp")
    local sources = cmp.get_config().sources
    for i = #sources, 1, -1 do
      if sources[i].name == "buffer" then
        table.remove(sources, i)
      end
    end
    cmp.setup.buffer({ sources = sources })
  end,
})

autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(event)
    local opts = { buffer = event.buf }
    vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
    vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
    vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
    vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
    vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
    vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
    vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
    vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
    vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
    vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
    vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)
  end,
})

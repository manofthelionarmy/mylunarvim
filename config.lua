-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.format_on_save = true
lvim.lint_on_save = true
lvim.colorscheme = "dracula"
lvim.transparent_window = true

-- keymappings
lvim.leader = "\\"
-- overwrite the key-mappings provided by LunarVim for any mode, or leave it empty to keep them
-- lvim.keys.normal_mode = {
--   Page down/up
--   {'[d', '<PageUp>'},
--   {']d', '<PageDown>'},
--
--   Navigate buffers
--   {'<Tab>', ':bnext<CR>'},
--   {'<S-Tab>', ':bprevious<CR>'},
-- }
-- if you just want to augment the existing ones then use the utility function
-- require("utils").add_keymap_insert_mode({ silent = true }, {
-- { "<C-s>", ":w<cr>" },
-- { "<C-c>", "<ESC>" },
-- })
-- you can also use the native vim way directly
-- vim.api.nvim_set_keymap("i", "<C-Space>", "compe#complete()", { noremap = true, silent = true, expr = true })

vim.cmd("nnoremap <silent> sp :echo expand('%:p')<CR>")
vim.cmd("set cursorline")
vim.cmd("set lazyredraw")
vim.cmd("nnoremap <silent> tn :NvimTreeToggle<CR>")
vim.api.nvim_set_keymap("n", "tl", ":lua require('mymodules/lv-searchdir').live_grep()<CR>", {noremap=true, silent=true})
vim.api.nvim_set_keymap("n", "tf", ":lua require('mymodules/lv-searchdir').find_files()<CR>", {noremap=true, silent=true})
vim.api.nvim_set_keymap("n", "tc", ":lua require('mymodules/lv-searchconfigs').search_configs()<CR>", {noremap=true, silent=true})
-- vim.api.nvim_set_keymap("n", "tb", ":Tagbar<CR>", {noremap=true, silent=true})
vim.api.nvim_set_keymap("n", "tb", ":SymbolsOutline<CR>", {noremap=true, silent=true})
vim.api.nvim_set_keymap("n", "F", ":Neoformat<CR>", {noremap=true, silent=true})

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.dashboard.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.side = "left"
lvim.builtin.nvimtree.show_icons.git = 1
lvim.builtin.which_key.active = true
lvim.builtin.treesitter.rainbow.enable = true

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = "maintained"
lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.nvimtree.hide_dotfiles = 0
lvim.builtin.dashboard.custom_header = require("myconfigs/dashboard").my_custom_header

-- generic LSP settings
-- you can set a custom on_attach function that will be used for all the language servers
-- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
lvim.builtin.telescope.on_config_done = function()
  local actions = require "telescope.actions"
  -- for input mode
  lvim.builtin.telescope.defaults.mappings.i["<C-j>"] = actions.move_selection_next
  lvim.builtin.telescope.defaults.mappings.i["<C-k>"] = actions.move_selection_previous
  lvim.builtin.telescope.defaults.mappings.i["<C-n>"] = actions.cycle_history_next
  lvim.builtin.telescope.defaults.mappings.i["<C-p>"] = actions.cycle_history_prev
  -- for normal mode
  lvim.builtin.telescope.defaults.mappings.n["<C-j>"] = actions.move_selection_next
  lvim.builtin.telescope.defaults.mappings.n["<C-k>"] = actions.move_selection_previous
end

lvim.lang.lua.formatter = {} -- We may get some more speed turning this off
lvim.lang.lua.linters = {} -- Live linter is slowing lua down, we should lint on save
lvim.lang.go.formatters = {{exe = "goimports", args = {} }, {exe = "gofmt", args = {}}}
lvim.lang.go.lsp.setup.settings = { gopls = { analyses = { unusedparams = true }, staticcheck = true } }
-- lvim.lang.go.lsp.setup.init_options = { usePlaceholders = true, completeUnimported = true }
lvim.lang.go.lsp.setup.init_options = { completeUnimported = true } -- usePlaceholders is a cool feature, but I'm not gonna use it

-- TODO: keep an eye out for indeterminism
local status_ok, error = pcall(require, "myconfigs/lsp_signature")
if not status_ok then
  print("something went wrong")
  print(error)
else
  lvim.lsp.on_attach_callback = function (client, bufnr)
    -- Load lsp_signature
    local cfg = require("myconfigs/lsp_signature").cfg
    require"lsp_signature".on_attach(cfg)
 end
end
-- The docs says if you specify table.remove with out a postion, you remove the last element
-- The last element is the deprecated use_decoration_api
-- table.remove(lvim.builtin.gitsigns.signs, 44)
-- lvim.builtin.gitsigns.signs

-- lvim.builtin.compe.preselect = "always"
-- lvim.builtin.autopairs.map_cr = true
-- lvim.builtin.autopairs.map_complete = true
lvim.builtin.telescope.defaults.sorting_strategy = "ascending"
lvim.builtin.telescope.defaults.layout_config.prompt_position = "top"
lvim.builtin.telescope.defaults.file_ignore_patterns = {".git/", "node_modules/", "vendor/"}
lvim.builtin.nvimtree.on_config_done = function (nvimtree)
  vim.g.nvim_tree_ignore = { ".git", "node_modules", ".cache", "vendor" }
end
lvim.lang.yaml.lsp.setup.settings = {
    yaml = {
      schemas = { kubernetes = {"*.yaml", "*.yml"}}
    }
  }

-- Additional Plugins

lvim.plugins = {
    {
        "ray-x/lsp_signature.nvim",
        event = "BufEnter",
    },
    {"christoomey/vim-tmux-navigator", event = {"VimEnter"}},
    {"dracula/vim"},
    {"p00f/nvim-ts-rainbow",
      event = "BufEnter",
      after = "nvim-treesitter"
    },
    {"sbdchd/neoformat",
      event="BufRead"
    },
    {"tpope/vim-fugitive",
    event = "BufEnter"},
    {
          "fatih/vim-go",
          run = ":GoInstallBinaries",
          config = function()
              vim.g.go_code_completion_enabled = 0 -- this collides with lsp
              vim.g.go_doc_keywordprg_enabled = 0 -- this collieds with lsp
              vim.g.go_doc_popup_window = 0 -- force this not to pop
              vim.g.go_def_mapping_enabled = 1 -- collides with lsp, FIX: they don't collide, they point to their own servers
              vim.g.go_gopls_enabled = 1 -- ensures we are  using the lsp, and no collison with vim-go
              vim.g.go_gopls_use_placeholders = 0 -- turn this off
              vim.g.go_echo_go_info = 0 -- turn this off, use :help vim-go to see what it does
              vim.g.go_imports_autosave = 0 -- turn this off, lsp supports this feature
              vim.g.go_fmt_autosave = 0 -- turn this off, we can use Neoformat
              -- TODO: set up daemon server both clients (vim-go and lsp can point to)
              -- vim.g.go_gopls_options = {'-remote=unix;/run/user/1000/gopls-75d976-daemon.armando'}
          end,
          tag = "v1.25", -- this is the last stable version of vim-go
          ft = {"go", "gomod"}
    },
    -- {
    --   "majutsushi/tagbar",
    --   event="BufRead",
    -- },
    {
      "simrat39/symbols-outline.nvim",
      event="BufRead"
    },
    {
      "folke/trouble.nvim",
      event="BufRead"
    }
}


vim.opt.number = true
vim.opt.relativenumber = true

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- lvim.autocommands.custom_groups = {
--   { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
-- }
vim.cmd("autocmd BufEnter * silent! lcd %:h")

-- Additional Leader bindings for WhichKey
lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnostics" },
}

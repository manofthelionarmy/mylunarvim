local M = {}
local status_ok, lib = pcall(require, "nvim-tree.lib")
if not status_ok then
  return
end


local getDir = function()
  local node = lib.get_node_at_cursor()
  if node == nil then
    return nil
  end
  local path = node.absolute_path
  return path
end

M.live_grep = function()
  if not require("nvim-tree.view").win_open() then return end
  local dir = getDir()
  if dir == nil then return end
  local opts = {}
  opts.search_dirs={dir}
  opts.prompt_title = '🌲 Nvim Tree Live Grep'
  require("telescope.builtin").live_grep(opts)
end

M.find_files = function ()
  if not require("nvim-tree.view").win_open() then return end
  local dir = getDir()
  if dir == nil then return end
  local opts = {}
  opts.search_dirs={dir}
  opts.path_display = {"absolute"}
  opts.prompt_title = '🌲 Nvim Tree Find Files'
  require("telescope.builtin").find_files(opts)
end

return M

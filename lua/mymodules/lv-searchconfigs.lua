local M = {}
local status_ok, builtin = pcall(require, "telescope.builtin")
if not status_ok then
  return
end

M.search_configs = function()
  local opts = {}
  opts.prompt_title = "🛠  Lvim Configs"
  opts.search_dirs = {"/home/armando/.local/share/lunarvim/lvim"}
  opts.path_display = {"absolute"}
  opts.cwd = "/home/armando/.local/share/lunarvim/lvim"
  opts.find_command = {
      "rg",
      "--hidden",
      "--files",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--no-ignore",
      "--smart-case",
    }
  builtin.find_files(opts)
end

return M

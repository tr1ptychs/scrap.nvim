local M = {}

local win_id = nil
local buf_id = nil
local data_path = vim.fn.stdpath('data')
local scrap_dir = data_path .. '/scrap'
local scrap_file = scrap_dir .. '/pad.txt'
local old_file = data_path .. '/scrap.txt'

-- defaults
local config = {
  border = "rounded",
  q_to_close = true,
  width_coeff = 0.8,
  height_coeff = 0.8,
}

-- where defaults can be overwritten
function M.setup(user_config)
  config = vim.tbl_extend('force', config, user_config or {})

  if vim.fn.is_directory(scrap_dir) == 0 then
    vim.fn.mkdir(scrap_dir, 'p')
  end
end

-- save
function M.save_pad()
  if buf_id and vim.api.nvim_buf_is_valid(buf_id) then
    local lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)
    local file = io.open(scrap_file, 'w')
    if file then
      file:write(table.concat(lines, '\n'))
      file:close()
    end
  end
end

-- load
function M.load_pad()
  if not buf_id or not vim.api.nvim_buf_is_valid(buf_id) then
    buf_id = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(buf_id, 'ScrapPad')
  end

  -- if still on old filepath, keep old file contents and migrate.
  local file = io.open(old_file, 'r')
  if file then
    local content = file:read('*a')
    file:close()
    vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, vim.split(content, '\n'))
    os.remove(old_file)
    M.save_pad()
    return
  end

  -- read file into buffer
  file = io.open(scrap_file, 'r')
  if file then
    local content = file:read('*a')
    file:close()
    vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, vim.split(content, '\n'))
  end
end

-- close
function M.close_pad()
  if win_id and vim.api.nvim_win_is_valid(win_id) then
    vim.api.nvim_win_close(win_id, true)
    win_id = nil
  end
end

-- keymaps
function M.init_keymaps()
  -- keymap for closing with esc
  vim.api.nvim_buf_set_keymap(buf_id, 'n', '<Esc>',
    '<Cmd>lua require("scrap").toggle_pad()<CR>',
    { noremap = true, silent = true })
  -- keymap for closing with q
  if config.q_to_close then
    vim.api.nvim_buf_set_keymap(buf_id, 'n', 'q',
      '<Cmd>lua require("scrap").toggle_pad()<CR>',
      { noremap = true, silent = true })
  end
end

-- open
function M.open_pad()
  M.load_pad()

  -- current editor dimensions
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")

  -- define floating window dimensions
  local win_width = math.floor(width * config.width_coeff)
  local win_height = math.floor(height * config.height_coeff)

  -- window opts
  local opts = {
    title = " Scrap Paper ",
    title_pos = "center",
    style = "minimal",
    relative = "editor",
    border = config.border,
    width = win_width,
    height = win_height,
    row = math.floor((height - win_height) / 2),
    col = math.floor((width - win_width) / 2),
  }

  -- Create the floating window
  win_id = vim.api.nvim_open_win(buf_id, true, opts)

  -- auto save on close
  vim.api.nvim_create_autocmd("BufWinLeave", {
    desc = "Automatically save when using `:q` or similar commands",
    buffer = buf_id,
    callback = function()
      M.save_pad()
    end,
  })

  M.init_keymaps()
end

-- toggle (main)
function M.toggle_pad()
  if win_id and vim.api.nvim_win_is_valid(win_id) then
    M.close_pad()
  else
    M.open_pad()
  end
end

return M

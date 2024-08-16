local scrap = require('scrap')

vim.api.nvim_create_user_command('ScrapToggle', scrap.toggle_pad, {})

vim.cmd[[
if has('nvim')
    autocmd TermOpen term://* startinsert
endif
]]
vim.keymap.set('n', '<leader>dj', "<cmd>lua require('django').Create_Project()<CR>")
vim.keymap.set('n', '<leader>rs', "<cmd>lua require('django').Run_Server()<CR>")
vim.keymap.set('n', '<leader>ds', "<cmd>lua require('django').Start_Shell()<CR>")
vim.keymap.set('n', '<leader>mm', "<cmd>lua require('django').Makemigrations()<CR>")
vim.keymap.set('n', '<leader>mr', "<cmd>lua require('django').Migrate()<CR>")
vim.keymap.set('n', '<leader>sa', "<cmd>lua require('django').Start_App()<CR>")

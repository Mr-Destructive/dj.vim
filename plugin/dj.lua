vim.cmd[[
if has('nvim')
    autocmd TermOpen term://* startinsert
endif
]]
vim.keymap.set('n', '<leader>pr', "<cmd>lua require('django').Create_Project()<CR>")
vim.keymap.set('n', '<leader>rs', "<cmd>lua require('django').Run_Server()<CR>")
vim.keymap.set('n', '<leader>sh', "<cmd>lua require('django').Start_Shell()<CR>")
vim.keymap.set('n', '<leader>mm', "<cmd>lua require('django').Makemigrations()<CR>")
vim.keymap.set('n', '<leader>mg', "<cmd>lua require('django').Migrate()<CR>")
vim.keymap.set('n', '<leader>ap', "<cmd>lua require('django').Start_App()<CR>")
vim.keymap.set('n', '<leader>su', "<cmd>lua require('django').CreateSuperUser()<CR>")
vim.keymap.set('n', '<leader>tm', "<cmd>lua require('django').StartTerminal()<CR>")
vim.keymap.set('n', '<leader>cs', "<cmd>lua require('django').RunCustomCommand()<CR>")
vim.keymap.set('n', '<leader>db', "<cmd>lua require('django').RunPGCLI()<CR>")

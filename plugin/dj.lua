vim.cmd[[
if has('nvim')
    autocmd TermOpen term://* startinsert
endif
]]
vim.keymap.set('n', '<leader>dj', "<cmd>lua require('django').Create_Project()<CR>")
vim.keymap.set('n', '<leader>rs', "<cmd>lua require('django').Run_Server()<CR>")

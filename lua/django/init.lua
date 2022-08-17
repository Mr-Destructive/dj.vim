local M = {}

local function Venv_Config()
    local venv = "env"

    if os.rename('venv', 'venv') then
        local venv = "venv"
    elseif os.rename(".venv", ".venv") then
        local venv = ".venv"
    elseif os.rename("env", "env") then
        local venv = "env"
    elseif os.rename(".env", ".env")then
        local venv = ".env"
    end

    local vpath = "/bin/"
    if vim.fn.has("win32") == 1 then 
        local vpath = "\\Scripts\\"
    elseif vim.fn.has("macunix") or vim.fn.has("unix") then
        local vpath = "/bin/"
    end

    vim.cmd('!pip install django')
    return {venv, vpath}
end

function M.Create_Project()
    local venv = ".venv"
    local project_name = vim.fn.input("Project name: ")
    vim.cmd("!cd " .. project_name)
    Venv_Config()
    vim.cmd("term django-admin startproject "..project_name)
end

return M

--[[
function! Runserver()
    let x = Venv_Config()
    let venv = x[0]
    let vpath = x[1]
    execute ":term ".venv.vpath."python manage.py runserver"
endfunction

function! Make_Migrations()
    let x = Venv_Config()
    let venv = x[0]
    let vpath = x[1]
    execute ":term ".venv.vpath."python manage.py makemigrations"
endfunction

function! Migrate()
    let x = Venv_Config()
    let venv = x[0]
    let vpath = x[1]
    execute ":term ".venv.vpath."python manage.py migrate"
endfunction

function! Add_App(name)
    execute ":e **\\settings.py | %s/APPS = \\[/APPS = \\[\r    ".a:name.",/g | :w"
endfunction

function! Create_app()
    let name = input("Enter the app's name: ")
    let x = Venv_Config()
    let venv = x[0]
    let vpath = x[1]
    execute ":term ".venv.vpath."python manage.py startapp ".name
    let name = "\"".name."\""
    call Add_App(name)
endfunction

function! Run_Shell()
    let x = Venv_Config()
    let venv = x[0]
    let vpath = x[1]
    execute ":term ".venv.vpath."python manage.py shell"
endfunction

function! Edit_Settings()
    execute ":e **\\settings.py"
endfunction


nnoremap <leader>dj :call Create_Project()<CR>
nnoremap <leader>app :call Create_app()<CR>
nnoremap <leader>esg :call Edit_Settings()<CR>
nnoremap <leader>rs :call Runserver()<CR>
nnoremap <leader>mm :call Make_Migrations()<CR>
nnoremap <leader>mg :call Migrate()<CR>
--]]

function! Create_Project()
    let venv = ".venv"
    let project_name = input("Enter the project name: ")
    exe ":term django-admin startproject ".project_name." ."
endfunction

function! Venv_Config()
    let venv = "env"
    if isdirectory("venv") == 1
        let venv = "venv"
    elseif isdirectory(".venv") == 1
        let venv = ".venv"
    elseif isdirectory("env") == 1
        let venv = "env"
    elseif isdirectory(".env") == 1
        let venv = ".env"
    endif

    let vpath = "/bin/"
    if has("win32") == 1
        let vpath = "\\Scripts\\"
    elseif has("macunix") == 1 || has("unix") == 1
        let vpath = "/bin/"
    endif 
    return [venv, vpath]
endfunction

function! Run_Command(command)
    let command = a:command
    if a:command == ""
        let command= input("Enter the command : ")
    endif
    let x = Venv_Config()
    let venv = x[0]
    let vpath = x[1]
    execute ":term ".venv.vpath."python manage.py ".command
endfunction

function! Runserver()
    call Run_Command("runserver")
endfunction

function! Make_Migrations()
    call Run_Command("makemigrations")
endfunction

function! Migrate()
    call Run_Command("migrate")
endfunction

function! Add_App(name)
    execute ":e **\\settings.py | %s/APPS = \\[/APPS = \\[\r    ".a:name.",/g | :w"
endfunction

function! Start_App()
    let name = input("Enter the app's name: ")
    let x = Venv_Config()
    let venv = x[0]
    let vpath = x[1]
    execute ":term ".venv.vpath."python manage.py startapp ".name
    let name = "\"".name."\""
    call Add_App(name)
endfunction

function! Run_Shell()
    call Run_Command("shell")
endfunction

function! Start_Terminal()
    let x = Venv_Config()
    let venv = x[0]
    let vpath = x[1]
    execute ":term ".venv.vpath
endfunction


function! Edit_Settings()
    execute ":e **\\settings.py"
endfunction

function! Run_Custom_Command(command)
    let command = a:command
    if a:command == ""
        let command= input("Enter the command : ")
    endif
    let x = Venv_Config()
    let venv = x[0]
    let vpath = x[1]
    execute ":term ".venv.vpath.command
endfunction

function! RunPGCLI(command)
    let db_string = input("Enter the db string: ")
    call Run_Custom_Command("pipx run pgcli " .. db_string)
end

nnoremap <leader>dj :call Create_Project()<CR>
nnoremap <leader>app :call Start_App()<CR>
nnoremap <leader>esg :call Edit_Settings()<CR>
nnoremap <leader>rs :call Runserver()<CR>
nnoremap <leader>mm :call Make_Migrations()<CR>
nnoremap <leader>mg :call Migrate()<CR>
nnoremap <leader>st :call Start_Terminal()<CR>
nnoremap <leader>rc :call Run_Command("")<CR>
nnoremap <leader>db :call RunPGCLI()<CR>

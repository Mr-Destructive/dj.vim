function Venv_Config()
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

    let vpath = "bin\\"
    if has("win32") == 1
        let vpath = "Scripts\\"
    elseif has("macunix") == 1 || has("unix") == 1
        let vpath = "bin/activate.sh"
    endif 
    return [venv, vpath]
endfunction

function! Runserver()
    let x = Venv_Config()
    let venv = x[0]
    let vpath = x[1]
    execute ":term ".venv."\\".vpath."python manage.py runserver"
endfunction

function! Make_Migrations()
    let x = Venv_Config()
    let venv = x[0]
    let vpath = x[1]
    execute ":term ".venv."\\".vpath."python manage.py makemigrations"
endfunction

function! Migrate()
    let x = Venv_Config()
    let venv = x[0]
    let vpath = x[1]
    execute ":term ".venv."\\".vpath."python manage.py migrate"
endfunction

function! Add_App(name)
    execute ":e **\\settings.py | %s/APPS = \\[/APPS = \\[\r    ".a:name.",/g | :w"
endfunction

function! Create_app()
    let name = input("Enter the app's name: ")
    let x = Venv_Config()
    let venv = x[0]
    let vpath = x[1]
    execute ":term ".venv."\\".vpath."python manage.py startapp ".name
    let name = "\"".name."\""
    call Add_App(name)
endfunction

function! Run_Shell()
    let x = Venv_Config()
    let venv = x[0]
    let vpath = x[1]
    execute ":term ".venv."\\".vpath."python manage.py shell"
endfunction

nnoremap <leader>rs :call Runserver()<CR>
nnoremap <leader>mm :call Make_Migrations()<CR>
nnoremap <leader>mg :call Migrate()<CR>
nnoremap <leader>app :call Create_app()<CR>

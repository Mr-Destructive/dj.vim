local M = {}

local _config = {
  command = nil, 
  layout = 'center',
  width = 0.8,
  height = 0.0,
  row = 0,
  col = 0,
  win_api = { style = 'minimal', relative = 'editor' },
  keymaps = { exit = '<A-q>', normal = '<A-n>' },
  name = 'fterm',
  bg_color = nil, 
  border_hl = nil,
}

-- detect the operating system and set the virtualenv path
local function Detect_OS()
  local vpath = "/bin/"
  if vim.fn.has("win32") then 
      local vpath = "\\Scripts\\"
  elseif vim.fn.has("macunix") or vim.fn.has("unix") then
      local vpath = "/bin/"
  end
  return vpath .. "activate"
end


-- detect the virtual environment folder name
local function Venv_Config()
    local venv = ".venv"

    if os.rename('venv', 'venv') then
        local venv = "venv"
    elseif os.rename(".venv", ".venv") then
        local venv = ".venv"
    elseif os.rename("env", "env") then
        local venv = "env"
    elseif os.rename(".env", ".env")then
        local venv = ".env"
    end

    local vpath = Detect_OS()
    return {venv=venv, vpath=vpath}
end

-- activate the virtual environment with given parameters of venv path
local function Activate_Venv()
  local list = Venv_Config()
  local venv = list.venv
  local vpath = list.vpath
  local activate_cmd = ""
  if vim.fn.has("win32") == 1 then 
    activate_cmd = "!.\\" .. venv .. vpath
  elseif vim.fn.has("unix") == 1 or vim.fn.has("macunix") == 1 then
    activate_cmd = "source " .. venv .. vpath .. " "
  end
  return activate_cmd
end

-- Create a virtual environment
local function Create_Venv()
  return "python3 -m venv .venv"
end

-- split opne terminal and parse commands
local function configure_term(command)
  ui = vim.api.nvim_list_uis()[1]
  local config = vim.tbl_deep_extend(
      'force',
      vim.deepcopy(_config),
      config or {}
    )
  local term = { on_exit = config.on_exit }
  term.buffer = vim.api.nvim_create_buf(true, false)
  --local win = vim.api.nvim_open_win(term.buffer, true, window_config(width, height))
  vim.cmd('split')
  vim.api.nvim_command("terminal")
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_win_set_height(win, 10.0)
  vim.cmd(vim.api.nvim_replace_termcodes('normal <C-w>r', true, true, true)) 
  vim.api.nvim_win_set_buf(win, buf)
  local activate_cmd = Activate_Venv()
  if not activate_cmd == nil then
      config.command = activate_cmd .. command
  else
      config.command = command
  end
  local run_command = config.command
  vim.fn.termopen(run_command or { vim.opt.shell:get() }, config)
end

local function RunCommand(command)
  local activate_cmd = Activate_Venv()
  local command = command
  if not command then
    command = vim.fn.input("Command name: ") 
  end
  configure_term(activate_cmd .. " && python manage.py " .. command) 
end

-- Create a project with name as input from user
function M.Create_Project()
  local venv = ".venv"
  local project_name = vim.fn.input("Project name: ")
  Venv_Config()
  if not Venv_Config() then
    Create_Venv()
  end
  activate_cmd = Activate_Venv()
  create_cmd = Create_Venv()
  configure_term("mkdir " .. project_name .. " && cd " .. project_name .. " && " .. create_cmd ..  " && " .. activate_cmd .. " && pip install django" .. " && django-admin startproject "..project_name .. " . ")
end

-- Run the runserver command for a django project
function M.Run_Server()
  Venv_Config()
  if not Venv_Config() then
    Create_Venv()
  end
  local cmd = "runserver"
  RunCommand(cmd)
end

-- Run the shell command for a django project
function M.Start_Shell()
  local cmd = "shell"
  RunCommand(cmd)
end

-- Run the makemigrations command for a django project
function M.Makemigrations()
  local cmd = "makemigrations"
  RunCommand(cmd)
end

-- Run the migrate command for a django project
function M.Migrate()
  local cmd = "migrate"
  RunCommand(cmd)
end

-- Run the startapp command for a django project with name from user input
function M.Start_App()
  local app_name = vim.fn.input("App name: ")
  local cmd = "startapp " .. app_name
  RunCommand(cmd)
end

-- Run the collectstatic command for a django project
function M.Collectstatic()
  local cmd = "collectstatic"
  RunCommand(cmd)
end

-- Run the createsuperuser command for a djagno project
function M.CreateSuperUser()
  local cmd = "createsuperuser"
  RunCommand(cmd)
end

-- Utility for a simple terminal split with venv activated
function M.StartTerminal()
    configure_term()
end

function M.RunCustomCommand(command)
    RunCommand(command)
end

function M.RunPGCLI(command)
    local db_string = vim.fn.input("Enter the DB URI: ")
    configure_term("pipx run pgcli " .. db_string)
end

function M.PipInstall()
    local package = vim.fn.input("Enter the package name: ")
    configure_term("pip install " .. package)
end

return M

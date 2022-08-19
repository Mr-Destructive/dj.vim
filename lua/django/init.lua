local M = {}

local function Detect_OS()
  local vpath = "/bin/"
  if vim.fn.has("win32") then 
      local vpath = "\\Scripts\\"
  elseif vim.fn.has("macunix") or vim.fn.has("unix") then
      local vpath = "/bin/"
  end
  return vpath .. "activate"
end


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

local function Activate_Venv()

  local list = Venv_Config()
  local venv = list.venv
  local vpath = list.vpath
  local activate_cmd = ""
  if vim.fn.has("win32") == 1 then 
    activate_cmd = "!.\\" .. venv .. vpath
  elseif vim.fn.has("unix") == 1 or vim.fn.has("macunix") == 1 then
    activate_cmd = "source " .. venv .. vpath
  end
  return activate_cmd

end
local function Create_Venv()
  return "python3 -m venv .venv"
end

function M.Create_Project()
    local venv = ".venv"
    local project_name = vim.fn.input("Project name: ")
    Venv_Config()
    if not Venv_Config() then
      Create_Venv()
    end
    activate_cmd = Activate_Venv()
    create_cmd = Create_Venv()
    vim.cmd("term mkdir " .. project_name .. " && cd " .. project_name .. " && " .. create_cmd ..  " && " .. activate_cmd .. " && pip install django" .. " && django-admin startproject "..project_name .. " . ")
end

function M.Run_Server()
  Venv_Config()
  if not Venv_Config() then
    Create_Venv()
  end
  local activate_cmd = Activate_Venv()
  vim.cmd("term " .. activate_cmd .. " && python manage.py runserver")
end

function M.Start_Shell()
  local activate_cmd = Activate_Venv()
  vim.cmd("term " .. activate_cmd .. "&& python manage.py shell")
end

function M.Makemigrations()
  local activate_cmd = Activate_Venv()
  vim.cmd("term " .. activate_cmd .. "&& python manage.py makemigrations")
end

function M.Migrate()
  local activate_cmd = Activate_Venv()
  vim.cmd("term " .. activate_cmd .. "&& python manage.py migrate")
end

function M.Start_App()
  local activate_cmd = Activate_Venv()
  local app_name = vim.fn.input("App name: ")
  vim.cmd("term " .. activate_cmd .. "&& python manage.py startapp " .. app_name)
end

return M

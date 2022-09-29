local M = {}

local _config = {
  command = nil, 
  layout = 'center',
  width = 0.8,
  height = 0.8,
  row = 0,
  col = 0,
  win_api = { style = 'minimal', relative = 'editor' },
  keymaps = { exit = '<A-q>', normal = '<A-n>' },
  name = 'fterm',
  bg_color = nil, 
  border_hl = nil,
}

local function window_config(width, height)
  if vim.api.nvim_call_function('has', {'nvim-0.5.0'}) == 1 then
    local border = vim.g.workbench_border or "double"
    return {
      relative = "editor",
      width = width,
      height = height,
      col = (ui.width - width) / 2,
      row = (ui.height - height) / 2,
      style = 'minimal',
      focusable = true,
      border = border
    }
  else
    return {
      relative = "editor",
      width = width,
      height = height,
      col = (ui.width - width) / 2,
      row = (ui.height - height) / 2,
      style = 'minimal',
      focusable = true,
    }
  end
end

local function configure_term(command)
  ui = vim.api.nvim_list_uis()[1]
  local width = math.floor((ui.width * 0.5)+ .5)
  local height = math.floor((ui.height * 0.5) + 5)
  local config = vim.tbl_deep_extend(
      'force',
      vim.deepcopy(_config),
      config or {}
    )
  local term = { on_exit = config.on_exit }
  term.buffer = vim.api.nvim_create_buf(true, false)
  --local win = vim.api.nvim_open_win(term.buffer, true, window_config(width, height))
  --local win = vim.api.nvim_open_win(term.buffer, true, window_config(width, height))
  vim.cmd('split')
  vim.api.nvim_command("terminal")
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_win_set_buf(win, buf)
  config.command = command
  run_command = command
  vim.fn.termopen(run_command or { vim.opt.shell:get() }, config)
end

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
  configure_term("mkdir " .. project_name .. " && cd " .. project_name .. " && " .. create_cmd ..  " && " .. activate_cmd .. " && pip install django" .. " && django-admin startproject "..project_name .. " . ")
  --vim.cmd("term mkdir " .. project_name .. " && cd " .. project_name .. " && " .. create_cmd ..  " && " .. activate_cmd .. " && pip install django" .. " && django-admin startproject "..project_name .. " . ")
end

function M.Run_Server()
  Venv_Config()
  if not Venv_Config() then
    Create_Venv()
  end
  local activate_cmd = Activate_Venv()
  configure_term(activate_cmd .. "&& python manage.py runserver")
  --vim.cmd("term " .. activate_cmd .. " && python manage.py runserver")
end

function M.Start_Shell()
  local activate_cmd = Activate_Venv()
  configure_term(activate_cmd .. "&& python manage.py shell")
  --vim.cmd("term " .. activate_cmd .. "&& python manage.py shell")
end

function M.Makemigrations()
  local activate_cmd = Activate_Venv()
  configure_term(activate_cmd .. "&& python manage.py makemigrations")
  --vim.cmd("term " .. activate_cmd .. "&& python manage.py makemigrations")
end

function M.Migrate()
  local activate_cmd = Activate_Venv()
  configure_term(activate_cmd .. "&& python manage.py migrate")
  --vim.cmd("term " .. activate_cmd .. "&& python manage.py migrate")
end

function M.Start_App()
  local activate_cmd = Activate_Venv()
  local app_name = vim.fn.input("App name: ")
  configure_term(activate_cmd .. "&& python manage.py startapp" .. app_name)
  --vim.cmd("term " .. activate_cmd .. "&& python manage.py startapp " .. app_name)
end

function M.Collectstatic()
  local activate_cmd = Activate_Venv()
  configure_term(activate_cmd .. "&& python manage.py collectstatic")
  --vim.cmd("term " .. activate_cmd .. "&& python manage.py collectstatic")
end

function M.CreateSuperUser()
  local activate_cmd = Activate_Venv()
  configure_term(activate_cmd .. "&& python manage.py createsuperuser")
  --vim.cmd("term " .. activate_cmd .. "&& python manage.py createsuperuser")
end

return M

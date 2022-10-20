## DJ.vim

DJ.vim is a vim plugin for making development process of django projects eassier in vim. It can run management commands, run server, etc. from the vim integrated terminal. 

## Features

- Automatically detect virtual environment / create a default environment if not present.
- Run server inside the integrated terminal in vim.
- Run management commands such as migrations, starting apps, projects, django shell, etc.

## Setup

Inside of the Lua setup for `Packer` add the plugin as follows:

```lua
use 'mr-destructive/dj.vim'
```

For custom keymappings use the below format:

```vim
nnoremap yourkeys :lua require("django").FUNCTION_NAME
```

## Default keymaps

- <leader>pr -> `Create_Project()`
- <leader>rs -> `Run_Server()`
- <leader>sh -> `Start_Shell()`
- <leader>mm -> `Makemigrations()`
- <leader>mg -> `Migrate()`
- <leader>ap -> `Start_App()`
- <leader>su -> `CreateSuperUser()`
- <leader>tm -> `StartTerminal()`
- <leader>cs -> `RunCustomCommand()`

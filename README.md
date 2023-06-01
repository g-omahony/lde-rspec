# lde-rspec

## Description
`lde-rspec` is a Neovim plugin that allows users to select a containerised service from a list.

You can then run rspec tests in the service container. Options are run the nearest spec to the cursor in the spec buffer. Run the entire spec or run all specs in the folder the current spec is in.

The chosen service is saved in a JSON configuration file so doesn't need to be selected every time.

## Installation
Use your preferred package manager to install the plugin. For example, with vim-plug:

```vim
Plug 'g-omahony/lde-rspec'
```

Using the lazy plugin manager, add:
```lua
return { 'g-omahony/lde-rspec' }
```

to `lde-rspec.lua` in your plugins folder

## Usage
```vim
:lua require('lde-rspec').select_service()
```
will allow you to select the service from the popup menu

it can be mapped to a key like so:
```vim
vim.keymap.set(
  "n",
  "<leader>rs",
  "<CMD>:lua require('lde-rspec').select_service()<CR>",
  { noremap = true, silent = true, desc = "Set the test service" }
)
```

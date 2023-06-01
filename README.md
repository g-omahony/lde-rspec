# lde-rspec

## Description
lde-rspec is a Neovim plugin that allows users to select a containerised service from a list and update the `service` variable in a JSON configuration file.
You can then run rspec tests in the service container. Options are run the nearest spec to the cursor in the spec buffer. Run the entire spec or run all specs in the folder the current spec is in.

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

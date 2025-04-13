# wes.nvim

A Neovim plugin that lets you switch colorschemes as easily as changing your clothes for the weather.


## Features
- Store your selected colorscheme automatically
- Switch between colorschemes with a single command

## Installation

Using lazy.nvim:

```lua
{
    'OwLu0905/wes.nvim',
    dependencies = {},
    config = function()
      require("wes").setup {
        telescope_bind = true,
      }
    end,
}
```

## Usage

`:WesPick` - pick colorscheme as default

```
:WesPick tokyonight
```
Your selection will be automatically saved and persisted. 

## Customization

### Telescope setup structure

`:WesThemes` - open telescope colorschemes to save and persist your selection

```lua 
require("wes").setup {
    telescope_bind = true,
}
```

```vim
vim.keymap.set("n", "<leader>cc", ":WesThemes<CR>", { desc = "Open Wes color theme picker" })
```


## License
MIT

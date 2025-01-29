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
```lua 
require("wes").setup {
    telescope_bind = true,
}
```

```vim
local builtin = require('telescope.builtin')
vim.keymap.set("n", "<leader>cc", function()
  builtin.colorscheme({
    enable_preview = true,
  })
end, { desc = "Pick colorscheme" })
```


## License
MIT

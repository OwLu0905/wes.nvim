# wes.nvim

A Neovim plugin that lets you switch colorschemes as easily as changing your clothes for the weather.


## Features
- Store your selected colorscheme automatically
- Switch between colorschemes with a single command

## Installation

Using lazy.nvim:

```lua
{
    'Owlu0905/wes.nvim',
    dependencies = {},
    config = function()
      require("wes").setup {}
    end,
}
```

## Usage

`:WesPick` - pick colorscheme as default
```
:WesPick tokyonight
```
Your selection will be automatically saved and persisted. 

## License
MIT

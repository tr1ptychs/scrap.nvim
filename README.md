# scrap.nvim

## What it do
Creates a piece of "scrap paper" for ideas, notes, your grocery list, or whatever.

Use a new keymap to pull out your scrap paper as you please.

You also can use Esc in normal mode to close the window when it's open.

Closing the floating window saves it automatically, and will persist across sessions. no need to `:w`.

## Setup
Use the package manager of your choice. Just set a keymap for toggling the window using the command `:ScrapToggle` for example:
### lazy.nvim
```lua
{
  'tr1ptychs/scrap.nvim',
  config = function ()
    vim.keymap.set('n', '<leader>ts', '<Cmd>:ScrapToggle<Cr>', {})
  end
}
```

## FYI
- This was created in an afternoon by a noob (me). 
- This is my first nvim plugin.
- This is currently in an 'unfinished' state.
- Do with this information what you will, use at your own risk.

## Todo:
- Make the window prettier
- Make ability to undo through previous sessions' changes

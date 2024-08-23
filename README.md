# scrap.nvim

## What it do
Creates a piece of "scrap paper" for ideas, notes, your grocery list, or whatever.

Use a new keymap to pull out your scrap paper as you please.

You also can use Esc in normal mode to close the window when it's open.

Closing the floating window saves it automatically, and contents will persist across sessions. no need to `:w`.

## Setup
Use the package manager of your choice. Just set a keymap for toggling the window using the command `:ScrapToggle`. for example:

### [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
  'tr1ptychs/scrap.nvim',
  config = function ()
    -- optional line. override configurations defaults using this.
    require('scrap').setup({})

    -- set a keymap as you want.
    vim.keymap.set('n', '<leader>ts', '<Cmd>ScrapToggle<Cr>', {})
  end
}
```

## Configuration
Here is an example for overriding configuration defaults.

```lua
-- ...
require('scrap').setup({
  border = "double",   -- default: "rounded", change window border.
  q_to_close = false,  -- default: true, turn off closing the window on q.
  width_coeff = 0.5,   -- default: 0.8, proportion of your scrap paper width to editor width.
  height_coeff = 0.9,  -- default: 0.8, same as above, but for height
})
-- ...
```

## FYI
- This was created in a few afternoons by a noob (me) (it's probably buggy). 
- This is my first nvim plugin. :)
- This is currently in a state I would describe as "less than finished".
- Do with this information what you will, use at your own risk.

## Todo:
- Enable ability to undo through previous sessions' changes.

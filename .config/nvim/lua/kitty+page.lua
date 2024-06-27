return function(INPUT_LINE_NUMBER, CURSOR_LINE, CURSOR_COLUMN)
  print('kitty sent:', INPUT_LINE_NUMBER, CURSOR_LINE, CURSOR_COLUMN)

  local function setOptions()
    vim.opt.encoding = 'utf-8'
    vim.opt.clipboard = 'unnamedplus'
    vim.opt.compatible = false
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.opt.termguicolors = true
    vim.opt.showmode = false
    vim.opt.ruler = false
    vim.opt.laststatus = 0
    vim.o.cmdheight = 0
    vim.opt.showcmd = false
    vim.opt.scrollback = INPUT_LINE_NUMBER + CURSOR_LINE
  end

  local function setColors()
    -- Define the background color
    vim.cmd('highlight Normal guibg=#040305')
  end

  -- Use pcall to execute setOptions and catch any errors
  local success, errorMessage = pcall(setOptions)

  -- If an error occurred, substitute INPUT_LINE_NUMBER, CURSOR_LINE, CURSOR_COLUMN with 0,0,0
  if not success then
    -- print("Error setting options:", errorMessage)
    INPUT_LINE_NUMBER, CURSOR_LINE, CURSOR_COLUMN = 0, 0, 0
  end

  -- Set the colors
  setColors()

  local term_buf = vim.api.nvim_create_buf(true, false);
  local term_io = vim.api.nvim_open_term(term_buf, {})
  vim.api.nvim_buf_set_keymap(term_buf, 'n', 'i', '<Cmd>q<CR>', { })
  vim.api.nvim_buf_set_keymap(term_buf, 'n', 'q', '<Nop>', { })

  local group = vim.api.nvim_create_augroup('kitty+page', {})

  local setCursor = function()
    vim.api.nvim_feedkeys(tostring(INPUT_LINE_NUMBER) .. [[ggzt]], 'n', true)
    local line = vim.api.nvim_buf_line_count(term_buf)
    if (CURSOR_LINE <= line) then
      line = CURSOR_LINE
    end
    vim.api.nvim_feedkeys(tostring(line - 1) .. [[j]], 'n', true)
    vim.api.nvim_feedkeys([[0]], 'n', true)
    vim.api.nvim_feedkeys(tostring(CURSOR_COLUMN - 1) .. [[l]], 'n', true)
  end

  vim.api.nvim_create_autocmd('ModeChanged', {
    group = group,
    buffer = term_buf,
    callback = function()
      local mode = vim.fn.mode()
      if mode == 't' then
        vim.cmd.stopinsert()
      end
    end,
  })

  vim.api.nvim_create_autocmd('VimEnter', {
    group = group,
    pattern = '*',
    once = true,
    callback = function(ev)
        local current_win = vim.fn.win_getid()
        for _, line in ipairs(vim.api.nvim_buf_get_lines(ev.buf, 0, -2, false)) do
          vim.api.nvim_chan_send(term_io, line)
          vim.api.nvim_chan_send(term_io, '\r\n')
        end
        for _, line in ipairs(vim.api.nvim_buf_get_lines(ev.buf, -2, -1, false)) do
          vim.api.nvim_chan_send(term_io, line)
        end
        vim.api.nvim_win_set_buf(current_win, term_buf)
        vim.api.nvim_buf_delete(ev.buf, { force = true } )
        vim.schedule(setCursor)
    end
  })
end

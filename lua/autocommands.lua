local function augroup(name)
  return vim.api.nvim_create_augroup("autocmd_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].autocmd_last_loc then
      return
    end
    vim.b[buf].autocmd_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- wrap in text filetypes
vim.api.nvim_create_augroup("wrap", { clear = true })
vim.api.nvim_create_augroup("spell", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap"),
  pattern = { "gitcommit", "markdown", "snacks_notif_history", "trouble" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
}) 

-- check for spelling in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Turn off relative line numbers when insert is left
local numtogGrp = vim.api.nvim_create_augroup("NumberToggle", { clear = true })
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  pattern = "*",
  callback = function()
    vim.wo.relativenumber = true
  end,

  group = numtogGrp,
  desc = "Turn off relative line numbers when insert is left",
})

-- Turn off relative line numbering when insert is entered
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  pattern = "*",
  callback = function()
    local ignore = { "oil", "fzf" }
    if ignore[vim.bo.filetype] then
      return
    end
    vim.wo.relativenumber = false
  end,
  group = numtogGrp,
  desc = "Turn off relative line numbering when insert is entered",
})


-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- last line, last position when entering buffer
local group = vim.api.nvim_create_augroup("RestoreCursor", { clear = true })
vim.api.nvim_create_autocmd("BufReadPre", {
  group = group,
  callback = function(args)
    vim.api.nvim_create_autocmd("FileType", {
      buffer = args.buf,
      once = true,
      callback = function()
        local ft = vim.bo[args.buf].filetype
        local last_pos = vim.api.nvim_buf_get_mark(args.buf, '"')[1]
        local last_line = vim.api.nvim_buf_line_count(args.buf)
        if
          last_pos >= 1
          and last_pos <= last_line
          and not ft:match("commit")
          and not vim.tbl_contains({ "gitrebase", "nofile", "svn", "gitcommit" }, ft)
        then
          vim.api.nvim_win_set_cursor(0, { last_pos, 0 })
        end
      end,
    })
  end,
})
--

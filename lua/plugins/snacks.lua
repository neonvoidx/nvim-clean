local snacks = require("snacks")
snacks.setup({
  animate = { enabled = true },
  bigfile = { enabled = true },
  dim = { enabled = true },
  scope = { enabled = true },
  rename = { enabled = true },
  git = { enabled = false },
  notifier = { enabled = true, timeout = 3000 },
  image = {
    resolve = function(path, src)
      local ok, obsidian_api = pcall(require, "obsidian.api")
      if ok then
        if obsidian_api.path_is_note(path) then
          return obsidian_api.resolve_image_path(src)
        end
      end
    end,
  },
  quickfile = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = {
    enable = true,
    left = { "sign" },
    right = { "fold", "git", "mark" },
    folds = {
      open = false,
      git_hl = true,
    },
  },
  indent = {
    enabled = true,
    hl = {
      "SnacksIndent1",
      "SnacksIndent2",
      "SnacksIndent3",
      "SnacksIndent4",
      "SnacksIndent5",
      "SnacksIndent6",
      "SnacksIndent7",
      "SnacksIndent8",
    },
  },
  input = { enabled = true },
  lazygit = { enabled = true },
  picker = {
    layout = {
      layout = {
        backdrop = false,
        width = 0.80,
        min_width = 80,
        height = 0.80,
        min_height = 30,
        box = "vertical",
        border = true,
        title = "{title} {live} {flags}",
        title_pos = "center",
        { win = "input", height = 1, border = "bottom" },
        { win = "list", border = "none", height = 0.4, wo = { wrap = true } },
        { win = "preview", title = "{preview}", height = 0.6, border = "top" },
      },
    },
    enabled = true,
    actions = {
      qflist_append = function(picker)
        picker:close()
        local sel = picker:selected()
        local items = #sel > 0 and sel or picker:items()
        local qf = {} ---@type vim.quickfix.entry[]
        for _, item in ipairs(items) do
          qf[#qf + 1] = {
            filename = Snacks.picker.util.path(item),
            bufnr = item.buf,
            lnum = item.pos and item.pos[1] or 1,
            col = item.pos and item.pos[2] + 1 or 1,
            end_lnum = item.end_pos and item.end_pos[1] or nil,
            end_col = item.end_pos and item.end_pos[2] + 1 or nil,
            text = item.line or item.comment or item.label or item.name or item.detail or item.text,
            pattern = item.search,
            valid = true,
          }
        end
        vim.fn.setqflist(qf, "a")
        vim.cmd("botright copen")
      end,
    },
    win = {
      input = {
        keys = {
          ["<c-q>"] = { "qflist_append", mode = { "n", "i" } },
        },
      },
    },
  },
  dashboard = {
    enabled = true,
    preset = {
      header = [[
                                                        ░██                

            ░████████   ░███████   ░███████  ░██    ░██ ░██░█████████████  
            ░██    ░██ ░██    ░██ ░██    ░██ ░██    ░██ ░██░██   ░██   ░██ 
            ░██    ░██ ░█████████ ░██    ░██  ░██  ░██  ░██░██   ░██   ░██ 
            ░██    ░██ ░██        ░██    ░██   ░██░██   ░██░██   ░██   ░██ 
            ░██    ░██  ░███████   ░███████     ░███    ░██░██   ░██   ░██ 
]],
      keys = {
        {
          icon = " ",
          key = "f",
          desc = "find file",
          action = function()
            Snacks.picker.file({ cwd = vim.uv.cwd() })
          end,
        },
        {
          icon = " ",
          key = "n",
          desc = "new file",
          action = function()
            vim.cmd("enew")
          end,
        },
        {
          icon = " ",
          key = "/",
          desc = "grep",
          action = function()
            Snacks.picker.grep()
          end,
        },
        {
          icon = "󰋚 ",
          key = "r",
          desc = "recent files",
          action = function()
            Snacks.picker.recent({ filter = { cwd = true } })
          end,
        },
      },
    },
    sections = {
      {
        section = "header",
      },
      { section = "keys", gap = 1, padding = 1 },
      {
        pane = 2,
        icon = " ",
        title = "Recent Files",
        section = "recent_files",
        indent = 2,
        padding = 2,
        cwd = true,
        limit = 5,
      },
      -- { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
      {
        pane = 2,
        icon = " ",
        title = "Git Status",
        section = "terminal",
        enabled = function()
          return Snacks.git.get_root() ~= nil
        end,
        cmd = "git status --short --branch --renames",
        height = 5,
        padding = 1,
        ttl = 5 * 60,
        indent = 3,
      },
      function()
        local in_git = Snacks.git.get_root() ~= nil
        local cmds = {
          {
            icon = " ",
            title = "Git Status",
            cmd = "git --no-pager diff --stat -B -M -C",
            height = 10,
          },
        }
        return vim.tbl_map(function(cmd)
          return vim.tbl_extend("force", {
            pane = 2,
            section = "terminal",
            enabled = in_git,
            padding = 1,
            ttl = 60,
            indent = 3,
          }, cmd)
        end, cmds)
      end,
    },
  },
})

local utils = require("utils")

local treesitter = require("nvim-treesitter.config")

treesitter.setup({
  ensure_installed = utils.is_nix() and {} or {
    "bash",
    "javascript",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "query",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
  },
  auto_install = not utils.is_nix(),
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
})

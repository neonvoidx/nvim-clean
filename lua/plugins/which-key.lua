local which_key = require("which-key")

which_key.setup({preset="helix"})

which_key.add({
  { "<leader>b", group = "Buffers" },
  { "<leader>bd", desc = "Close buffer" },
  { "<leader>bp", desc = "Pin buffer" },
  { "<leader>bP", desc = "Close non-pinned buffers" },
  { "<leader>e", desc = "Yazi current file" },
  { "<leader>E", desc = "Yazi working directory" },
  { "<leader>f", desc = "Format buffer" },
  { "<leader>q", desc = "Diagnostics loclist" },
})

local bufferline = require("bufferline")

bufferline.setup({
options = {
      themable = true,
      mode = "buffers",
      indicator = {
        style = "none",
      },
      color_icons = true,
      separator_style = "thin",
      show_tab_indicators = false,
      show_buffer_icons = true,
      show_duplicate_prefix = false,
      max_name_length = 16,
      max_prefix_length = 10,
      tab_size = 25,
      truncate_names = true,
      hover = {
        enabled = true,
        delay = 100,
        reveal = { "close" },
      },
      diagnostics = "nvim_lsp",
      always_show_bufferline = true,
      diagnostics_update_on_event = true, -- use nvim's diagnostic handler
      groups = {
        options = {
          toggle_hidden_on_enter = true,
        },
      },
    }
})

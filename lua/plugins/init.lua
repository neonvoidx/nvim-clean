---@class PluginSpec These are fetched and loaded in order! this is important
---@field src string Plugin source URL used by `vim.pack.add()`.
---@field module? string Optional `lua/plugins/<module>.lua` config module to require after fetching.

---@type PluginSpec[]
local plugins = {
	-- Colorscheme first
	{ src = "https://github.com/eldritch-theme/eldritch.nvim", module = "colorscheme" },
	-- Dependencies
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	-- Rest
	{ src = "https://github.com/neovim/nvim-lspconfig", module = "lsp" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", module = "treesitter" },
	{ src = "https://github.com/folke/snacks.nvim", module = "snacks" },
	{ src = "https://github.com/folke/which-key.nvim", module = "which-key" },
	{ src = "https://github.com/akinsho/bufferline.nvim", module = "bufferline" },
	{ src = "https://github.com/stevearc/conform.nvim", module = "conform" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim", module = "lualine" },
	{ src = "https://github.com/mikavilpas/yazi.nvim", module = "yazi" },
}

-- Map all src fields and pack add them. Disable the confirmation to install
vim.pack.add(
	vim.tbl_map(function(plugin)
		return plugin.src
	end, plugins),
	{ confirm = false }
)

-- For each plugin that has a module defined, load that module
for _, plugin in ipairs(plugins) do
	if plugin.module then
		require("plugins." .. plugin.module)
	end
end

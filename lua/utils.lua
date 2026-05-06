local M = {}

function M.is_nix()
  return vim.env.IN_NIX_SHELL ~= nil or vim.env.NIX_PROFILES ~= nil or vim.env.NIX_PATH ~= nil
end

function M.pack_update()
  vim.pack.update()
end

return M

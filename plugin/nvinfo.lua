-- =============================================================================
-- File: nvinfo.lua
-- Description: Define user commands
-- Author: Daniel Campoverde [alx741] <alx741@riseup.net>
-- Author: Jeremy Seago [seagoj] <jeremy@seago.io>
-- =============================================================================

local nvinfo = require("nvinfo")

vim.api.nvim_create_user_command("Nvinfo", nvinfo.load_doc, { nargs = 1 })
vim.api.nvim_create_user_command("NvinfoClean", nvinfo.clean, {})
-- vim.api.nvim_create_user_command("NvinfoNext", nvinfo.next_page, {})
-- vim.api.nvim_create_user_command("NvinfoPrevious", nvinfo.previous_page, {})

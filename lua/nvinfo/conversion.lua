-- =============================================================================
-- File: conversion.vim
-- Description: Conversion from info docs (plain text) to Vim help format
-- Author: Daniel Campoverde [alx741] <alx741@riseup.net>
-- Author: Jeremy Seago [seagoj] <jeremy@seago.dev>
-- =============================================================================

local conversion = {}

function conversion.info2help()
	-- Add vim modelines for help-file
	-- tw=78 ts=8 ft=help norl
	vim.cmd([[silent norm! Govim:tw=78:ts=8:ft=help:norl:<Esc>gg]])

	-- Remove UNICODE characters
	-- Common ones
	vim.cmd("silent %s/‘/'/eg")
	vim.cmd("silent %s/’/'/eg")
	vim.cmd("silent %s/“/'/eg")
	vim.cmd("silent %s/”/'/eg")
	vim.cmd("silent %s/•/-/eg")
	--The rest of them
	vim.cmd("silent! %s/[^\x00-\x7F]/ /eg")

	-- Convert node subtitles (replace .. underlining with -)
	vim.cmd([[silent g/\v^$\n.+\n\=+\n^$\n/norm! jjvg_r-<Esc>]])
	-- Convert node subtitles (replace .. underlining with -)
	vim.cmd([[silent g/\v^$\n.+\n\.+\n^$\n/norm! jjvg_r<Esc>]])

	-- Convert node titles (replace .. underlining with =)
	vim.cmd([[silent g/\v^$\n.+\n\*+\n^$\n/norm! jjvg_r=<Esc>]])

	-- Convert Menu marks to vim help-files syntax
	vim.cmd([[silent %s/^* Menu:/MENU/e]])

	-- Create tag references
	-- Change blank spaces, '-' with '_' and apply tag notation with '|'
	vim.cmd([[silent g/\v^\*\s+(.+)::/exe 'norm! Wvt:\<Esc>"|s/\%V /_/ge|s/\%V-/_/ge']])
	vim.cmd([[silent %s/\v^\*\s+(.+)::/\* |\1|::/e]])

	-- Remove false tags
	vim.cmd([[silent g/\mv\*[^\* ]+\*/exe "norm! f*xf*x"]])

	-- Create tags
	vim.cmd([[silent g/\v^File: /call s:Create_tag()]])

	-- Mark Nodes separations
	vim.fn.setreg("o", "==============================================================================\n")
	vim.cmd([=[silent g/\v^File: /exe [[norm! \"oPj\"op\<Esc>]]]=])
end

local function create_tag()
	-- Create self node tag
	vim.cmd('silent! norm! ' .. '/\vNode: ' .. "\<CR>W\"oyt,mm")
	vim.fn.setreg("o", "\n*" .. @o .. "*\n")


	vim.cmd("silent norm! \"op")
	vim.cmd('silent norm! ' ..  "j0V\<Esc>")
	vim.cmd('silent s/\%V /_/ge')
	vim.cmd('silent s/\%V-/_/ge')
	vim.cmd('silent right')
	vim.cmd('silent norm! ' .. "\'m")

-- Create tag references
-- Node:
	vim.cmd('silent! norm! ' . '/\vNode: ' . "\<CR>Wvt,y\<Esc>")

	-- FIXME figure out what the fuck this is doing
	if @@ !~? '.\+|' && @@ !~? '.\+)' then
		exe 'silent s/\%V /_/ge|s/\%V-/_/ge'
		exe 'silent norm! ' . "gv\<Esc>a|\<Esc>gvo\<Esc>i|\<Esc>"
			exe 'silent norm! ' . "\'m"
	end
	-- Next:
	vim.cmd('silent! norm! ' . '/\vNext: ' . "\<CR>Wvt,y\<Esc>")
	if @@ !~? '.\+|' && @@ !~? '.\+)' then
		vim.cmd('silent s/\%V /_/ge|s/\%V-/_/ge')
		vim.cmd('silent norm! ' . "gv\<Esc>a|\<Esc>gvo\<Esc>i|\<Esc>")
		vim.cmd('silent norm! ' . "\'m")
	end
	" Prev:
exe 'silent! norm! ' . '/\vPrev: ' . "\<CR>Wvt,y\<Esc>"
	if @@ !~? '.\+|' && @@ !~? '.\+)'
	exe 'silent s/\%V /_/ge|s/\%V-/_/ge'
	exe 'silent norm! ' . "gv\<Esc>a|\<Esc>gvo\<Esc>i|\<Esc>"
		exe 'silent norm! ' . "\'m"
	endif
	" Up:
exe 'silent! norm! ' . '/\vUp: ' . "\<CR>Wvg_y\<Esc>"
	if @@ !~? '.\+|' && @@ !~? '.\+)'
	exe 'silent s/\%V /_/ge|s/\%V-/_/ge'
	exe 'silent norm! ' . "gv\<Esc>a|\<Esc>gvo\<Esc>i|\<Esc>"
		exe 'silent norm! ' . "\'m"
	endif

end

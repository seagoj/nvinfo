-- =============================================================================
-- File: vinfo.vim
-- Description: Info docs loading and creation, buffer creation
-- Author: Daniel Campoverde Carrión [alx741] <alx741@riseup.net>
-- Author: Jeremy Seago [seagoj] <jeremy@seago.dev>
-- =============================================================================

local repo = require("nvinfo.repo")
local nvinfo = {}

NVINFO_CURRENT_DOC = ""
NVINFO_CURRENT_PAGe = 0
NVINFO_CURRENT_DOC_PAGES = 0

nvinfo.config = {
	repo_path = os.getenv("XDG_CACHE_HOME") .. "/nvinfo",
}

---@param opts table: Configuration opts. Keys: defaults, pickers, extensions
---@eval { ["description"] = require('telescope').__format_setup_keys() }
function nvinfo.setup(opts)
	opts = opts or {}

	if nil ~= opts.repo_path then
		nvinfo.config.repo_path = opts.repo_path
	end

	nvinfo.config = opts
end

function nvinfo.clean()
	repo.clean(nvinfo.config.repo_path)
	vim.print("[Nvinfo] Repository is now empty")
end

-- TODO does nvim have a builtin for this?
local function file_exists(file)
	local f = io.open(file, "r")
	if nil ~= f then
		io.close(f)
		return true
	end

	return false
end

function nvinfo.doc_files(doc)
	return vim.fn.split(vim.fn.globpath(nvinfo.config.repo_path .. "/" .. doc, "*"), "\n")
end

-- load doc from repo
-- add to repo if necessary
function nvinfo.load_doc(params)
	local doc = params.args
	local exists = file_exists(nvinfo.config.repo_path .. "/" .. doc)
	local doc_files = nvinfo.doc_files(doc)
	NVINFO_CURRENT_DOC = doc
	NVINFO_CURRENT_PAGE = 0
	NVINFO_CURRENT_DOC_PAGES = #doc_files

	if not exists then
		doc_files = repo.create(nvinfo.config.repo_path, doc)
		for i = 1, #doc_files do
			vim.cmd("edit " .. doc_files[i])
			require("nvinfo.conversion").info2help()
			vim.cmd("write!")
			vim.cmd("silent bdelete!")
			-- Write appropriate modeline options in repo files
			vim.cmd(
				'silent ! echo "vim:ft=help bt=nowrite bufhidden=delete readonly nomodifiable nobuflisted:" >> '
					.. doc_files[i]
			)
		end

		vim.cmd("helptags " .. nvinfo.config.repo_path .. "/" .. doc .. "/")
		nvinfo.show(doc, 0)
	end

	nvinfo.show(doc, 0)
end

-- Display the doc page
function nvinfo.show(doc, page)
	-- Convert page number to appropriate -two digits- format
	local page_number = ""
	if page <= 10 then
		page_number = "0" .. page
	end

	vim.cmd("edit " .. nvinfo.config.repo_path .. "/" .. doc .. "/" .. doc .. page_number .. ".txt")
	vim.cmd("redraw!")
	vim.cmd("norm gg")
end

return nvinfo

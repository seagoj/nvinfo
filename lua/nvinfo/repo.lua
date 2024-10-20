local repo = {}

function repo.clean(path)
	vim.print("[Nvinfo] Cleaning repository: " .. path)
	vim.cmd("silent !rm -rf " .. path .. "/*")
	vim.cmd("redraw!")
end

function repo.create(path, doc)
	vim.print("[Nvinfo] Creating repo for: " .. doc)
	local doc_path = path .. "/" .. doc .. "/"
	vim.cmd("!mkdir -p " .. doc_path)
	vim.cmd("!info " .. doc .. " >> " .. doc_path .. doc .. ".txt")
	local splitter = "split"
	if vim.fn.executable("gsplit") then
		splitter = "gsplit"
	end
	vim.cmd("!" .. splitter .. " -l 5000 -d --additional-suffix .txt " .. doc_path .. doc .. ".txt " .. doc_path .. doc)
	vim.cmd("silent !rm " .. doc_path .. doc .. ".txt")
	vim.cmd("redraw!")

	-- If DOC is not a valid Info file, none file will be created
	local doc_files = require("nvinfo").doc_files(doc)
	if #doc_files == 0 then
		-- vim.cmd("silent !rm -rf " .. doc_path)
		NVINFO_CURRENT_DOC = ""
		NVINFO_CURRENT_PAGE = 0
		NVINFO_CURRENT_DOC_PAGES = 0
		vim.cmd("redraw!")
		error("[Vinfo] Invalid DOC: " .. doc .. "	(No repo created)")
	end

	return doc_files
end

return repo

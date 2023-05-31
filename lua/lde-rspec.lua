local M = {}

local function write_config(config)
	local json = vim.fn.json_encode(config)
	local path = vim.fn.stdpath("data") .. "/lde-rspec.json"
	local file = io.open(path, "w")
	file:write(json)
	file:close()
end

local function create_service_selection_buffer()
	local services = { "service_a", "service_b", "service_c" }
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
	vim.api.nvim_buf_set_option(buf, "filetype", "lde-rspec")
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, services)
	return buf
end

local function select_service(buf)
	local selected = vim.fn.getline(".")
	vim.api.nvim_buf_delete(buf, { force = true })
	return selected
end

function M.select_service()
	local buf = create_service_selection_buffer()
	vim.cmd("botright split")
	vim.api.nvim_set_current_buf(buf)
	vim.cmd("startinsert")
	vim.cmd('nnoremap <buffer><silent><CR> :lua require("lde-rspec").set_service()<CR>')
end

function M.set_service()
	local service = select_service(vim.api.nvim_get_current_buf())
	local config = { service = service }
	write_config(config)

	-- Open FTerm and output the selected service name
	local fterm_cmd = "FTermToggle --title=lde-rspec --persist"
	local output_cmd = 'FTermSend --title=lde-rspec --persist "Selected  ' .. service .. '"'
	vim.cmd(fterm_cmd)
	vim.cmd(output_cmd)
end

return M

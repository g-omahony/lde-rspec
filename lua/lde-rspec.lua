local M = {}

local function write_config(config)
	local json = vim.fn.json_encode(config)
	local path = vim.fn.stdpath("data") .. "/lde-rspec.json"
	local file = io.open(path, "w")
	file:write(json)
	file:close()
end

local function read_config()
	local path = vim.fn.stdpath("data") .. "/lde-rspec.json"
	local file = io.open(path, "r")
	if file == nil then
		return M:select_service()
	else
		local config = assert(vim.fn.json_decode(file:read()))
		return config.service
	end
end

local function docker_command(service)
	return "docker exec -it kitman-lde-" .. service .. ' bash -c "bundle exec rspec '
end

local function create_service_selection_buffer()
	local services = { "medinah", "console", "athlete-api" }
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
	-- vim.cmd("startinsert")
	vim.cmd('nnoremap <buffer><silent><CR> :lua require("lde-rspec").set_service()<CR>')
end

function M.set_service()
	local service = select_service(vim.api.nvim_get_current_buf())
	local config = { service = service }
	write_config(config)

	return service
end

function M.run_nearest_spec()
	local service = read_config()

	local specPath = vim.fn.expand("%") .. ":" .. vim.api.nvim_win_get_cursor(0)[1]
	local runCommand = docker_command(service) .. specPath .. '"'
	require("FTerm").run(runCommand)
end

function M.run_this_spec()
	local service = read_config()
	local specPath = vim.fn.expand("%")
	local runCommand = docker_command(service) .. specPath .. '"'
	require("FTerm").run(runCommand)
end

function M.run_spec_folder()
	local service = read_config()
	local specPath = vim.fn.expand("%:h")
	local runCommand = docker_command(service) .. specPath .. '"'
	require("FTerm").run(runCommand)
end

return M

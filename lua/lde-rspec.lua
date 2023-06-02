local popup = require("plenary.popup")
local fterm = require("FTerm")

local M = {}

local function config_path()
	return vim.fn.stdpath("data") .. "/lde-rspec.json"
end

local function write_config(config)
	local json = vim.fn.json_encode(config)
	local path = config_path()
	local file = io.open(path, "w")
	if file ~= nil then
		file:write(json)
		file:close()
	end
end

local function read_config()
	local path = config_path()
	local file = io.open(path, "r")

	if file == nil then
		return M:select_service()
	else
		local config = assert(vim.fn.json_decode(file:read()))
		return config.service
	end
end

local function command(specPath)
	local service = read_config()
	return "docker exec -it kitman-lde-" .. service .. ' bash -c "bundle exec rspec ' .. specPath .. '"'
end

local function service_list()
	local services = {}
	local handle = io.popen('docker ps --filter "name=kitman-lde" --format "{{.Names}}"')
	local result = nil
	if handle then
		result = handle:read("*a")
		handle:close()
	end
	if result then
		for line in result:gmatch("[^\r\n]+") do
			table.insert(services, line.sub(line, 12, -1))
		end
		return services
	else
		return { "medinah" }
	end
end

local function create_service_selection_buffer()
	local services = service_list()
	local width = 20
	local height = #services
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
	vim.api.nvim_buf_set_option(buf, "filetype", "lde-rspec")
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, services)
	popup.create(buf, {
		title = "Select Service",
		highlight = "PopupColor",
		line = math.floor(((vim.o.lines - height) / 2) - 1),
		col = math.floor((vim.o.columns - width) / 2),
		minwidth = width,
		minheight = height,
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
	})

	return buf
end

local function service_selected(buf)
	local selected = vim.fn.getline(".")
	vim.api.nvim_buf_delete(buf, { force = true })

	return selected
end

function M.select_service()
	local buf = create_service_selection_buffer()
	vim.api.nvim_set_current_buf(buf)
	vim.cmd('nnoremap <buffer><silent><CR> :lua require("lde-rspec").set_service()<CR>')
end

function M.set_service()
	local service = service_selected(vim.api.nvim_get_current_buf())
	local config = { service = service }
	write_config(config)

	return service
end

function M.run_nearest_spec()
	local specPath = vim.fn.expand("%") .. ":" .. vim.api.nvim_win_get_cursor(0)[1]
	fterm.run(command(specPath))
end

function M.run_this_spec()
	local specPath = vim.fn.expand("%")
	fterm.run(command(specPath))
end

function M.run_spec_folder()
	local specPath = vim.fn.expand("%:h")
	fterm.run(command(specPath))
end

return M

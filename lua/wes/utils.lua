local M = {}

--- @class ConfigData
--- @field current_theme string current theme name
--- @field last_modified string timestamp

--- Reads a configuration file from the specified path
--- @param path string Path to the configuration file
--- @return ConfigData Configuration data
--- @return string|nil Error message if reading fails
local function read_config_file(path)
	local f = io.open(path, "r")
	if not f then
		local current_theme = vim.g.colors_name
		local default_config = {
			current_theme = current_theme,
			last_modified = os.date("%Y-%m-%d %H:%M:%S"),
		}
		local json_str = vim.fn.json_encode(default_config)
		f = io.open(path, "w")
		if f then
			f:write(json_str)
			f:close()
		else
			error("Could not create config file: " .. path)
		end
		return default_config
	end

	local content = f:read("*all")
	f:close()
	return vim.fn.json_decode(content)
end

-- Read current configuration
function M.get_config(path)
	return read_config_file(path)
end

--- @param new_theme string
--- @param get_theme_list function Function that returns the list of available themes
--- @param path string
--- @return boolean
function M.update_config(new_theme, get_theme_list, path)
	if not vim.tbl_contains(get_theme_list(), new_theme) then
		error("Theme '" .. new_theme .. "' is not available")
		return false
	end

	local config = {
		current_theme = new_theme,
		last_modified = os.date("%Y-%m-%d %H:%M:%S"),
	}

	local json_str = vim.fn.json_encode(config)
	local f = io.open(path, "w")
	if not f then
		error("Could not open config file for writing: " .. path)
		return false
	end

	f:write(json_str)
	f:close()

	vim.cmd.colorscheme(new_theme)
	print("Colorscheme updated to: " .. new_theme)
	return true
end

-- Apply the configured theme
function M.apply_theme(path)
	local config = M.get_config(path)
	if config and config.current_theme then
		vim.cmd.colorscheme(config.current_theme)
	end
end

return M

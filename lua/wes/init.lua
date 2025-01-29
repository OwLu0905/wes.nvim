--- @class ColorschemeOpts
--- @field new_theme string? theme

local M = {}

local manager = require("wes.utils")

-- Configuration
local config_dir = vim.fn.stdpath("state") -- ~/.local/state/nvim/
local config_file = config_dir .. "/colorscheme.json"

function M.get_themes()
	return vim.fn.getcompletion("", "color")
end

M.themes = M.get_themes()

--- @param opts ColorschemeOpts
function M.setup(opts)
	opts = opts or {}

	manager.apply_theme(config_file)
	vim.api.nvim_create_user_command("WesPick", function(cmd)
		local args = cmd.args

		manager.update_config(args, M.get_themes(), config_file)
	end, {
		nargs = 1,
		complete = function(ArgLead)
			-- Get all available themes
			local themes = M.themes

			-- Filter themes that partially match the current input
			local matches = {}
			for _, theme in ipairs(themes) do
				if string.lower(theme):find(string.lower(ArgLead)) then
					table.insert(matches, theme)
				end
			end
			return matches
		end,
	})
end

return M

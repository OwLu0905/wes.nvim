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
		complete = function()
			return M.themes
		end,
	})
end

return M

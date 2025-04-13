local M = {}

--- @param get_theme_list function Function that returns the list of available themes
--- @param path string
function M.telescope_bind(get_theme_list, path)
	-- Check if telescope is available
	local ok, _ = pcall(require, "telescope")
	if not ok then
		vim.notify("Telescope is required for wes.nvim telescope integration", vim.log.levels.ERROR)
		return
	end

	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local manager = require("wes.utils")

	-- Create a wrapper function that will customize the colorscheme picker
	M.wes_themes = function(opts)
		opts = opts or {}
		return require("telescope.builtin").colorscheme(vim.tbl_deep_extend("force", {
			enable_preview = true,
			attach_mappings = function(prompt_bufnr, _)
				-- Override the default enter key behavior
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					-- Close telescope picker
					actions.close(prompt_bufnr)
					-- Update colorscheme using our manager
					if selection and selection.value then
						-- Call the function to get the theme list and pass it to the manager
						manager.update_config(selection.value, get_theme_list, path)
					end
				end)
				return true
			end,
		}, opts))
	end

	-- Create a user command for easier access
	vim.api.nvim_create_user_command("WesThemes", function()
		M.wes_themes()
	end, {})
end

return M

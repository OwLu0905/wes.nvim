local M = {}

function M.telescope_bind(theme_list, path)
	local telescope = require("telescope")
	local actions = require("telescope.actions")

	local action_state = require("telescope.actions.state")

	local manager = require("wes.utils")

	telescope.setup({
		pickers = {
			colorscheme = {
				enable_preview = true,
				attach_mappings = function(prompt_bufnr)
					-- Override the default enter key behavior
					actions.select_default:replace(function()
						local selection = action_state.get_selected_entry()
						-- Close telescope picker
						actions.close(prompt_bufnr)
						-- Update colorscheme using our manager
						if selection and selection.value then
							manager.update_config(selection.value, theme_list, path)
						end
					end)
					return true
				end,
			},
		},
	})
end

return M

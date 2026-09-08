-- Run from the repository root with: lua tests/restore_theme.lua
-- Stubs Neovim's API to test the startup error-handling boundary.
local warnings, applied = {}, {}
vim = {
  log = { levels = { WARN = 2 } },
  notify = function(message, level)
    assert(level == 2)
    table.insert(warnings, message)
  end,
  cmd = { colorscheme = function(name)
    table.insert(applied, name)
    if name == "removed-theme" then error("E185: Cannot find color scheme") end
    if name == "broken-theme" then error("theme initialization failed") end
  end },
}
local manager = dofile("lua/wes/utils.lua")
local cases = {
  { name = "valid saved theme", config = { current_theme = "valid" }, success = true, calls = 1, warnings = 0 },
  { name = "removed theme", config = { current_theme = "removed-theme" }, success = false, calls = 1, warnings = 1 },
  { name = "theme initialization error", config = { current_theme = "broken-theme" }, success = false, calls = 1, warnings = 1 },
  { name = "malformed JSON", read_error = "JSON decode failed", success = false, calls = 0, warnings = 1 },
  { name = "unreadable config", read_error = "Could not create config file", success = false, calls = 0, warnings = 1 },
  { name = "non-object config", config = false, success = false, calls = 0, warnings = 1 },
  { name = "invalid theme type", config = { current_theme = 42 }, success = false, calls = 0, warnings = 1 },
  { name = "empty theme", config = { current_theme = "" }, success = false, calls = 0, warnings = 1 },
  { name = "no saved selection", config = {}, success = false, calls = 0, warnings = 0 },
}
for _, case in ipairs(cases) do
  warnings, applied = {}, {}
  manager.get_config = function(path)
    assert(path == "test-state.json")
    if case.read_error then error(case.read_error) end
    return case.config
  end
  assert(manager.apply_theme("test-state.json") == case.success, case.name)
  assert(#applied == case.calls, case.name .. ": unexpected application")
  assert(#warnings == case.warnings, case.name .. ": unexpected warnings")
end
print("Passed " .. #cases .. " startup restoration tests")

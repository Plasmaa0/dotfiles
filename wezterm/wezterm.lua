local wezterm = require 'wezterm'

local mykeys = {
  {
    key = '\\',
    mods = 'LEADER',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '-',
    mods = 'LEADER',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'q',
    mods = 'LEADER',
    action = wezterm.action.CloseCurrentPane { domain = 'CurrentPaneDomain', confirm = true },
  },
  {
    key = 'Q',
    mods = 'LEADER',
    action = wezterm.action.CloseCurrentTab { confirm = true },
  },
  {
    key = 's',
    mods = 'LEADER',
    action = wezterm.action.PaneSelect,
  },
  {
    key = 'n',
    mods = 'LEADER',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 't',
    mods = 'LEADER',
    action = wezterm.action.ShowTabNavigator,
  },
  {
    key = 'Enter',
    mods = 'LEADER',
    action = wezterm.action.ShowLauncher,
  },
}
for i = 1, 8 do
  -- CTRL+ALT + number to move to that position
  table.insert(mykeys, {
    key = tostring(i),
    mods = 'LEADER',
    action = wezterm.action.ActivateTab(i - 1),
  })
end

return {
  leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 },
  keys = mykeys,
  font = wezterm.font 'IosevkaTerm',
  color_scheme = 'midnight-in-mojave',
  launch_menu = {
    {
      -- Optional label to show in the launcher. If omitted, a label
      -- is derived from the `args`
      -- label = 'ssh Gumer',
      args = { 'bash -c "sshpass -p bmstu ssh -p 3002 student@virtual.fn11.bmstu.ru"' },
      -- cwd = "/some/path"
      -- set_environment_variables = { FOO = "bar" },
    },
  },
}

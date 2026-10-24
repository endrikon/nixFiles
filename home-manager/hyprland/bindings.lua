local workspaceLayouts = {}

local function setLayout(workspace, index)
    workspaceLayouts[workspace.id] = index
    hl.workspace_rule({
        workspace = tostring(workspace.id),
        layout = index == 3 and "monocle" or "master",
        layout_opts = { orientation = index == 2 and "top" or "left" },
    })
    hl.exec_scheduled_prop_refresh_immediately()
end

local function cycleLayout()
    local workspace = hl.get_active_workspace()
    if workspace then
        setLayout(workspace, (workspaceLayouts[workspace.id] or 1) % 3 + 1)
    end
end

local function resetLayout()
    local workspace = hl.get_active_workspace()
    if workspace then
        setLayout(workspace, 3)
        setLayout(workspace, 1)
    end
end

local function refreshLayout()
    local workspace = hl.get_active_workspace()
    if workspace then
        setLayout(workspace, workspaceLayouts[workspace.id] or 1)
    end
end

local function masterAction(message)
    return function()
        local workspace = hl.get_active_workspace()
        if workspace and workspace.tiled_layout == "master" then
            hl.dispatch(hl.dsp.layout(message))
        end
    end
end

local function cycleFocus(forward)
    return function()
        local workspace = hl.get_active_workspace()
        local window = hl.get_active_window()
        if workspace and window then
            if window.floating then
                hl.dispatch(hl.dsp.window.cycle_next({ next = forward }))
            else
                hl.dispatch(hl.dsp.layout(forward and "cyclenext" or "cycleprev"))
            end
        end
    end
end

local function swapWindow(forward)
    return function()
        local workspace = hl.get_active_workspace()
        if workspace and workspace.tiled_layout == "master" then
            hl.dispatch(hl.dsp.layout(forward and "swapnext" or "swapprev"))
        else
            hl.dispatch(hl.dsp.window.swap({ next = forward, prev = not forward }))
        end
    end
end

local function screenAction(index, moveWindow)
    return function()
        local monitors = hl.get_monitors()
        table.sort(monitors, function(first, second) return first.id < second.id end)
        local monitor = monitors[index]
        if monitor then
            if moveWindow and monitor.active_workspace then
                hl.dispatch(hl.dsp.window.move({ workspace = tostring(monitor.active_workspace.id), follow = false }))
            elseif not moveWindow then
                hl.dispatch(hl.dsp.focus({ monitor = monitor.name }))
            end
        end
    end
end

hl.bind("SUPER + SHIFT + Return", hl.dsp.exec_cmd(commands.terminal))
hl.bind("SUPER + d", hl.dsp.exec_cmd(commands.launcher))
hl.bind("SUPER + SHIFT + p", hl.dsp.exec_cmd(commands.run))
hl.bind("SUPER + SHIFT + c", hl.dsp.window.close())
hl.bind("SUPER + space", cycleLayout)
hl.bind("SUPER + SHIFT + space", resetLayout)
hl.bind("SUPER + n", refreshLayout)
hl.bind("SUPER + Tab", cycleFocus(true))
hl.bind("SUPER + j", cycleFocus(true))
hl.bind("SUPER + k", cycleFocus(false))
hl.bind("SUPER + m", masterAction("focusmaster master"))
hl.bind("SUPER + Return", masterAction("swapwithmaster master ignoremaster"))
hl.bind("SUPER + SHIFT + j", swapWindow(true))
hl.bind("SUPER + SHIFT + k", swapWindow(false))
hl.bind("SUPER + h", masterAction("mfact -0.03"))
hl.bind("SUPER + l", masterAction("mfact +0.03"))
hl.bind("SUPER + t", hl.dsp.window.float({ action = "unset" }))
hl.bind("SUPER + comma", masterAction("addmaster"))
hl.bind("SUPER + period", masterAction("removemaster"))
hl.bind("SUPER + f", hl.dsp.exec_cmd(commands.browser))
hl.bind("SUPER + SHIFT + m", monitorControls.connectMonitor)
hl.bind("SUPER + CTRL + Up", function() monitorControls.changeScale(1) end)
hl.bind("SUPER + CTRL + Down", function() monitorControls.changeScale(-1) end)
hl.bind("SUPER + SHIFT + q", hl.dsp.exit())
hl.bind("SUPER + CTRL + l", hl.dsp.exec_cmd(commands.lock))
hl.bind("SUPER + q", hl.dsp.exec_cmd(commands.reload))
hl.bind("SUPER + SHIFT + slash", hl.dsp.exec_cmd(commands.help))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(commands.volumeUp), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(commands.volumeDown), { repeating = true, locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(commands.volumeMute), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(commands.brightnessUp), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(commands.brightnessDown), { repeating = true, locked = true })

for workspace = 1, 9 do
    hl.bind("SUPER + " .. workspace, hl.dsp.focus({ workspace = tostring(workspace), on_current_monitor = true }))
    hl.bind("SUPER + SHIFT + " .. workspace, hl.dsp.window.move({ workspace = tostring(workspace), follow = false }))
end

for index, key in ipairs({ "w", "e", "r" }) do
    hl.bind("SUPER + " .. key, screenAction(index, false))
    hl.bind("SUPER + SHIFT + " .. key, screenAction(index, true))
end

hl.bind("SUPER + mouse:272", function()
    hl.dispatch(hl.dsp.window.float({ action = "set" }))
    hl.dispatch(hl.dsp.window.drag())
end)
hl.bind("SUPER + mouse:274", masterAction("swapwithmaster master ignoremaster"))
hl.bind("SUPER + mouse:273", function()
    hl.dispatch(hl.dsp.window.float({ action = "set" }))
    hl.dispatch(hl.dsp.window.resize())
end)

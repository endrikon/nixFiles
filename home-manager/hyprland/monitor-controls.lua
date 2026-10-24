local function logicalSize(monitor, scale)
    local width = monitor.width / scale
    local height = monitor.height / scale
    if monitor.transform % 2 == 1 then
        return height, width
    end
    return width, height
end

local function monitorRule(monitor, scale, position)
    return {
        output = monitor.name,
        mode = string.format("%dx%d@%.5f", monitor.width, monitor.height, monitor.refresh_rate),
        scale = scale,
        position = position,
        transform = monitor.transform,
    }
end

local function supportsScale(monitor, scale)
    local width = monitor.width / scale
    local height = monitor.height / scale
    return math.abs(width - math.floor(width + 0.5)) < 0.001
        and math.abs(height - math.floor(height + 0.5)) < 0.001
end

local function changeScale(direction)
    local focused = hl.get_active_monitor()
    if not focused then
        return
    end

    local nextScale
    for step = 4, 12 do
        local candidate = step / 4
        if supportsScale(focused, candidate) then
            if direction > 0 and candidate > focused.scale + 0.001 then
                nextScale = candidate
                break
            elseif direction < 0 and candidate < focused.scale - 0.001 then
                nextScale = candidate
            end
        end
    end
    if not nextScale then
        return
    end

    local oldWidth, oldHeight = logicalSize(focused, focused.scale)
    local newWidth, newHeight = logicalSize(focused, nextScale)
    local rules = {}
    for _, monitor in ipairs(hl.get_monitors()) do
        local positionX = monitor.x
        local positionY = monitor.y
        local scale = monitor.scale
        if monitor.name == focused.name then
            scale = nextScale
        else
            if positionX >= focused.x + oldWidth - 0.001 then
                positionX = positionX + newWidth - oldWidth
            end
            if positionY >= focused.y + oldHeight - 0.001 then
                positionY = positionY + newHeight - oldHeight
            end
        end
        if scale ~= monitor.scale or positionX ~= monitor.x or positionY ~= monitor.y then
            local position = string.format("%dx%d", math.floor(positionX + 0.5), math.floor(positionY + 0.5))
            table.insert(rules, monitorRule(monitor, scale, position))
        end
    end
    for _, rule in ipairs(rules) do
        hl.monitor(rule)
    end
end

local function connectMonitor()
    local internal
    local external
    for _, monitor in ipairs(hl.get_monitors()) do
        if monitor.name:match("^eDP") then
            internal = monitor
        elseif monitor.name:match("^HDMI") then
            external = monitor
        end
    end
    if internal and external then
        hl.monitor(monitorRule(external, external.scale, "auto-up"))
    end
end

return {
    changeScale = changeScale,
    connectMonitor = connectMonitor,
}

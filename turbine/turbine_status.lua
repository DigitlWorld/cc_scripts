package.path = "/cc_scripts/?.lua;" .. package.path

local TurbineData = require("turbine.TurbineData")
local TurbineStatusDisplay = require("turbine.TurbineStatusDisplay")

local turbine = peripheral.wrap("back")
local monitor = peripheral.wrap("top")

local gRunning = true

local gTurbineData = TurbineData.new(turbine)

function renderStatusDisplay()
    local renderArea = window.create(monitor, 12, 1, 25, 25, true)
    local gStatusDisplay = TurbineStatusDisplay.new(gTurbineData)

    monitor.setTextScale(1)

    while gRunning do
        monitor.clear()
        gStatusDisplay:render(renderArea)
        sleep(1)
    end
end

function monitorTurbine()
    while gRunning do
        gTurbineData:update()
        sleep(0.1)
    end
end

parallel.waitForAll(monitorTurbine, renderStatusDisplay)

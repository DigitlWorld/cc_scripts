package.path = "/cc_scripts/?.lua;" .. package.path

local ReactorData = require("fission_reactor.ReactorData")
local ReactorStatusDisplay = require("fission_reactor.ReactorStatusDisplay")

local reactor = peripheral.wrap("back")
local monitor = peripheral.wrap("top")

local gRunning = true

local gReactorData = ReactorData.new(reactor)

function renderStatusDisplay()
    local renderArea = window.create(monitor, 12, 1, 25, 25, true)
    local gStatusDisplay = ReactorStatusDisplay.new(gReactorData, renderArea)
    while gRunning do
        gStatusDisplay:render()
        sleep(1)
    end
end

function monitorReactor()
    while gRunning do
        
        gReactorData:update()
        
        if gReactorData.damagePercent > 0 or gReactorData.coolantPercent < 0.8 or gReactorData.wastePercent > 0.8 then
            if reactor.getStatus() then
                reactor.scram()
            end
        end
     
        sleep(0.1)
    end
end

parallel.waitForAll(monitorReactor, renderStatusDisplay)

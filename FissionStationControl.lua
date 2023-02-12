package.path = "/cc_scripts/?.lua;" .. package.path

local ReactorData = require("fission_reactor.ReactorData")
local ReactorStatusDisplay = require("fission_reactor.ReactorStatusDisplay")

local BoilerData = require("boiler.BoilerData")
local BoilerStatusDisplay = require("boiler.BoilerStatusDisplay")

local TurbineData = require("turbine.TurbineData")
local TurbineStatusDisplay = require("turbine.TurbineStatusDisplay")

local FissionStationControl = {}
FissionStationControl.__index = FissionStationControl

function FissionStationControl.new(reactor, boiler, turbine, monitor)
    local self = setmetatable({
        reactor = reactor,
        boiler = boiler,
        turbine = turbine,
        monitor = monitor,
        reactorData = nil,
        turbineData = nil
    }, FissionStationControl)

    if self.reactor ~= nil then
        self.reactorData = ReactorData.new(self.reactor)
    end

    if self.boiler ~= nil then
        self.boilerData = BoilerData.new(self.boiler)
    end

    if self.turbine ~= nil then
        self.turbineData = TurbineData.new(self.turbine)
    end

    return self
end

function FissionStationControl:renderStatusDisplay()
    if self.monitor ~= nil then
        
        local reactorStatusDisplay = nil;
        local boilerStatusDisplay = nil;
        local turbineStatusDisplay = nil;
        
        if self.reactor ~= nil then
            reactorStatusDisplay = ReactorStatusDisplay.new(self.reactorData)
        end

        if self.boiler ~= nil then
            boilerStatusDisplay = TurbineStatusDisplay.new(self.boilerData)
        end

        if self.turbine ~= nil then
            turbineStatusDisplay = TurbineStatusDisplay.new(self.turbineData)
        end

        local reactorRenderArea = window.create(self.monitor, 1, 1, 25, 25, true)
        local boilerRenderArea = window.create(self.monitor, 27, 1, 25, 25, true)
        local turbineRenderArea = window.create(self.monitor, 27, 7, 25, 25, true)
        
        self.monitor.setTextScale(1)

        while true do
            self.monitor.clear()
            if reactorStatusDisplay ~= nil then
                reactorStatusDisplay:render(reactorRenderArea)
            end
            if boilerStatusDisplay ~= nil then
                boilerStatusDisplay:render(boilerRenderArea)
            end
            if turbineStatusDisplay ~= nil then
                turbineStatusDisplay:render(turbineRenderArea)
            end
            sleep(1)
        end
    end
end

function FissionStationControl:monitorReactor()
    while true do

        if self.reactor ~= nil then
            self.reactorData:update()
            
            if self.reactorData.damagePercent > 0 or self.reactorData.coolantPercent < 0.8 or self.reactorData.wastePercent > 0.8 then
                if self.reactor.getStatus() then
                    self.reactor.scram()
                end
            end
        end

        if self.boiler ~= nil then
            self.boilerData:update()
        end

        if self.turbine ~= nil then
            self.turbineData:update()
        end

        sleep(0.1)
    end
end

function FissionStationControl:run()
    local monitorFunc = function() self:monitorReactor() end
    local renderFunc = function() self:renderStatusDisplay() end

    parallel.waitForAll(monitorFunc, renderFunc)
end

return FissionStationControl

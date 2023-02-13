package.path = "/cc_scripts/?.lua;" .. package.path

local ReactorData = require("fission_reactor.ReactorData")
local ReactorStatusDisplay = require("fission_reactor.ReactorStatusDisplay")

local BoilerData = require("boiler.BoilerData")
local BoilerStatusDisplay = require("boiler.BoilerStatusDisplay")

local TurbineData = require("turbine.TurbineData")
local TurbineStatusDisplay = require("turbine.TurbineStatusDisplay")

local InductionMatrixData = require("induction_matrix.InductionMatrixData")
local InductionMatrixStatusDisplay = require("induction_matrix.InductionMatrixStatusDisplay")

local ResistiveHeaterData = require("resistive_heater.ResistiveHeaterData")
local ResistiveHeaterStatusDisplay = require("resistive_heater.ResistiveHeaterStatusDisplay")

local Label = require("ui.Label")

local FissionStationControl = {}
FissionStationControl.__index = FissionStationControl

function FissionStationControl.new(reactor, boiler, turbine, matrix, heater, monitor)
    local self = setmetatable({
        reactor = reactor,
        boiler = boiler,
        turbine = turbine,
        matrix = matrix,
        heater = heater,
        monitor = monitor,
        reactorData = nil,
        boilerData = nil,
        turbineData = nil,
        matrixData = nil,
        heaterData = nil
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

    if self.matrix ~= nil then
        self.matrixData = InductionMatrixData.new(self.matrix)
    end

    if self.heater ~= nil then
        self.heaterData = ResistiveHeaterData.new(self.heater)
    end

    return self
end

function FissionStationControl:renderStatusDisplay()
    if self.monitor ~= nil then
        
        local reactorStatusDisplay = nil;
        local boilerStatusDisplay = nil;
        local turbineStatusDisplay = nil;
        local matrixStatusDisplay = nil;
        local heaterStatusDisplay = nil;
        
        if self.reactor ~= nil then
            reactorStatusDisplay = ReactorStatusDisplay.new(self.reactorData)
        end

        if self.boiler ~= nil then
            boilerStatusDisplay = BoilerStatusDisplay.new(self.boilerData)
        end

        if self.turbine ~= nil then
            turbineStatusDisplay = TurbineStatusDisplay.new(self.turbineData)
        end

        if self.matrix ~= nil then
            matrixStatusDisplay = InductionMatrixStatusDisplay.new(self.matrixData)
        end

        if self.heater ~= nil then
            heaterStatusDisplay = ResistiveHeaterStatusDisplay.new(self.heaterData)
        end

        local reactorRenderArea = window.create(self.monitor, 1, 1, 25, 25, true)
        local boilerRenderArea = window.create(self.monitor, 27, 1, 25, 25, true)
        local turbineRenderArea = window.create(self.monitor, 27, 7, 25, 25, true)
        local matrixRenderArea = window.create(self.monitor, 53, 1, 25, 25, true)
        local heaterRenderArea = window.create(self.monitor, 53, 7, 25, 25, true)
        
        self.monitor.setTextScale(1)
        Label.setBlinkInterval(10)

        while true do
            Label.doBlink()
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
            if matrixStatusDisplay ~= nil then
                matrixStatusDisplay:render(matrixRenderArea)
            end
            if heaterStatusDisplay ~= nil then
                heaterStatusDisplay:render(heaterRenderArea)
            end
            sleep(0.05)
        end
    end
end

function FissionStationControl:monitorReactor()
    while true do

        if self.boiler ~= nil then
            self.boilerData:update()
        end

        if self.turbine ~= nil then
            self.turbineData:update()
        end

        if self.matrix ~= nil then
            self.matrixData:update()
        end

        if self.heater ~= nil then
            self.heaterData:update()
        end

        if self.reactor ~= nil then
            self.reactorData:update()
            
            if self.reactorData.damagePercent > 0 or self.reactorData.coolantPercent < 0.8 or self.reactorData.wastePercent > 0.8 then
                if self.reactor.getStatus() then
                    self.reactor.scram()
                end
            end
        end

        sleep(0.05)
    end
end

function FissionStationControl:listenForTouch()
    if self.monitor ~= nil then
        while true do
            local event, side, x, y = os.pullEvent("monitor_touch")

            if self.reactor.getStatus() then
                self.reactor.scram()
            else
                self.reactor.activate()
            end
        end
    end
end

function FissionStationControl:run()
    local monitorFunc = function() self:monitorReactor() end
    local renderFunc = function() self:renderStatusDisplay() end
    local inputFunc = function() self:listenForTouch() end

    parallel.waitForAll(monitorFunc, renderFunc, inputFunc)
end

return FissionStationControl

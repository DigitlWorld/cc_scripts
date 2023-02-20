local PeripheralData = require("data.PeripheralData")

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
        monitor = monitor,
        reactorData = nil,
        boilerData = nil,
        turbineData = nil,
        matrixData = nil,
        heaterData = nil
    }, FissionStationControl)

    if reactor ~= nil then
        self.reactorData = ReactorData.new(reactor)
    end

    if boiler ~= nil then
        self.boilerData = BoilerData.new(boiler)
    end

    if turbine ~= nil then
        self.turbineData = TurbineData.new(turbine)
    end

    if matrix ~= nil then
        self.matrixData = InductionMatrixData.new(matrix)
    end

    if heater ~= nil then
        self.heaterData = ResistiveHeaterData.new(heater)
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
        
        if self.reactorData ~= nil then
            reactorStatusDisplay = ReactorStatusDisplay.new(self.reactorData)
        end

        if self.boilerData ~= nil then
            boilerStatusDisplay = BoilerStatusDisplay.new(self.boilerData)
        end

        if self.turbineData ~= nil then
            turbineStatusDisplay = TurbineStatusDisplay.new(self.turbineData)
        end

        if self.matrixData ~= nil then
            matrixStatusDisplay = InductionMatrixStatusDisplay.new(self.matrixData)
        end

        if self.heaterData ~= nil then
            heaterStatusDisplay = ResistiveHeaterStatusDisplay.new(self.heaterData)
        end

        local reactorRenderArea = window.create(self.monitor, 1, 1, 25, 25, true)
        local boilerRenderArea = window.create(self.monitor, 27, 1, 25, 25, true)
        local turbineRenderArea = window.create(self.monitor, 27, 7, 25, 25, true)
        local matrixRenderArea = window.create(self.monitor, 53, 1, 25, 25, true)
        local heaterRenderArea = window.create(self.monitor, 53, 7, 25, 25, true)
        
        self.monitor.setTextScale(1)

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
            sleep(0.1)
        end
    end
end

function FissionStationControl:shutdownStation()
    if self.reactorData:isAvailable() and self.reactorData:getPeripheral().getStatus() then
        self.reactorData:getPeripheral().scram()
    end
end

function FissionStationControl:monitorReactor()
    while true do

        if self.boilerData ~= nil then
            self.boilerData:update()
        end

        if self.turbineData ~= nil then
            self.turbineData:update()
        end

        if self.matrixData ~= nil then
            self.matrixData:update()
        end

        if self.heaterData ~= nil then
            self.heaterData:update()
            
            if PeripheralData.isAvailable(self.heaterData) then
                local heater = self.heaterData:getPeripheral()

                -- Bleed logic
                if PeripheralData.isAvailable(self.turbineData) then
                    local prodRate = self.turbineData.productionRate
                    local prodRatex2 = prodRate * 2
                    if PeripheralData.isAvailable(self.matrixData) or self.matrixData.energyNeeded < prodRatex2 then
                        heater.setEnergyUsage( prodRate )
                    else
                        heater.setEnergyUsage( 0.0 )
                    end

                    if self.turbineData.storedEnergyPercent > 0 then
                        -- Drain the turbine
                        heater.setEnergyUsage( prodRate * 1.5 )
                    elseif not PeripheralData.isAvailable(self.matrixData) then
                        -- If no storage available, permadrain
                        heater.setEnergyUsage( prodRate )
                    else
                        -- Storage available and turbine empty
                        heater.setEnergyUsage( 0.0 )
                    end
                end
            end
        end

        if self.reactorData ~= nil then
            self.reactorData:update()

            if PeripheralData.isAvailable(self.reactorData) then
                
                if self.reactorData.damagePercent > 0 or self.reactorData.coolantPercent < 0.8 or self.reactorData.wastePercent > 0.8 then
                    self:shutdownStation()
                end

                -- Not safe to run if the turbine data isn't available, or is getting full.
                if not PeripheralData.isAvailable(self.turbineData) or self.turbineData.storedEnergyPercent > 0.75 then
                    self:shutdownStation()
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

            if self.reactorData ~= nil and PeripheralData.isAvailable(self.reactorData) then
                local reactor = self.reactorData:getPeripheral()
                if reactor.getStatus() then
                    reactor.scram()
                else
                    reactor.activate()
                end
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

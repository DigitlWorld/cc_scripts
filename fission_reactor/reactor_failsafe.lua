package.path = "/cc_scripts/?.lua;" .. package.path

local TextElementBase = require("ui.TextElementBase")
local Label = require("ui.Label")
local ValueBar = require("ui.ValueBar")

local reactor = peripheral.wrap("back")

local gRunning = true

function getReactorData( aReactor )
    return {
        damagePercent = aReactor.getDamagePercent() / 100,
        coolantPercent = aReactor.getCoolantFilledPercentage(),
        heatedCoolantPercent = aReactor.getHeatedCoolantFilledPercentage(),
        fuelPercent = aReactor.getFuelFilledPercentage(),
        wastePercent = aReactor.getWasteFilledPercentage(),
        active = aReactor.getStatus()
    }
end

local gReactorData = getReactorData(reactor)

function renderStatusDisplay()
    local monitor = peripheral.wrap("top")
    local barWidth = 20
    if monitor ~= nil then
        monitor.setTextScale(1)

        local uiElements = {
            fuelLabel = Label.new( monitor, 1, 1, "Fuel" ),
            coolantLabel = Label.new( monitor, 1, 2, "Coolant" ),
            heatedCoolantLabel = Label.new( monitor, 1, 3, "H.Coolant" ),
            wasteLabel = Label.new( monitor, 1, 4, "Waste" ),
            damageLabel = Label.new( monitor, 1, 5, "Damage" ),

            fuelBar = ValueBar.new( monitor, 11, 1, barWidth),
            coolantBar = ValueBar.new( monitor, 11, 2, barWidth),
            heatedCoolantBar = ValueBar.new( monitor, 11, 3, barWidth),
            wasteBar = ValueBar.new( monitor, 11, 4, barWidth),
            damageBar = ValueBar.new( monitor, 11, 5, barWidth)
        }

        uiElements.fuelBar:setForegroundColor( colors.green )
        uiElements.coolantBar:setForegroundColor( colors.blue )
        uiElements.heatedCoolantBar:setForegroundColor( colors.orange )
        uiElements.wasteBar:setForegroundColor( colors.brown )
        uiElements.damageBar:setForegroundColor( colors.red )

        while gRunning do

            -- Update values
            uiElements.fuelBar:setValuePercent(gReactorData.fuelPercent)
            uiElements.coolantBar:setValuePercent(gReactorData.coolantPercent)
            uiElements.heatedCoolantBar:setValuePercent(gReactorData.heatedCoolantPercent)
            uiElements.wasteBar:setValuePercent(gReactorData.wastePercent)
            uiElements.damageBar:setValuePercent(gReactorData.damagePercent)

            monitor.setTextColor(colors.white)
            monitor.setBackgroundColor(colors.black)
            monitor.clear()

            TextElementBase.renderAll(uiElements)

            sleep(1)
        end
    end
end

function monitorReactor()
    while gRunning do
        
        gReactorData = getReactorData(reactor)
        
        if gReactorData.damagePercent > 0 or gReactorData.coolantPercent < 0.8 or gReactorData.wastePercent > 0.8 then
            if reactor.getStatus() then
                reactor.scram()
            end
        end
     
        sleep(0.1)
    end
end

parallel.waitForAll(monitorReactor, renderStatusDisplay)

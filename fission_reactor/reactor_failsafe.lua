package.path = "/cc_scripts/?.lua;" .. package.path

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
    if monitor ~= nil then
        monitor.setTextScale(1)

        local fuelLabel = Label.new( monitor, 1, 1, "Fuel" )
        local coolantLabel = Label.new( monitor, 1, 2, "Coolant" )
        local heatedCoolantLabel = Label.new( monitor, 1, 3, "H.Coolant" )
        local wasteLabel = Label.new( monitor, 1, 4, "Waste" )
        local damageLabel = Label.new( monitor, 1, 5, "Damage" )

        local fuelBar = ValueBar.new( monitor, 11, 1, 20)
        local coolantBar = ValueBar.new( monitor, 11, 2, 20)
        local heatedCoolantBar = ValueBar.new( monitor, 11, 3, 20)
        local wasteBar = ValueBar.new( monitor, 11, 4, 20)
        local damageBar = ValueBar.new( monitor, 11, 5, 20)

        while gRunning do

            -- Update values
            fuelBar:setValuePercent(gReactorData.fuelPercent)
            coolantBar:setValuePercent(gReactorData.coolantPercent)
            heatedCoolantBar:setValuePercent(gReactorData.heatedCoolantPercent)
            wasteBar:setValuePercent(gReactorData.wastePercent)
            damageBar:setValuePercent(gReactorData.damagePercent)

            monitor.setTextColor(colors.white)
            monitor.setBackgroundColor(colors.black)
            monitor.clear()

            fuelLabel:render()
            coolantLabel:render()
            heatedCoolantLabel:render()
            wasteLabel:render()
            damageLabel:render()

            fuelBar:render()
            coolantBar:render()
            heatedCoolantBar:render()
            wasteBar:render()
            damageBar:render()

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

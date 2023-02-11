local reactor = peripheral.wrap("back")

local gRunning = true

function getReactorData( aReactor )
    return {
        damagePercent = aReactor.getDamagePercent(),
        coolantPercent = aReactor.getCoolantFilledPercentage() * 100,
        heatedCoolantPercent = aReactor.getHeatedCoolantFilledPercentage() * 100,
        fuelPercent = aReactor.getFuelFilledPercentage() * 100,
        wastePercent = aReactor.getWasteFilledPercentage(),
        active = aReactor.getStatus()
    }
end

local gReactorData = getReactorData(reactor)

function renderStatusDisplay()
    local monitor = peripheral.wrap("top")
    if monitor ~= nil then
        monitor.setTextScale(1)
        while gRunning do
            monitor.clear()

            monitor.setCursorPos(1,1)
            monitor.write("Fuel:      " .. gReactorData.fuelPercent)

            monitor.setCursorPos(1,2)
            monitor.write("Coolant:   " .. gReactorData.coolantPercent)
            
            monitor.setCursorPos(1,3)
            monitor.write("H.Coolant: " .. gReactorData.heatedCoolantPercent)
            
            monitor.setCursorPos(1,4)
            monitor.write("Waste:     " .. gReactorData.wastePercent)

            monitor.setCursorPos(1,5)
            monitor.write("Damage:    " .. gReactorData.damagePercent)
            
            sleep(1)
        end
    end
end

function monitorReactor()
    while gRunning do
        
        gReactorData = getReactorData(reactor)
        
        if gReactorData.damagePercent > 0 or gReactorData.coolantPercent < 80 then
            if reactor.getStatus() then
                reactor.scram()
            end
        end
     
        sleep(0.1)
    end
end

parallel.waitForAll(monitorReactor, renderStatusDisplay)

package.path = "/cc_scripts/?.lua;" .. package.path

local Label = require("ui.Label")

local reactor = peripheral.wrap("back")

local gRunning = true

function writeBar( monitor, x, y, value, maxWidth, foreground, background )
    monitor.setCursorPos(x,y)
    monitor.setTextColor(foreground)
    monitor.setBackgroundColor(background)
    for i=1,maxWidth do
        monitor.write(string.char(127))
    end

    monitor.setCursorPos(x,y)
    monitor.setTextColor(background)
    monitor.setBackgroundColor(foreground)
    for i=1,math.min(value,maxWidth) do
        monitor.write(" ")
    end
end

function writePercentBar( monitor, x, y, value, maxWidth, foreground, background )
    local scaled = math.floor( value * maxWidth )
    writeBar(monitor, x, y, scaled, maxWidth, foreground, background)
end

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

        while gRunning do
            monitor.setTextColor(colors.white)
            monitor.setBackgroundColor(colors.black)
            monitor.clear()

            fuelLabel:render()
            coolantLabel:render()
            heatedCoolantLabel:render()
            wasteLabel:render()
            damageLabel:render()
            
            writePercentBar( monitor, 11, 1, gReactorData.fuelPercent, 20, colors.green, colors.black)
            writePercentBar( monitor, 11, 2, gReactorData.coolantPercent, 20, colors.lightBlue, colors.black)
            writePercentBar( monitor, 11, 3, gReactorData.heatedCoolantPercent, 20, colors.orange, colors.black)
            writePercentBar( monitor, 11, 4, gReactorData.wastePercent, 20, colors.brown, colors.black)
            writePercentBar( monitor, 11, 5, gReactorData.damagePercent, 20, colors.red, colors.black)

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

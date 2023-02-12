package.path = "/cc_scripts/?.lua;" .. package.path

local TextElementBase = require("ui.TextElementBase")
local Label = require("ui.Label")
local ValueBar = require("ui.ValueBar")

local TurbineStatusDisplay = {}
TurbineStatusDisplay.__index = TurbineStatusDisplay

function TurbineStatusDisplay.new(turbineData)
    local self = setmetatable({
        turbineData = turbineData
    }, TurbineStatusDisplay)

    local barWidth = 15

    self.uiElements = {
        titleLabel = Label.new( 1, 1, "Turbine" ),

        steamLabel = Label.new( 1, 2, "Steam" ),
        powerLabel = Label.new( 1, 3, "Power" ),

        steamBar = ValueBar.new( 11, 2, barWidth),
        powerBar = ValueBar.new( 11, 3, barWidth),
    }

    self.uiElements.steamBar:setForegroundColor( colors.white )
    self.uiElements.powerBar:setForegroundColor( colors.lime )

    return self
end

function TurbineStatusDisplay:render(monitor)

    -- Update values
    self.uiElements.steamBar:setValuePercent(self.turbineData.steamPercent)
    self.uiElements.powerBar:setValuePercent(self.turbineData.storedEnergyPercent)

    if monitor ~= nil then
        monitor.setTextColor(colors.white)
        monitor.setBackgroundColor(colors.black)
        monitor.clear()

        TextElementBase.renderAll(monitor, self.uiElements)
    end 
end

return TurbineStatusDisplay

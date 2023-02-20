local TextElementBase = require("ui.TextElementBase")
local Label = require("ui.Label")
local ValueLabel = require("ui.ValueLabel")
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

        outputLabel = ValueLabel.new( 1, 5, "J/t" ),

        steamBar = ValueBar.new( 11, 2, barWidth),
        powerBar = ValueBar.new( 11, 3, barWidth),
    }

    self.offlineLabel = Label.new( 1, 2, "NO CONNECTION" )
    self.offlineLabel:setColors(colors.black, colors.red)
    self.offlineLabel:setBlinking(true)

    self.uiElements.titleLabel:setWidth(25)
    self.uiElements.titleLabel:setColors(colors.gray, colors.black)

    self.uiElements.outputLabel:setColors(colors.black, colors.lime)

    self.uiElements.steamBar:setForegroundColor( colors.white )
    self.uiElements.powerBar:setForegroundColor( colors.lime )

    return self
end

function TurbineStatusDisplay:render(monitor)
    if monitor ~= nil then
        monitor.setTextColor(colors.white)
        monitor.setBackgroundColor(colors.black)
        monitor.clear()

        if self.turbineData:isAvailable() then
            -- Update values
            self.uiElements.steamBar:setValuePercent(self.turbineData.steamPercent)
            self.uiElements.powerBar:setValuePercent(self.turbineData.storedEnergyPercent)
            self.uiElements.outputLabel:setValue( self.turbineData.productionRate )
            TextElementBase.renderAll(monitor, self.uiElements)
        else
            self.uiElements.titleLabel:render(monitor)
            self.offlineLabel:render(monitor)
        end
    end 
end

return TurbineStatusDisplay

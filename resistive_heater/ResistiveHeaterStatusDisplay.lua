local TextElementBase = require("ui.TextElementBase")
local Label = require("ui.Label")
local ValueLabel = require("ui.ValueLabel")
local ValueBar = require("ui.ValueBar")

local ResistiveHeaterStatusDisplay = {}
ResistiveHeaterStatusDisplay.__index = ResistiveHeaterStatusDisplay

function ResistiveHeaterStatusDisplay.new(heaterData)
    local self = setmetatable({
        heaterData = heaterData
    }, ResistiveHeaterStatusDisplay)

    local barWidth = 15

    self.uiElements = {
        titleLabel = Label.new( 1, 1, "Resistive Heater" ),

        usageLabel = Label.new( 1, 2, "Usage" ),

        energyUsageLabel = ValueLabel.new( 11, 2, "J/t" ),

    }

    self.offlineLabel = Label.new( 1, 2, "NO CONNECTION" )
    self.offlineLabel:setColors(colors.black, colors.red)
    self.offlineLabel:setBlinking(true)

    self.uiElements.titleLabel:setWidth(25)
    self.uiElements.titleLabel:setColors(colors.gray, colors.black)

    self.uiElements.energyUsageLabel:setColors(colors.black, colors.lime)
    
    return self
end

function ResistiveHeaterStatusDisplay:render(monitor)
    if monitor ~= nil then
        monitor.setTextColor(colors.white)
        monitor.setBackgroundColor(colors.black)
        monitor.clear()

        if self.heaterData:isAvailable() then
            -- Update values
            self.uiElements.energyUsageLabel:setValue(self.heaterData.energyUsage)
            TextElementBase.renderAll(monitor, self.uiElements)
        else
            self.uiElements.titleLabel:render(monitor)
            self.offlineLabel:render(monitor)
        end
    end 
end

return ResistiveHeaterStatusDisplay

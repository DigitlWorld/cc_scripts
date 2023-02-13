package.path = "/cc_scripts/?.lua;" .. package.path

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

    self.uiElements.titleLabel:setWidth(25)
    self.uiElements.titleLabel:setColors(colors.gray, colors.black)

    self.uiElements.energyUsageLabel:setColors(colors.black, colors.lime)
    
    return self
end

function ResistiveHeaterStatusDisplay:render(monitor)

    -- Update values
    self.uiElements.energyUsageLabel:setValue(self.heaterData.energyUsage)

    if monitor ~= nil then
        monitor.setTextColor(colors.white)
        monitor.setBackgroundColor(colors.black)
        monitor.clear()

        TextElementBase.renderAll(monitor, self.uiElements)
    end 
end

return ResistiveHeaterStatusDisplay

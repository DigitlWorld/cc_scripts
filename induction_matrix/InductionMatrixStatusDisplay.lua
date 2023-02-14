local TextElementBase = require("ui.TextElementBase")
local Label = require("ui.Label")
local ValueLabel = require("ui.ValueLabel")
local ValueBar = require("ui.ValueBar")

local InductionMatrixStatusDisplay = {}
InductionMatrixStatusDisplay.__index = InductionMatrixStatusDisplay

function InductionMatrixStatusDisplay.new(matrixData)
    local self = setmetatable({
        matrixData = matrixData
    }, InductionMatrixStatusDisplay)

    local barWidth = 15

    self.uiElements = {
        titleLabel = Label.new( 1, 1, "Induction Matrix" ),

        storedLabel = Label.new( 1, 2, "Storage" ),

        storedValueLabel = ValueLabel.new( 11, 3, "J" ),

        storedBar = ValueBar.new( 11, 2, barWidth)

    }

    self.uiElements.titleLabel:setWidth(25)
    self.uiElements.titleLabel:setColors(colors.gray, colors.black)

    self.uiElements.storedValueLabel:setColors(colors.black, colors.lime)

    self.uiElements.storedBar:setForegroundColor( colors.purple )
    
    return self
end

function InductionMatrixStatusDisplay:render(monitor)

    -- Update values
    self.uiElements.storedBar:setValuePercent(self.matrixData.storedEnergyPercent)
    self.uiElements.storedValueLabel:setValue(self.matrixData.storedEnergy)

    if monitor ~= nil then
        monitor.setTextColor(colors.white)
        monitor.setBackgroundColor(colors.black)
        monitor.clear()

        TextElementBase.renderAll(monitor, self.uiElements)
    end 
end

return InductionMatrixStatusDisplay

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

    self.offlineLabel = Label.new( 1, 2, "NO CONNECTION" )
    self.offlineLabel:setColors(colors.black, colors.red)
    self.offlineLabel:setBlinking(true)

    self.uiElements.titleLabel:setWidth(25)
    self.uiElements.titleLabel:setColors(colors.gray, colors.black)

    self.uiElements.storedValueLabel:setColors(colors.black, colors.lime)

    self.uiElements.storedBar:setForegroundColor( colors.purple )
    
    return self
end

function InductionMatrixStatusDisplay:render(monitor)
    if monitor ~= nil then
        monitor.setTextColor(colors.white)
        monitor.setBackgroundColor(colors.black)
        monitor.clear()

        if self.matrixData:isAvailable() then
            -- Update values
            self.uiElements.storedBar:setValuePercent(self.matrixData.storedEnergyPercent)
            self.uiElements.storedValueLabel:setValue(self.matrixData.storedEnergy)
            TextElementBase.renderAll(monitor, self.uiElements)
        else
            self.uiElements.titleLabel:render(monitor)
            self.offlineLabel:render(monitor)
        end
    end 
end

return InductionMatrixStatusDisplay

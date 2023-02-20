local TextElementBase = require("ui.TextElementBase")
local Label = require("ui.Label")
local ValueBar = require("ui.ValueBar")

local BoilerStatusDisplay = {}
BoilerStatusDisplay.__index = BoilerStatusDisplay

function BoilerStatusDisplay.new(boilerData)
    local self = setmetatable({
        boilerData = boilerData
    }, BoilerStatusDisplay)

    local barWidth = 15

    self.uiElements = {
        titleLabel = Label.new( 1, 1, "Boiler" ),

        heatedCoolantLabel = Label.new( 1, 2, "H.Coolant" ),
        waterLabel = Label.new( 1, 3, "Water" ),
        steamLabel = Label.new( 1, 4, "Steam" ),
        coolantLabel = Label.new( 1, 5, "Coolant" ),

        heatedCoolantBar = ValueBar.new( 11, 2, barWidth),
        waterBar = ValueBar.new( 11, 3, barWidth),
        steamBar = ValueBar.new( 11, 4, barWidth),
        coolantBar = ValueBar.new( 11, 5, barWidth),
    }

    self.offlineLabel = Label.new( 1, 2, "OFFLINE" )
    self.offlineLabel:setColors(colors.black, colors.red)
    self.offlineLabel:setBlinking(true)

    self.uiElements.titleLabel:setWidth(25)
    self.uiElements.titleLabel:setColors(colors.gray, colors.black)

    self.uiElements.heatedCoolantBar:setForegroundColor( colors.orange )
    self.uiElements.waterBar:setForegroundColor( colors.blue )
    self.uiElements.steamBar:setForegroundColor( colors.white )
    self.uiElements.coolantBar:setForegroundColor( colors.lightBlue )

    return self
end

function BoilerStatusDisplay:render(monitor)
    if monitor ~= nil then
        monitor.setTextColor(colors.white)
        monitor.setBackgroundColor(colors.black)
        monitor.clear()

        -- Update values
        self.uiElements.heatedCoolantBar:setValuePercent(self.boilerData.heatedCoolantPercent)
        self.uiElements.waterBar:setValuePercent(self.boilerData.waterPercent)
        self.uiElements.steamBar:setValuePercent(self.boilerData.steamPercent)
        self.uiElements.coolantBar:setValuePercent(self.boilerData.coolantPercent)

        if self.boilerData:isAvailable() then
            TextElementBase.renderAll(monitor, self.uiElements)
        else
            self.uiElements.titleLabel:render(monitor)
            self.offlineLabel:render(monitor)
        end
    end 
end

return BoilerStatusDisplay

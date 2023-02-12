package.path = "/cc_scripts/?.lua;" .. package.path

local TextElementBase = require("ui.TextElementBase")
local Label = require("ui.Label")
local ValueBar = require("ui.ValueBar")

local ReactorStatusDisplay = {}
ReactorStatusDisplay.__index = ReactorStatusDisplay

function ReactorStatusDisplay.new(reactorData)
    local self = setmetatable({
        reactorData = reactorData
    }, ReactorStatusDisplay)

    local barWidth = 15

    self.uiElements = {
        titleLabel = Label.new( 1, 1, "Fission Reactor" ),

        fuelLabel = Label.new( 1, 2, "Fuel" ),
        coolantLabel = Label.new( 1, 3, "Coolant" ),
        heatedCoolantLabel = Label.new( 1, 4, "H.Coolant" ),
        wasteLabel = Label.new( 1, 5, "Waste" ),
        damageLabel = Label.new( 1, 6, "Damage" ),

        statusLabel = Label.new( 1, 8, "Stopped" ),

        fuelBar = ValueBar.new( 11, 2, barWidth),
        coolantBar = ValueBar.new( 11, 3, barWidth),
        heatedCoolantBar = ValueBar.new( 11, 4, barWidth),
        wasteBar = ValueBar.new( 11, 5, barWidth),
        damageBar = ValueBar.new( 11, 6, barWidth)
    }

    self.uiElements.fuelBar:setForegroundColor( colors.green )
    self.uiElements.coolantBar:setForegroundColor( colors.lightBlue )
    self.uiElements.heatedCoolantBar:setForegroundColor( colors.orange )
    self.uiElements.wasteBar:setForegroundColor( colors.brown )
    self.uiElements.damageBar:setForegroundColor( colors.red )

    return self
end

function ReactorStatusDisplay:render(monitor)

    -- Update values
    self.uiElements.fuelBar:setValuePercent(self.reactorData.fuelPercent)
    self.uiElements.coolantBar:setValuePercent(self.reactorData.coolantPercent)
    self.uiElements.heatedCoolantBar:setValuePercent(self.reactorData.heatedCoolantPercent)
    self.uiElements.wasteBar:setValuePercent(self.reactorData.wastePercent)
    self.uiElements.damageBar:setValuePercent(self.reactorData.damagePercent)

    self.uiElements.statusLabel:setText( self.reactorData.active and "Active" or "Stopped" )
    self.uiElements.statusLabel:setForegroundColor( self.reactorData.active and colors.green or colors.red )

    if monitor ~= nil then
        monitor.setTextColor(colors.white)
        monitor.setBackgroundColor(colors.black)
        monitor.clear()

        TextElementBase.renderAll(monitor, self.uiElements)
    end 
end

return ReactorStatusDisplay

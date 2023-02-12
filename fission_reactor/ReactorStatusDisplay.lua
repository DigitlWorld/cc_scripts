package.path = "/cc_scripts/?.lua;" .. package.path

local TextElementBase = require("ui.TextElementBase")
local Label = require("ui.Label")
local ValueBar = require("ui.ValueBar")

local ReactorStatusDisplay = {}
ReactorStatusDisplay.__index = ReactorStatusDisplay

function ReactorStatusDisplay.new(reactorData, monitor)
    local self = setmetatable({
        reactorData = reactorData,
        monitor = monitor
    }, ReactorStatusDisplay)

    local barWidth = 15
    if monitor ~= nil then
        self.uiElements = {
            fuelLabel = Label.new( monitor, 1, 1, "Fuel" ),
            coolantLabel = Label.new( monitor, 1, 2, "Coolant" ),
            heatedCoolantLabel = Label.new( monitor, 1, 3, "H.Coolant" ),
            wasteLabel = Label.new( monitor, 1, 4, "Waste" ),
            damageLabel = Label.new( monitor, 1, 5, "Damage" ),

            statusLabel = Label.new( monitor, 1, 7, "Stopped" ),

            fuelBar = ValueBar.new( monitor, 11, 1, barWidth),
            coolantBar = ValueBar.new( monitor, 11, 2, barWidth),
            heatedCoolantBar = ValueBar.new( monitor, 11, 3, barWidth),
            wasteBar = ValueBar.new( monitor, 11, 4, barWidth),
            damageBar = ValueBar.new( monitor, 11, 5, barWidth)
        }

        self.uiElements.fuelBar:setForegroundColor( colors.green )
        self.uiElements.coolantBar:setForegroundColor( colors.blue )
        self.uiElements.heatedCoolantBar:setForegroundColor( colors.orange )
        self.uiElements.wasteBar:setForegroundColor( colors.brown )
        self.uiElements.damageBar:setForegroundColor( colors.red )
    end

    return self
end

function ReactorStatusDisplay:render()

    -- Update values
    self.uiElements.fuelBar:setValuePercent(self.reactorData.fuelPercent)
    self.uiElements.coolantBar:setValuePercent(self.reactorData.coolantPercent)
    self.uiElements.heatedCoolantBar:setValuePercent(self.reactorData.heatedCoolantPercent)
    self.uiElements.wasteBar:setValuePercent(self.reactorData.wastePercent)
    self.uiElements.damageBar:setValuePercent(self.reactorData.damagePercent)

    self.uiElements.statusLabel:setText( self.reactorData.active and "Active" or "Stopped" )
    self.uiElements.statusLabel:setForegroundColor( self.reactorData.active and colors.green or colors.red )

    if self.monitor ~= nil then
        self.monitor.setTextColor(colors.white)
        self.monitor.setBackgroundColor(colors.black)
        self.monitor.clear()

        TextElementBase.renderAll(self.uiElements)
    end 
end

return ReactorStatusDisplay

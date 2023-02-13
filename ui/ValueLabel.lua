package.path = "/cc_scripts/?.lua;" .. package.path

local Label = require("ui.Label")

local ValueLabel = setmetatable({}, {__index = Label})
ValueLabel.__index = ValueLabel

function ValueLabel.new(x, y, units)
    local self = setmetatable(Label.new(x, y, ""), ValueLabel)
    self.value = 0.0
    self.numberFormat = "%.2f "
    self.conversionFactor = 1.0
    self.units = units
    return self
end

function ValueLabel:render(monitor)
    self.text = self:getFormattedValue()
    Label.render(self, monitor)
end

function ValueLabel:setValue( value )
    self.value = value
end

function ValueLabel:setUnits( units )
    self.units = units
end

function ValueLabel:setNumberFormat( format )
    self.numberFormat = format
end

function ValueLabel:setConversionFactor( factor )
    self.conversionFactor = factor
end

function ValueLabel:getFormattedValue()
    local scaled = self.value * self.conversionFactor
    local prefix = ""

    if scaled >= 1000000000000.0 then
        scaled = scaled / 1000000000000.0
        prefix = "T"
    elseif scaled >= 1000000000.0 then
        scaled = scaled / 1000000000.0
        prefix = "G"
    elseif scaled >= 1000000.0 then
        scaled = scaled / 1000000.0
        prefix = "M"
    elseif scaled >= 1000.0 then
        scaled = scaled / 1000.0
        prefix = "k"
    end 

    return (string.format(self.numberFormat, scaled) .. prefix .. self.units)
end

return ValueLabel

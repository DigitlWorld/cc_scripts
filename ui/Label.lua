package.path = "/cc_scripts/?.lua;" .. package.path

local TextElementBase = require("ui.TextElementBase")

local Label = setmetatable({}, {__index = TextElementBase})
Label.__index = Label

Label.blinkStep = 0
Label.blinkInterval = 5

function Label.doBlink()
    Label.blinkStep = Label.blinkStep + 1

    if Label.blinkStep >= (Label.blinkInterval * 2) then
        Label.blinkStep = 0
    end
end

function Label.new(x, y, text)
    local self = setmetatable(TextElementBase.new(x, y), Label)
    self.text = text
    self.blinking = false
    return self
end

function Label:render(monitor)
    if monitor then
        monitor.setCursorPos(self.x, self.y)
        if not self.blinking or Label.blinkStep < Label.blinkInterval then
            monitor.setBackgroundColor(self.background)
            monitor.setTextColor(self.foreground)
        else
            monitor.setBackgroundColor(self.foreground)
            monitor.setTextColor(self.background)
        end
        monitor.write(self.text)
    end
end

function Label:setText( text )
    self.text = text
end

function Label:setBlinking( blinking )
    self.blinking = blinking
end

return Label

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

function Label.setBlinkInterval( interval )
    if interval > 0 then
        Label.blinkStep = 0
        Label.blinkInterval = interval
    end
end

function Label.new(x, y, text)
    local self = setmetatable(TextElementBase.new(x, y), Label)
    self.text = text
    self.blinking = false
    self.width = 1
    return self
end

function Label:render(monitor)
    if monitor then
        if not self.blinking or Label.blinkStep < Label.blinkInterval then
            monitor.setBackgroundColor(self.background)
            monitor.setTextColor(self.foreground)
        else
            monitor.setBackgroundColor(self.foreground)
            monitor.setTextColor(self.background)
        end
        monitor.setCursorPos(self.x, self.y)
        monitor.write(string.rep(" ", self.width))
        monitor.setCursorPos(self.x, self.y)
        monitor.write(self.text)
    end
end

function Label:setText( text )
    self.text = text
end

function Label:setWidth( width )
    self.width = width
end

function Label:setBlinking( blinking )
    self.blinking = blinking
end

return Label

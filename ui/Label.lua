package.path = "/cc_scripts/?.lua;" .. package.path

local TextElementBase = require("ui.TextElementBase")

local Label = setmetatable({}, {__index = TextElementBase})
Label.__index = Label

function Label.new(monitor, x, y, text)
    local self = setmetatable(TextElementBase.new(monitor, x, y), Label)
    self.text = text
    return self
end

function Label:render()
    if monitor then
        monitor.setCursorPos(self.x, self.y)
        monitor.setBackgroundColor(self.background)
        monitor.setTextColor(self.foreground)
        monitor.write(self.text)
    end
end

function Label:setText( text )
    self.text = text
end

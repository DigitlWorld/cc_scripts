local TextElementBase = require("ui.TextElementBase")

local ValueBar = setmetatable({}, {__index = TextElementBase})
ValueBar.__index = ValueBar

function ValueBar.new(x, y, width)
    local self = setmetatable(TextElementBase.new(x, y), ValueBar)
    self.width = width
    self.value = 0
    return self
end

function ValueBar:render(monitor)
    if monitor then
        monitor.setCursorPos(self.x, self.y)
        
        monitor.setTextColor(self.foreground)
        monitor.setBackgroundColor(self.background)
        for i=1,self.width do
            monitor.write(string.char(127))
        end
    
        monitor.setCursorPos(self.x, self.y)
        monitor.setTextColor(self.background)
        monitor.setBackgroundColor(self.foreground)
        for i=1,math.min(self.value,self.width) do
            monitor.write(" ")
        end
        
    end
end

function ValueBar:setValue( value )
    self.value = value
end

function ValueBar:setValuePercent( percent )
    percent = percent or 0
    local scaled = math.floor( percent * self.width )
    self:setValue(scaled)
end

function ValueBar:setWidth( width )
    self.width = width
end

return ValueBar

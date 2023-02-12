package.path = "/cc_scripts/?.lua;" .. package.path

local TextElementBase = require("ui.TextElementBase")

local ValueBar = setmetatable({}, {__index = TextElementBase})
ValueBar.__index = ValueBar

function ValueBar.new(monitor, x, y, width)
    local self = setmetatable(TextElementBase.new(monitor, x, y), ValueBar)
    self.width = width
    self.value = 0
    return self
end

function ValueBar:render()
    if self.monitor then
        self.monitor.setCursorPos(self.x, self.y)
        
        self.monitor.setTextColor(self.foreground)
        self.monitor.setBackgroundColor(self.background)
        for i=1,self.width do
            self.monitor.write(string.char(127))
        end
    
        self.monitor.setCursorPos(self.x, self.y)
        self.monitor.setTextColor(self.background)
        self.monitor.setBackgroundColor(self.foreground)
        for i=1,math.min(self.value,self.width) do
            self.monitor.write(" ")
        end
        
    end
end

function ValueBar:setValue( value )
    self.value = value
end

function ValueBar:setValuePercent( percent )
    local scaled = math.floor( percent * self.width )
    self:setValue(scaled)
end

function ValueBar:setWidth( width )
    self.width = width
end

return ValueBar

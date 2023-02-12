local TextElementBase = {}
TextElementBase.__index = TextElementBase

function TextElementBase.new(monitor, x, y)
    local self = setmetatable({
        monitor = monitor,
        x = x or 0,
        y = y or 0,
        background = colors.black,
        foreground = colors.white
    }, TextElementBase)

    return self
end

function TextElementBase.renderAll( table )
    for k, v in pairs(table) do
        v:render()
    end
end

function TextElementBase:render()
    -- nop
end

function TextElementBase:setBackgroundColor( color )
    self.background = color
end

function TextElementBase:setForegroundColor( color )
    self.foreground = color
end

function TextElementBase:setColors( background, foreground )
    self.background = background
    self.foreground = foreground
end

return TextElementBase

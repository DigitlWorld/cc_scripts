local TextElementBase = {}
TextElementBase.__index = TextElementBase

function TextElementBase.new(x, y)
    local self = setmetatable({
        x = x or 0,
        y = y or 0,
        background = colors.black,
        foreground = colors.white
    }, TextElementBase)

    return self
end

function TextElementBase.renderAll( monitor, table )
    for k, v in pairs(table) do
        v:render(monitor)
    end
end

function TextElementBase:render(monitor)
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

local PeripheralData = {}
PeripheralData.__index = PeripheralData

function PeripheralData.new(wrappedPeripheral)
    local self = setmetatable({
        wrappedPeripheral = wrappedPeripheral,
        name = ""
    }, PeripheralData)

    if wrappedPeripheral ~= nil then
        name = peripheral.getName(wrappedPeripheral)
    end

    return self
end

function PeripheralData:isAvailable()
    return self.wrappedPeripheral ~= nil
end

function PeripheralData:getPeripheral()
    return self.wrappedPeripheral
end

function PeripheralData:update()
    local avail = peripheral.isPresent(self.name)

    if avail then
        if self.wrappedPeripheral == nil then
            self.wrappedPeripheral = peripheral.wrap(self.name)
        end
        self:fetchData()
    else
        self.wrappedPeripheral = nil
        self:initData()
    end
end

function PeripheralData:fetchData()
    -- No/op
end

function PeripheralData:initData()
    -- No/op
end

return PeripheralData

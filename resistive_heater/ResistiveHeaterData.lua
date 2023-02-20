local PeripheralData = require("data.PeripheralData")

local ResistiveHeaterData = setmetatable({}, {__index = PeripheralData})
ResistiveHeaterData.__index = ResistiveHeaterData

function ResistiveHeaterData.new(heater)
    local self = setmetatable(PeripheralData.new(heater), ResistiveHeaterData)
    self:initData()
    return self
end

function ResistiveHeaterData:fetchData()
    self.energyUsage = self.wrappedPeripheral.getEnergyUsage()
end

function ResistiveHeaterData:initData()
    self.energyUsage = 0
end

return ResistiveHeaterData

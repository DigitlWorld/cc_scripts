local PeripheralData = require("data.PeripheralData")

local InductionMatrixData = setmetatable({}, {__index = PeripheralData})
InductionMatrixData.__index = InductionMatrixData

function InductionMatrixData.new(matrix)
    local self = setmetatable(PeripheralData.new(matrix), InductionMatrixData)
    self:initData()
    return self
end

function InductionMatrixData:fetchData()
    self.storedEnergyPercent = self.wrappedPeripheral.getEnergyFilledPercentage()
    self.storedEnergy = self.wrappedPeripheral.getEnergy()
    self.energyNeeded = self.wrappedPeripheral.getEnergyNeeded()
end

function InductionMatrixData:initData()
    self.storedEnergyPercent = 0
    self.storedEnergy = 0
    self.energyNeeded = 0
end

return InductionMatrixData

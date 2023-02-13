local InductionMatrixData = {}
InductionMatrixData.__index = InductionMatrixData

function InductionMatrixData.new(matrix)
    local self = setmetatable({
        matrix = matrix,
        storedEnergyPercent = 0,
        storedEnergy = 0,
        energyNeeded = 0
    }, InductionMatrixData)

    return self
end

function InductionMatrixData:update()
    self.storedEnergyPercent = self.matrix.getEnergyFilledPercentage()
    self.storedEnergy = self.matrix.getEnergy()
    self.energyNeeded = self.matrix.getEnergyNeeded()
end

return InductionMatrixData

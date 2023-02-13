local TurbineData = {}
TurbineData.__index = TurbineData

function TurbineData.new(turbine)
    local self = setmetatable({
        turbine = turbine,
        storedEnergyPercent = 0,
        steamPercent = 0,
        productionRate = 0
    }, TurbineData)

    return self
end

function TurbineData:update()
    self.storedEnergyPercent = self.turbine.getEnergyFilledPercentage()
    self.steamPercent = self.turbine.getSteamFilledPercentage()
    self.productionRate = self.turbine.getProductionRate()
end

return TurbineData

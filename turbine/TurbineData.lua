local TurbineData = {}
TurbineData.__index = TurbineData

function TurbineData.new(turbine)
    local self = setmetatable({
        turbine = turbine,
        storedEnergyPercent = 0,
        steamPercent = 0
    }, TurbineData)

    return self
end

function TurbineData:update()
    self.storedEnergyPercent = self.turbine.getTotalEnergyFilledPercentage()
    self.steamPercent = self.turbine.getSteamFilledPercentage()
end

return TurbineData

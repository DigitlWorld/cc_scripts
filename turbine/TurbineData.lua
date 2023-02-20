local PeripheralData = require("data.PeripheralData")

local TurbineData = setmetatable({}, {__index = PeripheralData})
TurbineData.__index = TurbineData

function TurbineData.new(turbine)
    local self = setmetatable(PeripheralData.new(turbine), TurbineData)
    self:initData()
    return self
end

function TurbineData:fetchData()
    self.storedEnergyPercent = self.wrappedPeripheral.getEnergyFilledPercentage()
    self.steamPercent = self.wrappedPeripheral.getSteamFilledPercentage()
    self.productionRate = self.wrappedPeripheral.getProductionRate()
end

function TurbineData:initData()
    self.storedEnergyPercent = 0
    self.steamPercent = 0
    self.productionRate = 0
end

return TurbineData

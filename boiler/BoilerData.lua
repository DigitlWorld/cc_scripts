local PeripheralData = require("data.PeripheralData")

local BoilerData = setmetatable({}, {__index = PeripheralData})
BoilerData.__index = BoilerData

function BoilerData.new(boiler)
    local self = setmetatable(PeripheralData.new(boiler), BoilerData)
    self:initData()
    return self
end

function BoilerData:fetchData()
    self.heatedCoolantPercent = self.wrappedPeripheral.getHeatedCoolantFilledPercentage()
    self.waterPercent = self.wrappedPeripheral.getWaterFilledPercentage()
    self.steamPercent = self.wrappedPeripheral.getSteamFilledPercentage()
    self.coolantPercent = self.wrappedPeripheral.getCooledCoolantFilledPercentage()
end

function BoilerData:initData()
    self.heatedCoolantPercent = 0
    self.waterPercent = 0
    self.steamPercent = 0
    self.coolantPercent = 0
end

return BoilerData

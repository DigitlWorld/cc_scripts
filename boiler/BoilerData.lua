local BoilerData = {}
BoilerData.__index = BoilerData

function BoilerData.new(boiler)
    local self = setmetatable({
        boiler = boiler,
        heatedCoolantPercent = 0,
        waterPercent = 0,
        steamPercent = 0,
        coolantPercent = 0
    }, BoilerData)

    return self
end

function BoilerData:update()
    self.heatedCoolantPercent = self.boiler.getHeatedCoolantFilledPercentage()
    self.waterPercent = self.boiler.getWaterFilledPercentage()
    self.steamPercent = self.boiler.getSteamFilledPercentage()
    self.coolantPercent = self.boiler.getCooledCoolantFilledPercentage()
end

return BoilerData

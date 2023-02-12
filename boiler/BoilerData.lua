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
    self.heatedCoolantPercent = self.reactor.getHeatedCoolantFilledPercentage()
    self.waterPercent = self.reactor.getWaterFilledPercentage()
    self.steamPercent = self.reactor.getSteamFilledPercentage()
    self.coolantPercent = self.reactor.getCoolantFilledPercentage()
end

return BoilerData

local ResistiveHeaterData = {}
ResistiveHeaterData.__index = ResistiveHeaterData

function ResistiveHeaterData.new(heater)
    local self = setmetatable({
        heater = heater,
        energyUsage = 0
    }, ResistiveHeaterData)

    return self
end

function ResistiveHeaterData:update()
    self.energyUsage = self.heater.getEnergyUsage()
end

return ResistiveHeaterData

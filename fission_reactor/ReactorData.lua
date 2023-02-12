local ReactorData = {}
ReactorData.__index = ReactorData

function ReactorData.new(reactor)
    local self = setmetatable({
        reactor = reactor,
        damagePercent = 0,
        coolantPercent = 0,
        heatedCoolantPercent = 0,
        fuelPercent = 0,
        wastePercent = 0,
        active = false
    }, ReactorData)

    return self
end

function ReactorData:update()
    self.damagePercent = self.reactor.getDamagePercent() / 100
    self.coolantPercent = self.reactor.getCoolantFilledPercentage()
    self.heatedCoolantPercent = self.reactor.getHeatedCoolantFilledPercentage()
    self.fuelPercent = self.reactor.getFuelFilledPercentage()
    self.wastePercent = self.reactor.getWasteFilledPercentage()
    self.active = self.reactor.getStatus()
end

return ReactorData

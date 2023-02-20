local PeripheralData = require("data.PeripheralData")

local ReactorData = setmetatable({}, {__index = PeripheralData})
ReactorData.__index = ReactorData

function ReactorData.new(reactor)
    local self = setmetatable(PeripheralData.new(reactor), ReactorData)
    self:initData()
    return self
end

function ReactorData:fetchData()
    self.damagePercent = self.wrappedPeripheral.getDamagePercent() / 100
    self.coolantPercent = self.wrappedPeripheral.getCoolantFilledPercentage()
    self.heatedCoolantPercent = self.wrappedPeripheral.getHeatedCoolantFilledPercentage()
    self.fuelPercent = self.wrappedPeripheral.getFuelFilledPercentage()
    self.wastePercent = self.wrappedPeripheral.getWasteFilledPercentage()
    self.active = self.wrappedPeripheral.getStatus()
end

function ReactorData:initData()
    self.damagePercent = 0
    self.coolantPercent = 0
    self.heatedCoolantPercent = 0
    self.fuelPercent = 0
    self.wastePercent = 0
    self.active = false
end

return ReactorData

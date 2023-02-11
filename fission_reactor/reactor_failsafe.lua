local reactor = peripheral.wrap("back")
 
local blah = peripheral.getMethods("back")
 
local running = true
 
while running do
 
    local dmg = reactor.getDamagePercent()
    local cool = reactor.getCoolantFilledPercentage()
    print(dmg .. ", " .. cool)
    if dmg > 0 or cool < 0.8 then
        if reactor.getStatus() then
            reactor.scram()
            running = false
        end
    end
 
    sleep(0.1)
end
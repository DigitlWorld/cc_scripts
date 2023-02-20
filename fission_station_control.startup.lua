package.path = "/cc_scripts/?.lua;" .. package.path

local FissionStationControl = require("FissionStationControl")

local gStarting = true
local gRestart = false

while gStarting do

    local reactor = peripheral.find("fissionReactorLogicAdapter")

    -- Safety shutdown. If this program is starting and crashes
    -- because  other components weren't available (like after a server restart 
    -- with partially loaded chunks), then the reactor isn't going to be 
    -- monitored and should be shutdown until monitoring starts.
    if reactor ~= nil and reactor.getStatus() then
        gRestart = true
        reactor.scram()
    end

    local boiler = peripheral.wrap("boilerValve")
    local turbine = peripheral.wrap("turbineValve")
    local monitor = peripheral.wrap("monitor")

    local indMatrix = peripheral.wrap("inductionPort")
    local heater = peripheral.wrap("resistiveHeater")

    -- If all of the parts are available, start up the main loop.
    if reactor ~= nil and boiler ~= nil and turbine ~= nil and indMatrix ~= nil and heater ~= nil then
        gStarting = false

        local controller = FissionStationControl.new(reactor, boiler, turbine, indMatrix, heater, monitor)

        -- If we shutdown the reactor when we started, restart it here once
        -- the monitoring system is likely to start.
        if gRestart then
            reactor.activate()
        end

        controller:run()
    end
    sleep(0.1)
end

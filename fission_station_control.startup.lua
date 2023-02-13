package.path = "/cc_scripts/?.lua;" .. package.path

local FissionStationControl = require("FissionStationControl")

local reactor = peripheral.wrap("<reactor name>")
local boiler = peripheral.wrap("<boiler name>")
local turbine = peripheral.wrap("<turbine name>")
local monitor = peripheral.wrap("<monitor name>")
local indMatrix = peripheral.wrap("<matrix name>")
local heater = peripheral.wrap("<heater name>")

local controller = FissionStationControl.new(reactor, boiler, turbine, indMatrix, heater, monitor)

controller:run()

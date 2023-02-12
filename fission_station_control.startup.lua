package.path = "/cc_scripts/?.lua;" .. package.path

local FissionStationControl = require("FissionStationControl")

local reactor = peripheral.wrap("<reactor name>")
local boiler = peripheral.wrap("<boiler name>")
local turbine = peripheral.wrap("<turbine name>")
local monitor = peripheral.wrap("<monitor name>")

local controller = FissionStationControl.new(reactor, boiler, turbine, monitor)

controller:run()

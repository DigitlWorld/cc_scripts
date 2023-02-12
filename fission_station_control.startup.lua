package.path = "/cc_scripts/?.lua;" .. package.path

local FissionStationControl = require("FissionStationControl")

local reactor = peripheral.wrap("<reactor name>")
local turbine = peripheral.wrap("<turbine name>")
local monitor = peripheral.wrap("<monitor name>")

local controller = FissionStationControl.new(reactor, turbine, monitor)

controller:run()

-- Root script for getting latest version of the rest of the scripts
local gDesiredBranch = ...

if gDesiredBranch == nil then
    gDesiredBranch = "master"
end

if not fs.exists( "/github_download.lua" ) then
    shell.execute( "wget", "https://raw.githubusercontent.com/DigitlWorld/cc_scripts/master/github_download.lua", "/github_download.lua")
end

if fs.exists( "/cc_scripts") then
    fs.delete( "/cc_scripts" )
end

shell.execute( "/github_download.lua", "DigitlWorld", "cc_scripts", ".", ".", gDesiredBranch)

if fs.exists("/cc_scripts/update.lua") then
    fs.delete( "/update.lua" )
    fs.copy( "/cc_scripts/update.lua", "/update.lua" )
end

if fs.exists("/cc_scripts/github_download.lua") then
    fs.delete( "/github_download.lua" )
    fs.copy( "/cc_scripts/github_download.lua", "/github_download.lua" )
end

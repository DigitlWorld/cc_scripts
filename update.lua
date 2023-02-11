-- Root script for getting latest version of the rest of the scripts
if not fs.exists( "/github_download.lua" ) then
    shell.execute( "wget", "download", "https://raw.githubusercontent.com/DigitlWorld/cc_scripts/master/github_download.lua", "/github_download.lua")
end

if fs.exists( "/cc_scripts") then
    fs.delete( "/cc_scripts" )
end

shell.execute( "/github_download.lua", "DigitlWorld", "cc_scripts", ".", ".", "master")

if fs.exists("/cc_scripts/update.lua") then
    fs.copy( "/cc_scripts/update.lua", "/update.lua" )
end

if fs.exists("/cc_scripts/github_download.lua") then
    fs.copy( "/cc_scripts/github_download.lua", "/github_download.lua" )
end

-- Root script for getting latest version of scripts
local gRawServer = "raw.githubusercontent.com"

local gUser = "DigitlWorld"
local gRepo = "cc_scripts"
local gRef = "master"

-- Download File
function downloadFile( path, url, name )
    writeCenter("Downloading File: "..name)
    dirPath = path:gmatch('([%w%_%.% %-%+%,%;%:%*%#%=%/]+)/'..name..'$')()
    if dirPath ~= nil and not fs.isDir(dirPath) then fs.makeDir(dirPath) end
    local content = http.get(url)
    local file = fs.open(path,"w")
    file.write(content.readAll())
    file.close()
end

downloadFile( ., "https://" .. gRawServer .. "/" .. gUser .. "/" .. gRepo .. "/github_download.lua", "github_download.lua" )

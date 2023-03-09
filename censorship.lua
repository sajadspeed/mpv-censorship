local mp = require 'mp'
local msg = require 'mp.msg'
local utils = require 'mp.utils'

local open = io.open
local censorData = {}

function fileExist(path)
	local f = io.open(path, "r")
	if f then f:close() end
	return f ~= nil
end

function readFileLines(path)
	if not fileExist(path) then return false end
	
	local fileLines = io.lines(path) 
	local lines = {}
	for line in fileLines do 
		if line ~= "\n" and line ~= "\r\n" and line ~= '' then
			lines[#lines + 1] = line
		end
	end
	return lines
end

function stringSplit (string, sep)
	if sep == nil then
			sep = "%s"
	end
	local t={}
	for str in string.gmatch(string, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

function timeToSeconds(time)
	local timeArray=stringSplit(time, ":")

	return (tonumber(timeArray[1])*3600)+(tonumber(timeArray[2])*60)+tonumber(timeArray[3])
end

function getProtocol(filename, def)
    return string.lower(filename):match("^(%a[%w+-.]*)://") or def
end

function joinPath(working, relative)
    return getProtocol(relative) and relative or utils.join_path(working, relative)
end

function fixPath(str, is_directory)
    str = string.gsub(str, [[\]],[[/]])
    str = str:gsub([[/%./]], [[/]])
    if is_directory and str:sub(-1) ~= '/' then str = str..'/' end
    return str
end

function start()
    local censorFilePath = joinPath(mp.get_property('working-directory', ''), mp.get_property('path'))
    censorFilePath = fixPath(censorFilePath, false)
	censorFilePath = string.match(censorFilePath, "(.+)%..+$") .. ".censor"
	
	local fileLines = readFileLines(censorFilePath)
	
	if fileLines == false then return false end
	
	local errors = {}
	
	local censorDataCount = 0
	for key, value in pairs(fileLines) do
		valueSanitize = string.match(value, "%d+:%d+:%d+ +%d+")
		if valueSanitize ~= nil then
			local valueSplit = stringSplit(valueSanitize, " ")
			censorData[timeToSeconds(valueSplit[1])] = valueSplit[2]
			censorDataCount = censorDataCount + 1
		else
			errors[#errors + 1] = value
		end
	end
	
	if #errors > 0 then
		local errorMessage = "!!! Censorship errors !!!\n"
		for key, value in pairs(errors) do
			errorMessage = errorMessage .. value .. "\n"
		end
		mp.osd_message(errorMessage, #errors + 1)
	else
		mp.osd_message("Censorship successful...", 2)
	end
	
	if censorDataCount > 0 then
		local prevSecond = 0
		mp.observe_property('playback-time', 'number', 
			function(name, val)
				if val ~= nil then
					val = math.floor(val)
					
					if prevSecond ~= val then
						prevSecond = val
						tick(val)
					end
				end
			end
		)
	end
end

function tick(second)
	print(second)
	for key, value in pairs(censorData) do
		if key == second then
			mp.commandv('seek', value, "exact")
			print("Jump", value .. 's')
		end
	end
end 

mp.register_event('file-loaded', start)
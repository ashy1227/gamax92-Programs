local component = require("component")
local shell = require("shell")

local arg, options = shell.parse(...)
if #arg < 1 then
	print("Usage: setvolume volume")
	print("Set the playback volume of a tape drive.")
	print("Options:")
	print(" --address=addr  use tapedrive at address")
	return
end
if tonumber(arg[1]) == nil or tonumber(arg[1]) < 0.0 or tonumber(arg[1]) > 1.0 then
	error("Invalid volume", 2)
end
local volume = tonumber(arg[1])
local td
if options.address then
	if type(options.address) ~= "string" or options.address == "" then
		error("Invalid address", 2)
	end
	local fulladdr = component.get(options.address)
	if fulladdr == nil then
		error("No component at address", 2)
	elseif component.type(fulladdr) ~= "tape_drive" then
		error("Component specified is a " .. component.type(fulladdr), 2)
	end
	
	td = component.proxy(fulladdr)
else
	td = component.tape_drive
end

td.setVolume(volume)
print("Tape drive volume set to " .. volume)

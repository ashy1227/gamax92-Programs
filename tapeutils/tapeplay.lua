local component = require("component")
local shell = require("shell")

local arg, options = shell.parse(...)
if #arg < 1 then
	print("Usage: tapeplay start|stop")
	print("Start or stop tape playback on a tape drive.")
	print("Options:")
	print(" --address=addr  use tapedrive at address")
	return
end
local operation = arg[1]

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
if not td.isReady() then
	error("No tape present", 2)
end

if operation == "start" then
	td.play()
	print("Resumed tape playback.");
elseif operation == "stop" then
	td.stop()
	print("Stopped tape playback.");
else
	error("Invalid operation. Valid operations are: \"play\", \"stop\"", 2)
end
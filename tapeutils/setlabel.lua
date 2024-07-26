local component = require("component")
local shell = require("shell")

local arg, options = shell.parse(...)
if #arg < 1 then
	print("Usage: setlabel label")
	print("Set the label on a tape.")
	print("Options:")
	print(" --address=addr  use tapedrive at address")
	return
end
local label = arg[1]

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

td.setLabel(label)
print("Tape label set to \"" .. label .. "\"")

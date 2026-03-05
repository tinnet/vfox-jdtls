local http = require("http")

--- Return all available versions provided by this plugin
--- @param ctx table Empty table used as context, for future extension
--- @return table Descriptions of available versions and accompanying tool descriptions
function PLUGIN:Available(ctx)
	local resp, err = http.get({
		url = "https://download.eclipse.org/jdtls/milestones/",
	})
	if err ~= nil or resp.status_code ~= 200 then
		return {}
	end

	local result = {}
	-- The Eclipse directory listing uses absolute paths like /jdtls/milestones/1.57.0
	for version in resp.body:gmatch("/jdtls/milestones/(%d+%.%d+%.%d+)") do
		table.insert(result, { version = version, note = "" })
	end

	-- Deduplicate (versions appear twice in the HTML: href and link text context)
	local seen = {}
	local deduped = {}
	for _, entry in ipairs(result) do
		if not seen[entry.version] then
			seen[entry.version] = true
			table.insert(deduped, entry)
		end
	end

	-- Sort descending (newest first)
	table.sort(deduped, function(a, b)
		return a.version > b.version
	end)

	return deduped
end

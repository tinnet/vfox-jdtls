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

	-- Sort descending (newest first) using numeric semver comparison
	local function semver_gt(va, vb)
		local a1, a2, a3 = va:match("(%d+)%.(%d+)%.(%d+)")
		local b1, b2, b3 = vb:match("(%d+)%.(%d+)%.(%d+)")
		a1, a2, a3 = tonumber(a1), tonumber(a2), tonumber(a3)
		b1, b2, b3 = tonumber(b1), tonumber(b2), tonumber(b3)
		if a1 ~= b1 then return a1 > b1 end
		if a2 ~= b2 then return a2 > b2 end
		return a3 > b3
	end
	table.sort(deduped, function(a, b)
		return semver_gt(a.version, b.version)
	end)

	return deduped
end

local http = require("http")

--- Return all available versions provided by this plugin
--- @param ctx table Empty table used as context, for future extension
--- @return table Descriptions of available versions and accompanying tool descriptions
function PLUGIN:Available(ctx)
  local resp, err = http.get({
    url = "https://download.eclipse.org/jdtls/milestones/"
  })
  if err ~= nil or resp.status_code ~= 200 then
    error("Failed to fetch jdtls milestones: " .. (err or "HTTP " .. resp.status_code))
  end

  local result = {}
  for version in resp.body:gmatch('href="(%d+%.%d+%.%d+)/"') do
    table.insert(result, { version = version, note = "" })
  end

  -- Sort descending (newest first)
  table.sort(result, function(a, b)
    return a.version > b.version
  end)

  return result
end

local http = require("http")

--- Returns pre-installed information: version number, download URL, checksum.
--- Resolves the timestamped filename by scraping the milestone directory.
--- @param ctx table
--- @field ctx.version string User-input version
--- @return table Version information
function PLUGIN:PreInstall(ctx)
  local version = ctx.version

  -- Step 1: fetch version directory listing to find timestamped filename
  local dirUrl = "https://download.eclipse.org/jdtls/milestones/" .. version .. "/"
  local resp, err = http.get({ url = dirUrl })
  if err ~= nil or resp.status_code ~= 200 then
    error("Failed to fetch jdtls milestone directory for " .. version)
  end

  -- Match the tarball filename (includes build timestamp)
  local pattern = '(jdt%-language%-server%-' .. version:gsub("%.", "%%.") .. '%-%d+%.tar%.gz)'
  local filename = resp.body:match("'" .. pattern .. "'")
  if not filename then
    filename = resp.body:match('"' .. pattern .. '"')
  end
  if not filename then
    filename = resp.body:match(pattern)
  end
  if not filename then
    error("Could not find jdtls tarball for version " .. version)
  end

  -- Step 2: fetch sha256 checksum
  local sha256 = nil
  local shaResp, shaErr = http.get({ url = dirUrl .. filename .. ".sha256" })
  if shaErr == nil and shaResp.status_code == 200 then
    sha256 = shaResp.body:match("^(%x+)")
  end

  return {
    version = version,
    url = dirUrl .. filename,
    sha256 = sha256,
  }
end

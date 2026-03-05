--- Called after installation. Removes Windows-only config directories.
--- @param ctx table
--- @field ctx.rootPath string SDK installation directory
function PLUGIN:PostInstall(ctx)
  local rootPath = ctx.rootPath
  os.execute("rm -rf " .. rootPath .. "/config_win " .. rootPath .. "/config_win_arm")
end

--- Define environment variables for jdtls.
--- @param ctx table Context information
--- @field ctx.path string SDK installation directory
function PLUGIN:EnvKeys(ctx)
	local mainPath = ctx.path
	return {
		{ key = "JDTLS_HOME", value = mainPath },
		{ key = "PATH", value = mainPath .. "/bin" },
	}
end

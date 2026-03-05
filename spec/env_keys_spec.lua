-- spec/env_keys_spec.lua
require("spec.spec_helper")

describe("hooks/env_keys.lua", function()
	setup(function()
		-- Load the hook script
		local f = loadfile("hooks/env_keys.lua")
		if f then
			f()
		end
	end)

	it("should correctly define environment variables for JDTLS", function()
		local ctx = { path = "/path/to/jdtls" }
		local envs = PLUGIN:EnvKeys(ctx)

		assert.is_not_nil(envs)
		assert.are_equal(2, #envs)

		-- JDT_HOME
		assert.are_equal("JDTLS_HOME", envs[1].key)
		assert.are_equal("/path/to/jdtls", envs[1].value)

		-- PATH
		assert.are_equal("PATH", envs[2].key)
		assert.are_equal("/path/to/jdtls/bin", envs[2].value)
	end)
end)

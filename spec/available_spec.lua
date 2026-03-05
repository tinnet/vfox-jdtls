-- spec/available_spec.lua
require("spec.spec_helper")

describe("hooks/available.lua", function()
	setup(function()
		-- Load the hook script
		local f = loadfile("hooks/available.lua")
		if f then
			f()
		end
	end)

	it("should correctly extract and deduplicate versions from HTML", function()
		local mock_html = [[
            <a href="/jdtls/milestones/1.57.0">1.57.0</a>
            <a href="/jdtls/milestones/1.57.0">1.57.0</a>
            <a href="/jdtls/milestones/1.56.0">1.56.0</a>
            <a href="/jdtls/milestones/1.58.0">1.58.0</a>
        ]]
		mock_http_response(mock_html)

		local versions = PLUGIN:Available({})

		assert.is_not_nil(versions)
		-- Check count (deduplicated)
		assert.are_equal(3, #versions)
	end)

	it("should correctly sort versions descending by semver", function()
		local mock_html = [[
            <a href="/jdtls/milestones/1.9.0">1.9.0</a>
            <a href="/jdtls/milestones/1.10.0">1.10.0</a>
            <a href="/jdtls/milestones/1.57.0">1.57.0</a>
        ]]
		mock_http_response(mock_html)

		local versions = PLUGIN:Available({})

		-- Check sorting: 1.57.0, 1.10.0, 1.9.0
		assert.are_equal("1.57.0", versions[1].version)
		assert.are_equal("1.10.0", versions[2].version)
		assert.are_equal("1.9.0", versions[3].version)
	end)

	it("should handle HTTP errors gracefully", function()
		mock_http_error("Connection timeout")

		local versions = PLUGIN:Available({})

		assert.are_equal(0, #versions)
	end)
end)

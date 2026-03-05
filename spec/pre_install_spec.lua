-- spec/pre_install_spec.lua
require("spec.spec_helper")

describe("hooks/pre_install.lua", function()
	setup(function()
		-- Load the hook script
		local f = loadfile("hooks/pre_install.lua")
		if f then
			f()
		end
	end)

	it("should correctly resolve the download URL for a version", function()
		local version = "1.57.0"
		local mock_html = [[
            <a href="jdt-language-server-1.57.0-202602261110.tar.gz">jdt-language-server-1.57.0-202602261110.tar.gz</a>
        ]]
		mock_http_response(mock_html)

		local info = PLUGIN:PreInstall({ version = version })

		assert.is_not_nil(info)
		assert.are_equal(version, info.version)
		assert.are_equal(
			"https://download.eclipse.org/jdtls/milestones/1.57.0/jdt-language-server-1.57.0-202602261110.tar.gz",
			info.url
		)
	end)

	it("should fail if no tarball matches the version", function()
		mock_http_response("No files here")

		assert.has_error(function()
			PLUGIN:PreInstall({ version = "1.57.0" })
		end, "Could not find jdtls tarball for version 1.57.0")
	end)

	it("should resolve the sha256 checksum if available", function()
		local version = "1.57.0"
		local filename = "jdt-language-server-1.57.0-202602261110.tar.gz"
		local mock_html = '<a href="' .. filename .. '">' .. filename .. "</a>"
		local mock_sha256 = "1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef some-file.tar.gz"

		-- Simple mock for multiple sequential http calls (first HTML, then SHA256)
		local calls = 0
		local http = require("http")
		http.get = function()
			calls = calls + 1
			if calls == 1 then
				return { body = mock_html, status_code = 200 }, nil
			else
				return { body = mock_sha256, status_code = 200 }, nil
			end
		end

		local info = PLUGIN:PreInstall({ version = version })

		assert.are_equal("1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef", info.sha256)
	end)

	it("should handle missing sha256 checksum gracefully", function()
		local version = "1.57.0"
		local calls = 0
		local http = require("http")
		http.get = function()
			calls = calls + 1
			if calls == 1 then
				return { body = 'href="jdt-language-server-1.57.0-202602261110.tar.gz"', status_code = 200 }, nil
			else
				-- Checksum not found
				return { body = "Not Found", status_code = 404 }, nil
			end
		end

		local info = PLUGIN:PreInstall({ version = version })

		assert.is_not_nil(info)
		assert.is_nil(info.sha256)
	end)
end)

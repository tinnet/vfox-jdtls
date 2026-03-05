-- spec/spec_helper.lua
_G.PLUGIN = {}

-- Tiny assertion library
_G.assert = {
	are_equal = function(expected, actual)
		if expected ~= actual then
			error(string.format("Expected [%s], got [%s]", tostring(expected), tostring(actual)), 2)
		end
	end,
	is_not_nil = function(val)
		if val == nil then
			error("Expected value to be not nil", 2)
		end
	end,
	is_nil = function(val)
		if val ~= nil then
			error(string.format("Expected value to be nil, but got [%s]", tostring(val)), 2)
		end
	end,
	has_error = function(f, expected_err)
		local ok, err = pcall(f)
		if ok then
			error("Expected function to error, but it succeeded", 2)
		end
		if expected_err and not tostring(err):find(expected_err, 1, true) then
			error(string.format("Expected error [%s], got [%s]", expected_err, tostring(err)), 2)
		end
	end,
}

-- Mock http module
local http_mock = {
	get = function() end,
}
package.loaded["http"] = http_mock

function _G.mock_http_response(body, status_code)
	http_mock.get = function()
		return { body = body, status_code = status_code or 200 }, nil
	end
end

function _G.mock_http_error(err)
	http_mock.get = function()
		return nil, err
	end
end

-- BDD-like syntax for readability
function _G.describe(name, fn)
	print("  " .. name)
	fn()
end

function _G.it(name, fn)
	local ok, err = pcall(fn)
	if ok then
		print("    ✓ " .. name)
	else
		print("    ✗ " .. name)
		error(err, 0)
	end
end

function _G.setup(fn)
	fn()
end

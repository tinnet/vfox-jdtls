-- spec/run_tests.lua
local function run_spec(name)
	print("Running " .. name .. "...")
	local success, err = pcall(require, "spec." .. name)
	if not success then
		print("FAILED " .. name .. ": " .. tostring(err))
		os.exit(1)
	end
end

-- Force package path to include current dir
package.path = "./?.lua;" .. package.path

run_spec("available_spec")
run_spec("pre_install_spec")
run_spec("env_keys_spec")

print("\nALL TESTS PASSED!")

local docopt = require 'docopt'

--- Assert one doc string, may expect an error.
--
-- @param      doc          The doc string
-- @param[opt] expected_err Error name, if you expect one
local function check_parse(doc, expected_err)
	local res, err = docopt.parse(doc)
	if expected_err then
		assert.is_nil(res)
		local expected = docopt.errors[expected_err]
		assert.equal(expected, err:sub(1, #expected))
	else
		assert.is_nil(err)
		assert.truthy(res)
	end
end

--- Run a batch of tests
--
-- @param tests Table of tests, which should be tables {doc, expected_err}
local function test_all(tests)
	for i, t in ipairs(tests) do
		it(i, function()
			check_parse(t[1], t[2])
		end)
	end
end


describe("Doc parsing", function()
	describe("#success", function()
		describe("#usage", function()
			test_all{
{[[usage: prog]]},
{[[usage: prog <arg>]]},
{[[usage:     with_spaces
              with_spaces]]},
{[[usage:	with_tabs
			with_tabs]]},
{[[After some text, it works:
Usage: prog]]},
{[[Doesn't matter the CaSe:
uSaGe: prog]]},
			}
		end)
	end)

	describe("#error", function()
		describe("#usage", function()
			test_all{
{"there's no use", "MissingUsage"},
			}
		end)
	end)
end)

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
	describe("#usage #success", function()
		test_all{
{[[usage: prog]]},
{[[usage:
  prog]]},
{[[usage: prog <arg>]]},
{[[usage:     with_spaces
              with_spaces]]},
{[[usage:	with_tabs
			with_tabs]]},
{[[There may be text in the same line before Usage: prog]]},
{[[After some text, it works:
Usage: prog]]},
{[[Doesn't matter the CaSe:
uSaGe: prog]]},
{[[Usage: prog [options]

-o --output  Output file [default: a.out]
-h --help]]},
		}
	end)

	describe("#usage #error", function()
		test_all{
{[[there's no use]], "MissingUsage"},
{[[No spaces after usage :]], "MissingUsage"},
{[[there has to be the program name
usage:]], "MissingProgram"},
{[[there must be consistency in the program name
usage: prog
       no-prog]], "ProgramMismatch"},
{[[usage: prog

Cannot have another usage:]], "MuchUsage"},
		}
	end)

	describe("#option #error", function()
		test_all{
{[[usage: ambiguous-options

-o
-o]], "AmbiguousOption"},
{[[usage: 3options

-o --out ---output]], "InvalidArgument"},
		}
	end)
end)

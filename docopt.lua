--[[ No need for this, for now...
local C     = require 'pl.comprehension' . new()
local class = require 'pl.class'


--
-- Other utilities.
--

local function flatten(...)
    local flat_list = {}
    local flat_list_next = 1
    for i = 1, select('#', ...) do
        local t = select(i, ...)
        for j = 1, #t do
            flat_list[flat_list_next] = t[j]
            flat_list_next = flat_list_next + 1
        end
    end
end

local Ether
local Required
--
-- Pattern class.
--
local Pattern = class()

function Pattern:_init(name, ...)
    self.name = assert(name)
    self.children = {...}
end

function Pattern:__eq(other)
    return __tostring(self) == __tostring(other)
end

function Pattern:__tostring()
    local children_repr = ""
    for i, child in pairs(self.children) do
        children_repr = children_repr .. tostring(child)
    end
    return string.format("%s(%s)", self.name, children_repr)
end

function Pattern:flat()
    if not self.children then return {self} end
    return flatten(unpack(self.children))
end

function Pattern:fix()
    self:fix_identities()
    self:fix_list_arguments()
    return self
end

--- Make pattern-tree tips point to the same object if they are equal.
function Pattern:fix_identities(uniq)
    if not self.children then
        return self
    end
    uniq = uniq or set(self:flat())
    for i, c in ipairs(self.children) do
        if not c.children then
            -- assert( c in uniq )
            -- self.children[i] = uniq[uniq.index(c)]
        else
            c:fix_identities(uniq)
        end
    end
end

--- Find arguments that should accumulate values and fix them.
function Pattern:fix_list_arguments()
end

--- Transform pattern into an equivalent, with only top-level Either.
function Pattern:either()
end
--]]

--------------------------------------------------------------------------------
local docopt = {
	VERSION = "0.0.1",
	errors = {},
}

-- Parser errors
local re = require 'relabel'

local parseErrors = {}
parseErrors[0] = "PEG couldn't parse"
parseErrors.PegError = 0
local function addError(label, msg)
	table.insert(parseErrors, msg)
	parseErrors[label] = #parseErrors
	docopt.errors[label] = msg
end
addError("MissingUsage", [["usage:" (case insensitive) not found]])
addError("MuchUsage", [[More than one "usage:" (case insensitive) found]])
addError("ProgramMismatch", [[Program name mismatch between usages]])
addError("MissingProgram", [[Program name not found after "usage:" (case insensitive)]])
re.setlabels(parseErrors)


local grammar = re.compile[[
Docopt <- {| NoUsage (Usage / %{MissingUsage}) {:usage: Patterns :} NoUsage |} (!. / %{MuchUsage})

Usage <- [Uu][Ss][Aa][Gg][Ee]":"
Patterns <- Sp ({:program: [_%w.%-]+ :} / %{MissingProgram}) Sp {| Pattern
            (%nl Sp =program (%s+ Pattern)?)* |}
			(((%nl Sp (%nl / !.)) / !.) / %{ProgramMismatch})
Pattern <- UntilEOL

NoUsage <- (!Usage .)*
-- NoUsage <- (!Usage (Option / .)*
-- Option <- {| ShortOption " " LongOption / ShortOption / LongOption |} (("  " / "\t") UntilEOL)?

UntilEOL <- [^%nl]*
Sp <- (!%nl %s)*
S <- %s*
]]

function docopt.parse(doc)
	local res, label, suf = grammar:match(doc)
	if res then
		return res
	else
		local whereErr = #doc - #suf
		local lin, col = re.calcline(doc, whereErr)
		return nil, string.format("%s at %d:%d", parseErrors[label], lin, col)
	end
end


--- Process command-line arguments based on help string.
--
-- docopt() will parse the help message to see what the value usage cases
-- are, and also to see the options.  Then it will parse the list of
-- command line arguments to validate them.
--
-- If the arguments are in a correct form, they are returned
-- as a structured table.  Otherwise (if a non-existent argument is used
-- for example) docopt will print the help message and exit.
--
-- @param help_message Command line help text which shows the usage and
-- lists all the options available.
-- @param arg_list (optional) A list of command line arguments to
-- process. Defaults to the global 'arg' if arg_list is nil.
-- @param version (optional) The version of the program.
-- @param default_help (optional) By default, docopt() will print the
-- doc_string and exit if '-h' or '--help' is the only command-line
-- argument.  If default_help is false, docopt() will just return
-- normally with the '-h' option set to true.
--
-- @return A table with all the arguments as string keys if the use of the
-- arguments is valid.
function docopt.docopt(doc, args, help, version, options_first)
	assert(doc, "[docopt] Missing required argument 'doc'")
	-- Arguments can be passed in as a table, for keyword args
	if type(args) == "table" then
		options_first = args.options_first
		version = args.version
		help = args.help
		args = args.args
	end
	args = args or arg
	return parse(doc)
end


return docopt

# docopt.lua

[![Build Status](https://travis-ci.org/gilzoide/docopt.lua.svg?branch=master)](https://travis-ci.org/gilzoide/docopt.lua)

# What works

- [ ] Help message parsing
- [ ] Command line parsing

# Lua Port of the docopt Command Line Processor

[docopt](http://docopt.org) creates _beautiful_ command-line interfaces.

docopt is a parser for program command line help messages. It will use the
help message itself to validate the arguments passed into the program, and from
that it will generate a handy table of the arguments. Create the nicely
formatted help message and then let docopt take care of the rest!

This is the [Lua](http://www.lua.org) port of the original Python
implementation.

# Installation

Install using [LuaRocks](https://luarocks.org/):

	$ luarocks make

or just put the `docopt.lua` file in your Lua modules search path.

# Basic Usage

In your main code (in this case `simple_find.lua`) put:

```lua
local DOC = require 'docopt'  -- Any local name is fine.

local argument_help = [[
Simple Find Command.

Usage:
  simple_find.lua [-r] dir [<dirname>]
  simple_find.lua [-r] file [<filename>]
  simple_find.lua (-h | --help)
  simple_find.lua --version

Options:
  -h --help         Show this screen.
  --version         Show the program version.
  -r --recursive    Recursively search subdirectories too.
]]

local processed_args, err = DOC.docopt(argument_help)  -- Parse `arg` by default
assert(processed_args, err)  -- docopt returns meaningful error messages

if processed_args["<dirname>"] then
    -- Directory name search
elseif processed_args["<filename>"] then
    -- File name search
end
```

# Dependencies

docopt.lua requires [LPegLabel](https://github.com/sqmedeiros/lpeglabel/), and
is compatible with Lua 5.1, 5.2 and 5.3.

# Testing

Run automated tests using [busted](http://olivinelabs.com/busted/):

	$ busted

# Copyright and License

This project is distributed under the 
[MIT License](http://www.opensource.org/licenses/mit-license.html), 
reproduced below:
```
Copyright (c) 2017 Gil Barbosa Reis <gilzoide@gmail.com>,
              2012 Vladimir Keleshev <vladimir@keleshev.com>, 
                   James Graves <james.c.graves.jr@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
``` 

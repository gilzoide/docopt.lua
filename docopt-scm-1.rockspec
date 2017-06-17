package = 'docopt'
version = 'scm-1'
source = {
	url = 'git://github.com/gilzoide/docopt.lua',
}
description = {
	summary = 'A command line arguments parser that will make you smile',
	detailed = [[
docopt is a parser for program command line help messages. It will use the help
message itself to validate the arguments passed into the program, and from that
it will generate a handy table of the arguments. Create the nicely formatted
help message, and then let docopt take care of the rest!]],
	license = 'MIT',
	maintainer = 'gilzoide <gilzoide@gmail.com>'
}
dependencies = {
	'lua >= 5.1',
	'lpeglabel',
}
build = {
	type = 'builtin',
	modules = {
		molde = 'docopt.lua'
	}
}

require 'colors'
args = process.argv.slice 2

usage = """

      Usage: #{'npm-christmas'.cyan} [wrap or unwrap] (defaults to unwrap)
      
      unwrap: Your package.json file will have it's dependency versions replaced with *
      wrap: Your package.json file will pick up versions from your currently installed packages
      
      Use npm shrinkwrap for a more robust wrap
   
"""

if args.length > 2
	console.error usage
	process.exit 1

if args.length is 1 and !(args[0] in ['wrap', 'unwrap'])
	console.error usage
	process.exit 1

technique = 'unwrap'
technique = args[0] if args.length is 1

exists = require('fs').existsSync
resolve = require('path').resolve
write = require('fs').writeFileSync

path = resolve process.cwd(), 'package.json'

if !exists path
	console.error '   Expecting package.json in the current directory'.red
	console.error()
	process.exit 1

content = require path

if !content?
	console.error()
	console.error '   Expecting package.json in the current directory'.red
	console.error()
	process.exit 1

if !content.dependencies?
	console.log()
	console.log '   No dependencies in package.json'.cyan
	console.log()
	process.exit 0

if technique is 'wrap'
	dirpath = resolve process.cwd(), 'node_modules'
	
	if !exists path
		console.log()
		console.log '   No node_modules directory'.cyan
		console.log()
		process.exit 0
	
	console.log()
	dir = require('fs').readdirSync
	stat = require('fs').statSync
	atleastone = no
	
	for d in dir dirpath
		packagedir = resolve dirpath, d 
		if stat(packagedir).isDirectory()
			packagefile = resolve packagedir, 'package.json'
			continue if !exists packagefile
			packagecontent = require packagefile
			continue if !packagecontent? or !packagecontent.name? or !packagecontent.version?
			if content.dependencies[packagecontent.name]?
				continue if content.dependencies[packagecontent.name] is packagecontent.version
				content.dependencies[packagecontent.name] = packagecontent.version
				console.log " √ Locking #{packagecontent.name} to #{packagecontent.version}".green
				atleastone = yes
	
	if !atleastone
		console.log '   No presents needed wrapping'.cyan
		console.log()
		process.exit 0
	
	write path, JSON.stringify content, null, 2

	console.log()
	console.log '   Presents wrapped'
	console.log()
	
	return

atleastone = no
console.log()
for dependency of content.dependencies
	continue if content.dependencies[dependency] is '*'
	console.log " √ Releasing #{dependency} from #{content.dependencies[dependency]} to *".green
	content.dependencies[dependency] = '*'
	atleastone = yes
	
	
if !atleastone
	console.log '   No presents needed unwrapping'.cyan
	console.log()
	process.exit 0

write path, JSON.stringify content, null, 2

console.log()
console.log '   Presents unwrapped'
console.log()
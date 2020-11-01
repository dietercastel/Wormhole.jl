using Pkg

reqs = ["Conda", "PyCall"]

# By kristoffer.carlsson
# https://discourse.julialang.org/t/how-to-use-pkg-dependencies-instead-of-pkg-installed/36416/10
isinstalled(pkg::String) = any(x -> x.name == pkg && x.is_direct_dep, values(Pkg.dependencies()))

function pkgSetup()
	toInstall = filter!(isinstalled, reqs)
	println(toInstall)
	map(x -> Pkg.add(x), toInstall)
end

using Conda
function condaSetup()
	Conda.add("magic-wormhole",channel="conda-forge")
end

using PyCall
function pySetup()
	os = pyimport("os")
end


function doSetup()
	pkgSetup()
	condaSetup()
	return pySetup() 
end


osPyModule = doSetup()

function test()
	osPyModule.system("conda run wormhole --help")
end

function runCommand(str)
	osPyModule.system("conda activate base & $str")
end

function receive(word)
	runCommand("wormhole receive $word")
end

function sendText(txt)
	osPyModule.system("conda run wormhole send --text $txt")
	#osPyModule.system("conda activate base & wormhole send --text $txt")
end

#Todo macro for ease of use (no quotes)

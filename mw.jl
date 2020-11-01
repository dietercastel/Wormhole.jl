using Pkg

reqs = ["Conda", "PyCall"]

# By kristoffer.carlsson
# https://discourse.julialang.org/t/how-to-use-pkg-dependencies-instead-of-pkg-installed/36416/10
isinstalled(pkg::String) = any(x -> x.name == pkg && x.is_direct_dep, values(Pkg.dependencies()))

function setup()
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

function test(os)
	os.system("conda run wormhole --help")
end

function runCommand(str)
	os.system("conda activate base & $str")
end

function receive(word)
	runCommand("wormhole receive $word")
end

function sendText(txt)
	os.system("conda run wormhole send --text $txt")
	#os.system("conda activate base & wormhole send --text $txt")
end


#Todo macro for ease of use (no quotes)

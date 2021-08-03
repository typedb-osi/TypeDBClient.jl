using Base: runtests

using Behavior
using Behavior.Gherkin
using TypeDBClient

g = TypeDBClient
client = g.CoreClient("localhost",1729)

rootpath = joinpath(@__DIR__, "test/behaviour")
featurepath = joinpath(@__DIR__,"test/behaviour/features")
stepspath = joinpath(@__DIR__,"test/behaviour")
configpath = joinpath(@__DIR__,"test/behaviour/config/ConfigEnvironment.jl")

p = ParseOptions(allow_any_step_order = true)

# runspec(rootpath; featurepath = featurepath, stepspath = stepspath,  parseoptions=p, execenvpath = configpath, tags="not @ignore-typedb-core")

function run_tests()
    runspec(rootpath; featurepath = featurepath, stepspath = stepspath,  parseoptions=p, execenvpath = configpath, tags="@actual")
    # runspec(rootpath; featurepath = featurepath, stepspath = stepspath,  parseoptions=p, execenvpath = configpath)
end


run_tests()

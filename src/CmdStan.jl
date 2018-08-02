module CmdStan

using Compat, Pkg, Documenter, DelimitedFiles, Unicode, Statistics

"""
The directory which contains the cmdstan executables such as `bin/stanc` and 
`bin/stansummary`. Inferred from `Main.CMDSTAN_HOME` or `ENV["CMDSTAN_HOME"]`
when available. Use `set_cmdstan_home!` to modify.
"""
CMDSTAN_HOME=""

function __init__()
  if !isdefined(Main, :JULIA_CMDSTAN_HOME)
    if haskey(ENV, "JULIA_CMDSTAN_HOME")
        global CMDSTAN_HOME = ENV["JULIA_CMDSTAN_HOME"]
    else
        @warn("Environment variable CMDSTAN_HOME not set. Use set_cmdstan_home!.")
        ""
    end
  end
end

"""Set the path for the `CMDSTAN_HOME` environment variable.
    
Example: `set_cmdstan_home!(homedir() * "/Projects/Stan/cmdstan/")`
"""
set_cmdstan_home!(path) = global CMDSTAN_HOME=path

include("main/stanmodel.jl")
include("main/stancode.jl")

# preprocessing

include("utilities/update_model_file.jl")
include("utilities/create_r_files.jl")
include("utilities/create_cmd_line.jl")

# run cmdstan

include("utilities/parallel.jl")

# used in postprocessing

include("utilities/read_samples.jl")
#include("utilities/read_variational.jl")
include("utilities/read_diagnose.jl")
include("utilities/read_optimize.jl")
include("utilities/convert_a3d.jl")

# type definitions

include("types/sampletype.jl")
include("types/optimizetype.jl")
include("types/diagnosetype.jl")
include("types/variationaltype.jl")

export

# from this file
set_cmdstan_home!,
CMDSTAN_HOME,

# From stanmodel.jl
Stanmodel,

# From stancode.jl
stan,

# From sampletype.jl
Sample,

# From optimizetype.jl
Optimize,

# From diagnosetype.jl
Diagnose,

# From variationaltype.jl
Variational

end # module

module SpeedyEarth

using ClimaOcean, Oceananigans, SpeedyWeather
using GeometryOps, GeometryBasics, KernelAbstractions
using GeoMakie

include("methods_extension.jl")
include("extract_grid_polygons.jl")
include("conservative_remapping.jl")
include("earth_simulation.jl")

end

# This file contains all the extensions needed from SpeedyWeather to run the coupled model.

using ClimaOcean
using SpeedyWeather

using ClimaOcean.OceanSeaIceModels.Atmospheres: PrescribedAtmosphereThermodynamicsParameters

import Oceananigans: time_step!
import Oceananigans.Models: update_model_field_time_series!

using Oceananigans: on_architecture

#####
##### Extending the time_step! 
#####

time_step!(atmos::SpeedyWeather.Simulation, args...) = SpeedyWeather.timestep!(atmos)

####
#### Extending inputs to flux computation
####

# Make sure the atmospheric parameters from SpeedyWeather can be used in the compute fluxes function
import ClimaOcean.OceanSeaIceModels.Atmospheres: thermodynamics_parameters, 
                                                 boundary_layer_height, 
                                                 surface_layer_height


# This should be the height of the surface layer in the atmospheric model
# We use a constant surface_layer_height even if a Speedy model has σ coordinates
function surface_layer_height(s::SpeedyWeather.Simulation) 
    T = s.model.atmosphere.temp_ref
    g = s.model.planet.gravity
    Φ = s.model.geopotential.Δp_geopot_full

    return Φ[end] * T / g
end

# This is a parameter that is used in the computation of the fluxes,
# It probably should not be here but in the similarity theory type.
boundary_layer_height(atmos::SpeedyWeather.Simulation) = 600

using SpeedyWeather: EarthAtmosphere

# TODO: We need a better way to grab the parameter
Base.eltype(::EarthAtmosphere{FT}) where FT = FT

# This is a _hack_!! The parameters should be consistent with what is specified in SpeedyWeather
thermodynamics_parameters(atmos::SpeedyWeather.Simulation) = 
    PrescribedAtmosphereThermodynamicsParameters(eltype(atmos.model.atmosphere))

#####
##### Extensions for interpolation between the ocean/sea-ice model and the atmospheric model
#####

import ClimaOcean.OceanSeaIceModels.Atmospheres: 
                    compute_net_atmosphere_fluxes!, 
                    interpolate_atmospheric_state!

# Interpolate the atmospheric surface fields to the ocean/sea-ice model grid
function interpolate_atmospheric_state!(interfaces, atmosphere::SpeedyWeather.Simulation, coupled_model)

    # Regridding forward, this is what we need:

    # Get the atmospheric state on the ocean grid
    # ua = on_architecture(Oceananigans.CPU(), surface_atmosphere_state.u)
    # va = on_architecture(Oceananigans.CPU(), surface_atmosphere_state.v)
    # Ta = on_architecture(Oceananigans.CPU(), surface_atmosphere_state.T)
    # qa = on_architecture(Oceananigans.CPU(), surface_atmosphere_state.q)
    # pa = on_architecture(Oceananigans.CPU(), surface_atmosphere_state.p)
    # Qs = on_architecture(Oceananigans.CPU(), surface_atmosphere_state.Qs)
    # Qℓ = on_architecture(Oceananigans.CPU(), surface_atmosphere_state.Qℓ)
    # Mp = on_architecture(Oceananigans.CPU(), interpolated_prescribed_freshwater_flux)
    # ρf = fluxes.freshwater_density

    # RingGrids.interpolate!(vec(view(ua, :, :, 1)), atmos.diagnostic_variables.grid.u_grid[:, end],            interpolator)
    # RingGrids.interpolate!(vec(view(va, :, :, 1)), atmos.diagnostic_variables.grid.v_grid[:, end],            interpolator)
    # RingGrids.interpolate!(vec(view(Ta, :, :, 1)), atmos.diagnostic_variables.grid.temp_grid[:, end],         interpolator)
    # RingGrids.interpolate!(vec(view(qa, :, :, 1)), atmos.diagnostic_variables.grid.humid_grid[:, end],        interpolator)
    # RingGrids.interpolate!(vec(view(pa, :, :, 1)), exp.(atmos.diagnostic_variables.grid.pres_grid[:, end]),   interpolator)
    # RingGrids.interpolate!(vec(view(Qs, :, :, 1)), atmos.diagnostic_variables.physics.surface_shortwave_down, interpolator)
    # RingGrids.interpolate!(vec(view(Qℓ, :, :, 1)), atmos.diagnostic_variables.physics.surface_longwave_down,  interpolator)
    # RingGrids.interpolate!(vec(view(Mp, :, :, 1)), atmosphere_precipitation,                                  interpolator)

    return nothing
end

# Regrid the fluxes from the ocean/sea-ice grid to the atmospheric model grid
# This is a _hack_!! (We are performing a double interpolation)
function compute_net_atmosphere_fluxes!(atmos::SpeedyWeather.Simulation, similarity_theory_fields, total_fluxes)
    
    # Regridding here!

    return nothing
end
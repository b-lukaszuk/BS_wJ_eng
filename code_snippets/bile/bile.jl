import CairoMakie as Cmk
import Symbolics as Sym

const Flt = Float64

# the code in this file is meant to serve as a programming exercise only
# and it may not act correctly

struct Sphere
    radius::Flt
    Sphere(r::Flt) = r <= 0 ? error("radius must be > 0") : new(r)
end

function getVolume(s::Sphere)::Flt
    return (4 / 3) * pi * s.radius^3
end

function getSurfaceArea(s::Sphere)::Flt
    return 4 * pi * s.radius^2
end

# fraction - 4/3, p - π, r3 - r^3, v - volume
Sym.@variables fraction p r3 v
Sym.symbolic_linear_solve(fraction * p * r3 ~ v, r3)

# formula equivalent to the one returned by the solver above
function getSphere(volume::Flt)::Sphere
    # cbrt - fn that calculates cube root of a number
    radius::Flt = cbrt(volume / (4/3) / pi)
    return Sphere(radius)
end

# bile breakes big lipid droplets into small droplets
bigS = Sphere(10.0) # 10 um
bigV = getVolume(bigS)
bigA = getSurfaceArea(bigS)

# isapprox compares variables for equality
# accounts for possible rounding error
isapprox(
    getSphere(bigV / 4) |> getVolume,
    bigV / 4
)

sumsOfAreas = [bigA]
sumsOfVolumes = [bigV]
radii = [bigS.radius]

numsOfDroplets = collect(4:4:12)
for nDrops in numsOfDroplets
    # local variables smallS, smallV, smallA, sumSmallAs, sumSmallVs
    # visible only in for loop
    smallS = getSphere(bigV / nDrops)
    smallV = getVolume(smallS)
    smallA = getSurfaceArea(smallS)
    sumSmallAs = smallA * nDrops
    sumSmallVs = smallV * nDrops
    push!(sumsOfAreas, sumSmallAs)
    push!(sumsOfVolumes, sumSmallVs)
    push!(radii, smallS.radius)
end

prepend!(numsOfDroplets, 1)

round.(sumsOfVolumes, digits=2) # check that total sumsOfVolumes of lipid droplets are the same
round.(radii, digits=2) # check that radii of lipid droplets get smaller
round.(sumsOfAreas, digits=2) # check the total surface area of lipid droplets

fig = Cmk.Figure();
ax = Cmk.Axis(fig[1, 1],
              title="Lipid droplet size vs. summaric surface area",
              xlabel="number of lipid droplets",
              ylabel="total surface area [μm²]", xticks=0:13);
Cmk.scatter!(ax, numsOfDroplets, sumsOfAreas, markersize=radii .* 5,
             color="gold1", strokecolor="black");
Cmk.xlims!(ax, -3, 16);
Cmk.ylims!(ax, 800, 3000);
Cmk.text!(ax, numsOfDroplets, sumsOfAreas .- 150,
    text=map(r -> "single droplet radius = $(round(r, digits=2)) [μm]", radii),
    fontsize=12, align=(:center, :center)
);
Cmk.text!(ax, numsOfDroplets, sumsOfAreas .- 250,
          text=map((v, n) -> "volume ($n droplet/s) = $(round(Int, v)) [μm³]",
                   sumsOfVolumes, numsOfDroplets),
    fontsize=12, align=(:center, :center)
);
fig

import CairoMakie as Cmk
import Symbolics as Sym

struct Sphere
    radius::Float64
end

function getVolume(s::Sphere)::Float64
    return (4 / 3) * pi * s.radius^3
end

function getSurfaceArea(s::Sphere)::Float64
    return 4 * pi * s.radius^2
end

# fraction - 4/3, p - π, r3 - r^3, v - volume
Sym.@variables fraction p r3 v
Sym.symbolic_linear_solve(fraction * p * r3 ~ v, r3)

# formula equivalent to the one returned by the solver above
function getSphere(volume::Float64)::Sphere
    # cbrt - fn that calculates cube root of a number
    radius::Float64 = cbrt(volume / pi / (4 / 3))
    return Sphere(radius)
end

# bile breakes big lipid droplets into small droplets
bigS = Sphere(10) # 10 um
bigV = getVolume(bigS)
bigA = getSurfaceArea(bigS)

isapprox(
    getSphere(bigV / 4) |> getVolume,
    bigV / 4
)

areas = [bigA]
volumes = [bigV]
radii = [bigS.radius]

numsOfDroplets = collect(4:4:12)
for nDrops in numsOfDroplets
    # local variables smallS, smallV, smallA, sumSmallAs, sumSmallVs
    smallS = getSphere(bigV / nDrops)
    smallV = getVolume(smallS)
    smallA = getSurfaceArea(smallS)
    sumSmallAs = smallA * nDrops
    sumSmallVs = smallV * nDrops
    push!(areas, sumSmallAs)
    push!(volumes, sumSmallVs)
    push!(radii, smallS.radius)
end

prepend!(numsOfDroplets, 1)

round.(volumes, digits=2) # check that total volumes of lipid droplets are the same
round.(radii, digits=2) # check that radii of lipid droplets get smaller
round.(areas, digits=2) # check the total surface area of lipid droplets

fig = Cmk.Figure();
Cmk.scatter(fig[1, 1], numsOfDroplets, areas,
    markersize=radii .* 5,
    color="gold1", strokecolor="black",
    axis=(; title="Lipid droplet size vs. summaric surface area",
        xlabel="number of lipid droplets",
        ylabel="total surface area [μm²]",
        xticks=0:13)
);
Cmk.xlims!(-3, 16)
Cmk.ylims!(800, 3000)
Cmk.text!(fig[1, 1], numsOfDroplets, areas .- 150,
    text=map(r -> "radius: $(round(r, digits=2)) [μm]", radii),
    fontsize=12, align=(:center, :center)
)
Cmk.text!(fig[1, 1], numsOfDroplets, areas .- 250,
    text=map(r -> "total volume: $(round(r, digits=2)) [μm³]", volumes),
    fontsize=12, align=(:center, :center)
)
fig

import CairoMakie as Cmk

struct Sphere
    radius::Float64
end

function getVolume(s::Sphere)::Float64
    return (4/3) * pi * s.radius^3
end

function getArea(s::Sphere)::Float64
    return 4 * pi * s.radius^2
end

function getSphere(volume::Float64)::Sphere
    radius::Float64 = cbrt(volume / pi / (4/3))
    return Sphere(radius)
end

# bile emulsifies, breakes big lipid droplets into small droplets
bigS = Sphere(10) # 10 um
bigV = getVolume(bigS)
bigA = getArea(bigS)

areas = [bigA]
volumes = [bigV]
radii = [bigS.radius]

numsOfDroplets = collect(4:4:12)
for nDrops in numsOfDroplets
    smallS = getSphere(bigV / nDrops)
    smallV = getVolume(smallS)
    smallA = getArea(smallS)
    sumSmallAs = smallA * nDrops
    sumSmallVs = smallV * nDrops
    push!(areas, sumSmallAs)
    push!(volumes, sumSmallVs)
    push!(radii, smallS.radius)
end

round.(volumes, digits=2) # check that total volumes of lipids are the same
round.(radii, digits=2) # check that radii of lipid droplets gets smaller
round.(areas, digits=2) # check the total surface area of lipid droplets

prepend!(numsOfDroplets, 1)

fig = Cmk.Figure();
Cmk.scatter(fig[1, 1], numsOfDroplets, areas,
            markersize=radii .* 5,
            color="gold1", strokecolor="black",
            axis=(;title="Lipid droplet size vs. summaric surface area",
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

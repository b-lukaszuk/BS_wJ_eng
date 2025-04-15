const Vec = Vector
const Flt = Float64

struct Cylinder
    radius::Int
    height::Int

    Cylinder(r::Int, h::Int) = (r < 1 || h < 1) ?
        error("both radius and height must be >= 1") :
        new(r, h)
end

function getVolume(c::Cylinder)::Flt
    return c.height * pi * c.radius^2
end

function getRatios(cylinders::Vec{Cylinder},
                   radiusChange::Int, heightChange::Int)::Vec{Flt}
    ratios::Vec{Flt} = []
    for cyl1 in cylinders
        # newRadius, newHeight, cyl2, vol1, vol2 - local variables
        newRadius = cyl1.radius + radiusChange
        newHeight = cyl1.height + heightChange
        cyl2 = Cylinder(newRadius, newHeight)
        vol1 = getVolume(cyl1)
        vol2 = getVolume(cyl2)
        push!(ratios, round(vol2/vol1, digits=2))
    end
    return ratios
end

## Scenario 1
# radius+1, height = const
getRatios(Cylinder.(1:5, 5), 1, 0)

## Scenario 2
# radius+1, height-1
getRatios(Cylinder.(1:5, 5), 1, -1)

## Scenario 3
# radius+1, height-2
getRatios(Cylinder.(1:5, 5), 1, -2)

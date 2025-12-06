# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

# TODO
const Pt = Tuple{Int, Int} # (x, y)
const Vec = Vector

canvas = fill(' ', 40, 40) # top-left corner (1, 1)

function printCanvas(cvs::Matrix{Char})
    nRows, _ = size(cvs)
    for r in 1:nRows
        println(cvs[r, :] |> join)
    end
    return nothing
end

function isOutsideGrid(pt::Pt, cvs::Matrix{Char}=canvas)::Bool
    nRows, nCols = size(cvs)
    x, y = pt
    return (x > nCols || x < 1) || (y > nRows || y < 1)
end

function isWithinGrid(pt::Pt, cvs::Matrix{Char}=canvas)::Bool
    return !isOutsideGrid(pt, cvs)
end

function isSamePt(pt1::Pt, pt2::Pt)::Bool
    return pt1 .- pt2 == (0, 0)
end

function getHorizontalLine(pt1::Pt, pt2::Pt)::Vec{Pt}
    x1, y1 = pt1
    x2, y2 = pt2
    @assert y1 == y2 "the ys are not equal"
    return [(i, y1) for i in x1:x2]
end

function getVerticalLine(pt1::Pt, pt2::Pt)::Vec{Pt}
    x1, y1 = pt1
    x2, y2 = pt2
    @assert x1 == x2 "the xs are not equal"
    return [(x1, i) for i in y1:y2]
end

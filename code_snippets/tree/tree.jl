const Str = String

startDir = joinpath(homedir(), "Desktop", "catalog_a")

function printCatalogTree(path::Str, pad::Str)
    for name in readdir(path)
        newPath::Str = joinpath(path, name)
        newPad::Str = pad * "---"
        if isfile(newPath)
           println(newPad * name)
        else
            println(newPad * name * "/")
            printCatalogTree(newPath, pad * "   |")
        end
    end
    return nothing
end

function printCatalogTree(path::Str)
    println(path)
    printCatalogTree(path, "|")
    return nothing
end

printCatalogTree(startDir)

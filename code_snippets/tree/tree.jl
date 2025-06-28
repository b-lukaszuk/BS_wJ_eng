const Str = String

startDir = joinpath(homedir(), "Desktop", "catalog_a")

function printCatalogTree(path::Str, level::Int=0)
    for name in readdir(path)
        newPath::Str = joinpath(path, name)
        if isfile(newPath)
           println(" " ^ level * "|-" * "-" ^ level * name)
        else
            println(" " ^ level * "|-" * "-" ^ level * name * "/")
            printCatalogTree(newPath, level+1)
        end
    end
    return nothing
end

printCatalogTree(startDir)

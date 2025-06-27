const Str = String

startDir = joinpath(homedir(), "Desktop", "catalog_a")

function printCatalogTree(path::Str, level::Int=0)
    for name in readdir(path)
        newPath::Str = joinpath(path, name)
        if isfile(newPath)
            println("  " ^ level * name)
        else
            println("  " ^ level * name * "/")
            printCatalogTree(newPath, level+1)
        end
    end
end

printCatalogTree(startDir)

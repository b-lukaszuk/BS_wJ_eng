const Str = String

startDir = joinpath(homedir(), "Desktop", "catalog_a")

function printCatalogTree(path::Str)
    for (root, dirs, files) in walkdir(startDir)
        println("Directories in $root")
        for dir in dirs
            println(joinpath(root, dir)) # path to directories
        end
        println("Files in $root")
        for file in files
            println(joinpath(root, file)) # path to files
        end
    end
end

printCatalogTree(startDir)

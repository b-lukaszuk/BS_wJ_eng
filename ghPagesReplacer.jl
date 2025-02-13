function replaceBookTitle(htmlText::String)::String
    return replace(htmlText, "<title>Greetings and Salutations - Build SH*T with Julia</title>" => "<title>Build SH*T with Julia</title>")
end

function replaceJuliaMono(htmlText::String)::String
    return replace(htmlText, "/JuliaMono" => "./JuliaMono")
end

function replaceSrc(htmlText::String)::String
    return replace(htmlText, "src=\"/" => "src=\"./")
end

function replaceHref(htmlText::String)::String
    return replace(htmlText, "href=\"/" => "href=\"./")
end

function deleteFavIcon(htmlText::String)::String
    return replace(htmlText, r".*favicon.png.*\n" => "")
end

function transformHtmlForGhPages(htmlText::String)::String
    return replaceJuliaMono(htmlText) |> replaceSrc |> replaceHref |>
        deleteFavIcon |> replaceBookTitle
end

# ".html" and "html" are two different suffixes
function walk_paths_get_file_names_with_suffix(
        start_dirname::String, suffix::String,
        accumulator::Vector{String}=Vector{String}())::Vector{String}
    for name in readdir(start_dirname)
        path::String = joinpath(start_dirname, name)
        if isdir(path)
            walk_paths_get_file_names_with_suffix(path, suffix, accumulator)
        elseif isfile(path) && endswith(path, suffix)
            push!(accumulator, path)
        end
    end
    return accumulator
end

function getFileContents(file_path::String)::String
    lines::Vector{String} = []
    open(file_path) do file
        for line in eachline(file)
            push!(lines, line)
        end
    end
    return join(lines, "\n")
end 

function writeTextToFile(text::String, file_path::String)
    open(file_path, "w") do file
        write(file, text)
    end
    println("Writing to '$file_path' completed.")
end

function main()
    htmlFilesNames::Vector{String} = walk_paths_get_file_names_with_suffix("./", ".html")
    for htmlFile in htmlFilesNames
        tmpText = getFileContents(htmlFile)
        println("transforming text in $htmlFile")
        tmpText = transformHtmlForGhPages(tmpText)
        writeTextToFile(tmpText, htmlFile)
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end

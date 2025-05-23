const Str = String

function changeToSnakeCase(camelCasedWord::Str)::Str
    result::Str = ""
    for c in camelCasedWord
        result *= isuppercase(c) ? '_' * lowercase(c) : c
    end
    return result
end

map(changeToSnakeCase, ["helloWorld", "niceToMeetYou", "translateToEnglish"])

function changeToCamelCase(snakeCasedWord::Str)::Str
    result::Str = ""
    prevUnderscore::Bool = false
    for c in snakeCasedWord
        if c == '_'
            prevUnderscore = true
            continue
        else
            result *= prevUnderscore ? uppercase(c) : c
            prevUnderscore = false
        end
    end
    return result
end

map(changeToCamelCase,
    ["hello_world", "nice_to_meet_you", "translate_to_english"])

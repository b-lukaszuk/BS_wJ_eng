# Regex {#sec:regex}

In this chapter I did not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

I recommend you try to solve the task on your own first. Once you finish you may
compare your own solution with the one in this chapter (with explanations) or
with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/regex)
(without explanations).

## Problem {#sec:regex_problem}

Imagine you work at a police station that happened to arrest John Smith who is a
suspect in a certain case you ran. In your country the exact details of an
accused person are to be protected so your job is to remove or obfuscate any
mention of him from the press statement.

```jl
s = """
function getTxtFromFile(filePath::Str)::Str
    fileTxt::Str = ""
    try
        fileTxt = open(filePath) do file
            read(file, Str)
        end
    catch
        fileTxt = "Couldn't read '\$filePath'."
    end
    return fileTxt
end

txt = getTxtFromFile("./code_snippets/regex/loremJohnSmith.txt")
"<<< " * txt[1:200] * " ... >>>"
"""
replace(sco(s), "./code_snippets/regex/loremJohnSmith.txt" => "./loremJohnSmith.txt")
```

This could be done, e.g. by manually replacing his last name with the first
letter, but it's kind of tedious and boring. It could be sped up with a [word
processing
program](https://en.wikipedia.org/wiki/List_of_word_processor_programs) in which
`Ctrl+F` is an abbreviation for a `find` command. In Julia this could be done
with [eachmatch](https://docs.julialang.org/en/v1/base/strings/#Base.eachmatch)
like so:

```jl
s = """
function getAllMatches(rmi::Base.RegexMatchIterator)::Vec{Str}
    allMatches::Vec{RegexMatch} = collect(rmi)
    return isempty(allMatches) ? [] :
        [regMatch.match for regMatch in allMatches]
end

getAllMatches(eachmatch(r"John Smith", txt))[1:2]
"""
sco(s)
```

Here we defined a little helper function (`getAllMatches`), that will help us to
extract the matches as a vector of strings which is easier to read. Notice, the
`r"John Smith"` argument sent to `eachmatch`. The `r` indicates that the
following characters compose no ordinary string but a special one that is called
a [regular expression](https://en.wikipedia.org/wiki/Regular_expression). It may
not seem like much right now, but we'll see it potential in a moment.

## Solution {#sec:regex_solution}

The solution goes here.

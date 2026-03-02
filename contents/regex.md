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
`Ctrl+F` is a shortcut for a `find` command. In Julia this could be done
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
a [regular expression](https://en.wikipedia.org/wiki/Regular_expression) (or
regex). It may not seem like much right now, but we'll see its potential in a
moment.

Once we confirmed the phrase existence we may wish to obfuscate it. Again, in a
word processing program this would be likely done with `Ctrl+H` that stands for
`find and replace` command. In Julia, we would do with something like:

```
# in Julia strings are immutable
# to make changes permament write it to `txt` and/or to a file
txt = replace(txt, r"John Smith" => "John S")
getAllMatches(eachmatch(r"John Smith", txt))
```

```
String[]
```

There, we did our job, identity of a suspect was protected. We may now write the
file on a disk and send the press report. I imagine now you're wondering what's
the big deal with those regexes anyway, it doesn't seem that we've done anything
unusual for a person with basic computer literacy. We'll you're right. We
didn't. That's because in order to have a regex we need to use some
meta-characters, i.e. a special symbols that are interpreted beyond their
literal meaning.

Let me demonstrate it with another example.

## Solution {#sec:regex_solution}

The solution goes here.

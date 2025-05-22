# Camel case {#sec:camel_case}

In this chapter I will not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

You may compare your own solution with the one in this chapter's text (with
explanations) or with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/camel_case)
(without explanations).

## Problem {#sec:camel_case_problem}

In programming there are a few different type of naming conventions, the two
most popular of them are:
[smallCamelCase](https://en.wikipedia.org/wiki/Camel_case) and
[snake_case](https://en.wikipedia.org/wiki/Snake_case).

At times it is useful to quickly convert from one type of naming convention to
the other (hence such a functionality is sometimes built in in
[IDEs](https://en.wikipedia.org/wiki/Integrated_development_environment)).

Here is a task for you write two functions with the following signatures:

```
changeToCamelCase(snakeCasedWord::Str)::Str
```

and

```
changeToSnakeCase(camelCasedWord::Str)::Str
```

that will perform of the following examples according to the template:

```
"hello_world" <=> "helloWorld"
"nice_to_meet_you" <=> "niceToMeetYou"
"translate_to_english" <=> "translateToEnglish"
```

You may assume that the input is well formatted and contains only the
underscores ("_") and the characters from the Latin alphabet.

## Solution {#sec:camel_case_solution}

One of the most succint solutions (and the one quite performant) would be based
on [regular expressions](https://en.wikipedia.org/wiki/Regular_expression) (also
called regexes). Although Julia does have a regex support (see [the
docs](https://docs.julialang.org/en/v1/base/strings/#Base.Regex)) such a
solution would seem rather arcane and offputing for newcomers. Therefore, to
keep things simple our solution will rely on good old for loops and conditionals.

First `changeToSnakeCase` as it is a simpler one (start small and build).

```jl
s = """
function changeToSnakeCase(camelCasedWord::Str)::Str
    result::Str = ""
    for c in camelCasedWord
        result *= isuppercase(c) ? '_' * lowercase(c) : c
    end
    return result
end
"""
sc(s)
```

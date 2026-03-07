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

### Regex Intro {#sec:regex_problem_intro}

> **_Note:_** This subsection provides a short description of regular
> expressions. You may skip it if you know what a regex is. In that case go to
> the task specification right away (see @sec:regex_problem_task).

Imagine you work at a police station that happened to arrest a John Smith who is
a suspect in a certain case. In your country the identity of an accused person
is to be protected from public, so your job is to obfuscate any mention of him
from the press statement.

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
letter, but it's kind of tedious and boring. It may be sped up with a [word
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
following characters compose no ordinary string, but a special one that is
called a [regular expression](https://en.wikipedia.org/wiki/Regular_expression)
(or regex). It may not seem like much right now, but we'll see its potential in
a moment.

Once we confirmed the phrase existence we may wish to obfuscate it. Again, in a
word processing program this would be likely done with `Ctrl+H` that stands for
`find and replace` command. In Julia, we would do it with something like:

```
# in Julia strings are immutable
# to make changes permament write it to `txt` and/or to a file
txt = replace(txt, r"John Smith" => "John S")
eachmatch(r"John Smith", txt) |> getAllMatches
```

```
String[]
```

There, we did our job, identity of an accused person was protected. We may now
write the file on a disk and send the press report. I imagine now you're
wondering what's the big deal with those regexes anyway.  For a person with
basic computer literacy it doesn't seem that we've done anything particularly
advanced. Well, you're right. We didn't. That's because in order to have a regex
we need to use some meta-characters, i.e. a special symbols that are interpreted
beyond their literal meaning. Their list is rather long, but as stated in [the
docs](https://docs.julialang.org/en/v1/manual/strings/#man-regex-literals) it
may be found at [the PCRE2 syntax
manpage](https://www.pcre.org/current/doc/html/pcre2syntax.html).

Instead of going through all the meta-characters (admittedly an impossible task
for a short book chapter) let me just demonstrate a few of the more important
ones with some illustrative examples.

#### Example 1

```jl
s = """
txt = getTxtFromFile("./code_snippets/regex/loremDates.txt")
"<<< " * txt[1:200] * " ... >>>"
"""
replace(sco(s), "./code_snippets/regex/loremDates.txt" => "./loremDates.txt")
```

This time, since I study for an exam, my `txt` contains a passage from a history
book. I would like to extract all the dates from it to make sure I know them
all. Let's say that the dates cover years between 1000 AD and the present.
Doing a standard string search is no good, after all I would have to list like a
thousand numbers. But wait, a simple regex can save me a lot of work. Observe:

```jl
s = """
eachmatch(r"[0-9][0-9][0-9][0-9]", txt) |> getAllMatches
"""
sco(s)
```

This returned us all 4-digit sets in the order they appear in the text (left to
right, top to bottom).

In regex (`r"..."`), the `[...]` is a positive character class that matches any
of the enclosed characters. Therefore, `[0123456789]` would mean match any
character used to represent a digit (`0` or `1` or `2` or ...). In general the
contents of a positive character class are interpreted literally with the
exception of `\`, `^` at the beginning, and `-` between two characters. In the
last case, the hyphen (`-`) means any character within a range. Typically its
used in the following configurations: `[0-9]`, `[a-z]`, `[A-Z]`, or `[A-z]`. The
range is likely determined based on the underlying codes (e.g. like
[ASCII](https://en.wikipedia.org/wiki/ASCII)). Therefore, the last expression
must be written as `[A-z]` (it means match any, small or capital, letter) and
not `[a-Z]`. Anyway, in our case a regex of the form `r"[0-9][0-9][0-9][0-9]"`)
means match a digit (`[0-9]`) followed by a digit (`[0-9]`), followed by a digit
(`[0-9]`), followed by a digit (`[0-9]`) (exactly 4 digits in a row).

Interestingly, we could save ourselves even more typing by using other
meta-characters for this problem, i.e.

```jl
s = """
eachmatch(r"[0-9]{4}", txt) |> getAllMatches
"""
sco(s)
```

The `{4}` means exactly 4 repetitions of a preceding character class (which is
`[0-9]`, so a digit).

Some newer regex engines allow to shorten it even more:

```jl
s = """
eachmatch(r"\\d{4}", txt) |> getAllMatches
"""
sco(s)
```

Where `\d` means any digit (usually `\` gives a special meaning to the following
ordinary character) and `{4}` still designates exactly 4 repetitions of a
previous token.

#### Example 2

```jl
s = """
txt = getTxtFromFile("./code_snippets/regex/loremDollarsDates.txt")
"<<< " * txt[1:200] * " ... >>>"
"""
replace(sco(s), "./code_snippets/regex/loremDollarsDates.txt" => "./loremDollarsDates.txt")
```

This time, we got a text that contains both dollars quota (in `$123` format) and
dates, but we're interested only in the former. Let's say we want to sum them to
find out how much do we need to pay.

First, we'll try to get the numbers out. If we assume for a moment that the
amount of money is at least 3 digits long then for our first try we might go
with:

```
eachmatch(r"\d.+\d", txt) |> getAllMatches
```

```
[
"112 amet consectetur 1234",
"200",
"173 exercitation ullamco 1492",
"1180 Duis aute irure dolor in $122",
"113 cillum dolore eu $3333",
"444 sint occaecat cupidatat non $212",
"534"
]
```

Here `\d` means a digit, `.` is any character, and `+` stands for one or more of
the preceeding tokens (so match a digit followed by one or more other character,
followed by a digit). There is a small problem though, we caught more than we wanted,
that's because by default, regexes are greedy (they match as much as they can)
if we want to make it more temperate we need to follow `.+` with `?` (one or
more characters, but as few as you can to fulfil the condition).

```
eachmatch(r"\d.+?\d", txt) |> getAllMatches
```

```
[
"112",
"123",
"200",
"173",
"149",
"118",
"0 Duis aute irure dolor in \$1",
"113",
"333",
"444",
"212",
"534"
]
```

An improvement, but we're still not there. Let's try again.

```
eachmatch(r"\d{1, }", txt) |> getAllMatches
```

```
[
"112"
"1234"
"200"
"173"
"1492"
"1180"
"122"
"113"
"3333"
"444"
"212"
"534"
]
```

Pretty good, here `{i, j}` means between `i` and `j` (inclusive - inclusive)
occurrences of the previous token (`\d`). `{, j}` stands for 0 to `j` and `{i,
}` stands for `i` or more. Therefore, we only match 1 or more digits in a line,
so it seems that we are finally there. Well, not quite, right now we got no way
to tell do the digits denote money or years (they're from file
`loremDollarsDates.txt`).

Let's try to change our regex a bit to extract only dollars.

```
eachmatch(r"$\d{1,}", txt) |> getAllMatches
```

```
String[]
```

Hmm, we wanted to extract a dollar symbol `$` with all the following digits.
Oddly enough that seemed to have failed. That's because `$` is a meta-character
that denotes end of subject (usually end of line or end of string). So, actually
what we said with `$\d{1,}` was find digits after the end of string. An
impossible task, hence the empty vector. If we want `$` to be interpreted as a
regular dollar symbol we need to proceed it with `\` (`\` gives a special
meaning to an ordinary character, like `\d` and strips it away from a special
character like `$`).

```
getAllMatches(eachmatch(r"\$\d{1,}", txt))
```

```
[
"$112",
"$200",
"$173",
"$1180",
"$122",
"$113",
"$3333",
"$444",
"$212",
"$534"
]
```

Finally, we can sum it up using, e.g. this few liner:

```
getAllMatches(eachmatch(r"\$\d{1,4}", txt)) |>
vecStrDollars -> replace.(vecStrDollars, "\$" => "") |>
vecStrNumbers -> parse.(Int, vecStrNumbers) |>
sum
```

```
6423
```

And voila, we're done. Notice, however, that the regex doesn't handle amounts of
money that contain floating point values, so in that case we would have to
improve upon it.

#### Example 3

This time we got a few random telephone numbers.

```jl
s = """
Rnd.seed!(009)
telNums = [join(Rnd.rand(string.(0:9), 9)) for _ in 1:3]
"""
sco(s)
```

Our task is to convert them into more readable form, i.e. xxx-xxx-xxx.

```
replace.(telNums, r"(\d{3})(\d{3})(\d{3})" => s"\1-\2-\3")
```

```
[
"304-039-945",
"545-946-090",
"818-309-467"
]
```

The new elements here are `()` and `\number` which are capture groups and
back-references, respectively. Therefore, `(\d{3})` in regex (`r""`) means
capture any three numbers in a row and remember them whereas `\1` in
substitution (`s""` - denotes a substitution string that may use
meta-characters) is for use the first captured and remembered group (by analogy
`\2` is for the second captured group and `\3` is for the third).

#### Example 4

In @sec:camel_case we dealt with two-way text transformations between camelCase
and snake_case.

```
snakeCasedWords = [
	"hello_world", "nice_to_meet_you", "translate_to_english"]
```

Let's see can we do this with regex.

First, `camelCasedWords`

```
camelCasedWords = [
	"helloWorld", "niceToMeetYou", "translateToEnglish"]
eachmatch.(r"([A-Z])", camelCasedWords) .|> getAllMatches
```

```
[
["W"],
["T", "M", "Y"],
["T", "E"]
]
```

First, we capture (`()`) any capital letter (`[A-Z]`) in a string. Now we would
like to lowercase it. Per [pcre2 syntax
manual](https://www.pcre.org/current/doc/html/pcre2syntax.html#SEC32) we should
be able to do this using `\l` escape sequence (it means lowercase next
character), but for whatever reason the following snippet throws an error:

```
replace.(camelCasedWords, r"([A-Z])" => s"\l\1")
```

No, biggie. Julia allows the second argument to be a pair of the form `regex =>
function that operates on a matched string` which we can use to our advantage:

```
replace.(camelCasedWords, r"([A-Z])" => lowercase)
```

```
[
"helloworld",
"nicetomeetyou",
"translatetoenglish"
]
```

Almost there, we just need to precced the lowercased letter with `_` symbol which could be done with an anonymous function like this:

```
replace.(camelCasedWords, r"([A-Z])" => AtoZ -> "_" * lowercase(AtoZ))
```

```
[
"hello_world",
"nice_to_meet_you",
"translate_to_english"
]
```

or like that (choose the version that is more readable to you):

```
replace.(camelCasedWords, r"([A-Z])" => AtoZ -> "_$(lowercase(AtoZ))")
```

```
[
"hello_world",
"nice_to_meet_you",
"translate_to_english"
]
```

Time for the opposite transformation.

```
snakeCasedWords = ["hello_world",
	"nice_to_meet_you", "translate_to_english"]
replace.(snakeCasedWords, r"_[a-z]" => _atoz -> uppercase(_atoz[2:end]))
```

```
[
"helloWorld",
"niceToMeetYou",
"translateToEnglish",
]
```

Wow, that felt like a breeze.

Overall, the two lines of code (`replace.(camelCasedWord, etc.)` and
`replace.(snakeCasedWords, etc.)`) are the equivallent of roughtly 20 lines of
code in @sec:camel_case_solution. And that's how it usually is, regexes are more
succint than the traditional functions, although they're not necessarily faster
to write (especially if that is your first encounter with the subject).

### Regex Task {#sec:regex_problem_task}

The task goes here.

## Solution {#sec:regex_solution}

The solution goes here.

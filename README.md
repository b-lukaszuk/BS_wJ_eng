# Description

Here I will try to write another short book using [Julia](https://julialang.org/) and [Books.jl](https://github.com/JuliaBooks/Books.jl).

It is intended to be an experiment. It is not gonna even be a real book (no ISBN), maybe even I will abandon the project along the way (but maybe not).

## Working title

Build SH*T with Julia

## Book writing status

Start date: Wed, 2024-09-11

Work in Progress (I'm in no hurry though)

## Running book locally

```bash
julia --project -e 'using Books; serve()'
```

or

```bash
julia --project -ie 'using Books'
```

and then in the REPL

<pre>
julia> gen() # runs the code in *.md files, produces code output
</pre>

and

<pre>
julia> serve() # runs server, localhost:8004 to open in a browser
</pre>

# Additional info

**The content of this folder may be incorrect, erroneous and/or harmful. Use it at Your own risk.**

**Zawartość niniejszego katalogu może być nieprawidłowa, błędna czy szkodliwa. Używaj na własne ryzyko.**

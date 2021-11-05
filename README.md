# HigherKindedPolymorphisms

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://thautwarm.github.io/HigherKindedPolymorphisms.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://thautwarm.github.io/HigherKindedPolymorphisms.jl/dev)
[![Build Status](https://travis-ci.com/thautwarm/HigherKindedPolymorphisms.jl.svg?branch=master)](https://travis-ci.com/thautwarm/HigherKindedPolymorphisms.jl)
[![Codecov](https://codecov.io/gh/thautwarm/HigherKindedPolymorphisms.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/thautwarm/HigherKindedPolymorphisms.jl)

It's full featured but has performance issues now.

Also, without structural function types, some advanced
polymorhisms might not be that useful, unless you feel okay
to annotate functions here and there.

I made this for using [tagless-final style](http://okmij.org/ftp/tagless-final/index.html) in Julia.

Usage
=======

```julia
using HigherKindedPolymorphisms

abstract type VectSig end
@def_hkt VectSig{T} where T = Vector{T}


using CanonicalTraits
import FunctionWrappers: FunctionWrapper

Fn{A, B} = FunctionWrapper{B, Tuple{A}}
@trait Functor{F} begin
    fmap :: [Fn{A, B}, App{F, A}] where {A, B} => App{F, B}
end

@implement Functor{VectSig} begin
    fmap(f :: Fn{A, B}, a::App{VectSig, A}) where {A, B} =
        B[f(e) for e in prj(a)] |> inj
end

f = Fn{Int, String}(string)
a = inj([1, 2, 3])
fmap(f, a) |> prj

#=> ["1", "2", "3"]
```

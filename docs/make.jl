using Documenter, HigherKindedPolymorphisms

makedocs(;
    modules=[HigherKindedPolymorphisms],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/thautwarm/HigherKindedPolymorphisms.jl/blob/{commit}{path}#L{line}",
    sitename="HigherKindedPolymorphisms.jl",
    authors="thautwarm",
    assets=String[],
)

deploydocs(;
    repo="github.com/thautwarm/HigherKindedPolymorphisms.jl",
)

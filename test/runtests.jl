using HigherKindedPolymorphisms
using Test

abstract type Vect end
@def_hkt Vect{T} where T = Vector{T}
@testset "HigherKindedPolymorphisms.jl" begin
    hkt_vect = inj([1, 2, 3])
    @test (hkt_vect |> typeof) == App{Vect, Int}
    @test prj(hkt_vect) == [1, 2, 3]
    # Write your own tests here.
end

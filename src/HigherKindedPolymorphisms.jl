module HigherKindedPolymorphisms
export inj, prj, @def_hkt, App

const HKP = HigherKindedPolymorphisms
using CanonicalTraits
using MLStyle
@use UppercaseCapturing

function type_constructor_from_hkt end
function type_argument_from_hkt end
function type_app end

# type app representation
struct App{Cons, K₀}
    injected :: Any
end

@trait Higher{Cons, K₀, K₁} where {
    Cons=type_constructor_from_hkt(K₁),
    K₀=type_argument_from_hkt(K₁),
    K₁=type_app(Cons, K₀)
} begin
    inj :: K₁ => App{Cons, K₀}
    inj(data::K₁) = App{Cons, K₀}(data)
    prj :: App{Cons, K₀} => K₁
    prj(data::App{Cons, K₀})::K₁ = data.injected
end

macro def_hkt(expr)
    cg = @when :($Cons{$K₀} = $K₁) = expr begin
        quote
        $HKP.@implement $HKP.Higher{$Cons, $K₀, $K₁}
        $Base.@pure $HKP.type_constructor_from_hkt(::Type{$K₁}) = $Cons
        $Base.@pure $HKP.type_argument_from_hkt(::Type{$K₁}) = $K₀
        $Base.@pure $HKP.type_app(::Type{$Cons}, ::Type{$K₀}) = $K₁
        end
    # NOTE: tparams should occurred in K₁
    @when :($Cons{$K₀} where {$(tparams...)} = $K₁) = expr
        quote
        $HKP.@implement $HKP.Higher{$Cons, $K₀, $K₁} where {$(tparams...)}
        $Base.@pure $HKP.type_constructor_from_hkt(::Type{$K₁}) where {$(tparams...)} = $Cons
        $Base.@pure $HKP.type_argument_from_hkt(::Type{$K₁}) where {$(tparams...)} = $K₀
        $Base.@pure $HKP.type_app(::Type{$Cons}, ::Type{$K₀}) where {$(tparams...)} = $K₁
        end
    end
    esc(cg)
end

end # module

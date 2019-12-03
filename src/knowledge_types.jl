using AutoHashEquals

abstract type Knowledge end
abstract type MetaKnowledge <: Knowledge end

@auto_hash_equals struct Literal <: Knowledge
    value::String
end

const kl_true = Literal("1")
const kl_false = Literal("0")


Base.isless(x::Knowledge, y::Knowledge) = hash(x) < hash(y) # Only here to always keep the same order

Base.show(io::IO, kl::Literal) = print(io, kl.value)




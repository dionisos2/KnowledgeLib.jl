using AutoHashEquals

abstract type Knowledge end
abstract type Formula <: Knowledge end # Logical formula
abstract type MetaKnowledge <: Knowledge end

@auto_hash_equals struct Literal <: Knowledge
    value::String
end

# !X
@auto_hash_equals struct Negation <: Knowledge
    value::Knowledge
end

const Negation(value::Negation) = value.value


# X+Y
@auto_hash_equals struct Conjunction <: Formula
    terms::Set{Knowledge}
end

# X.Y
@auto_hash_equals struct Disjunction <: Formula
    terms::Set{Knowledge}
end

Conjunction(vect::Vector{T}) where T<:Knowledge = Conjunction(Set{Knowledge}(vect))
Disjunction(vect::Vector{T}) where T<:Knowledge = Disjunction(Set{Knowledge}(vect))

compl(::Type{Conjunction}) = Disjunction
compl(::Type{Disjunction}) = Conjunction

# De Morgan's laws
function Negation(value::T) where T <: Formula
    new_terms = [Negation(term) for term in value.terms]
    return compl(T)(new_terms)
end

# A:X
@auto_hash_equals struct KnowledgeOfOther <: MetaKnowledge
    agent::Agent
    value::Knowledge
end

# R(A,B):X
@auto_hash_equals struct MutuallyReflexiveKnowledge <: MetaKnowledge
    agents::Set{Agent}
    value::Knowledge
end

MutuallyReflexiveKnowledge(agents::Vector{Agent}, value::Knowledge) = MutuallyReflexiveKnowledge(Set(agents), value::Knowledge)


Base.isless(x::Knowledge, y::Knowledge) = hash(x) < hash(y) # Only here to always keep the same order


Base.show(io::IO, kl::Literal) = print(io, kl.value)
Base.show(io::IO, kl::Negation) = print(io, "!$(kl.value)")


function show_formula(io::IO, formula::Formula, op::String)
    terms = sort(collect(formula.terms))

    print(io, "(")
    for kl in terms[1:end-1]
        print(io, "$kl$op")
    end
    print(io, "$(terms[end]))")
end

Base.show(io::IO, formula::Disjunction) = show_formula(io, formula, " + ")
Base.show(io::IO, formula::Conjunction) = show_formula(io, formula, " . ")

Base.show(io::IO, kl::KnowledgeOfOther) = print(io, "$(kl.agent):$(kl.value)")


function Base.show(io::IO, kl::MutuallyReflexiveKnowledge)
    print(io, "[")

    agents = sort(collect(kl.agents), by=x->x.name)
    for agent in agents[1:end-1]
        print(io, "$agent,")
    end
    print(io, "$(agents[end])]:$(kl.value)")
end


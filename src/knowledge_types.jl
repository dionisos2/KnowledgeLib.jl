using AutoHashEquals

abstract type Knowledge end
abstract type Formula <: Knowledge end # Logical formula
abstract type MetaKnowledge <: Knowledge end

@auto_hash_equals struct Literal <: Knowledge
    value::String
end

const kl_true = Literal("1")
const kl_false = Literal("0")

# !X
@auto_hash_equals struct Negation <: Knowledge
    value::Knowledge

    function Negation(value::Literal)
        if value == kl_true
            return kl_false
        elseif value == kl_false
            return kl_true
        else
            return new(value)
        end
    end

    function Negation(value::Knowledge)
        new(value)
    end
end

const Negation(value::Negation) = value.value



# X+Y
@auto_hash_equals struct Conjunction <: Formula
    terms::Set{Knowledge}

    function Conjunction(terms::Set{T}) where T<:Knowledge
        if any(term == kl_false for term in terms)
            return kl_false
        end

        external_terms = Set{Knowledge}()

        for term in terms
            if isa(term, Conjunction)
                union!(external_terms, term.terms)
            elseif term != kl_true
                union!(external_terms, [term])
            end
        end
        terms = external_terms

        if length(terms) == 1
            return first(terms)
        elseif length(terms) == 0
            return kl_true
        end

        for term in terms
            if Negation(term)∈terms
                return kl_false
            end
        end

        return new(terms)
    end
end

# X.Y
@auto_hash_equals struct Disjunction <: Formula
    terms::Set{Knowledge}

    function Disjunction(terms::Set{T}) where T<:Knowledge
        if any(term == kl_true for term in terms)
            return kl_true
        end

        external_terms = Set{Knowledge}()

        for term in terms
            if isa(term, Disjunction)
                union!(external_terms, term.terms)
            elseif term != kl_false
                union!(external_terms, [term])
            end
        end
        terms = external_terms

        if length(terms) == 1
            return first(terms)
        elseif length(terms) == 0
            return kl_false
        end

        for term in terms
            if Negation(term)∈terms
                return kl_true
            end
        end

        return new(terms)
    end
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

    function KnowledgeOfOther(agent::Agent, value::T) where T<:Knowledge
        if value == kl_true
            return kl_true
        elseif value == kl_false
            return kl_false
        else
            return new(agent, value)
        end
    end
end

# R(A,B):X
@auto_hash_equals struct MutuallyReflexiveKnowledge <: MetaKnowledge
    agents::Set{Agent}
    value::Knowledge

    function MutuallyReflexiveKnowledge(agents::Set{Agent}, value::T) where T<:Knowledge
        if value == kl_true
            return kl_true
        elseif value == kl_false
            return kl_false
        else
            return new(agents, value)
        end
    end
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



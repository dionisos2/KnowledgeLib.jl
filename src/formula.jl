abstract type Formula <: Knowledge end # Logical formula

function find_correct_terms end

# X+Y
@auto_hash_equals struct Conjunction <: Formula
    terms::Set{Knowledge}

    function Conjunction(terms::Set{T}) where T<:Knowledge
        (create, term_s) = find_correct_terms(terms, Conjunction)
        if create
            return new(term_s)
        else
            return term_s
        end
    end
end

# X.Y
@auto_hash_equals struct Disjunction <: Formula
    terms::Set{Knowledge}

    function Disjunction(terms::Set{T}) where T<:Knowledge
        (create, term_s) = find_correct_terms(terms, Disjunction)
        if create
            return new(term_s)
        else
            return term_s
        end
    end
end

Conjunction(vect::Vector{T}) where T<:Knowledge = Conjunction(Set{Knowledge}(vect))
Disjunction(vect::Vector{T}) where T<:Knowledge = Disjunction(Set{Knowledge}(vect))

function find_correct_terms(terms, TypeFormula::Union{Type{Conjunction}, Type{Disjunction}})
    neutral, absorbing = TypeFormula <: Conjunction ? (kl_true, kl_false) : (kl_false, kl_true)

    external_terms = Set{Knowledge}()

    for term in terms
        if isa(term, TypeFormula)
            union!(external_terms, term.terms)
        elseif term == absorbing
            return (false, absorbing)
        elseif term != neutral
            union!(external_terms, [term])
        end
    end
    terms = external_terms

    if length(terms) == 1
        return (false, first(terms))
    elseif length(terms) == 0
        return (false, neutral)
    end

    for term in terms
        if Negation(term)∈terms
            return (false, absorbing)
        end
    end

    return (true, terms)
end

compl(::Type{Conjunction}) = Disjunction
compl(::Type{Disjunction}) = Conjunction

# De Morgan's laws
function Negation(value::T) where T <: Formula
    new_terms = [Negation(term) for term in value.terms]
    return compl(T)(new_terms)
end

function show_formula(io::IO, formula::Formula, op::String)
    terms = sort(collect(formula.terms))

    print(io, "(")
    for kl in terms[1:end-1]
        print(io, "$kl$op")
    end
    print(io, "$(terms[end]))")
end

Base.:*(kl1::T1, kl2::T2) where T1<:Knowledge where T2<:Knowledge = Conjunction([kl1, kl2])

Base.show(io::IO, formula::Disjunction) = show_formula(io, formula, " + ")
Base.show(io::IO, formula::Conjunction) = show_formula(io, formula, " . ")

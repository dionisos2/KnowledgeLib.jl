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

Base.show(io::IO, kl::Negation) = print(io, "!$(kl.value)")

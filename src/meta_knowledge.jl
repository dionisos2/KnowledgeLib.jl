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

Base.show(io::IO, kl::KnowledgeOfOther) = print(io, "$(kl.agent):$(kl.value)")


function Base.show(io::IO, kl::MutuallyReflexiveKnowledge)
    print(io, "[")

    agents = sort(collect(kl.agents), by=x->x.name)
    for agent in agents[1:end-1]
        print(io, "$agent,")
    end
    print(io, "$(agents[end])]:$(kl.value)")
end

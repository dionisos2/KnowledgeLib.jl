abstract type Deduction end

# A:X → A:X . X
struct Derivate <: Deduction end

# A:X . A:Y → A:X . A:Y . A:(X.Y)
struct Merge <: Deduction end

function (d::Derivate)(knowledge::MetaKnowledge)
    return knowledge.value
end

function (m::Merge)(AX::KnowledgeOfOther, AY::KnowledgeOfOther)
    if AX.agent != AY.agent
        throw(DomainError("The agents should be equal to be able merge knowledge"))
    end

    new_knowledge = Conjunction([AX.value, AY.value])

    return KnowledgeOfOther(AX.agent, new_knowledge)
end

const derivate = Derivate()
const merge = Merge()

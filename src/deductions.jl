abstract type Deduction end

# A:X → A:X . X
struct Derivate <: Deduction end

# A:X . A:Y → A:X . A:Y . A:(X.Y)
struct Merge <: Deduction end

struct Develop <: Deduction end

function (d::Develop)(kl_base::Knowledge, kl_target::MetaKnowledge)
    check_validity(kl_base, kl_target)


    return false
end

function (d::Derivate)(kl_base::Knowledge, kl_target::MetaKnowledge)
    check_validity(kl_base, kl_target)


    return false
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
const develop = Develop()

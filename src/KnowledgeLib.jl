module KnowledgeLib

include("agent.jl")
include("knowledge_types.jl")
include("deductions.jl")

export Agent
export Knowledge, Formula, MetaKnowledge
export Literal, Negation, Conjunction, Disjunction, MutuallyReflexiveKnowledge, KnowledgeOfOther, create_root
export Deduction, Derivate, Merge
export derivate, merge



end # module

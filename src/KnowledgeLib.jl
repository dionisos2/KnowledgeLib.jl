module KnowledgeLib

include("agent.jl")
include("knowledge_types.jl")
include("deductions.jl")
include("parsing.jl")

export Agent
export Knowledge, Formula, MetaKnowledge
export Literal, Negation, Conjunction, Disjunction, MutuallyReflexiveKnowledge, KnowledgeOfOther, compl
export Deduction, Derivate, Merge
export derivate, merge, develop
export @kl_str


end # module

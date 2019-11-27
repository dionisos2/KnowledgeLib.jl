module KnowledgeLib

include("agent.jl")
include("knowledge_types.jl")
include("deductions.jl")
include("parsing.jl")

export Agent
export Knowledge, Formula, MetaKnowledge
export Literal, Negation, Conjunction, Disjunction, MutuallyReflexiveKnowledge, KnowledgeOfOther, create_root
export Deduction, Derivate, Merge
export derivate, merge
export @kl_str, str_to_knowledge, decompose_formula


end # module

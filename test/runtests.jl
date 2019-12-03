using Test
using KnowledgeLib

tests = ["knowledge_types_test.jl", "parsing_test.jl", "deductions_test.jl"]

for test in tests
  include(test)
end

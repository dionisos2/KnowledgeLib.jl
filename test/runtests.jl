using Test
using KnowledgeLib

tests = ["parsing_test.jl", "deductions_test.jl"]

for test in tests
  include(test)
end

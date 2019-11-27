using Test
using Knowledge

tests = ["myobject_test.jl"]

for test in tests
  include(test)
end

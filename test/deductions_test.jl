using KnowledgeLib

@testset "deductions" begin
    @testset "merge" begin
        kl_base = kl"(A:b . A:c . d)"
        #@test merge(kl_base, kl"A:b", kl"A:c") == kl"(A:b . A:c . d . A:(b.c))"
    end
    @testset "derivate" begin
        kl_base = kl"(A:b . A:c . d)"
        #@test derivate(kl_base, kl"A:c") == kl"(A:b . A:c . d . c)"
    end
    @testset "derivate" begin
        kl_base = kl"(a . !b . (!a + b))"
        #@test develop(kl_base, kl"(!a + b)") = kl"((a . !b . !a) + (a . !b . b))"
    end
end

using KnowledgeLib

@testset "deductions" begin
    @testset "merge" begin
        kl_base = kl"(A:b . A:c . d)"
        #@test merge(kl_base, kl"A:b", kl"A:c") == kl"(A:b . A:c . d . A:(b.c))"
    end
    @testset "extract" begin
        kl_base = kl"(A:b . A:c . d)"
        #@test extract(kl_base, kl"A:c") == kl"(A:b . A:c . d . c)"
    end
    @testset "develop" begin
        kl1 = kl"(a . !b . (!c + d))"
        kl2 = kl"(a . A:(a . (c + d) . (e + f)))"

        fc = Focus([kl2, kl"A:(a . (c + d) . (e + f)))", kl"(a . (c + d) . (e + f))"])
        fc = fc"(a . A:&(a . (c + d) . (e + f)))"

        develop = "(X.(Y+Z)) → ((X.Y)+(X.Z))"

        mapping = Mapping(Dict("X"=>"(a . (e + f))", "Y"=>"c", "Z"=>"d"))
        mapping = Mapping(Dict("X"=>:remainder, "(Y+Z)"=>"(c+d)"))
        mapping = Mapping(Dict("(Y+Z)"=>"(c+d)"))
        mapping = mp"(Y+Z)→(c+d)"

        kl3 = transform(kl2, fc, develop, mapping)
        kl3 = develop(kl2, fc, mapping)
        kl3 = develop(kl2, fc"(a . A:&(a . (c + d) . (e + f)))", mp"(Y+Z)=>(c+d)|X=>(a.(e+f))")
        kl3 = develop(kl2, fc"(a . A:&(a . (c + d) . (e + f)))", mp"(Y+Z)=>(c+d)")

        transform(kl, develop, mapping)

        theo = Theorem(kl2, [(develop, fc, mapping), (derivate, fc2, mapping2)])
        kl3 = transform(kl2, fc, develop, mapping)
        kl_end = transform(kl3, fc2, derivate, mapping2)

        kl3 = theo(kl2, Focus([kl2]), mapping)
        kl3 = theo(kl2, mapping)


        fc = kl"(a . A:(a . &(c + d) . (e + f)))"
        kl3 = develop(kl2, fc)

        @test develop(kl1, kl"(!c + d)") = kl"((a . !b . !a) + (a . !b . b))"
        @test develop(kl2, ) = kl"(a . A:((a.c) + (a.d)))"
    end
end

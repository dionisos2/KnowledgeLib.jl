using KnowledgeLib

@testset "knowledge type" begin
    @testset "negation" begin
        la = Literal("a")
        nla = Negation(Literal("a"))

        @test Negation(Negation(Literal("a"))) == la
        @test Negation(Negation(nla)) == nla
        @test Negation(Negation(KnowledgeOfOther(Agent("A"),Negation(nla)))) == KnowledgeOfOther(Agent("A"), la)
    end

    @testset "morgan" begin
        la, lb, lc = Literal("a"), Literal("b"), Literal("c")
        nla, nlb, nlc = Negation(la), Negation(lb), Negation(lc)

        @test Negation(Conjunction([la, lb, lc])) == Disjunction([nla, nlb, nlc])
        @test Negation(Disjunction([la, lb, lc])) == Conjunction([nla, nlb, nlc])
        @test isa(Negation(Conjunction([la, lb, lc])), Disjunction)
        @test isa(Negation(Disjunction([la, lb, lc])), Conjunction)
    end
end

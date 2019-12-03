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

    @testset "kl_true and kl_false" begin
        la, lb, lc = Literal("a"), Literal("b"), Literal("c")
        agent = Agent("A")

        @test Literal("0") == kl_false
        @test Literal("1") == kl_true
        @test Negation(kl_false) == kl_true
        @test Negation(kl_true) == kl_false

        @test Conjunction([la, lb, lc, kl_true]) == Conjunction([la, lb, lc])
        @test Conjunction([la, lb, lc, kl_false]) == kl_false
        @test Disjunction([la, lb, lc, kl_false]) == Disjunction([la, lb, lc])
        @test Disjunction([la, lb, lc, kl_true]) == kl_true

        @test KnowledgeOfOther(agent, kl_true) == kl_true
        @test KnowledgeOfOther(agent, kl_false) == kl_false

        @test MutuallyReflexiveKnowledge([agent], kl_true) == kl_true
        @test MutuallyReflexiveKnowledge([agent], kl_false) == kl_false
    end

    @testset "externalise formulas" begin
        la, lb, lc = Literal("a"), Literal("b"), Literal("c")

        @test Conjunction([la]) == la
        @test Disjunction([la]) == la
        @test Conjunction([la, Conjunction([lb, lc])]) == Conjunction([la, lb, lc])
        @test Disjunction([la, Disjunction([lb, lc])]) == Disjunction([la, lb, lc])
    end

    @testset "check for x . !x and x + !x" begin
        la, lb, lc = Literal("a"), Literal("b"), Literal("c")
        nla, nlb, nlc = Negation(la), Negation(lb), Negation(lc)

        @test Conjunction([la, lb, nla, lc]) == kl_false
        @test Disjunction([la, lb, nla, lc]) == kl_true

        @test Conjunction([la, Disjunction([lb, nlb])]) == la
        @test Disjunction([la, Conjunction([lb, nlb])]) == la

        @test Conjunction([kl_true, Disjunction([lb, nlb])]) == kl_true
        @test Disjunction([kl_false, Conjunction([lb, nlb])]) == kl_false
    end
end

using KnowledgeLib

get_agent = KnowledgeLib.get_agent
decompose_knowledge_of_other = KnowledgeLib.decompose_knowledge_of_other
decompose_mutually_reflexive_knowledge = KnowledgeLib.decompose_mutually_reflexive_knowledge

@testset "parsing" begin
    @testset "decompose_formula" begin
        @testset "decompose_formula Conjunction" begin
            (terms, FormulaType) = decompose_formula("(a:(b+(a.d)).(a.b).[x,y]:((a+b).(a.b)))")
            @test FormulaType == Conjunction
            @test length(terms) == 3
            @test terms[1] == "a:(b+(a.d))"
            @test terms[2] == "(a.b)"
            @test terms[3] == "[x,y]:((a+b).(a.b))"
        end

        @testset "decompose_formula Conjunction" begin
            (terms, FormulaType) = decompose_formula("(a:(b+(a.d))+(a.b)+[x,y]:((a+b).(a.b)))")
            @test FormulaType == Disjunction
            @test length(terms) == 3
            @test terms[1] == "a:(b+(a.d))"
            @test terms[2] == "(a.b)"
            @test terms[3] == "[x,y]:((a+b).(a.b))"
        end

        @testset "decompose_formula Mixed" begin
            @test_throws DomainError decompose_formula("(a:(b+(a.d))+(a.b).[x,y]:((a+b).(a.b)))")
        end
    end

    @testset "get_agent" begin
        @test get_agent("a_agent^10") == ("a_agent", 10)
        @test get_agent("a_agent") == ("a_agent", 0)
    end

    @testset "decompose_knowledge_of_other" begin
        @test decompose_knowledge_of_other("a_agent:a+(a.b:c)") == ("a_agent", 0, "a+(a.b:c)")
        @test decompose_knowledge_of_other("a_agent^3:a+(a.b:c)") == ("a_agent", 3, "a+(a.b:c)")
        @test_throws DomainError decompose_knowledge_of_other("aiie+eiuie:ieie")
    end

    @testset "decompose_mutually_reflexive_knowledge" begin
        @test decompose_mutually_reflexive_knowledge("[a_agent]:a+(a.b:c)") == ([("a_agent", 0)], "a+(a.b:c)")
        @test decompose_mutually_reflexive_knowledge("[a_agent,a_agent^3,bob]:a+(a.b:c)") == ([("a_agent", 0), ("a_agent", 3), ("bob", 0)], "a+(a.b:c)")
        @test_throws DomainError decompose_mutually_reflexive_knowledge("a_agent:a+(a.b:c)")
    end

    @testset "str_to_knowledge" begin
        @testset "str_to_knowledge convert valid Conjunction" begin
            kl = str_to_knowledge("(¬a . (a+b) . A:plop . [A, B^1]:¬plop . (b+(¬b.¬c)))")
            @test isa(kl, Conjunction)
            @test length(kl.terms) == 5

            a, b, c, plop = Literal("a"), Literal("b"), Literal("c"), Literal("plop")
            A, B = Agent("A"), Agent("B", 1)
            pa, pb, pc, pplop = Negation(a), Negation(b), Negation(c), Negation(plop)
            bbc = Disjunction([b, Conjunction([pb, pc])])

            res = Conjunction([pa, Disjunction([a,b]), KnowledgeOfOther(A, plop), MutuallyReflexiveKnowledge([A, B], pplop), bbc])

            @test kl == res

        end
    end
end



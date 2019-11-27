using Test

@testset "Agent" begin
    @testset "constructors" begin
        agent = Agent("Albert")
        @test length(agent.know) == 0
        @test agent.name == "Albert"
    end

    @testset "add knowledge" begin
        agent = Agent()
        knowledge = Knowledge("Albert blackhat")
        agent.learn(knowledge)
        @test agent.know == [knowledge]
        agent.learn(knowledge)
        @test agent.know == [knowledge]
    end
end

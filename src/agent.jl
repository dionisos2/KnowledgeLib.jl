struct Agent
    name::String
    time::Int
end

Agent(name::String) = Agent(name, 0)

function Base.show(io::IO, agent::Agent)
    if agent.time == 0
        print(io, agent.name)
    else
        print(io, "$(agent.name)^$(agent.time)")
    end
end

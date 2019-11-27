function str_to_knowledge(str::AbstractString)
    str = replace(str, " "=>"")

    if is_negation(str)
        return Negation(str_to_knowledge(str[3:end])) # ¬ is two caracteres in one
    elseif is_literal(str)
        return Literal(str)
    elseif is_formula(str)
        (terms, FormulaType) = decompose_formula(str)
        return FormulaType(map(str_to_knowledge, terms))
    elseif is_knowledge_of_other(str)
        (agent_name, time, knowledge) = decompose_knowledge_of_other(str)
        return KnowledgeOfOther(Agent(agent_name, time), str_to_knowledge(knowledge))
    elseif is_mutually_reflexive_knowledge(str)
        (agents, knowledge) = decompose_mutually_reflexive_knowledge(str)
        return MutuallyReflexiveKnowledge([Agent(name, time) for (name, time) in agents], str_to_knowledge(knowledge))
    else
        throw(DomainError("Can’t parse \"$str\", incorrect knowledge expression"))
    end
end


Base.parse(::Type{Knowledge}, str::AbstractString) = str_to_knowledge(str)

const r_literal = "[^ +.:¬\\[\\]\\(\\)]*"
const r_agent = "$r_literal(?:^[0-9]+)?"

is_negation(str) = (str[1] == '¬')
is_literal(str) = occursin(Regex("^$r_literal\$"), str)
is_formula(str) = (str[1] == '(')
is_knowledge_of_other(str) = occursin(Regex("^$r_literal:"), str)
is_mutually_reflexive_knowledge(str) = (str[1] == '[')

function decompose_formula(str::AbstractString)
    str = str[2:end-1] # remove external parentheses
    terms = []
    open_p = 0 # number of open parentheses
    op = nothing
    ops = ['.', '+']

    current_term = ""
    for letter in str
        if open_p == 0
            if op == nothing && letter in ops
                op = letter
            end

            if letter == op
                push!(terms, current_term)
                current_term = ""
            elseif letter in ops
                throw(DomainError("Conjunction and Disjunction should be between parentheses"))
            else
                current_term *= letter
            end
        else
            current_term *= letter
        end

        if letter == '('
            open_p += 1
        elseif letter == ')'
            open_p -= 1
        end
    end

    push!(terms, current_term)

    FormulaType = op == '+' ? Disjunction : Conjunction

    return (terms, FormulaType)
end

function get_agent(str::AbstractString)
    res = match(r"([^^]*)(\^.*)?", str)

    if res[2] != nothing
        return (res[1], parse(Int, res[2][2:end]))
    else
        return (res[1], 0)
    end
end

function decompose_knowledge_of_other(str::AbstractString)
    res = match(Regex("^($r_agent):(.*)\$"), str)

    if res == nothing
        throw(DomainError("\"$str\" is not a correct format of KnowledgeOfOther type"))
    end

    agent_name, time = get_agent(res[1])
    knowledge = res[2]

    return (agent_name, time, knowledge)
end

function decompose_mutually_reflexive_knowledge(str::AbstractString)
    res = match(Regex("^\\[((?:$r_agent,)*$r_agent)\\]:(.*)\$"), str)

    if res == nothing
        throw(DomainError("\"$str\" is not a correct format of MutuallyReflexiveKnowledge type."))
    end

    agents_str = split(res[1], ",")
    agents = [get_agent(agent) for agent in agents_str if agent != nothing]
    knowledge = res.captures[end]

    return (agents, knowledge)
end

macro kl_str(str::AbstractString)
    return str_to_knowledge(str)
end

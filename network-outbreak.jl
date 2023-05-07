using Agents
using Random
using Graphs


@agent Person GraphAgent begin
    infected::Bool
    time_since_infected::Int64
end

function initialise(; seed = 1234)

    g = Graphs.KarateGraph()
    agent_count = Graphs.nv(g)

    properties = Dict(
        :infection_probability => 0.1,
        :infectious_days => 5)
    model = ABM(
        Person,
        Agents.GraphSpace(g);
        properties = properties,
        rng = Random.MersenneTwister(seed)
    )

    for i in 1:(agent_count-1)
        p = Person(i,0,false,0)
        add_agent_single!(p,model)
    end

    p = Person(agent_count,0,true,0)
    add_agent_single!(p,model)
    

    return model
end


function agent_step!(agent, model)
    if agent.infected
        agent.time_since_infected += 1
        if agent.time_since_infected > model.infectious_days
            agent.infected = false
            agent.time_since_infected = 0
        end
        for a in Agents.nearby_agents(agent, model)
            if rand(model.rng) < model.infection_probability
                a.infected = true
            end
        end
    end
end


# run the model
m = initialise()
agent_df, model_df = run!(m, agent_step!,100; adata = [(:infected,sum)], showprogress=true)


# what happend?
using DataFrames
using Plots
plot(Matrix(agent_df), labels=permutedims(names(agent_df)), legend=:topleft)


# run multiple (here three) versions of the model
models = [initialise(seed = x) for x in rand(UInt64, 3)];
adf, = ensemblerun!(models, agent_step!, dummystep, 99; adata = [(:infected,sum)])

# horizontal concatenation
plotdf = hcat(
            adf[1:100,2:2],
            adf[101:200,2:2],
            adf[201:300,2:2]; 
            makeunique = true)

plot(Matrix(plotdf))




#
#
#
# This is only to explain some things
#
 


stop()


using GraphPlot

# What is the KarateGraph? 
gplot(Graphs.KarateGraph())


using InteractiveDynamics
using CairoMakie

#AgentColor
acol(p) = p.infected ? :red : :blue


fig,_,_ = abmplot(m)
fig
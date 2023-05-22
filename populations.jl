using Agents
using Random
using Graphs
using LightOSM
map_path = "./luebeck.json"


## Load map data

data = download_osm_network(:point;
    network_type=:drive,
    point = LightOSM.GeoLocation(53.866781, 10.686955), # center of Lübeck
    radius = 2);


## Convert to Graph data

g = graph_from_object(data, weight_type=:distance);

using GraphPlot


## Test Graph data
g.nodes[90642047].tags
w = g.ways[666731061].tags
g.highways
g.ways

g.restrictions


## Load Census Data

using CSV
using DataFrames
df = CSV.read("Zensus_spitze_Werte_1km-Gitter.csv", DataFrame)


a = (1,2,3)
a .!= 2


populated_areas = df[df.Einwohner .!= -1, :]
dd = select(populated_areas, [:x_mp_1km, :y_mp_1km])

using Plots
using Statistics

x_width = (maximum(df.x_mp_1km) - minimum(df.x_mp_1km)) / 1000
y_width = (maximum(df.y_mp_1km) - minimum(df.y_mp_1km)) / 1000

Plots.scatter(populated_areas.x_mp_1km,populated_areas.y_mp_1km, markersize = 1)

l_x = (4359000, 4373000)
l_y = (3409000, 3424000)


Plots.heatmap(df.x_mp_1km,
              df.y_mp_1km,
              df.Einwohner)




df.Einwohner
reshape(df.Einwohner, 866, :)



l_df = df[(df.x_mp_1km .> l_x[1]) .& (df.x_mp_1km .< l_x[2]) .& (df.y_mp_1km .> l_y[1]) .& (df.y_mp_1km .< l_y[2]) .& (df.Einwohner .!= -1), :]

l_df.cumulative_sum = cumsum(l_df.Einwohner)

our_df = select(l_df, :x_mp_1km, :y_mp_1km, :Einwohner)

our_m = reshape(our_df.Einwohner,  ,: )

scatter(our_df.x_mp_1km, our_df.y_mp_1km)

heatmap(reverse(our_m', dims= 1))



rand(1:215218)

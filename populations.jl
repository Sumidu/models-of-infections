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
df = CSV.read("Zensus_klassierte_Werte_1km-Gitter.csv", DataFrame)


populated_areas = df[df.Einwohner .!= -1,:]
dd = select(populated_areas, [:x_mp_1km, :y_mp_1km])


using InteractiveViz, GLMakie
InteractiveViz.iscatter(dd.x_mp_1km, dd.y_mp_1km; cursor=true)

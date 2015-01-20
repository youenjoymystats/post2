library(googleVis)
cities <- read.csv("cities.csv")
#missing <- data.frame(state = state.abb[!(state.abb %in% states$state)], count = 0)
#states <- rbind(states,missing)

names(cities) <- c("latlon","city","count","dates")
cities$col <- rep(0, length(cities$count))
cities$test <- rep("tesnblah", length(cities$count))
map <- gvisGeoChart(cities,locationvar = "latlon",  sizevar = "count",
                    hovervar = "city", options=list(region="US", 
                                displayMode="markers", 
                                resolution="provinces",
                                width=900, height=550,
                                colors="['#41ab5d','#238b45','#006d2c','#00441b']"))



print(map,"chart",file="map.txt")
plot(map)


Geo=gvisGeoChart(Exports, locationvar="Country", 
                 colorvar="Profit",
                 options=list(projection="kavrayskiy-vii"))
plot(Geo)
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

burlington <- tapply(data$city=="Burlington", data$year, sum)
nyc <- tapply(data$city=="New York", data$year, sum)

df.burlington <- data.frame(city = "Burlington", shows = burlington, 
                            year = rownames(burlington))
df.nyc <- data.frame(city = "NYC", shows = nyc, 
                            year = rownames(nyc))
df <- rbind(df.burlington, df.nyc)
mn <- min(as.numeric(as.character(df$year)))
mx <- max(as.numeric(as.character(df$year)))
          
ggplot(df, aes(year, shows, colour = city)) + 
        geom_point() + 
        geom_line(aes(group=city)) +
        scale_x_discrete(breaks=pretty(c(mn,max), n = 10))
ggsave(file="ggplot.png")
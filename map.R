library(googleVis)
cities <- read.csv("cities.csv")
#missing <- data.frame(state = state.abb[!(state.abb %in% states$state)], count = 0)
#states <- rbind(states,missing)

names(cities) <- c("latlon","city","shows","dates")
cities$col <- rep(0, length(cities$count))
cities$test <- rep("tesnblah", length(cities$count))
map <- gvisGeoChart(cities,locationvar = "latlon",  sizevar = "shows",
                    hovervar = "city", options=list(region="US", 
                                displayMode="markers", 
                                resolution="provinces",
                                width=900, height=550,
                                colors="['#41ab5d','#238b45','#006d2c','#00441b']"))



print(map,"chart",file="map.txt")
plot(map)

data <- read.csv("burlington_nyc.csv")

burlington <- tapply(data$City=="Burlington", data$Year, sum)
nyc <- tapply(data$City=="NYC", data$Year, sum)

years <- seq(1983, 2015, 1)

df.burlington <- data.frame(City = "Burlington", Shows = burlington, 
                            Year = rownames(burlington), stringsAsFactors = FALSE)
df.nyc <- data.frame(City = "NYC", Shows = nyc, 
                            Year = rownames(nyc), stringsAsFactors = FALSE)

missing.burlington <- 
        data.frame(City = "Burlington", 
                   Year = years[!(years %in% df.burlington$Year)], Shows = 0, stringsAsFactors = FALSE)
missing.nyc <- 
        data.frame(City = "NYC", 
                   Year = years[!(years %in% df.nyc$Year)], Shows = 0, stringsAsFactors = FALSE)

df.burlington <- rbind(df.burlington, missing.burlington)
df.nyc <- rbind(df.nyc, missing.nyc)


df <- rbind(df.burlington, df.nyc)
mn <- min(as.numeric(as.character(df$Year)))
mx <- max(as.numeric(as.character(df$Year)))



ggplot(df, aes(Year, Shows, colour = City)) + 
        geom_point() + 
        geom_line(aes(group=City)) +
        scale_x_discrete(breaks=pretty(c(mn,mx), n = 10))
ggsave(file="burlington_nyc.png", scale = 0.75)
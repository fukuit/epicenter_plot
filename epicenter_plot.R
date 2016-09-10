library(ggmap)

center <- geocode('tajimi')
map <-   get <- map(c(center$lon, center$lat), zoom = 5, maptype = 'roadmap')

files = list.files(pattern = ".txt")
for (i in 1:length(files)) {
    dat <- read.delim(files[i], header = T, sep = '\t')
    
    longitude <- c()
    latitude <- c()
    magnitude <- c()
    for (j in 1:nrow(dat)) {
        longitude[j] <- as.numeric(dat$longitude[j])
        latitude[j]  <- as.numeric(dat$latitude[j])
        if (as.character(dat$magnitude[j]) == '-') {
            magnitude[j] <- 0
        } else{
            if (as.numeric(as.character(dat$magnitude[j])) < 0) {
                magnitude[j] <- 0
            } else{
                magnitude[j] <- as.numeric(as.character(dat$magnitude[j]))
            }
        }
    }
    dat$longitude <- longitude
    dat$latitude <- latitude
    dat$magnitude <- magnitude
    
    fname <- gsub('.txt', '', files[i])
    png.japan <- paste(fname, 'png', sep = '.')
    
    p <- ggmap(map)+
        geom <- point(data=dat, aes(x=longitude, y=latitude), size=magnitude, colour='red', alpha=0.7)+
            ggtitle(fname)+
            stat <- density2d(data=dat, aes(x=longitude, y=latitude), geom='polygon', alpha=0.2)
    ggsave(png.japan, plot=p)
}

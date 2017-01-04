library("plyr")
library("ggplot2")
library("ggthemes")
setwd("/Users/prateekmittal/Dropbox/data_visualization/air_pollution_stunting")

a <- read.csv("data/stunting_data.csv", stringsAsFactors = F)

filter <- c("INDIA","BRAZIL","CHINA","SOUTH AFRICA","PAKISTAN","BANGLADESH","INDONESIA","SRI LANKA","AFGHANISTAN")

b <- a[which(a$country %in% filter),]

### Creating a time variable which will take values 1 or 2. 
### 1 for the earliest records in 1990s & 2 for the latest available record##
b$time <- 0

# identifying the latest record for each country ##
for (i in filter) {
  t1 <- min(b[which(b$country==i & b$year>1990),]$year)
  t2 <- max(b[which(b$country==i),]$year)
  b[which(b$country==i & b$year==t1),]$time <- 1990
  b[which(b$country==i & b$year==t2),]$time <- 2014
}

## dealing with missing values in Indonesia ###
b[which(b$country=="INDONESIA" & b$time==1990),]$time <- 0
b[which(b$country=="INDONESIA" & b$year==1995),]$time <- 1990

c <- b[which(b$time>0),]

c <- c[,c("country","stunting","year","time")]

c$xlabel = "1990s"
c[which(c$time==2014),]$xlabel = "Latest"

#### Exploratory Plot ################
test1 <- ggplot(c, aes(time, stunting)) + geom_line(aes(color=country)) +
  theme_minimal() +
  scale_colour_brewer(palette="Set1") +
  scale_y_continuous(breaks=seq(0,100,20), limits=c(0,100)) +
  scale_x_continuous(breaks=seq(1990,2014,24),labels=c("1990s","Latest"))

ggsave("plots/stunting_countries.png", plot=test1, width=10, height = 10)

we

library("reshape2")
library("ggplot2")

imr <- read.csv("/Users/prateekmittal/Desktop/skill_development/portfolio/visualizations/mmr_imr_timeseries/data/imr.csv")
mmr <- read.csv("/Users/prateekmittal/Desktop/skill_development/portfolio/visualizations/mmr_imr_timeseries/data/mmr.csv")

imr <- melt(imr, id=c("India.States.Uts"))
names(imr) <- c("state","year","imr")
imr$year <- as.numeric(substr(imr$year,2,5))

write.csv(imr, "/Users/prateekmittal/Desktop/skill_development/portfolio/visualizations/mmr_imr_timeseries/data/imr_long.csv")

names(mmr) <- c("state","X1998","X2000","X2002","X2005","X2008","X2011","X2012")
mmr <- melt(mmr, id=c("state"))
names(mmr) <- c("state","year","mmr")
mmr$year <- as.numeric(substr(mmr$year,2,5))

write.csv(mmr, "/Users/prateekmittal/Desktop/skill_development/portfolio/visualizations/mmr_imr_timeseries/data/mmr_long.csv")

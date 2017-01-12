library("plyr")
library("sqldf")
library("readstata13")
library("foreign")
setwd("/Users/prateekmittal/Dropbox/IndiaSpend_Prateek/Datasets")

a <- read.dta("newdataset.dta")

a$haz <- a$hw5/100
a <- a[which(a$haz<6),]

a$stunting <- 0
a[which(a$haz<=-2),]$stunting <- 1

a$fuel_type <- "-999"
a[which(a$v161 == 2),]$fuel_type <- "LPG"
a[which(a$v161 == 5),]$fuel_type <- "Kerosene"
a[which(a$v161 == 8),]$fuel_type <- "Wood"
a[which(a$v161 == 11),]$fuel_type <- "Dung"

b <- sqldf("SELECT fuel_type, COUNT(fuel_type) AS total,
           SUM(stunting) AS stunting
           FROM a GROUP BY fuel_type")

b$stunting_rate <- b$stunting/b$total

b$pm10 <- -999
b[which(b$fuel_type=="Dung"),]$pm10 <- 35
b[which(b$fuel_type=="Wood"),]$pm10 <- 8
b[which(b$fuel_type=="Kerosene"),]$pm10 <- 2
b[which(b$fuel_type=="LPG"),]$pm10 <- 0


write.csv(b[which(b$fuel_type!="-999"),],
          "/Users/prateekmittal/Dropbox/data_visualization/air_pollution_stunting/data/stunting_fuel.csv")

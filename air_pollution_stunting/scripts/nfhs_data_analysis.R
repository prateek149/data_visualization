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
a[which(a$v161 == 10),]$fuel_type <- "Crop Residue"
a[which(a$v161 == 9),]$fuel_type <- "Crop Residue"
a[which(a$v161 == 11),]$fuel_type <- "Dung"

a$separate_kitchen <- 0
a[which(a$hv242==1),]$separate_kitchen <- 1

a$window <- 0
a[which(a$s56a==1),]$window <- 1

a$chimney <- 0
a[which(a$s50==1),]$chimney <- 1

b <- sqldf("SELECT fuel_type, COUNT(fuel_type) AS total,
           SUM(stunting) AS stunting
           FROM a GROUP BY fuel_type")

b$stunting_rate <- b$stunting/b$total
b$pm10 <- -999
b[which(b$fuel_type=="Dung"),]$pm10 <- 1.6
b[which(b$fuel_type=="Wood"),]$pm10 <- 0.4
b[which(b$fuel_type=="Crop Residue"),]$pm10 <- 1.4
b[which(b$fuel_type=="Kerosene"),]$pm10 <- 0.1
b[which(b$fuel_type=="LPG"),]$pm10 <- 0

write.csv(b[which(b$fuel_type!="-999"),],
          "/Users/prateekmittal/Dropbox/data_visualization/air_pollution_stunting/data/stunting_fuel.csv")


c <- sqldf("SELECT fuel_type, separate_kitchen, window,COUNT(fuel_type) AS total,
           SUM(stunting) AS stunting
           FROM a GROUP BY fuel_type,separate_kitchen, window ")
c$stunting_rate <- c$stunting/c$total

c <- c[which(c$fuel_type != "-999"),]

for (i in unique(c$fuel_type))
{
  total <- sum(c[which(c$fuel_type==i),]$total)
  stunting <- sum(c[which(c$fuel_type==i),]$stunting)
  stunting_rate <- stunting/total
  c <- rbind(c, data.frame(fuel_type=i,separate_kitchen=-1,window=-1,total=total,
                        stunting=stunting,stunting_rate=stunting_rate))
}

write.csv(c,
          "/Users/prateekmittal/Dropbox/data_visualization/air_pollution_stunting/data/stunting_fuel_ventilation.csv")

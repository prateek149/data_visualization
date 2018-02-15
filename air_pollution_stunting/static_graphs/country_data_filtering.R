library("tidyr")
library(zoo)

setwd("/Users/prateekmittal/Dropbox/data_visualization/air_pollution_stunting/static_graphs")

a <- read.csv("stunting_data.csv", stringsAsFactors = F)
a <- a[which(a$country %in% c("INDIA","BRAZIL","CHINA","SOUTH AFRICA","PAKISTAN","BANGLADESH","INDONESIA","SRI LANKA","AFGHANISTAN")),]
a <- a[,c("country","year","stunting")]
a <- spread(a,key="year", value="stunting")

write.csv(a,"stunting_county_wide.csv", row.names = F)

b <- a
          
for(i in 1:9) {
  all_vals <- unlist(c(b[i,2:29]))
  vals <- na.approx(c(b[i,2:29]))
  start <- range(which(!(is.na(all_vals))))[1]
  end <- range(which(!(is.na(all_vals))))[2]
  all_vals[start:end] <- vals
  b[i,2:29] <- all_vals
}

write.csv(b,"stunting_county_wide_interpolated.csv", row.names = F)


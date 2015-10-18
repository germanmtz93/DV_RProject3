require("jsonlite")
require("RCurl")
require(dplyr)

business <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from yelpbusiness"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_btb687', PASS='orcl_btb687', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
summary (business)
head(business)

tip <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from yelptip where likes > 0"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_btb687', PASS='orcl_btb687', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
summary (tip)
head(tip)

zip <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from ZIPPOPDEN"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_gfm367', PASS='orcl_gfm367', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
summary (zip)
head(zip)


require(tidyr)
require(dplyr)
require(ggplot2)

#Table 1
"The reason that this visual is interseting is because it shows that the tips for a restaurant on yelp gets more likes when the restuarant has less reviews on yelp which would normally be the opposite."

full_join(tip, business, by="BUSINESS_ID")  %>% ggplot(aes(x=LIKES, y=REVIEW_COUNT)) +geom_point() + xlab("Tip Likes") + ylab("Restaurant Review Counts") + ggtitle("REVIEW COUNTS VS LIKES")

#Table 2
"The reason that this visual is interesting is because it shows that there is a higher density of restaurants with high number of stars when the tips in the restuarants have less likes."

inner_join(tip,business, by="BUSINESS_ID") %>% ggplot(aes(x=STARS)) + geom_density() + facet_wrap(~LIKES) + xlab("Number Of Stars") + ylab("Density") + ggtitle("Density plots of Stars with Tip Likes")

#Table 3
require(stringr)
buss <- business  
addr <- buss %>% select (FULL_ADDRESS, STATE)
for (i in 1:61184) {
      addr$ZIPZCTA[i] <- strtoi(str_sub(toString(business$FULL_ADDRESS[i]),-5))
}
bus2 <- full_join(addr, buss, by="FULL_ADDRESS")

"The reason that this visual is interesting is because it shows a very large spike in review counts for restuarants that are in an area with a small population which is quite opposite of what was to be expected."

right_join(zip,bus2 , by = "ZIPZCTA") %>% ggplot(aes(x=POPULATION, y=REVIEW_COUNT, color=STARS)) +geom_point() + xlab("Population of Zip Code Address") + ylab("Number of Reviews for Businesses") + ggtitle("REVIEW COUNTS VS POPULATION")
                                                      
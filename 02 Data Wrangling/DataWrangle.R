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
View(zip)

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
buss <- business  
addr <- buss %>% select (FULL_ADDRESS, STATE)
addr$ZIPZCTA <- strtoi(substrRight(toString(addr$FULL_ADDRESS),5))
bus2 <- full_join(addr, buss, by="FULL_ADDRESS")
View(bus2)

full_join(zip,bus2 , by = "ZIPZCTA") %>% ggplot(aes(x=STARS, y=DENSITYPERSQMILE)) +geom_point()


                                                      
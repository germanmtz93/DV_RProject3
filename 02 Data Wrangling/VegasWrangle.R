require("jsonlite")
require("RCurl")
require(dplyr)

business <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from yelpbusiness"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_btb687', PASS='orcl_btb687', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

vegas <- business %>% filter(CITY == "Las Vegas")
View(vegas)


substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}

addr <- vegas %>% select (FULL_ADDRESS)
for(i in 1:3) {
  a1 <- addr [i,]
  a1 <- data.frame(lapply(a1, gsub, pattern=a1, replacement= substrRight(toString(a1),5)))
}


View (addr)



tip <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from yelptip where likes > 0"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_btb687', PASS='orcl_btb687', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
View(tip)

dplyr::semi_join(tip, business, by="business_id") %>% View

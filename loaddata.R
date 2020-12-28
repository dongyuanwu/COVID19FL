
library(httr)
library(data.table)


req <- httr::GET(url = "https://opendata.arcgis.com/datasets/37abda537d17458bae6677b8ab75fcb9_0.geojson")
req_parsed <- httr::content(req, type = "application/json")
caseline <- lapply(req_parsed$features, function(x) x$properties)
# Convert to data.frame
caseline <- rbindlist(caseline)

lastcaseline <- readRDS("caseline.rds")

if (nrow(caseline) > nrow(lastcaseline)) {
    lastupdate <- vector(mode="list", length=4)
    lastupdate[[1]] <- Sys.Date()
    lastupdate[[2]] <- lastcaseline %>% group_by(County) %>% summarize(n=n())
    lastupdate[[3]] <- lastcaseline %>% subset(Died == "Yes") %>% group_by(County) %>% summarize(n=n())
    lastupdate[[4]] <- lastcaseline %>% subset(Hospitalized == "YES") %>% group_by(County) %>% summarize(n=n())
    
    saveRDS(caseline, "caseline.rds")
    saveRDS(lastupdate, "lastupdate.rds")
    
}

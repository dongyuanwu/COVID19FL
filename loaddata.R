
library(httr)
library(data.table)


req <- httr::GET(url = "https://opendata.arcgis.com/datasets/37abda537d17458bae6677b8ab75fcb9_0.geojson")
req_parsed <- httr::content(req, type = "application/json")
caseline <- lapply(req_parsed$features, function(x) x$properties)
# Convert to data.frame
caseline <- rbindlist(caseline)

lastcaseline <- readRDS("caseline.rds")

if (nrow(caseline) != nrow(lastcaseline)) {
    lastupdate <- vector(mode="list", length=2)
    lastupdate[[1]] <- Sys.Date()
    lastupdate[[2]] <- lastcaseline
    
    saveRDS(caseline, "caseline.rds")
    saveRDS(lastupdate, "lastupdate.rds")
    
}

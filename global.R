
library(shiny)
library(shinydashboard)
library(DT)
library(plotly)
library(tidyverse)


caseline <- readRDS("caseline.rds")
lastupdate <- readRDS("lastupdate.rds")
#caseline_json <- fromJSON("Florida_COVID19_Case_Line_Data.geojson")
#caseline <- as.data.frame(caseline_json$features$properties)


# compare numbers
comp <- function(newdat, olddat) {
    diff = newdat - olddat
    # inputs are numbers
    if (diff >=0) {
        return (paste0("+", diff))
    } else {
        return (paste0(diff))
    }
}

# preprocessing
caseline <- caseline[, -c(1, 4, 6, 8, 12, 14)]
caseline$Age <- as.numeric(caseline$Age)
caseline$EDvisit <- ifelse(is.na(caseline$EDvisit), "UNKNOWN", caseline$EDvisit)
caseline$Hospitalized <- ifelse(caseline$Hospitalized == "NA", "UNKNOWN", caseline$Hospitalized)
caseline$Died <- ifelse(caseline$Died == "NA", "NO", caseline$Died)
caseline$Contact <- ifelse(caseline$Contact == "NA", "UNKNOWN", caseline$Contact)
caseline$Contact <- ifelse(caseline$Contact == "Yes", "YES", caseline$Contact)
caseline$EventDate <- as.Date(caseline$EventDate,"%Y/%m/%d")
caseline$ChartDate <- as.Date(caseline$ChartDate,"%Y/%m/%d")

caseline <- caseline[order(caseline$ChartDate, decreasing=TRUE), ]
row.names(caseline) <- NULL

# overview
entire_tab <- as.data.frame(table(caseline$EventDate))
entire_tab$Var1 <- as.Date(entire_tab$Var1,"%Y-%m-%d")
entire_tab$summ <- cumsum(entire_tab$Freq)

# summarize
total <- nrow(caseline)
death <- sum(caseline$Died == "Yes", na.rm=TRUE)
hosp <- sum(caseline$Hospitalized == "YES", na.rm=TRUE)

total_com <- comp(total, nrow(lastupdate[[2]]))
death_com <- comp(death, sum(lastupdate[[2]]$Died == "Yes", na.rm=TRUE))
hosp_com <- comp(hosp, sum(lastupdate[[2]]$Hospitalized == "YES", na.rm=TRUE))

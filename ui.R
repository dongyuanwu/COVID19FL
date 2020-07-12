
ui <- dashboardPage(skin = "green",
    dashboardHeader(title = "Florida's COVID-19 Data Visualization", titleWidth = 400),
    dashboardSidebar(
        sidebarMenu(
        menuItem("Overview", tabName = "overview", icon = icon("dashboard")),
        menuItem("Summarize", tabName="summarize",icon=icon("bar-chart-o"), 
                                 menuSubItem("Entire State", tabName="subitem1"),
                                 menuSubItem("Specific County (If Chosen)", tabName="subitem2")),
        menuItem("Raw Data", tabName = "rawdata", icon = icon("th")),
        menuItem("About", tabName = "about", icon = icon("cog", lib="glyphicon"))
        ), br(),
        selectInput("dataset", "Choose a specific county (don't forget to click on 'Update View'):",
                    choices=sort(unique(caseline$County))
        ),
        actionButton("action1", "Update View"),
        br(), br(),
        tags$b(HTML("&nbsp;&nbsp;&nbsp;&nbsp;Last Update:")), lastupdate[[1]]
    ),
    dashboardBody(
        tabItems(
            # First tab content
            tabItem(tabName = "overview",
                    fluidRow(
                        valueBox(total, HTML(paste0("Total Cases <br> (Compare to yesterday: ", total_com, ")")), 
                                 icon=icon("users"), color="yellow"),
                        valueBox(hosp, HTML(paste0("Total Hospitalized", br(), "(Compare to yesterday: ", hosp_com, ")")), 
                                 icon=icon("hospital"), color="purple"),
                        valueBox(death, HTML(paste0("Total Deaths", br(), "(Compare to yesterday: ", death_com, ")")), 
                                 icon=icon("sad-tear"), color="red")
                    ),
            
                    fluidRow(
                        tabBox(title="New Cases by Date",
                               tabPanel("Entire State", plotlyOutput(outputId="entire_plot_new")),
                               tabPanel("Specific County (If Chosen)", plotlyOutput(outputId="plot_new"))
                        ),
                        tabBox(title="Cumulative Cases",
                               tabPanel("Entire State", plotlyOutput(outputId="entire_plot_cum")),
                               tabPanel("Specific County (If Chosen)", plotlyOutput(outputId="plot_cum"))
                        )
                        
                    ),
                    fluidRow(width=12,
                        box(title="County Cases", status="primary", solidHeader=TRUE,
                            plotlyOutput(outputId="countycase"), width=12)
                    )
                    
            ),
            tabItem(tabName = "subitem1",
                    fluidRow(
                        box(title="Age", status="primary", solidHeader=TRUE,
                            plotlyOutput(outputId="entire_age", height=300),
                            height=370),
                        box(title="Gender", status="primary", solidHeader=TRUE,
                            plotlyOutput(outputId="entire_gender", height=300),
                            height=370),
                        box(title="Age and Gender", status="primary", solidHeader=TRUE,
                            plotlyOutput(outputId="entire_agegender", height=300),
                            height=370),
                        box(title="Travel or not?", status="primary", solidHeader=TRUE,
                            plotlyOutput(outputId="entire_travel", height=300),
                            height=370),
                        box(title="Contact with cases or not?", status="primary", solidHeader=TRUE,
                            plotlyOutput(outputId="entire_contact", height=300),
                            height=370),
                        box(title="Hospitalized or not?", status="primary", solidHeader=TRUE,
                            plotlyOutput(outputId="entire_hosp", height=300),
                            height=370)
                    )
            ),
            tabItem(tabName = "subitem2",
                    h3(textOutput("county")),
                    fluidRow(
                        valueBoxOutput("caseBox"),
                        valueBoxOutput("hospBox"),
                        valueBoxOutput("deathBox")
                    ),
                    fluidRow(
                        box(title="Age", status="primary", solidHeader=TRUE,
                            plotlyOutput(outputId="age", height=300),
                            height=370),
                        box(title="Gender", status="primary", solidHeader=TRUE,
                            plotlyOutput(outputId="gender", height=300),
                            height=370),
                        box(title="Age and Gender", status="primary", solidHeader=TRUE,
                            plotlyOutput(outputId="agegender", height=300),
                            height=370),
                        box(title="Travel or not?", status="primary", solidHeader=TRUE,
                            plotlyOutput(outputId="travel", height=300),
                            height=370),
                        box(title="Contact with cases or not?", status="primary", solidHeader=TRUE,
                            plotlyOutput(outputId="contact", height=300),
                            height=370),
                        box(title="Hospitalized or not?", status="primary", solidHeader=TRUE,
                            plotlyOutput(outputId="hosp", height=300),
                            height=370)
                    )
            ),
            tabItem(tabName = "rawdata",
                    fluidRow(width=12,
                             box(title="Introduction", status="warning",
                                 "Travel_related: Did the case travel out of state during exposure period", br(),
                                 "EDvisit: Did the case go to an emergency department", br(),
                                 "Hospitalized: Was the case hospitalized at any point during their illness", br(),
                                 "Died: Case died", br(),
                                 "Contact: Case had known contact with another COVID-19 case", br(),
                                 "EventDate: Date symptoms started, or if that date is unknown, 
                                 date lab results were reported to the DOH
                                 (The time series plots in Overview used this kind of date)", br(),
                                 "ChartDate: Date used to create bar chart in the Dashboard",
                                 width=12)
                    ),
                    DT::dataTableOutput("mytable")
            ),
            tabItem(tabName = "about",
                    fluidRow(width=12,
                        box(title="About", status="warning", includeMarkdown("README.md"), width=12)
                    )
            )
        )
    )
)

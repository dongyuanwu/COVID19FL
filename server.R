

shinyServer(function(input, output) {
    
    # raw data
    output$mytable = DT::renderDataTable(
        caseline,
        options = list(scrollX = TRUE)
    )
    
    datasetInput <- eventReactive(input$action1,{
        subset(caseline, County == input$dataset)
    })
    
    lastInput <- eventReactive(input$action1,{
        subset(lastupdate[[2]], County == input$dataset)
    })
    
    
    output$county <- renderText({ unique(datasetInput()$County) })

    # overview
    output$entire_plot_new <- renderPlotly({
        plot_ly(entire_tab, x=~Var1, y=~Freq) %>% add_lines() %>% 
            layout(xaxis=list(title=""), yaxis=list(title="Count"))
    })
    output$entire_plot_cum <- renderPlotly({
        plot_ly(entire_tab, x=~Var1, y=~summ) %>% add_lines() %>% 
            layout(xaxis=list(title=""), yaxis=list(title="Count"))
    })
    
    output$plot_new <- renderPlotly({
        tab <- as.data.frame(table(datasetInput()$EventDate))
        tab$Var1 <- as.Date(tab$Var1,"%Y-%m-%d")
        tab$summ <- cumsum(tab$Freq)
        plot_ly(tab, x=~Var1, y=~Freq) %>% add_lines() %>% 
            layout(xaxis=list(title=""), yaxis=list(title="Count"))
    })
    output$plot_cum <- renderPlotly({
        tab <- as.data.frame(table(datasetInput()$EventDate))
        tab$Var1 <- as.Date(tab$Var1,"%Y-%m-%d")
        tab$summ <- cumsum(tab$Freq)
        plot_ly(tab, x=~Var1, y=~summ) %>% add_lines() %>% 
            layout(xaxis=list(title=""), yaxis=list(title="Count"))
    })
    
    output$countycase <- renderPlotly({
        as.data.frame(table(caseline$County)) %>%
        plot_ly(x=~Var1, y=~Freq, type="bar") %>% 
            layout(xaxis=list(title=""), yaxis=list(title="Count"))
    })
    
    # summarize-1
    output$entire_age <- renderPlotly({
        plot_ly(alpha=0.6) %>% add_histogram(x = ~caseline$Age, name="Cases") %>% 
            add_histogram(x = ~caseline$Age[caseline$Died == "Yes"], name="Deaths") %>% 
            layout(barmode="overlay", legend=list(x=0.8, y=0.9),
                   xaxis=list(title="Age (Years)"), yaxis=list(title="Count"))
    })
    output$entire_gender <- renderPlotly({
        as.data.frame(table(caseline$Gender)) %>%
            plot_ly(labels = ~Var1, values = ~Freq, type = 'pie')
    })
    output$entire_agegender <- renderPlotly({
        plot_ly(alpha=0.6) %>% add_histogram(x = ~caseline$Age[caseline$Gender == "Male"], name="Male") %>% 
            add_histogram(x = ~caseline$Age[caseline$Gender == "Female"], name="Female") %>% 
            add_histogram(x = ~caseline$Age[caseline$Gender == "Unknown"], name="Unknown") %>% 
            layout(barmode="overlay", legend=list(x=0.8, y=0.9),
                   xaxis=list(title="Age (Years)"), yaxis=list(title="Count"))
    })
    output$entire_travel <- renderPlotly({
        as.data.frame(table(caseline$Travel_related)) %>%
            plot_ly(labels = ~Var1, values = ~Freq, type = 'pie')
    })
    output$entire_contact <- renderPlotly({
        as.data.frame(table(caseline$Contact)) %>%
            plot_ly(labels = ~Var1, values = ~Freq, type = 'pie')
    })
    output$entire_hosp <- renderPlotly({
        as.data.frame(table(caseline$Hospitalized, caseline$Died)) %>%
            pivot_wider(names_from=Var2, values_from=Freq) %>%
            plot_ly(x = ~Var1, y = ~NO, type='bar', name='Alived') %>% 
            add_trace(y = ~Yes, name='Died') %>%
            layout(barmode = 'stack', legend=list(x=0.8, y=0.9),
                   xaxis=list(title="Hospitalized or Not"), yaxis=list(title="Count"))
    })

    
    # summarize-2
    
    
    output$caseBox <- renderValueBox({
        valueBox(
            nrow(datasetInput()),
            HTML(paste0("Total Cases <br> (Compare to yesterday: ", 
                        comp(nrow(datasetInput()), nrow(lastInput())), ")")), 
            icon=icon("users"), color="yellow"
        )
    })
    
    output$hospBox <- renderValueBox({
        valueBox(
            sum(datasetInput()$Hospitalized == "YES", na.rm=TRUE), 
            HTML(paste0("Total Cases <br> (Compare to yesterday: ", 
                        comp(sum(datasetInput()$Hospitalized == "YES", na.rm=TRUE),
                             sum(lastInput()$Hospitalized == "YES", na.rm=TRUE)), ")")), 
            icon=icon("hospital"), color="purple"
        )
    })
    
    output$deathBox <- renderValueBox({
        valueBox(
            sum(datasetInput()$Died == "Yes", na.rm=TRUE),
            HTML(paste0("Total Cases <br> (Compare to yesterday: ", 
                        comp(sum(datasetInput()$Died == "Yes", na.rm=TRUE),
                             sum(lastInput()$Died == "Yes", na.rm=TRUE)), ")")), 
            icon=icon("sad-tear"), color = "red"
        )
    })
    
    
    output$age <- renderPlotly({
        plot_ly(alpha=0.6) %>% add_histogram(x = ~datasetInput()$Age, name="Cases") %>% 
            add_histogram(x = ~datasetInput()$Age[datasetInput()$Died == "Yes"], name="Deaths") %>% 
            layout(barmode="overlay", legend=list(x=0.8, y=0.9),
                   xaxis=list(title="Age (Years)"), yaxis=list(title="Count"))
    })
    output$gender <- renderPlotly({
        as.data.frame(table(datasetInput()$Gender)) %>%
            plot_ly(labels = ~Var1, values = ~Freq, type = 'pie')
    })
    output$agegender <- renderPlotly({
        plot_ly(alpha=0.6) %>% add_histogram(x = ~datasetInput()$Age[datasetInput()$Gender == "Male"], name="Male") %>% 
            add_histogram(x = ~datasetInput()$Age[datasetInput()$Gender == "Female"], name="Female") %>% 
            add_histogram(x = ~datasetInput()$Age[datasetInput()$Gender == "Unknown"], name="Unknown") %>% 
            layout(barmode="overlay", legend=list(x=0.8, y=0.9),
                   xaxis=list(title="Age (Years)"), yaxis=list(title="Count"))
    })
    output$travel <- renderPlotly({
        as.data.frame(table(datasetInput()$Travel_related)) %>%
            plot_ly(labels = ~Var1, values = ~Freq, type = 'pie')
    })
    output$contact <- renderPlotly({
        as.data.frame(table(datasetInput()$Contact)) %>%
            plot_ly(labels = ~Var1, values = ~Freq, type = 'pie')
    })
    output$hosp <- renderPlotly({
        as.data.frame(table(datasetInput()$Hospitalized, datasetInput()$Died)) %>%
            pivot_wider(names_from=Var2, values_from=Freq) %>%
            plot_ly(x = ~Var1, y = ~NO, type='bar', name='Alived') %>% 
            add_trace(y = ~Yes, name='Died') %>%
            layout(barmode = 'stack', legend=list(x=0.8, y=0.9),
                   xaxis=list(title="Hospitalized or Not"), yaxis=list(title="Count"))
    })

})


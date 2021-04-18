library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    # # Plot Trend Line 
    # output$trendline <- renderPlotly({
    #     # preprocessing
    #     agg1 <- games %>% 
    #         select(date, year, gamename, avg) %>% 
    #         group_by(gamename, date) %>% 
    #         filter(gamename == input$gamename1)
    #     # visualization
    #     plot1 <- ggplot(data = agg1, aes(x = date, y = avg, fill = gamename)) +
    #         geom_area() +
    #         geom_line() +
    #         geom_point(size = 1, aes(text = glue("{date} = {avg}"))) +
    #         labs(x = "",
    #              y = "",
    #              fill = "") +
    #         theme_minimal()
    #     # interactive
    #     ggplotly(plot1, tooltip = "text") %>% 
    #         config(displayModeBar = F)
    # })
    
    # Plot Gain Percentage Game 1
    output$percentgain1 <- renderPlotly({
        # preprocessing
        gainpercent <- games %>%
            select(date, gamename, avg) %>%
            filter(gamename == input$gamename1) %>%
            mutate(gain_percent = (avg/lead(avg)-1)*100) %>% 
            mutate(gain_percent = round(gain_percent, 1))
        # visualization
        plot2 <- ggplot(gainpercent, aes(x = date, y = gain_percent)) +
            geom_bar(color = "red", stat = "identity", aes(text = glue("{date}: {gain_percent}%"))) +
            scale_y_continuous("Gain Percentage (%)") +
            labs(title = glue("Gain Percentage of 1st Game"),
                 y = "",
                 x = "") +
            theme(legend.position = "none") +
            theme_minimal( )
        # interactive
        ggplotly(plot2, tooltip = "text") %>%
            config(displayModeBar = F)
    })
    
    # Plot Gain Percentage Game 2
    output$percentgain2 <- renderPlotly({
        # preprocessing
        gainpercent2 <- games %>%
            select(date, gamename, avg) %>%
            filter(gamename == input$gamename2) %>%
            mutate(gain_percent = (avg/lead(avg)-1)*100) %>% 
            mutate(gain_percent = round(gain_percent, 1))
        # visualization
        plot3 <- ggplot(gainpercent2, aes(x = date, y = gain_percent)) +
            geom_bar(color = "green", stat = "identity", aes(text = glue("{date}: {gain_percent}%"))) +
            scale_y_continuous("Gain Percentage (%)") +
            labs(title = paste("Gain Percentage of 2nd Game"),
                 y = "",
                 x = "") +
            theme(legend.position = "none") +
            theme_minimal( )
        # interactive
        ggplotly(plot3, tooltip = "text") %>%
            config(displayModeBar = F)
    })
    
    # Plot Gain Percentage Game 3
    output$percentgain3 <- renderPlotly({
        # preprocessing
        gainpercent3 <- games %>%
            select(date, gamename, avg) %>%
            filter(gamename == input$gamename3) %>%
            mutate(gain_percent = (avg/lead(avg)-1)*100) %>% 
            mutate(gain_percent = round(gain_percent, 1))
        # visualization
        plot4 <- ggplot(gainpercent3, aes(x = date, y = gain_percent)) +
            geom_bar(color = "blue", stat = "identity", aes(text = glue("{date}: {gain_percent}%"))) +
            scale_y_continuous("Gain Percentage (%)") +
            labs(title = paste("Gain Percentage of 3rd Game"),
                 y = "",
                 x = "") +
            theme(legend.position = "none") +
            theme_minimal( )
        # interactive
        ggplotly(plot4, tooltip = "text") %>%
            config(displayModeBar = F)
    })
    
    # Table Top 5 Gainer
    
    output$top5gainer <- DT::renderDataTable({
        topgainer <- games %>% 
            select(date, gamename, gain, avg) %>%
            group_by(gamename) %>% 
            arrange(gamename, date) %>%
            mutate(gain_percent = (avg/lead(avg)-1)*100) %>% 
            filter(date == input$slider) %>% 
            arrange(desc(gain_percent)) %>%
            mutate(gain_percent = round(gain_percent, 0)) %>%
            select(gamename, gain_percent) %>% 
            head(5)
        
        DT::datatable(topgainer)
    })
    
    # Plot Top 5 Gainer
    
    output$plot5gainer <- renderPlotly({
        # preprocess
        top5 <- games %>% 
            select(date, gamename, gain, avg) %>%
            group_by(gamename) %>% 
            arrange(gamename, date) %>%
            mutate(gain_percent = (avg/lead(avg)-1)*100) %>% 
            filter(date == input$slider) %>% 
            arrange(desc(gain_percent)) %>%
            mutate(gain_percent = round(gain_percent, 0)) %>%
            select(gamename, gain_percent) %>% 
            head(5)
        
        # visualization
        plot5 <- ggplot(top5, aes(x = gain_percent, y = reorder(gamename, gain_percent)), color = "green") +
            geom_col(aes(text = glue("{gain_percent}%"))) +
            labs(title = "",
                 x = "Gain Percentage (%)",
                 y = "") +
            guides(fill = FALSE) +
            theme_minimal()
        
        ggplotly(plot5, tooltip = "text") %>% 
            config(displayModeBar = F)
    })
    
    # Source Table
    
    output$dataframe <- DT::renderDataTable({
        DT::datatable(dataframe)  
    })
    
    # combined
    output$combined <- renderPlotly({
        
        # visual 1
        v1 <- games %>% 
            select(date, year, gamename, avg) %>% 
            group_by(gamename, date) %>% 
            filter(gamename == input$gamename1) %>% 
            summarise(average = mean(avg)) %>%
            arrange(date, desc(average))
        
        
        #visual 2
        v2 <- games %>% 
            select(date, year, gamename, avg) %>% 
            group_by(gamename, date) %>% 
            filter(gamename == input$gamename2) %>% 
            summarise(average = mean(avg)) %>%
            arrange(date, desc(average))
        
        
        #visual 3
        v3 <- games %>% 
            select(date, year, gamename, avg) %>% 
            group_by(gamename, date) %>% 
            filter(gamename == input$gamename3) %>% 
            summarise(average = mean(avg)) %>%
            arrange(date, desc(average))
        
        
        #combined plot
        combine <- ggplot(NULL, aes(x = date, y = average, fill = gamename)) +
            geom_line(data = v1, color = "red") +
            geom_line(data= v2, color = "green") +
            geom_line(data = v3, color = "blue") +
            labs(title = "Trend Line of Average Player Monthly",x = "", y = "") +
            theme_minimal()
        
        ggplotly(combine, tooltip = c("x","y")) %>% 
            config(displayModeBar = F)
    })
    
    #avgcum
    output$avgcum <- renderPlotly({
        
        # preprocess
        avgcumtotal <- games %>% 
            select(date, gamename, avg) %>% 
            group_by(gamename, date) %>% 
            summarise(total_avg = sum(avg)) %>% 
            mutate(cumtotal = cumsum(total_avg)) %>% 
            filter(gamename %in% input$selectgame) %>% 
            head(as.numeric(input$numberinput))
        
        # visualization
        accum <- ggplot(data = avgcumtotal, aes(x = date, y = cumtotal)) +
            geom_line(aes(linetype = gamename, color = gamename), show.legend = FALSE) +
            geom_point(size = 0.1, aes(text = glue("{date}: {cumtotal}"))) +
            theme(legend.position="top") +
            labs(title = "Player Accumulation Number Over Periods",
                 x = "",
                 y = "") +
            theme_minimal()
        
        ggplotly(accum, tooltip = "text") %>%
            config(displayModeBar = F)
    })

})

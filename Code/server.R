library(shiny)
crimeData <- read.csv("CrimeData.csv");

# Define server logic for slider examples
shinyServer(function(input, output) {
    
    #  Get a the selected data using Year, Crime, State
    #  Calculate the US Average as well 
    #  Returned the combined data
    #
    selectedData <- reactive({
        
        # What are values to subset crime data
        #
        minYear <- input$range[1]
        maxYear <- input$range[2]
        states  <- input$e1
        crimeName <- gsub(" ",".",input$e0)
        crimeName <- paste0(crimeName,".rate")
        
        #  Subset the crime data assign an generic name for rate
        crime <- crimeData[crimeData$Year >= minYear & 
                               crimeData$Year <= maxYear & 
                               crimeData$State %in% states, 
                           c("Year", "State", crimeName) ]
        
        #  Calculate the US Averages for the Years Selected
        crimeAll <- crimeData[crimeData$Year >= minYear & 
                                 crimeData$Year <= maxYear, 
                             c("Year", crimeName) ]
        colnames(crimeAll) = c("Year", "Rate")
        crimeAll$State <- "US"
        crimeUS <- aggregate(Rate ~ Year + State, 
                             data=crimeAll, mean)
        colnames(crime) = c("Year", "State", "Rate")
        
        #  Return the states selected with US Averages
        crimeAll<-merge(crimeUS,crime, all.x=TRUE, all.y=TRUE)
        crimeAll
    })
    
    #  Create a plot of the US Crime Statistics 
    #  By Range of Years, Crime Type and Selected States
    #  Add the US Average as well
    #
    output$crimePlot <- renderPlot({
        minYear <- input$range[1]
        maxYear <- input$range[2]
        states  <- c("US")
        states  <- union(states,input$e1)
        crime <- selectedData() 
        
        #  Lables for Plot
        yLabel <- input$e0
        xLabel <- "Year"
        mainLabel <- "Crime Rate per 100,000 population"
        
        #  Calculate range for plot
        maxCrime <- max(crime$Rate)

        #  Plot Crime Rates
        plotNum <- 1
        plotColors = palette()
        par(mar=c(5.1, 4.1, 4.1, 10.2), xpd=TRUE)
        for (state in states) {
            if (plotNum == 1) {
                plot(crime$Year[crime$State == state], 
                     crime$Rate[crime$State == state], 
                     xlab = xLabel, ylab = yLabel, main = mainLabel,
                     xlim = c(minYear,maxYear), ylim = c(0,maxCrime),
                     type = "b", pch=plotNum, col=plotColors[plotNum])
            }
            else {
                lines(crime$Year[crime$State == state], 
                      crime$Rate[crime$State == state],
                      type="b",
                      pch=plotNum, col=plotColors[plotNum])      
            }
            plotNum <- plotNum + 1
        }
        
        # Place the legend using plot colors from palette
        legend("topright", inset=c(-0.2,0), states, cex=0.8, fill=plotColors);
        
        # Restore default clipping rect
        par(mar=c(5, 4, 4, 2) + 0.1)
    })
    
})
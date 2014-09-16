library(shiny)

#  User Interface for Shiny Application of Crime Statisitics
#  Use the standard template and widgets provided 
#  Get Year Range using a sliderInput
#  Get the Crime Type from a single selectizedInput
#  Get the desired States from a multiple selectizedInput
#
shinyUI(fluidPage(
    
    #  Application title
    titlePanel("US Crime Statistics"),
    
    # Sidebar with sliders that demonstrate various available
    # options
    sidebarLayout(        
        sidebarPanel(
            
            #  Display help text documentation for describing the application
            #
            helpText("The US average crime rate is calculated and the default.",
                     "Left click and hold to select the year range, crime and add states.",
                     "The up and down arrow keys my also be used to select a crime and state option.",
                     "To remove a state, left click and use the delete button."),
            
            #  Select a range of years from 1960 - 2012
            #
            sliderInput("range", "",
                        min = 1960, max = 2012, 
                        value = c(1960,2012), format = "####"
            ),
            
            #  Pick from a list of Crime Types (Violent Crime, Property Crime are Summary) )
            #
            selectizeInput(
                'e0', '', choices = c("Violent crime",
                                           "Murder and nonnegligent manslaughter", 
                                           "Forcible rape",
                                           "Robbery",
                                           "Aggravated assault",
                                           "Property crime",
                                           "Burglary",
                                           "Larceny theft",
                                           "Motor vehicle theft"), 
                options = list(create = TRUE)
            ),
            
            #  Select from a list of States
            #
            selectizeInput(
                'e1', 'States', choices = state.name, multiple = TRUE
            )

        ),
        
        #  Display the Crime Statistics Plot
        #
        mainPanel(
            plotOutput('crimePlot')
        )
    )
))

library(shiny)
library(plotly)
library(dplyr)
library(tidyr)
source("sum over years.R")
source("Creation dataframe.R")
#import dataset
Launch <- read.csv("data/Launch.csv", header = TRUE)

#where there is no values inside the expenditure of the mission, insert 0
Launch[Launch == ""] <- "0.00"
Launch %>% filter(!is.na(Rocket))
Launch$Rocket <- gsub(",","",Launch$Rocket)

ui <- fluidPage(
  titlePanel(h1("Aerospace launches")),
  navlistPanel(
    ("Data visualization"),
    tabPanel("Total launches per state", h1("Histogram of launches for each state by 1957"),"The plot below represents the number of launches that are made, tried and failed by each state in the dataset. In the original dataset no informations are available on #MULTI, but probably are mission planned by different coutries.",plotlyOutput(outputId = "tlps")),
    tabPanel("Cost launches during time", h1("Scatter-plot of expenditure for each launches over time"), "The x-axis represents the time in month and year, while the y-axis (in millions of dollars) are the expenditures. It's also possible to understand which state planned the launch throught to the label.
             The first plot (all States) shows only partial data beacuse of the number of launches are enormous, and some point aren't shown becuase of the density of launches in some period. It's possible to select one state between USA, Russia and China to observe their launches over tiime",
             selectInput("select", label = h3("Select box"), 
                         choices = list("All states" = 1, "USA" = 2, "Russia" = 3, "China" = 4), 
                         selected = 1),
             plotlyOutput(outputId = "sp_plot"),
             ),
    tabPanel("Time series of global expenditure 2000-2020", h1("Plot of the total expenditure from 2000 to 2020"),plotlyOutput (outputId = "ts_plot")),
    
    
    
    ("Some analysis"),
    tabPanel(" Total expenditure for aerospaces launches for each state",
             h1("Lollipop chart of States expenditure in a range of years"),"Select tha range that you want to observe, the plot will return the expenditure of each State in the dataset in that period",
             sliderInput("slider2", label = h3("Select the starting and ending year for your analysis"), sep ="",min = 2000, 
                         max = 2020, value = c(2000, 2020), step = 1),
             plotOutput(outputId = "Lollipop"))
    
  )
)


server <- function(input, output){
  
  
  output$tlps <-renderPlotly({
    X <- names(table(Launch[8]))
    Y <- as.numeric(table(Launch[8]))
    tpls <- plot_ly(x=Y,
                    y = X,
                    name = "country",
                    type = "bar",width = 1200, height = 600) %>%
      layout(xaxis = list(title = "Expenditures in millions of dollar",
                          zeroline = TRUE))
  })
  
  
  output$sp_plot <- renderPlotly({
    
    #clean the dataset
    Launch1 <- filter(Launch, Rocket != "0.00" )
    Launch1 <- unite(Launch1, MY, c(Year,Month), remove=FALSE)
    
    #rocket column as numeric
    Launch1$Rocket <- lapply(Launch1$Rocket, as.numeric)
    
    if ( input$select == 1){
      Launch1 <- Launch1
    } else if (input$select == 2){
      Launch1 <- filter(Launch1, Launch1$Companys.Country.of.Origin == "USA")
    } else if (input$select == 3){
      Launch1 <- filter(Launch1, Launch1$Companys.Country.of.Origin == "Russia")
    } else if (input$select == 4){
      Launch1 <- filter(Launch1, Launch1$Companys.Country.of.Origin == "China")
    }
    
  
    sp_plot <- plot_ly(Launch1, x = ~MY, y=  ~Rocket, type = "scatter", mode = "markers", color = ~Launch1$Companys.Country.of.Origin, width = 1200, height = 600) %>%
      layout(xaxis = list(title = "Year_month"), yaxis = (list(title = "Expenditures (in millions of dollar)")))
  
    })
    
  
  
  output$ts_plot <- renderPlotly({
    
    #create variables
    vec_exp <- integer(21)
    years <- seq(from = 2000, to = 2020, by = 1)
    
    for (i in 1:4324){
      for (j in  1:21){
        if(Launch[i,11]== years[j]){
          vec_exp[j]<- vec_exp[j] + as.numeric(Launch[i,5])
        }
      }
    }

    
    #plot 
    plot_ly(x = ~years, y = ~vec_exp, type = 'scatter', mode = 'lines',width = 1200, height = 600) %>%
      layout(xaxis = list(title = "Years"), yaxis = (list(title = "Expenditures (in millions of dollar)")))
          
  })
  
  
  output$Lollipop <- renderPlot({

    
    #create basic variables
    NMS <- names(table(Launch[8]))
    YEARS <- seq(from = 2000, to = 2020, by = 1)
    count <- (matrix(0, ncol = 21, nrow = 17))
    
    
    #improvement to the dataframe
    Launch$Rocket <- as.numeric(Launch$Rocket)
    na.omit(Launch$Rocket)
    
    
    #create a table  where are stored tha values of the expenditure by state/year
    lil_launch <- aggregate(Launch$Rocket, by = list(Launch$Companys.Country.of.Origin, Launch$Year), FUN = sum)
    
    
    #count table creation from the values present in the lil_launch dataframe
    count <- create_df(lil_launch, count, NMS, YEARS)
    
    
    #create a dataframe from the matrix
    count.df <- as.data.frame(count)
    colnames(count.df) <- c(2000:2020)
    
    #create the vector necessary to print the plot with the proper function
    expenditure <- create_Y(input$slider2[1], input$slider2[2], NMS, count.df)
    
    #create a dataframe for ggplot
    datas <- data.frame(expenditure, NMS)
  
    
    
    # Horizontal version
    ggplot(datas,aes(x= expenditure, y= NMS)) +
      geom_segment(aes(x=0, xend = expenditure, y=NMS, yend = NMS), color="blue4") +
      geom_point( color="blue4", size=8, alpha=0.7) +
      labs(y= "States", x = "Aggregate expenditures(in millions of dollars)")+
      theme(axis.text.x = element_text(size=13),
                      axis.text.y = element_text(size=13 )) +
      theme(axis.title.x = element_text(size=15),
             axis.title.y = element_text(size=15)) +
      theme(panel.background = element_rect( fill = "#e6ffff" ))
     
    
    })
  
}

shinyApp(ui = ui, server = server)



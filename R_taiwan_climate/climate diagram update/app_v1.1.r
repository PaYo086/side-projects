# Load packages -----
library(shiny)
library(climatol)

# Source helpers -----
source("Station_Month_Download.r")
source("Calculate_Ayear.r")
source("Years_Download.r")
options(warn = -1) 

# List of station -----
station_list <- read.csv("data/station.csv", stringsAsFactors = F)

# User interface -----
ui <- fluidPage(
  titlePanel("Taiwan Climate Diagram"),
  
  sidebarLayout(
    sidebarPanel(
      
      selectInput("station", label = h3("Station"), choices = as.list(colnames(station_list)), selected = "Taichung"),
      
      br(), 
      sliderInput("years", label = h3("Year Range"), min = 2010, max = 2018, value = c(2010, 2018)), 
      
      br(), 
      h3("Diagram Size"),
      sliderInput("width", label = h5("width"), min = 200, max = 1200, value = 550), 
      sliderInput("height", label = h5("height"), min = 200, max = 1200, value = 600), 
      
      br(), br(), br(), br(), br(), br(), 
      p("made by Po-Yu Lin"),
      p("data source: ", a("Central Weather Bureau, Taiwan", href = "http://e-service.cwb.gov.tw/HistoryDataQuery/"))

    ),
    
    mainPanel(
      h3(textOutput("station_t")), 
      uiOutput("plot.ui"), 
      tableOutput("dataframe")
    )
  )
)

# Server logic -----
server <- function(input, output) {
  dataInput <- reactive({
    years <- input$years
    station <- input$station
    stationID <- station_list[1, station]
    dia_data <- matrix(1:72, nrow = 6) * 0
    for (i in (years[1]:years[2])) {
      if (!file.exists(paste0("data/", input$station, i, "dia.csv"))){
        Years_Download(i, station, stationID)
        read_data <- read.csv(paste0("data/", station, i, "dia.csv"), stringsAsFactors = F)
        dia_data <- dia_data + read_data
      } else {
        read_data <- read.csv(paste0("data/", station, i, "dia.csv"), stringsAsFactors = F)
        dia_data <- dia_data + read_data
      }
    }
    dia_data <- (dia_data / (years[2] - years[1] + 1))
    rownames(dia_data) <- c("Prec.", "Mean.t", "Max.t", "Min.t", "Ab.max.t", "Ab.min.t")
    colnames(dia_data) <- as.character(1:12)
    return(dia_data)
  })
  
  output$station_t <- renderText({
    paste(input$station, "climate diagram", sep = " ")
  })
  
  output$diagram <- renderPlot({
    diagwl(dataInput()[c("Prec.", "Max.t", "Min.t", "Ab.min.t"),], est = input$station, alt = station_list[2, input$station], per = paste(input$years[1], input$years[2], sep = "-"), mlab = "en")
  })
  
  output$plot.ui <- renderUI({
    plotOutput("diagram", width = input$width, height = input$height)
  })
  
  output$dataframe <- renderTable(dataInput(), include.rownames = T)
}

# Run the app -----
shinyApp(ui, server)

# shiny::runApp("D:/6111/VegLab/R/climate_diagram", display.mode = "showcase")
# shiny::runApp("D:/6111/VegLab/R/climate_diagram")
# shiny::runApp("P:/VegLab/R codes/Po-Yu/climate_diagram")
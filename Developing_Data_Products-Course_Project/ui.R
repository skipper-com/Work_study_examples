library(shiny)

# Define UI for application that plays with mtcars
shinyUI(fluidPage(
  # Application title
  titlePanel("Annoyed mtcars"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      p("Check number of cylinders you want to see:"),
      checkboxGroupInput(inputId = "cyl", label = "Cylinders", c("4-cyl" = "4", "6-cyl" = "6", "8-cyl" = "8"), selected = "4"),
      sliderInput(inputId = "disp", label = "Disp range:", min = 70, max = 470, value = c(70, 470), step = 20),
      uiOutput("disp_range")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      verbatimTextOutput("date"),
      p("The main purpose of this app is demonstration. Preiction doesn't have enough accuracy. Lot's of variables are omitted. Don't try to find amazing results and bloody-good models. Of course, all is possible, but not here:) Have a nice play!"),
      h4("Play with mpg ~ wt plot faceted by cyl"),
      p("Here is ordinary plot of mtcars data. Miles per Gallon depends on Weight. Using checkbox on a sidebar you could control the number of plots for each value of cylinders - 4, 6 or 8. Easy to see that more cylinders have cars with more weight and less miles per gallon. Unchecking all checkboxes leads general plot without faceting colored by Cylinders value."),
      plotOutput("mpgPlot"),
      h4("Play with mpg prediction based on disp using cyl, wt and am"),
      p("Basic prediction of Miles per Gallon could be based on couple of variables. I suggests make a prediction based on four variables. Three of them I fixed: cyl = 4, wt = 2.5, am = 0 (automatic). But disp I didn't fix and let you choose the value. Moreover you can choose the range of disp variable then app automatically filters observations to those whose disp value inside this range. The smaller range you define the less observation will be used for prediction. The number of filtered observations displayed in app"),
      p("Then linear model fitted to filtered observation using four variables disp, cyl, wt, am."),
      p("Enter disp value (in selected range above) to predict mpg. cyl is fixed to 4, wt is fixed to 2.5, am is fixed to 1."),
      verbatimTextOutput("observations"),
      verbatimTextOutput("predict")
    )
  )
))

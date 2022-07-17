App Presentation
========================================================
author: Alex Pilugin
date: 27.12.2017
autosize: true
transition: fade
navigation: slide
font-family: 'Calibri', 'Times New Roman', 'Helvetica'
width: 1920
height: 1080

Overview
========================================================
incremental: true
Using shiny app you can get from mtcars dataset:
- Plots of Miles per Gallon dependence on Weight considering variable Cylinders
- Prediction of Miles per Gallon using Cylinders, Weight, Transmission Type and Displacement on limited dataset. Limits controlled by user and applied to Displacement values.
- A lot of fun:)

mtcars plots
========================================================
The plots are constructed using basic ggplot library with the following code:

```r
if (!is.null(input$cyl)) {
    mtcars_cyled <- mtcars[mtcars$cyl %in% input$cyl, ]
    g <- ggplot(data = mtcars_cyled, aes(x = wt, y = mpg)) +
        geom_point(aes(color = as.factor(cyl))) +
        geom_smooth(method = "lm") +
        facet_wrap(~ cyl)
    g
} else {
    g <- ggplot(data = mtcars, aes(x = wt, y = mpg)) +
        geom_point(aes(color = as.factor(cyl))) +
        geom_smooth(method = "lm") 
    g
}
```
where cyl variable is taken from user check box input.

mtcars predict (Part 1)
========================================================
Prediction consists of two parts:
- sub-setting mtcars data set for defined Displacement range (by slider)
- predict using limited dataset value of Miles per Gallon using defined Displacement value
To subset mtcars dataset slider input (min, max) values were used with following code:

```r
mtcars_disped <- mtcars[mtcars$disp > input$disp[1] & mtcars$disp < input$disp[2],]
paste("Number of observations: ", dim(mtcars_disped)[1])
```
To user GUI (ui.R) is necessary to return new Displacement range, what was done using the following code:

```r
numericInput(inputId = 'disp_val', label = 'disp value to predict mpg', value = input$disp[1], min = input$disp[1], max = input$disp[2])
```
mtcars predict (Part 2)
========================================================
Simple prediction using Linear Model was done with fixed Cylinders, Weight and Transmission Type. Displacement value is defined by user input. Following code provide overview of server.R code for the shiny app in that part.

```r
fitmod <- lm(mpg ~ disp + cyl + wt + am, data = mtcars_disped)
pred_data <- data.frame(disp = input$disp_val, cyl = 6, wt = 2.5, am = 1)
paste("Predicted mpg: ", predict(fitmod, newdata = pred_data))
```

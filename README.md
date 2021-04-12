# Shiny
This Shiny-app wants to show some intresting features on the aerospace launches over the last 60 years. The dataset is "Launch.csv", in which are present informations on the year, month, day, hour, minute and second of the launch. There are also the company of origin of the rocket, if the mission was public or private funded, if the mission was successfull or not and the cost of the mission.
One of the main problem in this analysis is the fact that before the 1995/2000 the costs of missions rarely are available, for this reason the analysis throught the app is an approximation of the real expenditures that the states faced over time. Furthermore the costs present in the file aren't the effective cost, but a prevision of the expenditures that the states/companys have to face to complete the mission.

## Plots
The plots included in the Shiny-app are histograms, scatter plot and time series. Some of them allow to choose the data to show.

### Histogram of Launches
The plot represent in an inverted histogram how many launches each state had completed. On the x-axis is possible to see the number of launches and on the y-axis the country. It is possible, thanks to plotly, to know the exact number of launches pointing on the bar of the state.

### Interactive Scatter plot
The plot represent the expenditure and the date of mission of the dataset. The colors allow to understand the country of origin of the mission. Furthermore is possible to select between "all states", "USA", "Russia" and "China" to see their specific mission over time.

### Time series of expenditure
The plot represent the global total expenditure over time.

### Interactive Lollipop Chart
Throught this interactive plot is possible to see how much each state spent over time. As said before, some data about the costs aren't available for some states and it is not possible to know the real expenditure for those states.




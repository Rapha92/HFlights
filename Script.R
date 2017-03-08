#Dplyr example
library(dplyr)
library(hflights)
data(hflights)


#Create a data frame
flights = tbl_df(hflights)

print(flights, n=20)
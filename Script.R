#Dplyr example
library(dplyr)
library(hflights)
data(hflights)


#Create a data frame
flights = tbl_df(hflights)

print(flights, n=20)

# Use Filter Command
filter(flights, Month == 1 & DayofMonth == 1)
filter(flights, UniqueCarrier == "AA" | UniqueCarrier == "UA")
filter(flights, UniqueCarrier %in% c("AA", "UA"))

#use select command
select(flights, DepTime, ArrTime, FlightNum)
select(flights, contains("Taxi"))

# Chaining or Pipelining
filter(select(flights, UniqueCarrier, FlightNum, DepDelay), DepDelay >60)

flights %>%
  select(UniqueCarrier, FlightNum, DepDelay) %>%
  filter(DepDelay > 60) 

x1 = 1:5
x2 = 2:6
(x1 - x2)^2 %>% sum() %>% sqrt()

# Reorder
flights %>%
  select(UniqueCarrier, FlightNum, DepDelay) %>%
  arrange(desc(DepDelay))



# reduce variables to values
flights %>%
  group_by(Dest) %>%
  summarise(avg_delay = mean(ArrDelay, na.rm = TRUE))


flights %>%
  group_by(UniqueCarrier) %>%
  summarise_each(funs(mean), Cancelled, Diverted)


flights %>%
  group_by(UniqueCarrier) %>%
  summarise_each(funs(min(.,na.rm = T), max(.,na.rm=T)), matches("Delay"))


flights %>%
  group_by(Month, DayofMonth) %>%
  summarise(flight_count = n()) %>%
  arrange(desc(flight_count))

flights %>%
  group_by(Month, DayofMonth) %>%
  tally(sort = T)

flights %>%
  group_by(Dest) %>%
  summarise(flight_count = n(), plane_count = n_distinct(TailNum))

flights %>%
  group_by(Dest) %>%
  select(Cancelled) %>%
  table()

# Window Function

flights %>%
  group_by(UniqueCarrier) %>%
  select(Month, DayofMonth, DepDelay) %>%
  filter(min_rank(desc(DepDelay)) <= 2) %>%
  arrange(UniqueCarrier, desc(DepDelay))

#This is the same as

flights %>%
  group_by(UniqueCarrier) %>%
  select(Month, DayofMonth, DepDelay) %>%
  top_n(2) %>%
  arrange(UniqueCarrier, desc(DepDelay))

flights %>%
  group_by(Month) %>%
  summarise(flight_count = n()) %>%
  mutate(change = flight_count - lag(flight_count))

flights %>%
  group_by(Month) %>%
  tally() %>%  #tally = summarise(flight_count = n())
  mutate(change = n - lag(n))
  

# randomly sample some rows
flights %>%
  sample_n(5)

flights %>%
  sample_frac(0.25, replace = T)

glimpse(flights)



#Working with databases in Dplyr Package
install.packages(RSQLite)
library(RSQLite)
my_db = src_sqlite("my_db.sqlite3")



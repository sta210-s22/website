# load packages ----------------------------------------------------------------

library(tidyverse)
library(tidymodels)
library(nycflights13)    # for flight data

# prep data --------------------------------------------------------------------

set.seed(234)

flight_data <- flights %>%
  mutate(
    # Convert the arrival delay to a factor
    arr_delay = if_else(arr_delay >= 30, "late", "on_time"),
    arr_delay = factor(arr_delay),
    # We will use the date (not date-time) in the recipe below
    date = lubridate::as_date(time_hour)
  ) %>%
  # Include the weather data
  inner_join(weather, by = c("origin", "time_hour")) %>%
  # Only retain the specific columns we will use
  select(dep_time, flight, origin, dest, air_time, distance,
         carrier, date, arr_delay, time_hour) %>%
  # Exclude missing data
  drop_na() %>%
  # Sample
  sample_n(size = 25000)

# save data --------------------------------------------------------------------

write_csv(flight_data, file = "data/flight-data.csv")

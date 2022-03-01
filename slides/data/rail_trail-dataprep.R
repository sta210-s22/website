library(tidyverse)

rail_trail <- RailTrail %>%
  mutate(
    season = case_when(
      spring == 1 ~ "Spring",
      summer == 1 ~ "Summer",
      fall == 1   ~ "Fall"
    ),
    dayType = str_to_title(dayType)
  ) %>%
  select(-spring, -summer, -fall, -weekday, -lowtemp) %>%
  relocate(volume, contains("temp"), season) %>%
  janitor::clean_names()

write_csv(rail_trail, file = here::here("slides/data", "rail_trail.csv"))

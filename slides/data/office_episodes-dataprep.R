# load packages ----------------------------------------------------------------

library(tidyverse)
library(schrute)
library(lubridate)

# data prep --------------------------------------------------------------------

office_episodes <- theoffice %>%
  mutate(
    text = str_to_lower(text),
    halloween_mention = if_else(str_detect(text, "halloween"), 1, 0),
    valentine_mention = if_else(str_detect(text, "valentine"), 1, 0),
    christmas_mention = if_else(str_detect(text, "christmas"), 1, 0)
  ) %>%
  group_by(season, episode, episode_name, imdb_rating, total_votes, air_date) %>%
  summarize(
    n_lines = n(),
    lines_jim = sum(character == "Jim") / n_lines,
    lines_pam = sum(character == "Pam") / n_lines,
    lines_michael = sum(character == "Michael") / n_lines,
    lines_dwight = sum(character == "Dwight") / n_lines,
    halloween = if_else(sum(halloween_mention) >= 1, "yes", "no"),
    valentine = if_else(sum(valentine_mention) >= 1, "yes", "no"),
    christmas = if_else(sum(christmas_mention) >= 1, "yes", "no"),
    .groups = "drop"
  ) %>%
  select(-n_lines) %>%
  mutate(michael = if_else(season > 7, "no", "yes"))

dim(office_episodes)

# write data -------------------------------------------------------------------

write_csv(office_episodes, here::here("slides/data/", "office_episodes.csv"))

library(tidyverse)
library(nycflights13)
library(dplyr)
library(ggplot2)
# flights
# weather

library(lubridate)
weather %>% 
  mutate(day_of_year = yday(time_hour)) %>% 
  group_by(origin,day_of_year) %>%
  summarize(mean_temp = mean(temp)) %>% 
  ggplot() +
  geom_point(mapping = aes(x = day_of_year, y = mean_temp)) +
  facet_grid(.~origin)

weather %>% 
  mutate(day_of_year = yday(time_hour)) %>% 
  group_by(origin, day_of_year) %>% 
  summarize(ave.temp = mean(temp, na.rm = T)) %>% 
  pivot_wider(names_from = day_of_year, values_from = ave.temp)

performance.dat <- flights %>% 
  mutate(day_of_year = yday(time_hour)) %>% 
  group_by(origin, day_of_year) %>%
  summarize(performance = mean(dep_delay < 60, na.rm = T))
  
weather.dat <- weather %>% 
  mutate(day_of_year = yday(time_hour)) %>% 
  group_by(origin, day_of_year) %>% 
  summarize(total.precitipitation = sum(precip,na.rm = T),
            minimum.visibility = min(visib),
            average.wind_speed = mean(wind_speed,na.rm = T))

dat <- left_join(weather.dat, performance.dat)
m <- lm(performance ~ total.precitipitation + minimum.visibility + average.wind_speed, data = dat)
summary(m)

dat.EWR <- dat %>% filter(origin == "EWR")
m.EWR <- lm(performance ~ total.precitipitation + minimum.visibility + average.wind_speed, data = dat.EWR)
summary(m.EWR)
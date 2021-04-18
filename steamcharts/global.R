library(shiny)
library(shinydashboard)
library(plyr)
library(dplyr)
library(tidyverse)
library(lubridate)
library(zoo)
library(glue)
library(plotly)
library(scales)
library(shinyWidgets)
options(scipen = 999)

games <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-03-16/games.csv')

games <- games %>% 
  mutate(tanggal = ymd(paste(year,"-",month,"-01")))
games$date <- as.yearmon(games$tanggal, "%y%m")
games <- games %>% 
  select(year, month, date, gamename, avg, gain, peak, avg_peak_perc)

dataframe <- games %>% 
  select(year, month, gamename, avg, gain, peak, avg_peak_perc)
  


## load packages
library(data.table)
library(dplyr)
library(ggplot2)
library(speedglm)
library(zoo)
library(lubridate)
library(logistf)

## data preprocess
preprocess <- function(df){
  # making base dateframe of event
  df <- df %>% filter(is.na(miss)) %>%
    filter(fullprice > 0) %>%
    mutate(event = (id == lag(id) & fullprice != lag(fullprice))) %>%
    group_by(id) %>%
    select(id, date, fullprice, event, cat1, cat2, cat3, cat4,
           category)
  df1$cat1[is.na(df1$cat1)] <- 0
  df1$cat2[is.na(df1$cat2)] <- 0
  df1$cat3[is.na(df1$cat3)] <- 0
  df1$cat4[is.na(df1$cat4)] <- 0
  df1$cat5[is.na(df1$cat5)] <- 0
  df1$event <- ifelse(df1$event == "TRUE",1,0)
  df1$event[is.na(df1$event)] <- 0
  
  # make date as "date" variable
  df1$date <- dmy(df1$date)
  
  # make "len" on df
  df <- df %>% filter(event == 1) %>%
    mutate(len = difftime(date,lag(date), units = "days"),
           direction = case_when(lag(fullprice) - fullprice > 0 ~ -1,
                                 lag(fullprice) - fullprice < 0 ~ 1))
  df$len[is.na(df$len)] <- 0
  df <- df %>% na.omit()
  
  # mutate date1 to refer time duration and fill NA as last non-NA
  df <- df %>% mutate(date1 = case_when(lag(event == 1) ~ lag(date))) %>%
    arrange(id,date) %>% group_by(id) %>% fill(date1) %>% 
    mutate(duration = as.integer(difftime(date, date1, units = "days")),
           date = as.Date(date),
           logprice = log1p(fullprice),
           pricecat = case_when(logprice < 1.41099 ~ "Q1",
                                logprice >= 1.41099 & 
                                  logprice < 1.79009 ~ "Q2",
                                logprice >= 1.79009 & 
                                  logprice < 2.39777 ~ "Q3",
                                logprice >= 2.39777 ~ "Q4"),
           magnitude = fullprice - lag(fullprice))
  
  # making a monthday
  df$day <- factor(weekdays(df$date),
                   levels = c("Monday","Tuesday","Wednesday",
                              "Thursday","Friday","Saturday","Sunday"))
  # make seasonal dummies
  df$season <- factor(format(as.yearqtr(as.yearmon(df$date) + 1/12), "%q"), 
                      levels = 1:4,
                      labels = c("winter", "spring", "summer", "fall"))
  
  # make weekly dummies
  df$month <- factor(format(df$date, "%B"),
                     levels = c("January","February","March","April",
                                "May","June","July","August",
                                "September","October","November",
                                "December"))
  
  df <- df %>% mutate(weekofm = factor(weekofm),
                      category = factor(category),
                      season = factor(season))
}
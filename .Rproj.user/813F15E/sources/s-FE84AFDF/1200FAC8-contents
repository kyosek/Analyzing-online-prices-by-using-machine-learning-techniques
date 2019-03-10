library(data.table)
setwd("/Volumes/HD-PVRU2/data")
df <- fread("usa.csv")

library(dplyr)
df <- df %>% mutate(date = as.Date(date)) %>% select(-monthly,-week)

train <- df %>% filter(date < "2010-02-26")
test <- df %>% filter(date >= "2010-02-26")

# making a monthday
df$day <- weekdays(df$date)
df$dayfac <- factor(df$day,
                     levels = c("Monday","Tuesday","Wednesday",
                                "Thursday","Friday","Saturday",
                                "Sunday"))
# make seasonal dummies
library(zoo)
df$yq <- as.yearqtr(as.yearmon(df$date) + 1/12)
df$season <- factor(format(df$yq, "%q"), levels = 1:4,
                     labels = c("winter", "spring", "summer", "fall"))

# make weekly dummies
library(lubridate)
df$month <- factor(format(df$date, "%B"),
                   levels = c("January","February","March","April",
                              "May","June","July","August",
                              "September","October","November",
                              "December"))

df <- df %>% 
  mutate(pricecat = case_when(logprice < 1.41099 ~ "Q1",
                              logprice >= 1.41099 & 
                                logprice < 1.79009 ~ "Q2",
                              logprice >= 1.79009 & 
                                logprice < 2.39777 ~ "Q3",
                              logprice >= 2.39777 ~ "Q4"))
df$pricecat <- factor(df$pricecat,
                       levels = c("Q1","Q2","Q3","Q4"))

ggplot(df, aes(eventfac,fullprice))+geom_boxplot()


df <- df %>% group_by(id) %>%
  mutate(magnitude = fullprice - lag(fullprice))
df$magnitude[is.na(df$magnitude)] <- 0

#### visualization for thesis ####
library(ggplot2)
# fullprice histogram
ggplot(data = df, aes(x = fullprice)) +
  geom_histogram(bins = 100) + xlim(0,100) +
  labs(x = 'price', y = 'count')+
  theme(axis.text=element_text(size=17),
        axis.title=element_text(size=17,face="bold"))

# magnitude histogram
ggplot(data = df, aes(x = magnitude)) +
  geom_histogram(bins = 1000) + xlim(-200,200) + ylim(0,40000) +
  labs(x = 'magnitude of price change', y = 'count')

# probability dist. on day
df %>% group_by(day) %>%
  summarise(mean_event = mean(event)) %>%
  ggplot(aes(x=day, y=mean_event)) +
  geom_bar(stat = "identity") +
  labs(x = 'day of a week', y = 'Probability')+
  geom_abline(intercept = 0.0491, slope = 0,color="red")+
  theme(axis.text=element_text(size=17),
        axis.title=element_text(size=17,face="bold"),
        axis.title.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.ticks.y=element_blank())+
  scale_x_discrete(labels=c("Mon","Tue","Wed","Thu","Fri","Sat",
                            "Sun"))

# probability dist. on week
df %>% group_by(weekofm) %>%
  summarise(mean_event = mean(event)) %>%
  ggplot(aes(x=weekofm, y=mean_event)) +
  geom_bar(stat = "identity") +
  labs(y = 'Probability')+
  geom_abline(intercept = 0.0491, slope = 0,color="red")+
  theme(axis.text=element_text(size=15),
        axis.title=element_text(size=15,face="bold"),
        axis.title.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.ticks.y=element_blank())+
  scale_x_discrete(labels=c("1st","2nd","3rd","4th","5th"))

# probability dist. on month
df %>% group_by(month) %>%
  summarise(mean_event = mean(event)) %>%
  ggplot(aes(x=month, y=mean_event)) +
  geom_bar(stat = "identity") +
  labs( y = 'Probability')+
  geom_abline(intercept = 0.0491, slope = 0,color="red")+
  theme(axis.text=element_text(size=13),
        axis.title=element_text(size=15,face="bold"),
        axis.title.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.ticks.y=element_blank())+
  scale_x_discrete(labels=c("Jan","Feb","Mar","Apr","May","Jun","Jul",
                            "Aug","Sep","Oct","Nov","Dec"))

# probability dist. on season
df %>% group_by(season) %>%
  summarise(mean_event = mean(event)) %>%
  ggplot(aes(x=season, y=mean_event)) +
  geom_bar(stat = "identity") +
  labs(x = 'season', y = 'Probability')+
  geom_abline(intercept = 0.0491, slope = 0,color="red")+
  theme(axis.text=element_text(size=15),
        axis.title=element_text(size=15,face="bold"),
        axis.title.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.ticks.y=element_blank())

# probability dist. on pricecat
df %>% group_by(pricecat) %>%
  summarise(mean_event = mean(event)) %>%
  ggplot(aes(x=pricecat, y=mean_event)) +
  geom_bar(stat = "identity") +
  labs(x = 'price category', y = 'Probability')+
  geom_abline(intercept = 0.0491, slope = 0,color="red")+
  theme(axis.text=element_text(size=13),
        axis.title=element_text(size=15,face="bold"),
        axis.title.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.ticks.y=element_blank())

# probability dist. on category
df %>% group_by(category) %>%
  summarise(mean_event = mean(event)) %>%
  ggplot(aes(x=category, y=mean_event)) +
  geom_bar(stat = "identity") +
  labs( y = 'Probability')+
  geom_abline(intercept = 0.0491, slope = 0,color="red")+
  theme(axis.text=element_text(size=10),
        axis.title=element_text(size=15,face="bold"),
        axis.title.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.ticks.y=element_blank())

df$category <- as.numeric(df$category)

# logistic regression
df <- df %>% mutate(weekofm = factor(weekofm)) %>%
  mutate(category = factor(category)) %>%
  mutate(season = factor(season))

library(speedglm)
model <- speedglm(event ~ duration + day +weekofm +  month +
                    fullprice +pricecat+ category,
                  data = df,
                  family = binomial(link = "logit"), maxit = 50)
summary(model)

#### weekly analysis ####
# make weekly data
library(dplyr)
library(zoo)
library(lubridate)
df <- df %>% mutate(week = week(date))
weeky <- df %>% group_by(id,week,category) %>%
  summarise_each(funs(mean))

weekly$day <- weekdays(weekly$date)
weekly$dayfac <- factor(weekly$day,
                        levels = c("Monday","Tuesday","Wednesday",
                                   "Thursday","Friday","Saturday",
                                   "Sunday"))

# make event, direction, and logprice
weekly <- weekly %>% group_by(id) %>%
  mutate(event = case_when (lag(fullprice) == fullprice ~ 0,
                            lag(fullprice) != fullprice ~ 1)) %>%
  mutate(direction =
           case_when(lag(fullprice) - fullprice > 0 ~ -1,
                     lag(fullprice) - fullprice < 0 ~ 1,
                     lag(fullprice) - fullprice == 0 ~ 0)) %>%
  mutate(logprice = log(fullprice+1))
weekly$event[is.na(weekly$event)] <- 0
weekly$direction[is.na(weekly$direction)] <- 0

weeky$event <- ifelse(weeky$event >0,1,0)

weekly$eventfac <- factor(weekly$event)
weekly$direcfac <- factor(weekly$direction)

weekly$month <- factor(format(weekly$date, "%B"),
                       levels = c("January","February","March",
                                  "April","May","June","July",
                                  "August","September","October",
                                  "November","December"))
library(dplyr)
library(zoo)
weekly$yq <- as.yearqtr(as.yearmon(weekly$date) + 1/12)
weekly$season <- factor(format(weekly$yq, "%q"), levels = 1:4,
                        labels = c("winter", "spring",
                                   "summer", "fall"))
weekly <- weekly %>% select(-yq)

weekly <- left_join(weekly, df, by=c(id,date))

weekly <- weekly %>%
  mutate(pricecat = case_when(fullprice > 24.99 ~ "Q4",
                              fullprice <= 24.99 & 
                                fullprice > 6.49 ~
                                "Q3",
                              fullprice <= 6.49 & 
                                fullprice >= 3.32 ~
                                "Q2",
                              fullprice < 3.32 ~ "Q1"))
weekly$pricecat <- factor(weekly$pricecat,
                          levels = c("Q1","Q2","Q3","Q4"))

library(lubridate)
weekly$weekofm <- ceiling(as.numeric(day(weekly$date)) / 7) 

# get the highest cond. prob. on category 531
cat531 <- df %>% filter(category == 531)

#### logit ####
model <- glm(event~duration+fullprice+factor(weekofm)+month+pricecat+
               category,data=weekly,
             family = binomial(link = "logit"))
summary(model)

weekly <- weekly %>% mutate(cat531=
                              case_when(category=="531"~1,
                                        category!="531"~0))

model <- glm(event~duration+fullprice+cat531,data=weekly,
             family = binomial(link = "logit"))
summary(model)

anova(model1,"chisq")
library(BaylorEdPsych)
PseudoR2(model1)

library(aod)
library(ggplot2)
l <- cbind(0,1, -1)
wald.test(b = coef(model), Sigma = vcov(model),Terms = 61)
wald.test(b = coef(model), Sigma = vcov(model),Terms = 3)

exp(coef(model1))

#### firth ####
library(dplyr)
df <- df %>% 
  mutate(cat531 =
           case_when(category == "531" ~ 1,
                     category != "531" ~ 0)) %>%
  mutate(cat1212 =
           case_when(category == "1212" ~ 1,
                     category != "1212" ~ 0))%>%
  mutate(week_2 =
           case_when(weekofm == "2" ~ 1,
                     weekofm != "2" ~ 0))%>%
  mutate(week_5 =
           case_when(weekofm == "5" ~ 1,
                     weekofm != "5" ~ 0))%>%
  mutate(Sep =
           case_when(month == "September" ~ 1,
                     month != "September" ~ 0))%>%
  mutate(pricecat_3 =
           case_when(pricecat == "3" ~ 1,
                     pricecat != "3" ~ 0))

library(logistf)
# E Net
firthe = logistf(event ~ duration + fullprice+ cat531,
                 data=df)
summary(firthe)

# Lasso
firth = logistf(event ~ duration + fullprice,
                data=df)
summary(firth)

anova(firth,firthe)
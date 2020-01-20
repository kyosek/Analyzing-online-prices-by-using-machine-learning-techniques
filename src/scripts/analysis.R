## visualisation ##
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
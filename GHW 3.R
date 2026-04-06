

d <- MAT342data
names(d)[c(45,41,48, 46, 52, 76, 77)] #INCOM16 RES16 PARTYID INCOME RELIG16 YEARSJOB MNTLHLTH 
d2 <- d[,c(45,41,48, 46, 52, 76, 77)]
d2 <- filter(d2, YEARSJOB > 0)	
d2 <- filter(d2, MNTLHLTH > 0)
d2 <- filter(d2, INCOM16 > 0)


# Taking a sample of 200 from the dataset
p <- d2 %>% slice_sample(n = 200, replace = TRUE)

# Take the mean of YEARSJOB 500 times by resampling p
num_trials <- 500
yj_200_bs <- 1:num_trials %>%
  map_dfr(
    ~p %>%
      slice_sample(n = 200, replace = TRUE) %>%
      summarize(mean_yearsjob = mean(YEARSJOB))
    ) %>%
  mutate(n = 200)

yj_200_bs %>% summarize(q95 = quantile(mean_yearsjob, p = 0.95))

#

ggplot(d2, aes(x = YEARSJOB, y = MNTLHLTH)) + geom_point(alpha = 0.6) + 
  geom_smooth(method = "lm", se = TRUE, color = "blue") +
  labs( title = "Relationship Between Years on the Job and Mental Health", x = "Years at Current Job", y = "Days of Poor Mental Health (Past 30 Days)") 

theme_minimal()

model <- lm(MNTLHLTH ~ YEARSJOB, data = d2)
summary(model)

# my code

combination = d2$MNTLHLTH + d2$INCOM16

ggplot(d2, aes(x=YEARSJOB)) + 
  geom_point(alpha = 0.4, aes(y=MNTLHLTH, color="Mental Health")) +
  geom_point(alpha = 0.4, aes(y=INCOM16, color="Income at 16")) + 
  labs(color="Legend text") +
  geom_smooth(method = "lm",  se = TRUE, color = "blue", aes(x = YEARSJOB, y = MNTLHLTH)) +
  geom_smooth(method = "lm", se = TRUE, color = "red", aes(x = YEARSJOB, y = INCOM16)) + 
  geom_smooth(method = "lm", se = TRUE, color = "green", aes(x = YEARSJOB, y = combination)) +
  labs( title = "Relationship Between Years on the Job + Household Income at 16 + Mental Health", x = "Years at Current Job", y = "Days of Poor Mental Health + Income at 16") 


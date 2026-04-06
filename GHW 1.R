library(ggplot2)
library(dplyr)

d <- MAT342data
names(d)[c(45,41,48, 46, 52, 76, 77)] #INCOM16 RES16 PARTYID INCOME RELIG16 YEARSJOB MNTLHLTH 
d2 <- d[,c(45,41,48, 46, 52, 76, 77)]
head(d2)

#removes any "non-answers". I'm not really interested in those right now
d2$INCOME <- ifelse(d2$INCOME<0, NA,d2$INCOME)
d2$INCOM16 <- ifelse(d2$INCOM16<0, NA, d2$INCOM16)
d2$MNTLHLTH <- ifelse(d2$MNTLHLTH<0, NA, d2$MNTLHLTH)

# these are "don't know" & "no answer" respectively
d2$MNTLHLTH <- ifelse(d2$MNTLHLTH==98, NA, d2$MNTLHLTH)
d2$MNTLHLTH <- ifelse(d2$MNTLHLTH==99, NA, d2$MNTLHLTH)

# setting them all as categories
d2$PARTYID <- as.factor(d2$PARTYID)
d2$YEARSJOB <- as.factor(d2$YEARSJOB)
d2$MNTLHLTH <- as.factor(d2$MNTLHLTH)
d2$INCOME <- as.factor(d2$INCOME)
d2$INCOM16 <- as.factor(d2$INCOM16)

# testing the poor mental health days of people depending on their income
ggplot(data = d2, aes(x = INCOME, y = MNTLHLTH)) + geom_count() + geom_jitter(alpha = .25, aes(col=INCOM16))

#Political Party Identification by Current Income Code
d2_clean <- d2 %>% filter(PARTYID != -99)
ggplot(d2_clean, aes(x = INCOME, fill = as.factor(PARTYID))) +
  geom_bar(position = "fill") +
  labs(
    title = “Political Party Identification by Current Income”,
    x = “Current Income”,
    y = “Percentage of Respondents”,
    fill = “Party ID”
  ) +
  scale_y_continuous(labels = scales::percent_format())

#Income to Incom16 
d <- MAT342data 
names(d)[c(45,41,48, 46, 52, 76, 77)] #INCOM16 RES16 PARTYID INCOME RELIG16 YEARSJOB MNTLHLTH
d2 <- d[,c(45,41,48, 46, 52, 76, 77)]
#get rid of N/As ~~
  
ggplot(data = d2, aes(x = INCOME, y = INCOM16)) + geom_count() + geom_jitter(alpha = .25, aes(col=INCOME))
graphd2 + ggtitle("Income At 16 To Income In The Last Year")

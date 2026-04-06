library(ggplot2)
library(dplyr)
library(tidyr)

# SETTING UP VARIABLES FOR USE
d <- MAT342data
names(d)[c(45,41,48, 46, 52, 76, 77)] #INCOM16 RES16 PARTYID INCOME RELIG16 YEARSJOB MNTLHLTH 
d2 <- d[,c(45,41,48, 46, 52, 76, 77)]
head(d2)

# filter() required for 2.
# Filter out only Income missing values
d2 |> filter(INCOM16 >0)

# Filter out some of the YEARSJOB missing values
d2 |> filter(YEARSJOB != "-100")

# Filter out both
d2 |> filter(YEARSJOB != "-100", INCOM16 >0, RES16 >0)
d2

# mutate() required for 1.
# Employed is 1, Unemployed is 0
d3 <- d2 |> mutate(Employed = ifelse(YEARSJOB == "-100", 0, 1))
d3 <- d3 |> filter(INCOM16 >0)


# summarize() and group_by() required for 3.
d3 |>
  summarize(
    N = n(),
    poorest = min(INCOM16),
    richest = max(INCOM16)
  )

employment.income.residence <- d3 |>
  group_by(RES16, Employed) |>
  summarize(mean_income = mean(INCOM16))
employment.income.residence

# pivot_wider() required for 4.
pivot01 <- employment.income.residence |>
  pivot_wider(names_from = Employed, values_from = mean_income)
pivot01

# graph required for 5.
ggplot(data = pivot01, aes(x=`0`, y = `1`, color = RES16)) + geom_point(size = 5) + expand_limits(x = 2, y =2) + labs(x = "Average Income Bracket at 16 of Unemployed", y = "Average Income Bracket at 16 of Employed") +  geom_abline(slope=1, intercept = 0)

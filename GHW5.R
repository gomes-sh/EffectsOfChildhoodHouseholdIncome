library(dplyr)
library(tidyverse)
library(mosaicData)
library(tidymodels)
library(rpart)
library(rpart.plot)
library(yardstick)
library(partykit)

d <- MAT342data
names(d)[c(45,41,48, 46, 52, 76, 77)] #INCOM16 RES16 PARTYID INCOME RELIG16 YEARSJOB MNTLHLTH 
d2 <- d[,c(45,41,48, 46, 52, 76, 77)]

d2$INCOME <- ifelse(d2$INCOME<0, NA,d2$INCOME)
d2$INCOM16 <- ifelse(d2$INCOM16<0, NA, d2$INCOM16)
d2$MNTLHLTH <- ifelse(d2$MNTLHLTH<0, NA, d2$MNTLHLTH)
d2$YEARSJOB <- ifelse(d2$YEARSJOB<0, NA, d2$YEARSJOB)
d2$RES16 <- ifelse(d2$RES16<0, NA, d2$RES16)
d2$PARTYID <- ifelse(d2$PARTYID<0, NA, d2$PARTYID)
d2$RELIG16 <- ifelse(d2$RELIG16<0, NA, d2$RELIG16)

head(d2)

# Part 1 - Splitting into 75% training and 25% test data
set.seed(256)
d2$INCOM16f <- as.factor(d2$INCOM16)
d2$RES16f <- as.factor(d2$RES16)
d2$PARTYIDf <- as.factor(d2$PARTYID)
d2$INCOMEf <- as.factor(d2$INCOME)
d2$RELIG16f <- as.factor(d2$RELIG16)

n <- nrow(d2)
data_parts <- d2 |>
  initial_split(prop = 0.75)
train <- data_parts |> training()
test <- data_parts |> testing()

# Part 2 - Fitting CART model on the training data set
mod_dtree <- decision_tree(mode = "classification", cost_complexity = 0.005) |>
  set_engine("rpart") |>
  fit(INCOM16f ~ RES16f + PARTYIDf + INCOMEf + RELIG16f + YEARSJOB + MNTLHLTH, data = train)

split_val <- mod_dtree$fit$splits |>
  as_tibble() |>
  pull(index)

plot(as.party(mod_dtree$fit))

# Part 3 - Obtain predictions for training data with confusion matrix and model accuracy
pred <- train |>
  select(INCOM16f) |>
  bind_cols(
    predict(mod_dtree, new_data = train, type = "class")
  ) |>
  rename(income_dtree = .pred_class)

confusion <- pred |>
  conf_mat(truth = INCOM16f, estimate = income_dtree)
confusion

accuracy(pred, INCOM16f, income_dtree)


# Part 4- Obtain predictions for test data with confusion matrix and model accuracy
pred <- test |>
  select(INCOM16f) |>
  bind_cols(
    predict(mod_dtree, new_data = test, type = "class")
  ) |>
  rename(income_dtree2 = .pred_class)

confusion <- pred |>
  conf_mat(truth = INCOM16f, estimate = income_dtree2)
confusion

accuracy(pred, INCOM16f, income_dtree2)
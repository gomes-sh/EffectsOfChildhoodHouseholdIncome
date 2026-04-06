library(ggplot2)
library(dplyr)
library(tidyverse)
library(rpart)
library(rpart.plot)
library(mosaicData)
library(tidymodels)
library(yardstick)
library(pROC)



d <- MAT342data
names(d)[c(45,41,48, 46, 52, 76, 77)] #INCOM16 RES16 PARTYID INCOME RELIG16 YEARSJOB MNTLHLTH 
d2 <- d[,c(45,41,48, 46, 52, 76, 77)]

# Part 1  - Collapsing INCOM16 to two levels
d2$INCOM16f <- as.factor(d2$INCOM16)

d2$incomeLevel <- fct_collapse(d2$INCOM16f,
                            "Higher Income" = c("3", "4", "5"),
                            other_level = "Lower Income")

levels(d2$incomeLevel)
levels(d2$INCOM16f)

table(d2$incomeLevel, d2$INCOM16f)

# Part 2 - Creating a null model with the collapsed data
set.seed(364)
n <- nrow(d2)
d2_parts <- d2 |>
  initial_split(prop = 0.75)

train <- d2_parts |>
  training()

test <- d2_parts |>
  testing()

list(train, test) |>
  map_int(nrow)

train |>
  count(incomeLevel) |>
  mutate(pct = n / sum(n))

mod_null <- logistic_reg(mode = "classification") |>
  set_engine("glm") |>
  fit(incomeLevel ~ 1, data = train)

pred <- train |>
  select(incomeLevel, MNTLHLTH) |>
  bind_cols(
    predict(mod_null, new_data = train, type = "class")
  ) |>
  rename(income_null = .pred_class)
accuracy(pred, incomeLevel, income_null)

confusion_null <- pred |>
  conf_mat(truth = incomeLevel, estimate = income_null)
confusion_null

# Part 3 - Fitting a Logistic Regression Model
log_model <- glm(incomeLevel ~ MNTLHLTH, data = d2, family = binomial)
tidy(log_model)

# Part 4 - Generating Confusion Matrix
prob <- predict(log_model, newdata = d2, type = "response")

pred_class <- ifelse(prob > 0.5, "Higher Income", "Lower Income")
pred_class <- factor(pred_class, levels = levels(d2$incomeLevel))

pred_df <- d2 |>
  mutate(pred_class = pred_class)

confusion_log <- pred_df |>
  conf_mat(truth = incomeLevel, estimate = pred_class)
confusion_log

# Part 5 - Creating ROC Curve

pred2 <- d2 |>
  mutate(
    .pred_HigherIncome = prob,
    .pred_LowerIncome  = 1 - prob
  )

roc_curve_log <- pred2 |>
  mutate(estimate = .pred_HigherIncome) |>
  roc_curve(
    truth = incomeLevel,
    estimate,
    event_level = "second"
  ) |>
  autoplot(roc_curve_log)
roc_curve_log

pred_accuracy <- pred2 |>
  mutate(
    pred_class = if_else(.pred_HigherIncome > 0.5,
                         "Higher Income",
                         "Lower Income"),
    pred_class = factor(pred_class,
                        levels = levels(incomeLevel))
  )

accuracy(pred_accuracy, truth = incomeLevel, estimate = pred_class) 

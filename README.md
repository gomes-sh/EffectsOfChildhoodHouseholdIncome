# Effects Of Childhood Household Income

This repository contains the R code for an analysis of variables that correlate to childhood household income. This project was done for a Data Analytics class at my college in 2025 in collaboration with two classmates.

All data comes from the <a href="https://gssdataexplorer.norc.org/">GSS Data Explorer</a> from the 2016 survey. In particular, the following variables are used: INCOM16, RES16, PARTYID, INCOME, RELIG16, YEARSJOB, MNTLHLTH. These correspond to the following.

<ul>
  <li>Household income at 16 years old.</li>
  <li>Area of residence at 16 years old.</li>
  <li>Current political party.</li>
  <li>Current household income.</li>
  <li>Religion at 16 years old.</li>
  <li>Number of years at current job.</li>
  <li>Number of days per month of poor mental health.</li>
</ul>

## File Overview
<ul>
  <li>**GHW1** subsets the data, removes any missing values, sets them all to factors, and plots three different graphs to get a better view of the data.</li>
  <li>**GHW2** creates a new variable Employed, where YEARSJOB is mutated to create a variable indicating if someone is currently employed or not. This is then plotted against RES16.</li>
  <li>**GHW3** uses bootstrap estimation on YEARSJOB to calculate 95% confidence interval. This is then plotted in two scatterplots.</li>
  <li>**GHW4** recodes INCOM16 to two levels: higher and lower income. It creates a confusion matrix, fits a logistic regression model to it as a function of MNTLHLTH, creates a confusion matrix for the model, and then plots an ROC curve to determine accuracy.</li>
  <li>**GHW5** splits the data into training and test sets. A CART model is trained on the training set and accuracy determined. It is then rerun on the test data to assure there is no overfitting.</li>
</ul>

# Predicting Employee Turnover
Dataset: https://www.kaggle.com/datasets/jacksonchou/hr-data-for-analytics <br>
Analysis instructions from Field (2012). <br>
Code adapted from Field (2012). 

## Introduction
* Employee turnover is “a measure of permanent separation from the organization” (Gatewood et al., 2008, p. 672).
* This dataset and company are fictional, but turnover is a very real concern for companies. Due to the cost to hire and train new employees, having a high employee turnover rate can get expensive. 
* Additionally, important institutional knowledge can be lost when an experienced employee leaves. This can have its own costs, such as decreased productivity.

## Questions to Answer
* How do we predict individual employee turnover?
* What influences attrition?
* How do we improve employee retention?
## What predictors are in the dataset?
* Satisfaction ratings
* Score on last evaluation
* Number of projects
* Hours worked per month
* Employee tenure
* Work accidents
* Promotions
* Department
* Salary Range

## Developing a Prediction Model
* Logistic Regression is the statistical method used. This is appropriate when we are attempting to predict a binary outcome.
* Model was able to predict 21% variance in employee turnover (Cox and Snell's pseudo R^2 = 0.21).

## What wasn't included?
* Scores on last evaluation (low generalizability, too closely related to hours worked and number of projects)
* Average hours worked per month (too closely related to number of projects, less predictive)
* Most departments (not significant)

## Increases Likelihood of Staying:
* Satisfaction level
* High or medium salary
* Promoted in the last 5 years
* Involved in an accident at work
* Department is R & D or Management
* Having a large number of projects

## Increases Likelihood of Leaving:
* Tenure

## Recommendations:
* Improve employee satisfaction
* Consider compensation
* Assign more projects where appropriate for employee development
* Promote from within

## Actionable Steps:
* Benchmark turnover rates against comparable companies
* Conduct detailed employee satisfaction survey and focus groups to identify ways to improve satisfaction
* Competitive salary benchmarking to ensure compensation is competitive
* Put an employee development program in place
* Look to fill open roles by promoting from within

## Citations
Field, A., Miles, J., & Field, Z. (2012). Discovering Statistics Using R. SAGE. <br>
Gatewood, R. D., Feild, H. S., & Barrick, M. R. (2008). Human resource selection. Cengage Learning.<br>
R Core Team (2013). R: A language and environment for statistical computing. R Foundation for Statistical Computing, Vienna, Austria. URL http://www.R-project.org/.

## Assumptions Made About the Data:
* Voluntary and involuntary attrition are both included
* For binary columns (“Work_accident”, “left_employer”, “promotion_last_5years”), 0 is no and 1 is yes
* Column labeled “sales” is the employee’s department
* The “time_spend_company” column is a rating of tenure by year
* The columns “satisfaction_level” and “last evaluation” are ratings from a 0-1 scale where higher is better, and measure employee satisfaction and performance, respectively

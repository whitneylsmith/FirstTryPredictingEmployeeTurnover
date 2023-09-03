# Predicting Employee Turnover Rate
# Data Analytics Case Study
# Data Exploration

# Dataset from Kaggle: 
# https://www.kaggle.com/datasets/jacksonchou/hr-data-for-analytics

#
# Install required packages if needed
# tidyverse for data import and wrangling
# ggplot2 (included in tidyverse) for visualizations
# corrplot for creating a correlation matrix visualization
#

# Step 1: Load Packages===============================================

library(tidyverse) # for wrangling data and visualizations
library(skimr)
library(corrplot) # creates a correlation matrix viz
library(ggplot2)

#Packages for logistic regression
library(car)
library(mlogit)
library(Rcmdr)


# Step 2: Import Data===============================================
# First, download the dataset from Kaggle:
# https://www.kaggle.com/datasets/jacksonchou/hr-data-for-analytics
# Set your working directory to where you have saved the csv file

# Importing and saving as a tibble dataframe named "df"
df <- as_tibble(read.csv("HR_comma_sep.csv",header=TRUE,
                         stringsAsFactors=TRUE))


# Step 3: Getting to know your data==================================

str(df) # Structure
glimpse(df) # Preview
colnames(df) # Lists the column names
skim_without_charts(df) # Part of the skimr package, detailed summary


# Step 4: Cleaning Your Data==================================

# Renaming "left" column as "left_employer for clarity
# Renaming "time_spend_company" as "tenure"
# Renaming "Work_accident" as "work_accident" for consistency
df <- df %>% 
  rename(left_employer = left) %>% 
  rename(tenure = time_spend_company) %>% 
  rename(work_accident = Work_accident) %>% 
  rename(average_monthly_hours = average_montly_hours)

# The column "sales" appears to be a list of employees' departments
# Let's rename it to "department"
df <- df %>% 
  rename(department = sales) 

# Try this instead for releveling salary instead of recoding
df$salary <- factor(df$salary, levels = c('low', 'medium', 'high'))

# salary is listed as low, medium, or high. 
# Let's add a column that codes the salary ranges as numbers
# This will help us calculate a correlation coefficient later too
# Use dplyr::recode so that we are getting the dplyr function, (which
# is masked by the car recode function)
# df$salary_code<-dplyr::recode(df$salary,'low'=1,'medium'=2,'high'=3)

#============================
# Step 5: Exploring the Data
#============================

#Percent Attrition Rate for the whole dataset
sum(df$left_employer)/nrow(df)*100

#Create aggregate dataframe to look at turnover rate by department
total_dept_df <- aggregate(df$left_employer, by=list(df$department), FUN=length)
left_dept_df <- aggregate(df$left_employer, by=list(df$department), FUN=sum)
total_dept_df$left <- left_dept_df$x 
total_dept_df$rate <- total_dept_df$left / total_dept_df$x
names(total_dept_df)[names(total_dept_df)=="x"] <- "total"
names(total_dept_df)[names(total_dept_df)=="Group.1"] <- "Department"

#total_dept_df now shows turnover rate by department
write.csv(total_dept_df,file="turnover_rate_by_department.csv")

# Histograms 

ggplot(data=df) +
  geom_bar(mapping=aes(x=left_employer),fill="lightblue") +
  labs(x="Retained vs. Left", 
       y="Frequency",
       title="Employee Retention vs Attrition",
       caption="kaggle.com/datasets/jacksonchou/hr-data-for-analytics")



# Left vs Tenure (both ways to measure retention/attrition)
# Very few people leave before 3 years of tenure
# Both distributions are positively skewed
df %>% 
  mutate(left_employer = as.factor(left_employer)) %>% 
  ggplot(mapping=aes(x=tenure, fill=left_employer)) +
  geom_histogram(position="dodge", bins = 9)+
  labs(title="Distribution of Tenure",
       x="Years with Company", y="Employee Count")+
  scale_fill_discrete(name = "Group",
                      labels = c("Retained", "Left"))

cor(df$tenure, df$left_employer, method="pearson")
cor.test(df$tenure, df$left_employer, method="pearson")


# Left vs Satisfaction Rating
# Satisfaction level looks pretty normally distributed
# among leavers, but negatively skewed in retained ppl
df %>% 
  mutate(left_employer = as.factor(left_employer)) %>% 
  ggplot(mapping=aes(x=satisfaction_level, fill=left_employer)) +
  geom_histogram(position="dodge", bins=6)+ 
  labs(title="Distribution of Satisfaction Ratings",
  x="Satisfaction Rating", y="Employee Count") +
  scale_fill_discrete(name = "Group",
                      labels = c("Retained", "Left"))

#Left vs Score on Last Evaluation
#Bimodal!!
df %>% 
  mutate(left_employer = as.factor(left_employer)) %>% 
  ggplot(mapping=aes(x=last_evaluation, fill=left_employer)) +
  geom_histogram(position="dodge", bins = 15)+
  labs(title="Distribution of Evaluation Scores",
       x="Score on Last Evaluation", y="Employee Count") +
  scale_fill_discrete(name = "Group",
                      labels = c("Retained", "Left"))

# Left vs number of projects
# A decent sized section of leavers had very few projects
# The people with the very highest number of projects also left
# Both distributions are positively skewed
df %>% 
  mutate(left_employer = as.factor(left_employer)) %>% 
  ggplot(mapping=aes(x=number_project, fill=left_employer)) +
  geom_histogram(position="dodge", bins = 5)+
  labs(title="Distribution of Project Count",
       x="Number of Projects", y="Employee Count") +
  scale_fill_discrete(name = "Group",
                      labels = c("Retained", "Left"))

# Left vs. Monthly Hours Worked
# The distribution for leavers is bimodal, but the
# distribution of retained employees is closer to normal
df %>% 
  mutate(left_employer = as.factor(left_employer)) %>% 
  ggplot(mapping=aes(x=average_monthly_hours, fill=left_employer)) +
  geom_histogram(position="dodge", bins = 20)+
  labs(title="Distribution of Hours Worked",
       x="Hours per Month", y="Employee Count") +
  scale_fill_discrete(name = "Group",
                      labels = c("Retained", "Left"))

# Left vs work accident
df %>% 
  mutate(left_employer = as.factor(left_employer)) %>% 
  ggplot(mapping=aes(x=work_accident, fill=left_employer)) +
  geom_histogram(position="dodge", bins = 3)+
  labs(title="Distribution of Work Accidents",
               x= "No Accident vs. Accident",y="Employee Count") +
  scale_fill_discrete(name = "Group",
                      labels = c("Retained", "Left"))




# Left vs Promotions
# Very few employees have been promoted in the last 5 years
# Almost nobody who has been promoted has left the company
df %>% 
  mutate(left_employer = as.factor(left_employer)) %>% 
  ggplot(mapping=aes(x=promotion_last_5years, fill=left_employer)) +
  geom_histogram(position="dodge", bins=3)+
  labs(title = "Distribution of Promotions in the Last 5 Years", 
       x="Not Promoted vs Promoted", y="Employee Count")+
  scale_fill_discrete(name = "Group",
                      labels = c("Retained", "Left"))

# Attrition by department
# Might be more useful to calculate rate by dept
df %>% 
  mutate(left_employer = as.factor(left_employer)) %>% 
ggplot(aes(x=department, fill=left_employer)) +
  geom_bar(position="dodge")+
  labs(title="Distribution of Departments",
       x="Department", y="Employee Count") 
  scale_fill_discrete(name = "Group",
                      labels = c("Retained", "Left"))

# Left vs Salary Level
# Low/Med/High Salary
# Looks like lower salary correlates with higher attrition
df %>% 
  mutate(left_employer = as.factor(left_employer)) %>% 
  ggplot(aes(x=salary, fill=left_employer)) +
  geom_bar(position="dodge")+
  labs(title="Distribution of Salaries",
       x="Salary Range", y="Employee Count") +
  scale_fill_discrete(name = "Group",
                      labels = c("Retained", "Left"))

# Original method. We don't have to use this if we relevel salary
# Now that salary ranges are in order it's clearer
# Used scale_x_discrete and scale_fill_discrete to change x-axis
# numbering and legend labels (x needs to come before fill)

#df %>% 
#  mutate(left_employer = as.factor(left_employer)) %>% 
#  ggplot(aes(x=salary_code, fill=left_employer)) +
#  geom_bar(position="dodge") +
#  scale_x_discrete(limit=c("1","2","3"),
#                   labels=c("low","medium","high"))+
#  scale_fill_discrete(name = "Employees",
#                      labels = c("Stayed", "Left")) +
#  labs(title="Attrition by Salary Range",
#       x="Salary Range",y="Frequency")

  
# Looking at Tenure vs. factors
# Doesn't appear to be much of a relationship between tenure
# and any of the factors. This is probably due to hte fact that 
# tenure is a long-term measure


# Correlations

my_data <- df[, c(1:8,11)] # only predictors and criterion columns
cor_matrix <- cor(my_data) 
cor_matrix_round <- round(cor_matrix, 2)
corrplot(cor_matrix, type = "lower", order='AOE')

write.csv(cor_matrix,file="cor_matrix.csv")



# Create a pie chart

# Convert left_employer to a factor
df$left_employer <- as.factor(df$left_employer)

# Pie chart
ggplot(data=df, aes(x="", y=left_employer, fill=left_employer)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y",start=0) +
  theme_void() +
  scale_fill_discrete(name="Group",labels = c("Retained", "Left"))

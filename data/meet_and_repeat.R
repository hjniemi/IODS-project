#Heikki Niemi / 9.12.2022
#IODS Assignment 6 data wrangling exercise
#Data source: MABS4IODS book

#Load the required packages
library(tidyverse)

#Load  the data
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep =" ", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE, sep = '\t')


#Check their variable names, view the data contents and structures, and create some brief summaries of the variables
str(BPRS)
str(RATS)

summary(BPRS)
summary(RATS)

#BPRS contains data about psychiatric patients assigned to two different treatments. BPRS scores are measured at time 0 and 1-8 weeks. Each measurement is its own variable from week0 to week8.
#RATS contains data about weight change of three groups of rats on different diets. Weight is measured on different days, each of which is its own variable from WD1 to  WD64

#Convert the categorical variables of both data sets to factors
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

#Convert the data sets to long form. Add a week variable to BPRS and a Time variable to RAT
BPRS <-  pivot_longer(BPRS, cols=-c(treatment,subject),names_to = "weeks",values_to = "bprs") %>% arrange(weeks)
BPRS <-  BPRS %>% mutate(week = as.integer(substr(weeks,5,5)))

RATS <- pivot_longer(RATS, cols=-c(ID,Group), names_to = "WD",values_to = "Weight")  %>%
  mutate(Time = as.integer(substr(WD,3,4))) %>% arrange(Time) 


#Take a serious look at the new data sets and compare them with their wide form versions: 
#Check the variable names, view the data contents and structures, and create some brief summaries of the variables.
str(BPRS)
str(RATS)
summary(BPRS)
summary(RATS)

#Now each time point is its own row meaning that for example int the BPRS dataset each subject is divided to 9 rows, one for every time point. Week number is now in the week variable and the corresponding score in the bprs variable.


#Save the data
write_csv(BPRS, "data/BPRS.csv")
write_csv(RATS, "data/RATS.csv")

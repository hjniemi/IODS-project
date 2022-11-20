#Heikki Niemi / 20.11.2022
#IODS Assignment 3 data wrangling exercise
#Data source: https://archive.ics.uci.edu/ml/datasets/Student+Performance


#Load required packages
library(tidyverse)

#Read data
math <- read.table("data/student-mat.csv", sep = ";" , header = TRUE)
por <- read.table("data/student-por.csv", sep = ";" , header = TRUE)

#Explore the structure and dimensions of the data
str(math)
str(por)
dim(math)
dim(por)
#The math dataset has 395 rows (cases) and 33 variables and the por dataset has 649 rows (cases) and 33 variables
#Both datasets have the same set of variables (either character or numerical) describing the students in the dataset


#Join the two data sets using all other variables than "failures", "paid", "absences", "G1", "G2", "G3" as (student) identifiers. Keep only the students present in both data sets. 
free_cols <- c("failures","paid","absences","G1","G2","G3")
join_cols <- setdiff(colnames(por), free_cols)
math_por <- inner_join(math, por, by = join_cols, suffix = c(".math", ".por"))

#Explore the structure and dimensions of the joined data. 
str(math_por)
dim(math_por)
#The joined dataset has 370 rows (cases) and 39 variables
#The joined dataset has the same variables, except that the variables that differ in the two datasets are present twice

#Get rid of the duplicate records in the joined data set
alc <- select(math_por, all_of(join_cols))
for(col_name in free_cols) {
  two_cols <- select(math_por, starts_with(col_name))
  first_col <- select(two_cols, 1)[[1]]
  if(is.numeric(first_col)) {
    alc[col_name] <- round(rowMeans(two_cols))
  } else {
    alc[col_name] <- first_col
  }
}


#Take the average of the answers related to weekday and weekend alcohol consumption to create a new column 'alc_use' to the joined data. 
#Then use 'alc_use' to create a new logical column 'high_use' which is TRUE for students for which 'alc_use' is greater than 2 (and FALSE otherwise)
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
alc <- mutate(alc, high_use = alc_use > 2)

#Glimpse at the joined and modified data to make sure everything is in order
glimpse(alc)


#Save the joined and modified data set to the ‘data’ folder
write_csv(alc, "data/alc.csv")

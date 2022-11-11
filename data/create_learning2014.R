#Heikki Niemi / 10.11.2022
#IODS Assignment 2 data wrangling exercise
#Data source: http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt


#Load required packages
library(tidyverse)

#Read data
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

#Dimensions of the data
dim(lrn14)
#The data table contains 183 rows (observations) and 60 columns (variables)

#Structure of the data
str(lrn14)
#The data contains 60 variables: Questions through Aa to Dj, age, attitude, points and gender. 
#All the variables are integers besides gender, which is a character variable ("F" or "M").



#Create an analysis dataset with the variables gender, age, attitude, deep, stra, surf and points by combining questions in the learning2014 data.
#Scale all combination variables to the original scales (by taking the mean). 
#Exclude observations where the exam points variable is zero. 
lrn14$attitude <- lrn14$Attitude / 10
lrn14$deep <- rowMeans(lrn14[, c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")])
lrn14$surf <- rowMeans(lrn14[, c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")])
lrn14$stra <- rowMeans(lrn14[, c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")])

lrn14 <- lrn14 %>% filter(Points != 0) %>% select(gender, Age, attitude, deep, stra, surf, Points)
lrn14 <- lrn14 %>% rename("points"="Points", "age"="Age")


#Write lrn14 table to the "data" folder
write_csv(lrn14, "data/learning2014.csv")

#Read the data again and make sure that the data is correct
lrn14_2 <- read_csv("data/learning2014.csv")
str(lrn14_2)
head(lrn14_2)
#The data structure is still the same (though read_csv returns a tibble, not a data.frame)

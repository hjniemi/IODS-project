#Heikki Niemi / 27.11.2022
#IODS Assignment 4 data wrangling exercise
#Data source: https://raw.githubusercontent.com/KimmoVehkalahti/

#Load required packages
library(tidyverse)

#Read in the “Human development” and “Gender inequality” data sets
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

#Explore the datasets: see the structure and dimensions of the data

dim(hd)
str(hd)
#The hd dataset has 195 rows (cases) and 8 columns (variables)
#The dataset describes countries and their human development index and related properties

dim(gii)
str(gii)
#The gii dataset has 195 rows (cases) and 10 columns (variables)
#The dataset describes countries and their gender inequality index and related properties

#Create summaries of the variables
summary(hd)
summary(gii)


#Rename the variables with (shorter) descriptive names.
names(hd) <- c("HDI.Rank", "Country", "HDI", "Life.Exp", "Edu.Exp", "Edu.Mean", "GNI", "GNI.Minus.Rank")
names(gii) <- c("GII.Rank", "Country", "GII", "Mat.Mor", "Ado.Birth", "Parli.F", "Edu2.F", "Edu2.M", "Labo.F", "Labo.M")
                      
                      
#Mutate the “Gender inequality” data and create two new variables. 
gii <- gii %>% mutate(Edu2.FM = Edu2.F / Edu2.M, Labo.FM = Labo.F / Labo.M)

#Join together the two datasets using the variable Country as the identifier. Keep only the countries in both data sets
human <- hd %>% inner_join(gii, by="Country")

#Write the data to a csv file
human %>% write_csv("data/human.csv")

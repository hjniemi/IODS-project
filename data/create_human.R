#Heikki Niemi / 27.11.2022 + 1.12.2022
#IODS Assignment 4 and 5 data wrangling exercise
#Data source: https://hdr.undp.org/data-center/human-development-index

#Load required packages
library(tidyverse)

###################
#Assignment 4
###################

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


###################
#Assignment 5
###################

#Read in the human dataset
human <- read_csv("data/human.csv")

#Explore the dataset
dim(human)
str(human)

#The human dataset contains 195 rows (countries) and 19 variables.
#The dataset describes countries and their human development index and related properties, such as life expectancy, education and gender equality
#It contains the variables "HDI.Rank","Country","HDI","Life.Exp","Edu.Exp","Edu.Mean","GNI","GNI.Minus.Rank","GII.Rank","GII","Mat.Mor","Ado.Birth","Parli.F","Edu2.F","Edu2.M","Labo.F","Labo.M","Edu2.FM","Labo.FM"


#Mutate the data: transform the Gross National Income (GNI) variable to numeric
human$GNI <- str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric

#Exclude unneeded variables
keep <- c("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")
human <- select(human, one_of(keep))

#Remove all rows with missing values
human <- filter(human, complete.cases(human))

#Remove the observations which relate to regions instead of countries (last 7 observations)
human <- human[1:(nrow(human)-7), ]

#Define the row names of the data by the country names and remove the country name column from the data
human <- as.data.frame(human)
rownames(human) <- human$Country
human <- human[,2:ncol(human)]

#Save the human data
human %>% write.csv("data/human.csv", row.names = TRUE)



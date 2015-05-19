# WHO
# global.R

library(shiny)
library(plyr)


##### Main data frame for selectInput(), Maps and Correlation Table #####

# check.names=FALSE allows column names to have space
# na.strings="" means all empty strings will be treated as NA value
WHO <- read.csv("data/WHO.csv",na.strings="",check.names=FALSE)

# Categorical columns such as CountryID are discarded 
WHO.subset <- WHO[,4:358]
WHO.subset <- WHO.subset[,order(names(WHO.subset))]


##### Create data frame for Correlation Table #####
# Goal: Data frame with list of variables pairs with correlation coefficient
# Only keeps column with number of NA < half of the observations, correlation with huge number of NA value is not reliable and generate a lot of noise
n <- 0.5*nrow(WHO.subset)
WHO.subset <- WHO.subset[,colSums(is.na(WHO.subset)) < n]	
WHO.matrix <- data.frame(WHO.subset, check.names=FALSE) 

# Pearson's method is used (default method)
WHO.cor <- cor(WHO.matrix, use="pairwise.complete.obs")

# To make table that rank correlation
# Columns 1 & 2 are correlated variables, column 3 is the correlation coefficient
 WHO.cor <- as.data.frame(as.table(WHO.cor))

# Sort descending from highest correlation coefficient
 WHO.cor <- WHO.cor[order(-WHO.cor$Freq),]

# Discard correlation with identical variable 
ind <- with(WHO.cor, ((WHO.cor$Var1 == WHO.cor$Var2)))
WHO.cor <- WHO.cor[!ind,]
WHO.cor <- rename(WHO.cor, c("Var1"="Variable 1", "Var2"="Variable 2", "Freq"="Correlation Coefficient"))



##### Main data frame for ggplot(), cor.test() #####
# check.names=TRUE by default. All spaces and special characters will be replaced by "."
# Column names from this data frame will be used in functions that doesn't allow space and special characters in variables (ggplot(), cor.test())
WHO2 <- read.csv("data/WHO.csv",na.strings="")

# Categorical columns such as CountryID are discarded
WHO.subset2 <- WHO2[,4:358]



# ## Color brewer
# Color brewer: http://colorbrewer2.org
colorbrewer <- "{minValue:0,colors:['#F7FCF0', '#E0F3DB', '#CCEBC5', '#A8DDB5', '#7BCCC4', '#4EB3D3', '#2B8CBE', '#0868AC', '#084081']}"


# global.R
# WHO

library(shiny)
library(plyr)
library(stringr)

## Data frame #############################################
WHO <- read.csv("data/WHO.csv",na.strings="",check.names=F)
WHO2 <- read.csv("data/WHO.csv",na.strings="")

# Process data for correlation
# Categorical columns such as CountryID are discarded
WHO.subset <- WHO[,4:358]
WHO.subset <- WHO.subset[,order(names(WHO.subset))]

# WHO.subset2, column name has no space, for ggplot
WHO.subset2 <- WHO2[,4:358]
# WHO.subset2 <- data.frame(lapply(WHO.subset2, gsub, pattern = "[[:punct:]]", replacement = "."))

# Only keep columns with less than 100 NA
# Columns with plenty of NA causes a lot of noise
WHO.subset <- WHO.subset[,colSums(is.na(WHO.subset)) < 100]
WHO.matrix <- data.frame(WHO.subset, check.names=FALSE)
WHO.cor <- cor(WHO.matrix, use="pairwise.complete.obs")

# To make table that rank correlation
# Columns 1 & 2 are correlated variables, column 3 is the frequency 
 WHO.cor <- as.data.frame(as.table(WHO.cor))
# Sort descending from highest frequency
 WHO.cor <- WHO.cor[order(-WHO.cor$Freq),]
# Discard correlation with frequency = 1 or correlation with same variable 
ind <- with(WHO.cor, ((WHO.cor$Var1 == WHO.cor$Var2)))
WHO.cor <- WHO.cor[!ind,]
WHO.cor <- rename(WHO.cor, c("Var1"="Variable 1", "Var2"="Variable 2", "Freq"="Correlation Coefficient"))

# ## Color brewer
colorbrewer <- "{minValue:0,colors:['#F7FCF0', '#E0F3DB', '#CCEBC5', '#A8DDB5', '#7BCCC4', '#4EB3D3', '#2B8CBE', '#0868AC', '#084081']}"

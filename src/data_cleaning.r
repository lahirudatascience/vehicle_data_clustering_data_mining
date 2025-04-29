# Load necessary libraries
library(tidyverse)    # For data manipulation and visualization
library(factoextra)   # For clustering visualization
library(cluster)      # For clustering algorithms
library(gridExtra)   # For arranging multiple plots
library(GGally)      # For pairwise plots
library(mice)        # For missing data imputation
library(outliers)    # For outlier detection

# Load the dataset
data_path <- "~/Documents/vehicle_data_clustering_data_mining/dataset/vehicles.csv"
vehicles <- read.csv(data_path)

# View the structure of the data
str(vehicles)

# Summary statistics
summary(vehicles)

# Check for missing values
missing_values <- sapply(vehicles, function(x) sum(is.na(x)))
print(missing_values)

# Impute missing values using predictive mean matching (pmm)
imputed_data <- mice(vehicles, m=5, maxit=50, meth='pmm', seed=500)
vehicles_complete <- complete(imputed_data)

# Verify no more missing values
sum(is.na(vehicles_complete))

# Check for missing values
missing_values <- sapply(vehicles_complete, function(x) sum(is.na(x)))
print(missing_values)

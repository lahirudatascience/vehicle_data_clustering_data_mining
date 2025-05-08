# Load necessary libraries
library(tidyverse)    # For data manipulation and visualization
library(gridExtra)   # For arranging multiple plots
library(GGally)      # For pairwise plots
library(mice)        # For missing data imputation
library(outliers)    # For outlier detection
library(dplyr)      # For data manipulation

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

# Function to detect outliers
detect_outliers <- function(x) {
  q1 <- quantile(x, 0.25)
  q3 <- quantile(x, 0.75)
  iqr <- q3 - q1
  lower_bound <- q1 - (1.5 * iqr)
  upper_bound <- q3 + (1.5 * iqr)
  return(x < lower_bound | x > upper_bound)
}

# Apply to all numeric columns
numeric_cols <- sapply(vehicles_complete, is.numeric)
outliers <- sapply(vehicles_complete[, numeric_cols], detect_outliers)

# Count outliers per feature
outlier_counts <- colSums(outliers)
print(outlier_counts)

# Visualize outliers with boxplots
boxplot_plots <- list()
for (col in names(vehicles_complete)[numeric_cols]) {
  boxplot_plots[[col]] <- ggplot(vehicles_complete, aes_string(y = col)) +
    geom_boxplot(fill = "lightblue") +
    theme_minimal() +
    ggtitle(col)
}

# Display first few boxplots
grid.arrange(grobs = boxplot_plots[1:6], ncol = 3)
grid.arrange(grobs = boxplot_plots[7:12], ncol = 3)
grid.arrange(grobs = boxplot_plots[13:18], ncol = 3)

# Combine outlier info to get any row with at least one outlier
outlier_rows_logical <- apply(outliers, 1, any)  # TRUE if any column has outlier

# Get all rows with at least one outlier
outlier_rows <- vehicles_complete[outlier_rows_logical, ]

# Print the number of outlier rows
cat("Number of rows with at least one outlier:", nrow(outlier_rows), "\n")

# Display the full rows that contain outliers
print(outlier_rows)

# Convert to long format for easier faceting
vehicles_long <- vehicles_complete %>%
  pivot_longer(cols = where(is.numeric), names_to = "Feature", values_to = "Value")

# Faceted boxplots by Feature and Class
ggplot(vehicles_long, aes(x = class, y = Value, fill = class)) +
  geom_boxplot(outlier.color = "red", outlier.shape = 16, outlier.size = 1.5) +
  facet_wrap(~ Feature, scales = "free", ncol = 3) +
  theme_minimal() +
  labs(title = "Outliers in Each Feature Grouped by Vehicle Class",
       x = "Vehicle Class", y = "Feature Value") +
  theme(legend.position = "none")

# Winsorize (cap) outliers at 5th and 95th percentiles
winsorize <- function(x, lower_percentile = 0.05, upper_percentile = 0.95) {
  lower_bound <- quantile(x, lower_percentile, na.rm = TRUE)
  upper_bound <- quantile(x, upper_percentile, na.rm = TRUE)
  x[x < lower_bound] <- lower_bound
  x[x > upper_bound] <- upper_bound
  return(x)
}

vehicles_clean <- vehicles_complete
vehicles_clean[, numeric_cols] <- lapply(vehicles_clean[, numeric_cols], winsorize)

# Check for outliers again
outliers_after_winsorizing <- sapply(vehicles_clean[, numeric_cols], detect_outliers)
outlier_counts_after <- colSums(outliers_after_winsorizing)
print(outlier_counts_after)

# Visualize the cleaned data with boxplots
boxplot_plots_clean <- list()
for (col in names(vehicles_clean)[numeric_cols]) {
  boxplot_plots_clean[[col]] <- ggplot(vehicles_clean, aes_string(y = col)) +
    geom_boxplot(fill = "lightgreen") +
    theme_minimal() +
    ggtitle(col)
}
# Display first few boxplots
grid.arrange(grobs = boxplot_plots_clean[1:6], ncol = 3)
grid.arrange(grobs = boxplot_plots_clean[7:12], ncol = 3)
grid.arrange(grobs = boxplot_plots_clean[13:18], ncol = 3)

# save the cleaned data to a new CSV file
write.csv(vehicles_complete, file = "~/Documents/vehicle_data_clustering_data_mining/dataset/vehicles_cleaned.csv", row.names = FALSE)


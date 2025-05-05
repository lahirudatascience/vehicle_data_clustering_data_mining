# Load necessary libraries
library(factoextra)   # For clustering visualization
library(cluster)      # For clustering algorithms
library(gridExtra)   # For arranging multiple plots

# Load the dataset
data_path <- "~/Documents/vehicle_data_clustering_data_mining/dataset/vehicles_cleaned.csv"
vehicles_clean <- read.csv(data_path)

# View the structure of the data
str(vehicles_clean)

# Summary statistics
summary(vehicles_clean)

# Separate features and class label
features <- vehicles_clean[, -ncol(vehicles_clean)]
class_labels <- vehicles_clean$class

# Standardize the features
features_scaled <- scale(features)
print(features_scaled)

# 🔃 PCA for dimensionality reduction
pca_result <- prcomp(features_scaled, center = TRUE, scale. = TRUE)
print(pca_result)

# 📉 Scree plot and PCA variable contributions
fviz_eig(pca_result, addlabels = TRUE, ylim = c(0, 50))
fviz_pca_var(pca_result,
             col.var = "contrib",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE)
fviz_pca_biplot(pca_result,
                col.ind = as.factor(class_labels),
                palette = "jco",
                addEllipses = TRUE,
                label = "var",
                col.var = "black",
                repel = TRUE,
                legend.title = "Class") +
  ggtitle("PCA Biplot with Original Classes")

# 🧪 Extract PCA scores
pca_scores <- as.data.frame(pca_result$x)
# Add class labels to PCA scores
pca_scores$class <- class_labels
# Save PCA scores to CSV
write.csv(pca_scores, file = "~/Documents/vehicle_data_clustering_data_mining/dataset/pca_scores.csv", row.names = FALSE)

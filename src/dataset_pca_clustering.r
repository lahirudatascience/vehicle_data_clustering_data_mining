
#Load necessary libraries
library(factoextra)   # PCA & clustering visualization
library(cluster)      # silhouette plot
library(gridExtra)    # layout of plots
library(tidyverse)    # dplyr, ggplot2, etc.
library(ggplot2)

# Ensure the visuals folder exists
visual_path <- "~/Documents/vehicle_data_clustering_data_mining/visuals/"
dir.create(visual_path, showWarnings = FALSE, recursive = TRUE)

# Ensure models folder exists
models_path <- "~/Documents/vehicle_data_clustering_data_mining/models/"
dir.create(models_path, showWarnings = FALSE, recursive = TRUE)

# Load the cleaned dataset
data_path <- "~/Documents/vehicle_data_clustering_data_mining/dataset/vehicles_cleaned.csv"
vehicles_clean <- read.csv(data_path)

# Data inspection
str(vehicles_clean)
summary(vehicles_clean)

# Select only numeric features
features <- vehicles_clean %>% select(where(is.numeric))

# Get class labels
if ("class" %in% colnames(vehicles_clean)) {
  class_labels <- vehicles_clean$class
} else {
  stop("Column 'class' not found.")
}

# 🔎 Compute and save feature variances before standardization
variances <- apply(features, 2, var)
variance_df <- data.frame(Feature = names(variances), Variance = round(variances, 3))
write.csv(variance_df, "~/Documents/vehicle_data_clustering_data_mining/dataset/feature_variances.csv", row.names = FALSE)

# Plot variances
var_plot <- ggplot(variance_df, aes(x = reorder(Feature, -Variance), y = Variance)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  theme_minimal() +
  labs(title = "Feature Variance Before Standardization", x = "Feature", y = "Variance") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave(paste0(visual_path, "feature_variance_plot.png"), plot = var_plot, width = 8, height = 4)

# Standardize features
features_scaled <- scale(features)

# PCA
pca_result <- prcomp(features_scaled, center = TRUE, scale. = TRUE)
summary(pca_result)

# Save PCA variances (proportion of variance explained)
pca_variance_df <- data.frame(
  PC = paste0("PC", seq_along(pca_result$sdev)),
  Variance = round((pca_result$sdev^2) / sum(pca_result$sdev^2), 4)
)
write.csv(pca_variance_df, "~/Documents/vehicle_data_clustering_data_mining/dataset/pca_variance_explained.csv", row.names = FALSE)

# Scree Plot
scree_plot <- fviz_eig(pca_result, addlabels = TRUE, ylim = c(0, 50)) +
  ggtitle("Scree Plot - PCA")
print(scree_plot)
ggsave(paste0(visual_path, "pca_scree_plot.png"), plot = scree_plot, width = 6, height = 4)

# PCA Variable Contribution
pca_var_plot <- fviz_pca_var(pca_result,
                             col.var = "contrib",
                             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
                             repel = TRUE) +
  ggtitle("PCA - Variable Contributions")
print(pca_var_plot)
ggsave(paste0(visual_path, "pca_variable_contribution.png"), plot = pca_var_plot, width = 8, height = 6)

# Extract PCA scores and add class
pca_scores <- as.data.frame(pca_result$x)
pca_scores$class <- class_labels

# Save scores
write.csv(pca_scores, "~/Documents/vehicle_data_clustering_data_mining/dataset/pca_scores.csv", row.names = FALSE)

# PCA PC1 vs PC2 scatter plot
scatter_plot <- ggplot(pca_scores, aes(x = PC1, y = PC2)) +
  geom_point(alpha = 0.7) +
  labs(title = "First Two Principal Components", x = "PC1", y = "PC2")
print(scatter_plot)
ggsave(paste0(visual_path, "pca_scatter_plot.png"), plot = scatter_plot, width = 6, height = 4)

# Elbow plot to choose optimal K
elbow_plot <- fviz_nbclust(pca_scores[, 1:2], kmeans, method = "wss") +
  labs(subtitle = "Elbow Method for Optimal K")
print(elbow_plot)
ggsave(paste0(visual_path, "kmeans_elbow_plot.png"), plot = elbow_plot, width = 6, height = 4)

# K-Means (e.g., k = 3)
set.seed(123)
km_res <- kmeans(pca_scores[, 1:2], centers = 3, nstart = 25)
pca_scores$cluster <- as.factor(km_res$cluster)

# Cluster visualization
cluster_plot <- ggplot(pca_scores, aes(x = PC1, y = PC2, color = cluster)) +
  geom_point(size = 2) +
  labs(title = "K-Means Clustering on PCA Result", color = "Cluster")
print(cluster_plot)
ggsave(paste0(visual_path, "kmeans_clusters.png"), plot = cluster_plot, width = 6, height = 4)

# Biplot with K-Means Clusters
cluster_biplot <- fviz_pca_biplot(pca_result,
                                  geom.ind = "point",
                                  col.ind = pca_scores$cluster,
                                  palette = "jco",
                                  addEllipses = TRUE,
                                  label = "var",
                                  col.var = "black",
                                  repel = TRUE) +
  labs(title = "PCA Biplot with K-Means Clusters") +
  theme(legend.position = "bottom")
print(cluster_biplot)
ggsave(paste0(visual_path, "pca_biplot_kmeans_clusters.png"), plot = cluster_biplot, width = 8, height = 6)

# Silhouette plot
sil <- silhouette(km_res$cluster, dist(pca_scores[, 1:2]))
sil_plot <- fviz_silhouette(sil)
print(sil_plot)
ggsave(paste0(visual_path, "silhouette_plot.png"), plot = sil_plot, width = 6, height = 4)

# Save the clustering results
write.csv(pca_scores, "~/Documents/vehicle_data_clustering_data_mining/dataset/pca_kmeans_results.csv", row.names = FALSE)

# Save the PCA and K-Means models
saveRDS(pca_result, file = paste0(models_path, "pca_model.rds"))
saveRDS(km_res, file = paste0(models_path, "kmeans_model.rds"))


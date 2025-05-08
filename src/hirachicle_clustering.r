# Load necessary libraries
library(tidyverse)
library(cluster)
library(factoextra)
library(dendextend)
library(caret)
library(gplots)
library(colorspace)
library(corrplot)

# Paths
visual_path <- "~/Documents/vehicle_data_clustering_data_mining/visuals_dendrogram/"
dataset_path <- "~/Documents/vehicle_data_clustering_data_mining/dataset/"
dir.create(visual_path, showWarnings = FALSE)
dir.create(dataset_path, showWarnings = FALSE)

# Load cleaned dataset
vehicles <- read.csv(paste0(dataset_path, "vehicles_cleaned.csv"))

# Standardize numeric features
features <- vehicles %>% select(where(is.numeric))
features_scaled <- scale(features)
class_labels <- droplevels(factor(vehicles$class))  # Ensure factor

# PCA
pca_result <- prcomp(features_scaled, center = TRUE, scale. = TRUE)
pca_scores <- as.data.frame(pca_result$x)

# Save PCA variance explained
pca_var_df <- data.frame(PC = paste0("PC", seq_along(pca_result$sdev)),
                         Variance = round((pca_result$sdev^2) / sum(pca_result$sdev^2), 4))
write.csv(pca_var_df, paste0(dataset_path, "pca_variance_explained.csv"), row.names = FALSE)

# Scree Plot
scree_plot <- fviz_eig(pca_result, addlabels = TRUE, ylim = c(0, 50)) + ggtitle("Scree Plot - PCA")
ggsave(paste0(visual_path, "hc_scree_plot.png"), scree_plot, width = 6, height = 4)

# PCA Feature Contributions
var_contrib_plot <- fviz_pca_var(pca_result,
                                 col.var = "contrib",
                                 gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
                                 repel = TRUE) + ggtitle("Feature Contributions on Principal Components")
ggsave(paste0(visual_path, "pca_feature_contributions.png"), var_contrib_plot, width = 8, height = 6)

# Distance Matrix
dist_matrix <- dist(pca_scores[, 1:3], method = "euclidean")

# Hierarchical clustering using Ward’s method
hc_model <- hclust(dist_matrix, method = "ward.D2")

# Base Dendrogram
png(paste0(visual_path, "dendrogram.png"), width = 800, height = 600)
plot(hc_model, labels = FALSE, main = "Dendrogram (Ward.D2)")
rect.hclust(hc_model, k = 3, border = "red")
dev.off()

# Colored Dendrogram
dend_plot <- fviz_dend(hc_model, k = 3, cex = 0.6,
                       k_colors = c("#2E9FDF", "#E7B800", "#FC4E07"),
                       color_labels_by_k = TRUE, rect = TRUE) +
  ggtitle("Colored Dendrogram - Agglomerative Clustering")
ggsave(paste0(visual_path, "fviz_dend_colored.png"), dend_plot, width = 8, height = 6)

#  Assign cluster labels
hc_clusters <- cutree(hc_model, k = 3)
pca_scores$hc_cluster <- factor(hc_clusters)

# Save clustering result
write.csv(pca_scores, paste0(dataset_path, "pca_hc_clusters.csv"), row.names = FALSE)

# Confusion Matrix (fixed)
actual <- factor(class_labels)
predicted <- factor(hc_clusters, levels = levels(actual))  # Ensure same levels
conf_matrix_table <- table(Actual = actual, Predicted = predicted)
print(conf_matrix_table)

conf_result <- confusionMatrix(conf_matrix_table)
print(conf_result)

# Compare Linkage Methods
linkage_methods <- c("ward.D", "single", "complete", "average", "mcquitty", "median", "centroid", "ward.D2")
iris_dendlist <- dendlist()
for (method in linkage_methods) {
  hc <- hclust(dist_matrix, method = method)
  iris_dendlist <- dendlist(iris_dendlist, as.dendrogram(hc))
}
names(iris_dendlist) <- linkage_methods

# Cophenetic Correlation
cophenetic_cor <- cor.dendlist(iris_dendlist)
corrplot(cophenetic_cor, method = "pie", type = "lower")
ggsave(paste0(visual_path, "cophenetic_corrplot.png"), width = 7, height = 6)

# Heatmap
some_col_func <- function(n) rev(colorspace::heat_hcl(n, c = c(80, 30), l = c(30, 90)))
dend <- color_branches(as.dendrogram(hc_model), k = 3)

# Match colors to row order
row_order <- order.dendrogram(dend)
row_clusters <- cutree(hc_model, k = 3)[row_order]
cluster_palette <- c("#2E9FDF", "#E7B800", "#FC4E07")
row_colors <- cluster_palette[row_clusters]

png(paste0(visual_path, "hc_heatmap.png"), width = 1000, height = 800)
gplots::heatmap.2(as.matrix(pca_scores[, 1:6]),
                  main = "Heatmap with Clustered Rows",
                  dendrogram = "row",
                  Rowv = dend,
                  Colv = "NA",
                  trace = "none",
                  margins = c(6, 1),
                  key.xlab = "Z-Score",
                  denscol = "grey",
                  density.info = "density",
                  RowSideColors = row_colors,
                  col = some_col_func)
dev.off()

# PCA Biplot with Hierarchical Clusters
biplot_hc <- fviz_pca_biplot(pca_result,
                             geom.ind = "point",
                             col.ind = pca_scores$hc_cluster,
                             palette = "jco",
                             addEllipses = TRUE,
                             label = "var",
                             col.var = "black",
                             repel = TRUE) +
  labs(title = "PCA Biplot with Hierarchical Clusters") +
  theme(legend.position = "bottom")
ggsave(paste0(visual_path, "pca_biplot_hc_clusters.png"), biplot_hc, width = 8, height = 6)

# Silhouette Plot
silhouette_hc <- silhouette(hc_clusters, dist(pca_scores[, 1:3]))
silhouette_plot <- fviz_silhouette(silhouette_hc) +
  labs(title = "Silhouette Plot for Hierarchical Clustering")
ggsave(paste0(visual_path, "silhouette_hc.png"), silhouette_plot, width = 6, height = 4)
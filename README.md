
# 🚗 Vehicle Silhouette Clustering Project

## 📁 Project Structure

```
.
├── dataset/
│   ├── vehicles.csv                    # Original raw vehicle dataset
│   ├── vehicles_cleaned.csv           # Cleaned and winsorized dataset
│   ├── feature_variances.csv          # Feature variances from PCA
│   ├── pca_hc_clusters.csv            # Cluster assignments from hierarchical clustering
│   ├── pca_variance_explained.csv     # PCA explained variance data
│   ├── silhouette_score_summary.csv   # Silhouette scores for clustering runs
├── models/
│   ├── pca_model.rds                  # Saved PCA model
│   ├── kmeans_model.rds               # Saved K-Means clustering model
│   └── hierarchical_model.rds        # Saved Hierarchical clustering model
├── src/
│   ├── data_cleaning.r                # Script for cleaning, imputing, and outlier handling
│   ├── dataset_pca_clustering.r       # Script for optimal K-means clustering using silhouette
│   └── hirachicle_clustering.r        # Script for hierarchical clustering and dendrogram analysis
├── visuals/
│   ├── feature_variance_plot.png
│   ├── kmeans_clusters.png
│   ├── kmeans_elbow_plot.png
│   ├── pca_biplot_kmeans_clusters.png
│   ├── pca_scatter_plot.png
│   ├── pca_scree_plot.png
│   ├── pca_variable_contribution.png
│   └── silhouette_plot.png
├── visuals_dendrogram/
│   ├── cophenetic_corrplot.png
│   ├── dendrogram.png
│   ├── fviz_dend_colored.png
│   ├── hc_heatmap.png
│   ├── hc_scree_plot.png
│   ├── pca_biplot_hc_clusters.png
│   ├── pca_feature_contributions.png
│   ├── Rplot.png
│   └── silhouette_hc.png
└── README.md                          # Project documentation
```

---

## 📊 Project Overview

This project explores unsupervised clustering of vehicle silhouettes using image-derived shape features. The objective is to automatically discover meaningful groupings in the data, guided by dimensionality reduction and clustering quality metrics.

### Techniques used:
- **Principal Component Analysis (PCA)** for reducing 18 shape-related features
- **K-Means Clustering** for partitioning vehicle types
- **Hierarchical Clustering** for visual grouping and dendrogram analysis
- **Silhouette Analysis** to determine the optimal number of clusters and dimensionality

---

## 🧾 Dataset Summary

- **File**: `vehicles.csv`
- **Observations**: 846 vehicles
- **Features**: 18 numerical shape descriptors + 1 class label
- **Classes**:
  - Double Decker Bus
  - Chevrolet Van
  - Saab
  - Opel Manta

Shape descriptors were extracted using the HIPS system and include:
- Classical Moments: Variance, Skewness, Kurtosis
- Shape Heuristics: Compactness, Elongation, Circularity

---

## 📦 R Packages Used

| Package       | Purpose |
|---------------|---------|
| `tidyverse`   | Data wrangling and plotting |
| `factoextra`  | PCA and cluster visualization |
| `cluster`     | Clustering algorithms and silhouette analysis |
| `gridExtra`   | Arrange plots |
| `GGally`      | Scatter matrix plots |
| `mice`        | Missing data imputation |
| `outliers`    | Tukey-based outlier detection |
| `dendextend`  | Enhanced dendrogram visualizations |
| `gplots`      | Heatmaps for hierarchical clusters |
| `colorspace`  | Cluster-based color mapping |
| `corrplot`    | Correlation matrix visualization |

---

## 🔍 Analysis Workflow

1. **Data Cleaning (`data_cleaning.r`)**
   - Imputed missing values using Predictive Mean Matching (`mice`)
   - Detected and winsorized outliers across all numeric features

2. **Dimensionality Reduction (`dataset_pca_clustering.r`)**
   - Applied PCA to reduce from 18 features to top 2–3 principal components

3. **K-Means Clustering**
   - Evaluated clusters for `k = 2:6` on PC1:2 and PC1:3
   - Selected optimal config using average silhouette scores
   - Final clustering saved in `pca_kmeans_results.csv`

4. **Hierarchical Clustering (`hirachicle_clustering.r`)**
   - Generated dendrograms and heatmaps
   - Visualized correlation and cophenetic distances
   - Saved cluster assignments in `pca_hc_clusters.csv`

---

## 📈 Visual Outputs

All visuals saved in the `/visuals` and `/visuals_dendrogram` folders:
- **PCA Scree & Contribution Plots**
- **PCA Biplots with Class and Cluster Labels**
- **K-Means Elbow, Cluster Assignment, and Silhouette Plots**
- **Hierarchical Dendrograms, Cophenetic Correlations, and Heatmaps**

---

## 🏆 Results

- Best clustering found using **k = _X_** and **PC1:_Y_** (automatically selected via silhouette score)
- Average Silhouette Score: **_Z.ZZ_**
- Clusters showed strong visual separation and low intra-cluster variance

_Note: Replace `X`, `Y`, and `Z.ZZ` with actual values once results are known._

---

## 💼 Business Use Cases

- Understand how vehicle shape can define product segmentation
- Enhance machine vision systems with shape-based cluster priors
- Detect outliers or prototype anomalies
- Support competitive shape benchmarking in R&D and design

---

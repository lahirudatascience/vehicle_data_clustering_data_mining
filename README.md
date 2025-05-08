# 🚗 Vehicle Silhouette Clustering Project

## 📁 Project Structure

```
.
├── dataset/
│   ├── vehicles.csv                    # Original raw vehicle dataset
│   ├── vehicles_cleaned.csv           # Cleaned and winsorized dataset
│   ├── pca_scores.csv                 # PCA-reduced data with class labels
│   └── pca_kmeans_results.csv         # Silhouette scores across k and PC dimensions
├── models/
│   ├── pca_model.rds                  # Saved PCA model
│   └── kmeans_model.rds               # Saved K-Means clustering model
├── src/
│   ├── data_cleaning.r                # Script for cleaning, imputing, and outlier handling
│   ├── dataset_pca.r                  # Script for performing PCA
│   └── dataset_pca_clustering.r       # Script for optimal K-means clustering using silhouette
├── visuals/
│   ├── pca_scree_plot.png
│   ├── pca_variable_contribution.png
│   ├── pca_biplot_with_class.png
│   ├── pca_biplot_kmeans_clusters.png
│   ├── pca_scatter_plot.png
│   ├── kmeans_elbow_plot.png
│   ├── kmeans_clusters.png
│   └── silhouette_plot.png
└── README.md                          # Project documentation
```

---

## 📊 Project Overview

This project explores unsupervised clustering of vehicle silhouettes using image-derived shape features. The objective is to automatically discover meaningful groupings in the data, guided by dimensionality reduction and clustering quality metrics.

### Techniques used:
- **Principal Component Analysis (PCA)** for reducing 18 shape-related features
- **K-Means Clustering** for partitioning vehicle types
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

---

## 🔍 Analysis Workflow

1. **Data Cleaning (`data_cleaning.r`)**
   - Imputed missing values using Predictive Mean Matching (`mice`)
   - Detected and winsorized outliers across all numeric features

2. **Dimensionality Reduction (`dataset_pca.r`)**
   - Applied PCA to reduce from 18 features to 2–3 principal components

3. **Clustering and Optimization (`dataset_pca_clustering.r`)**
   - K-Means clustering tested over `k = 2:6` and PC1:2 vs PC1:3
   - Optimal `k` and PC count selected via average silhouette score
   - Final clustering applied and results saved

---

## 📈 Visual Outputs

All visuals saved in the `/visuals` folder:
- **PCA Scree Plot** — Variance explained by components
- **PCA Variable Contribution Plot**
- **PCA Biplot (with Class Labels & Cluster Labels)**
- **K-Means Elbow Plot**
- **K-Means Cluster Assignment**
- **Silhouette Plot** — Measures cluster separation quality

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

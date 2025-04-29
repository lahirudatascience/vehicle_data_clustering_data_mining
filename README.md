# 🚗 Vehicle Silhouette Clustering Project

## 📁 Project Structure

```
.
├── dataset/
│   └── vehicles.csv              # Input dataset with 846 vehicle observations
├── src/
│   └── data_cleaning.r           # R script for data preprocessing and missing value handling
└── README.md                     # Project documentation
```

---

## 📊 Project Overview

This project focuses on unsupervised clustering of vehicle silhouettes using shape-based numerical features extracted from images. The objective is to discover underlying groupings (clusters) among different types of vehicles using two key clustering approaches, following dimensionality reduction:

- **K-Means Clustering**
- **Agglomerative Hierarchical Clustering**

Both techniques are preceded by **Principal Component Analysis (PCA)** to reduce dimensionality and improve interpretability.

---

## 🧾 Dataset Summary

- **File**: `vehicles.csv`
- **Size**: 846 observations (rows)
- **Features**: 18 numerical features + 1 categorical `Class` variable
- **Classes**:
  - Double Decker Bus
  - Chevrolet Van
  - Saab
  - Opel Manta

These features were extracted using the HIPS (Hierarchical Image Processing System) extension **BINATTS**, incorporating shape-related descriptors such as:

- Classical Moments: Variance, Skewness, Kurtosis
- Heuristics: Circularity, Compactness, Rectangularity

---

## 📦 R Libraries Used

| Package       | Purpose |
|---------------|---------|
| `tidyverse`   | Data manipulation and visualization |
| `factoextra`  | Clustering visualization (e.g., PCA plots) |
| `cluster`     | Clustering algorithms |
| `gridExtra`   | Arranging multiple plots |
| `GGally`      | Pairwise plots and advanced visualization |
| `mice`        | Missing data imputation |
| `outliers`    | Detecting outliers in the data |

---

## 🧪 Analysis Workflow

1. **Data Cleaning**:
   - Handled missing values using `mice` package with Predictive Mean Matching (PMM).
   - Checked for outliers using `outliers` package.

2. **Dimensionality Reduction**:
   - Performed PCA to reduce from 18 numerical features to 2-3 principal components.

3. **Clustering**:
   - Applied K-Means clustering on PCA-reduced data.
   - Applied Agglomerative Hierarchical clustering.
   - Visualized results using cluster plots and dendrograms.

---

## 📈 Visualizations

- **PCA Scatter Plots** for reduced feature space
- **Cluster Plots** for K-Means and Hierarchical results
- **Dendrograms** to visualize hierarchy
- **Silhouette Scores** to assess clustering quality

---

## 💼 Business Value

Cluster analysis in this context can:
- Assist manufacturers and designers in distinguishing between vehicle types based on visual silhouette.
- Enhance autonomous vehicle recognition systems by pre-identifying vehicle clusters.
- Support R&D and market positioning by recognizing shape-based product similarities.
- Aid in anomaly or prototype detection within datasets of vehicle images.

---

## 👤 Author

This project was implemented in **R** using **RStudio**.

_Last updated: April 2025_
"""

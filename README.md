# NDVI-Based Temporal Deforestation Analysis in Borneo

This remote sensing project assesses forest cover change in Central Borneo using Sentinel-2 imagery and NDVI differences for 2018, 2020, and 2024.

## Objectives

- Calculate NDVI for three time points (Sentinel-2, GEE).
- Quantify vegetation loss using classified difference rasters.
- Analyze trends using point sampling and land cover types.
- Visualize trends in QGIS and R.

## Project Structure

```
Borneo_Deforestation_NDVI/
├── ndvi_analysis.R
├── gee_code/
│   └── ndvi_visualization.js
├── output/
│   └── deforestation_report.pdf
├── maps/
│   └── classified_ndvi_maps.png
├── figures/
│   └── boxplot_scatter_ndvi.png
```

## Requirements

```r
install.packages(c("terra", "sf", "ggplot2", "RStoolbox", "exactextractr", "tidyverse"))
```

## How to Run

1. Run the R script `ndvi_analysis.R` to load data and generate outputs.
2. The `.js` file can be used in Google Earth Engine for NDVI visualization.

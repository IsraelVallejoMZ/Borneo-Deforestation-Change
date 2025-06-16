# Load libraries
library(terra)
library(sf)
library(ggplot2)
library(lubridate)
library(RStoolbox)
library(exactextractr)
library(tidyverse)
library(viridis)

# Load NDVI raster files
ndvi_2020 <- rast("C:/Users/israe/OneDrive/Desktop/Portafolio Israel Vallejo Muñoz/Borneo Deforestation/Borneo 2020 vs 2024/NDVI_2020_Borneo.tif")

ndvi_2024 <- rast("C:/Users/israe/OneDrive/Desktop/Portafolio Israel Vallejo Muñoz/Borneo Deforestation/Borneo 2018 vs 2024/Tif files/NDVI_2024_Borneo.tif")

ndvi_diff <- rast("C:/Users/israe/OneDrive/Desktop/Portafolio Israel Vallejo Muñoz/Borneo Deforestation/Borneo 2020 vs 2024/NDVI_Diff_2024_2020_Borneo.tif")

# Create a simple classification based on NDVI change
# - Significant Loss: NDVI < -0.1
# - No Change: NDVI between -0.1 and 0.1
# - Gain: NDVI > 0.1

ndvi_classes <- classify(ndvi_diff, 
                         rcl = matrix(c(-Inf, -0.1, 1,
                                        -0.1, 0.1, 2,
                                        0.1, Inf, 3), ncol = 3, byrow = TRUE))

# Assign class labels
levels(ndvi_classes) <- data.frame(value = 1:3, class = c("Loss", "No change", "Gain"))

# Convert to data frame for ggplot visualization
ndvi_df <- as.data.frame(ndvi_classes, xy = TRUE, na.rm = TRUE)
colnames(ndvi_df)[3] <- "Class"

# Classification map
ggplot(ndvi_df) +
  geom_raster(aes(x = x, y = y, fill = Class)) +
  scale_fill_manual(values = c("Loss" = "red", "No change" = "gray80", "Gain" = "green")) +
  coord_equal() +
  labs(title = "NDVI Change between 2020 and 2024 - Borneo",
       fill = "Vegetation Change") +
  theme_minimal()

# Save classified raster as GeoTIFF
writeRaster(ndvi_classes, "NDVI_change_classes_Borneo2020.tif", overwrite = TRUE)

# Area by class (in number of pixels and %)
area_tab <- freq(ndvi_classes)
total_pixels <- sum(area_tab$count)
area_tab$percent <- round(100 * area_tab$count / total_pixels, 2)

# Add class names for plotting
area_tab$class <- c("Loss", "No change", "Gain")
area_tab
# Bar plot of change percentage by class
ggplot(area_tab, aes(x = class, y = percent, fill = class)) +
  geom_bar(stat = "identity", width = 0.6) +
  scale_fill_manual(values = c("Loss" = "red", "No change" = "gray70", "Gain" = "green")) +
  labs(title = "Vegetation Cover Change (NDVI) in Borneo (2018–2024)",
       x = "Change Class",
       y = "Area Percentage (%)") +
  theme_minimal(base_size = 13) +
  theme(legend.position = "none")

plot(ndvi_diff, main = "NDVI Difference (GEE)")


# También puedes ver el histograma completo
hist(ndvi_diff, main = "Histogram of NDVI Difference")

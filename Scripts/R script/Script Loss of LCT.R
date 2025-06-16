# Cargar paquetes necesarios
library(tidyverse)

# Leer el CSV exportado desde GEE
ndvi_data <- read_csv("C:/Users/israe/OneDrive/Desktop/Portafolio Israel Vallejo Muñoz/Borneo Deforestation/Borneo 2020 vs 2024/NDVI_Change_Sample_Borneo.csv")

# Reemplaza los códigos de cobertura con nombres
landcover_names <- c(
  "Evergreen Forest", "Deciduous Forest", "Deciduous Boreal",
  "Mixed Forest", "Closed Shrubland", "Open Shrubland",
  "Woody Savannas", "Savannas", "Grasslands",
  "Croplands", "Cropland/Natural Mosaic", "Natural/Cropland Mosaic",
  "Urban", "Barren", "Snow/Ice", "Water", "Unclassified Forest"
)

ndvi_data <- ndvi_data %>%
  mutate(
    LC_2020 = factor(LC_2020, levels = 1:17, labels = landcover_names)
  )

# Ver resumen de NDVI por cobertura
ndvi_data %>%
  group_by(LC_2020) %>%
  summarise(
    NDVI_2020 = mean(NDVI_2020, na.rm = TRUE),
    NDVI_2024 = mean(NDVI_2024, na.rm = TRUE),
    NDVI_diff = mean(NDVI_diff, na.rm = TRUE),
    n = n()
  ) %>%
  arrange(desc(NDVI_diff))
ndvi_data <- ndvi_data %>%
  rename(
    NDVI_2020 = NDVI,
    NDVI_2024 = NDVI_1
  )
ndvi_data %>%
  group_by(LC_2020) %>%
  summarise(
    NDVI_2020 = mean(NDVI_2020, na.rm = TRUE),
    NDVI_2024 = mean(NDVI_2024, na.rm = TRUE),
    NDVI_diff = mean(NDVI_diff, na.rm = TRUE),
    n = n()
  ) %>%
  arrange(desc(NDVI_diff))
# Boxplot de diferencia de NDVI por tipo de cobertura
ggplot(ndvi_data, aes(x = LC_2020, y = NDVI_diff, fill = LC_2020)) +
  geom_boxplot() +
  theme_minimal(base_size = 12) +
  labs(
    title = "NDVI Change (2020–2024) by Land Cover Type",
    x = "Land Cover Type",
    y = "NDVI Difference (2024 - 2020)"
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position = "none")

# Diagrama de dispersión NDVI 2020 vs 2024
scatter_ndvi <- ggplot(ndvi_data, aes(x = NDVI_2020, y = NDVI_2024, color = LC_2020)) +
  geom_point(size = 3, alpha = 0.7) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  theme_minimal() +
  labs(
    title = "NDVI Comparison: 2020 vs 2024",
    x = "NDVI 2020",
    y = "NDVI 2024",
    color = "Land Cover"
  )
# Guardar como PNG
ggsave("C:/Users/israe/OneDrive/Desktop/Portafolio Israel Vallejo Muñoz/Borneo Deforestation/scatter_ndvi_comparison.png",
       plot = scatter_ndvi,
       width = 8, height = 6, dpi = 300)

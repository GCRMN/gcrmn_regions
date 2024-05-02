# 1. Load packages ----

library(tidyverse)
library(sf)
library(extrafont)
windowsFonts("Open Sans" = windowsFont("Open Sans"))

# 2. Load and assign GCRMN region and subregion ----

data_gcrmn_regions <- st_read("data/meow/Marine_Ecoregions_Of_the_World__MEOW_.shp") %>% 
  st_transform(crs = 4326) %>% 
  # GCRMN region
  mutate(gcrmn_region = case_when(ECO_CODE_X %in% c(202, 203, 204, 205, 206, 207, 208, 209, 210, 211,
                                                    120, 145, 144, 141, 140, 142, 143, 150, 151) ~ "Australia",
                                  ECO_CODE_X %in% c(90, 91, 92) ~ "ROPME",
                                  ECO_CODE_X %in% c(87, 88, 89) ~ "PERSGA",
                                  ECO_CODE_X %in% c(103, 104, 105, 106, 107, 108) ~ "South Asia",
                                  ECO_CODE_X %in% c(93, 94, 95, 96, 97, 98, 99, 100, 101, 102) ~ "WIO",
                                  ECO_CODE_X %in% c(71, 72, 73, 74, 75, 76, 77) ~ "Brazil",
                                  ECO_CODE_X %in% c(62, 63, 64, 65, 66, 67, 68, 69, 70, 43) ~ "Caribbean",
                                  ECO_CODE_X %in% c(60, 61, 164, 165, 166, 167, 168, 
                                                    169, 170, 171, 172, 173, 174) ~ "ETP",
                                  ECO_CODE_X %in% c(109, 110, 111, 112, 113, 114, 115, 116, 117,
                                                    118, 119, 121, 52, 51, 126, 127, 128, 129, 
                                                    130, 139, 131, 132, 133) ~ "EAS",
                                  ECO_CODE_X %in% c(122, 123, 124, 125, 134, 135, 136, 137, 138,
                                                    149, 148, 147, 153, 154, 152, 159,
                                                    162, 158, 161, 160, 156, 155, 157, 146) ~ "Pacific",
                                  TRUE ~ NA_character_)) %>% 
  # GCRMN subregion
  mutate(gcrmn_subregion = case_when(# ROPME
                                     ECO_CODE_X %in% c(90) ~ 1,
                                     ECO_CODE_X %in% c(91) ~ 2,
                                     ECO_CODE_X %in% c(92) ~ 3,
                                     # PERSGA
                                     ECO_CODE_X %in% c(87) ~ 1,
                                     ECO_CODE_X %in% c(88) ~ 2,
                                     ECO_CODE_X %in% c(89) ~ 3,
                                     # WIO
                                     ECO_CODE_X %in% c(93, 94, 95) ~ 1,
                                     ECO_CODE_X %in% c(96) ~ 2,
                                     ECO_CODE_X %in% c(97, 98) ~ 3,
                                     ECO_CODE_X %in% c(99, 100) ~ 4,
                                     ECO_CODE_X %in% c(101, 102) ~ 5,
                                     # South Asia
                                     ECO_CODE_X %in% c(106) ~ 1,
                                     ECO_CODE_X %in% c(105) ~ 2,
                                     ECO_CODE_X %in% c(103, 104) ~ 3,
                                     ECO_CODE_X %in% c(107, 108) ~ 4,
                                     # EAS
                                     ECO_CODE_X %in% c(126, 127, 128) ~ 1,
                                     ECO_CODE_X %in% c(129, 130, 131, 133, 138, 139) ~ 2,
                                     ECO_CODE_X %in% c(115, 116, 117, 118) ~ 3,
                                     ECO_CODE_X %in% c(119, 132) ~ 4,
                                     ECO_CODE_X %in% c(109, 110, 111) ~ 5,
                                     ECO_CODE_X %in% c(112, 113, 114) ~ 6,
                                     ECO_CODE_X %in% c(51, 52, 121) ~ 7,
                                     # Australia
                                     ECO_CODE_X %in% c(142, 143, 202) ~ 1,
                                     ECO_CODE_X %in% c(140, 141, 144, 145, 210, 211) ~ 2,
                                     ECO_CODE_X %in% c(120) ~ 3,
                                     ECO_CODE_X %in% c(151) ~ 4,
                                     ECO_CODE_X %in% c(150) ~ 5,
                                     # Pacific
                                     ECO_CODE_X %in% c(121, 122, 124, 125) ~ 1,
                                     ECO_CODE_X %in% c(134, 135, 136, 137) ~ 2,
                                     ECO_CODE_X %in% c(146, 147, 148, 149, 150) ~ 3,
                                     ECO_CODE_X %in% c(152) ~ 4,
                                     ECO_CODE_X %in% c(153, 154) ~ 5,
                                     ECO_CODE_X %in% c(155, 156, 157) ~ 6,
                                     ECO_CODE_X %in% c(158, 162, 159, 160, 161) ~ 7,
                                     # ETP
                                     ECO_CODE_X %in% c(60, 61) ~ 1,
                                     ECO_CODE_X %in% c(166, 167, 168) ~ 2,
                                     ECO_CODE_X %in% c(170, 171) ~ 3,
                                     ECO_CODE_X %in% c(169, 172, 173, 174) ~ 4,
                                     ECO_CODE_X %in% c(164, 165) ~ 5,
                                     # Brazil
                                     ECO_CODE_X %in% c(74) ~ 1,
                                     ECO_CODE_X %in% c(75) ~ 2,
                                     ECO_CODE_X %in% c(76, 77) ~ 3,
                                     ECO_CODE_X %in% c(71, 72) ~ 4,
                                     # Caribbean
                                     ECO_CODE_X %in% c(62, 63) ~ 1,
                                     ECO_CODE_X %in% c(64, 66) ~ 2,
                                     ECO_CODE_X %in% c(65) ~ 3,
                                     ECO_CODE_X %in% c(67, 68) ~ 4,
                                     ECO_CODE_X %in% c(43, 69, 70) ~ 5,
                                     TRUE ~ NA_integer_)) %>% 
  st_as_sf() %>% 
  group_by(gcrmn_region, gcrmn_subregion) %>% 
  summarise() %>% 
  ungroup() %>% 
  drop_na(gcrmn_region, gcrmn_subregion) %>% 
  st_as_sf()

# 3. Fill holes within polygons ----

data_gcrmn_regions <- nngeo::st_remove_holes(data_gcrmn_regions) %>% 
  st_transform(crs = 4326) %>% 
  st_make_valid()

# 4. Export the data ----

## 4.1 GCRMN subregions ----

data_gcrmn_subregions <- nngeo::st_remove_holes(data_gcrmn_regions) %>% 
  st_transform(crs = 4326) %>% 
  st_make_valid()

save(data_gcrmn_subregions, file = "data/gcrmn-regions/gcrmn_subregions.RData")

st_write(obj = data_gcrmn_subregions, dsn = "data/gcrmn-regions/gcrmn_subregions.shp", delete_dsn = TRUE)

## 4.2 GCRMN regions ----

data_gcrmn_regions <- data_gcrmn_regions %>% 
  select(-gcrmn_subregion) %>% 
  group_by(gcrmn_region) %>% 
  summarise(geometry = st_union(geometry)) %>% 
  ungroup()

data_gcrmn_regions <- nngeo::st_remove_holes(data_gcrmn_regions) %>% 
  st_transform(crs = 4326) %>% 
  st_make_valid()

save(data_gcrmn_regions, file = "data/gcrmn-regions/gcrmn_regions.RData")

st_write(obj = data_gcrmn_regions, dsn = "data/gcrmn-regions/gcrmn_regions.shp", delete_dsn = TRUE)

# 5. Make the plot ----

## 5.1 Load Natural Earth Data ----

data_country <- st_read("data/natural-earth-data/ne_10m_admin_0_countries/ne_10m_admin_0_countries.shp") %>% 
  st_transform(crs = "+proj=eqearth")

data_graticules <- st_read("data/natural-earth-data/ne_10m_graticules_20/ne_10m_graticules_20.shp")%>% 
  st_transform(crs = "+proj=eqearth")

## 5.2 Change projection of GCRMN regions ----

data_gcrmn_regions <- data_gcrmn_regions %>% 
  st_transform(crs = "+proj=eqearth")

## 5.3 Create the border of background map ----

lats <- c(90:-90, -90:90, 90)
longs <- c(rep(c(180, -180), each = 181), 180)

background_map_border <- list(cbind(longs, lats)) %>%
  st_polygon() %>%
  st_sfc(crs = 4326) %>% 
  st_sf() %>%
  st_transform(crs = "+proj=eqearth")

## 5.4 Create the plot ----

ggplot() +
  geom_sf(data = background_map_border, fill = "white", color = "grey30", linewidth = 0.25) +
  geom_sf(data = data_graticules, color = "#ecf0f1", linewidth = 0.25) +
  geom_sf(data = background_map_border, fill = NA, color = "grey30", linewidth = 0.25) +
  geom_sf(data = data_gcrmn_regions, aes(fill = gcrmn_region)) +
  geom_sf(data = data_country, color = "#24252a", fill = "#dadfe1") +
  theme(text = element_text(family = "Open Sans"),
        legend.position = "bottom",
        legend.background = element_rect(fill = "transparent", color = NA),
        legend.title = element_blank(),
        panel.background = element_blank(),
        plot.background = element_rect(fill = "transparent", color = NA)) +
  guides(fill = guide_legend(override.aes = list(size = 5, color = NA)))

ggsave("figs/map_regions.png", bg = "transparent", height = 5, width = 8, dpi = 300)

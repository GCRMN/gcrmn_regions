# 1. Load packages ----

library(tidyverse)
library(sf)

# 2. Load and assign GCRMN region ----

data_gcrmn_regions <- st_read("data/Marine_Ecoregions_Of_the_World__MEOW_.shp") %>% 
  st_transform(crs = 4326) %>% 
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
  st_as_sf() %>% 
  group_by(gcrmn_region) %>% 
  summarise() %>% 
  ungroup() %>% 
  drop_na(gcrmn_region) %>% 
  st_as_sf()

# 3. Fill holes within polygons ----

data_gcrmn_regions <- nngeo::st_remove_holes(data_gcrmn_regions)

# 4. Export the data ----

save(data_gcrmn_regions, file = "data/gcrmn_regions.RData")

# 5. Make the plot ----

# 5.1 Load Natural Earth Data --

data_lands <- st_read("data/natural-earth-data/ne_10m_land/ne_10m_land.shp") %>% 
  st_transform(crs = "+proj=eqearth")

data_country <- st_read("data/natural-earth-data/ne_10m_admin_0_countries/ne_10m_admin_0_countries.shp") %>% 
  st_transform(crs = "+proj=eqearth")

# 5.2 Change projection of GCRMN regions --

data_gcrmn_regions <- data_gcrmn_regions %>% 
  st_transform(crs = "+proj=eqearth")

# 5.3 Create the border of background map --

lats <- c(90:-90, -90:90, 90)
longs <- c(rep(c(180, -180), each = 181), 180)

background_map_border <- list(cbind(longs, lats)) %>%
  st_polygon() %>%
  st_sfc(crs = 4326) %>% 
  st_sf() %>%
  st_transform(crs = "+proj=eqearth")

# 5.4 Create the plot --

ggplot() +
  geom_sf(data = background_map_border, fill = "#56B4E950", color = "grey30", linewidth = 0.25) +
  geom_sf(data = data_gcrmn_regions, aes(fill = gcrmn_region)) +
  geom_sf(data = data_lands) +
  geom_sf(data = data_country) +
  theme(legend.position = "bottom",
        legend.background = element_rect(fill = "transparent", color = NA),
        legend.title = element_blank(),
        panel.background = element_blank(),
        plot.background = element_rect(fill = "transparent", color = NA))

ggsave("figs/map_regions.png", bg = "transparent")

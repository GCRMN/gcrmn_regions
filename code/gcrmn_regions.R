# 1. Load packages ----

library(tidyverse)
library(sf)
library(extrafont)
windowsFonts("Open Sans" = windowsFont("Open Sans"))

# 2. Load and assign GCRMN region and subregion ----

data_gcrmn_regions <- st_read("data/meow/Marine_Ecoregions_Of_the_World__MEOW_.shp") %>% 
  st_transform(crs = 4326) %>% 
  # GCRMN region
  mutate(region = case_when(ECO_CODE_X %in% c(202, 203, 204, 205, 206, 207, 208, 209, 210, 211,
                                              120, 145, 144, 141, 140, 142, 143, 150, 151) ~ "Australia",
                            ECO_CODE_X %in% c(90, 91, 92) ~ "ROPME",
                            ECO_CODE_X %in% c(87, 88, 89) ~ "PERSGA",
                            ECO_CODE_X %in% c(103, 104, 105, 106, 107, 108) ~ "South Asia",
                            ECO_CODE_X %in% c(93, 94, 95, 96, 97, 98, 99, 100, 101, 102) ~ "WIO",
                            ECO_CODE_X %in% c(72, 73, 74, 75, 76, 77) ~ "Brazil",
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
  mutate(subregion = case_when(
    # ROPME
    ECO_CODE_X %in% c(90) ~ 1,
    ECO_CODE_X %in% c(91) ~ 2,
    ECO_CODE_X %in% c(92) ~ 3,
    # PERSGA
    ECO_CODE_X %in% c(87) ~ 1,
    ECO_CODE_X %in% c(88) ~ 3,
    ECO_CODE_X %in% c(89) ~ 4,
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
    ECO_CODE_X %in% c(120) ~ 1,
    ECO_CODE_X %in% c(145, 210, 211) ~ 2,
    ECO_CODE_X %in% c(144) ~ 3,
    ECO_CODE_X %in% c(140, 141) ~ 4,
    ECO_CODE_X %in% c(142, 143, 202) ~ 5,
    ECO_CODE_X %in% c(150) ~ 6,
    ECO_CODE_X %in% c(151) ~ 7,
    # Pacific
    ECO_CODE_X %in% c(121, 122, 123, 124, 125) ~ 1,
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
    ECO_CODE_X %in% c(76) ~ 3,
    ECO_CODE_X %in% c(77) ~ 4,
    ECO_CODE_X %in% c(72) ~ 5,
    # Caribbean
    ECO_CODE_X %in% c(62, 63) ~ 1,
    ECO_CODE_X %in% c(64) ~ 2,
    ECO_CODE_X %in% c(66) ~ 3,
    ECO_CODE_X %in% c(67, 68) ~ 4,
    ECO_CODE_X %in% c(65) ~ 5,
    ECO_CODE_X %in% c(43, 69, 70) ~ 6,
    TRUE ~ NA_integer_)) %>% 
  st_as_sf() %>% 
  rename(ecoregion = ECOREGION) %>% 
  group_by(region, subregion, ecoregion) %>% 
  summarise() %>% 
  ungroup() %>% 
  drop_na(region, subregion) %>% 
  st_as_sf() %>% 
  mutate(ecoregion = str_replace_all(ecoregion,
  "Fernando de Naronha and Atoll das Rocas",
  "Fernando de Noronha and Rocas Atoll"))

# 3. Fill holes within polygons ----

data_gcrmn_regions <- nngeo::st_remove_holes(data_gcrmn_regions) %>% 
  st_transform(crs = 4326) %>% 
  st_make_valid()

# 4. Split PERGSA 1 into PERSGA 1 and 2 ----

## 4.1 Create PERSGA 2 polygon ----

# (The polygon was manually created on Google Earth Engine)

data_persga2 <- matrix(c(
  31.379, 23.155,
  32.544, 20.154,
  34.126, 17.910,
  42.981, 21.304,
  42.711, 21.769,
  40.844, 25.294,
  37.822, 24.394,
  35.724, 23.956,
  35.619, 23.961,
  35.490, 24.051,
  31.379, 23.155), # closing (repeat the first line)
  ncol = 2, byrow = TRUE) %>% 
  list(.) %>% 
  st_polygon() %>% 
  st_sfc(., crs = 4326) %>% 
  st_as_sf()
  
## 4.2 Intersect with other polygons ----

data_persga1_before <- data_gcrmn_regions %>% 
  filter(region == "PERSGA" & subregion == 1)

persga2 <- st_intersection(data_persga1_before, data_persga2) %>% 
  mutate(region = "PERSGA",
         subregion = 2,
         ecoregion = "Central Red Sea")

persga1 <- st_difference(data_persga1_before, data_persga2) %>% 
  mutate(region = "PERSGA",
         subregion = 1,
         ecoregion = "Northern Red Sea")
  
data_gcrmn_regions <- data_gcrmn_regions %>% 
  filter(!(region == "PERSGA" & subregion == 1)) %>% 
  bind_rows(., persga2) %>% 
  bind_rows(., persga1) 
  
rm(persga1, persga2, data_persga1_before, data_persga2)

# 5. Change PERSGA / ROPME boundary ----

data_eez_yemen <- st_read("data/eez/eez_v12.shp") %>% 
  filter(SOVEREIGN1 == "Yemen")

data_persga_4 <- data_gcrmn_regions %>% 
  filter(region == "PERSGA" & subregion == 4)
  
data_eez_yemen <- st_difference(data_eez_yemen, data_persga_4) %>% 
  st_cast("POLYGON") %>% 
  filter(row_number() == 4)

data_rectangle <- matrix(c(
  47.5, as.numeric(st_bbox(data_persga_4)$ymax),
  53.10934, as.numeric(st_bbox(data_eez_yemen)$ymax),
  52.5, 12,
  47.5, 12,
  47.5, as.numeric(st_bbox(data_persga_4)$ymax)), # closing (repeat the first line)
  ncol = 2, byrow = TRUE) %>% 
  list(.) %>% 
  st_polygon() %>% 
  st_sfc(., crs = 4326) %>% 
  st_as_sf()

data_persga_4 <- st_union(data_persga_4, data_eez_yemen) %>% 
  st_union(., data_rectangle) %>% 
  select(region, subregion, ecoregion)

data_ropme_3 <- data_gcrmn_regions %>% 
  filter(region == "ROPME" & subregion == 3) %>% 
  st_difference(., data_persga_4) %>% 
  select(region, subregion, ecoregion)

data_gcrmn_regions <- data_gcrmn_regions %>% 
  filter(!(region == "PERSGA" & subregion == 4)) %>% 
  filter(!(region == "ROPME" & subregion == 3)) %>% 
  bind_rows(., data_persga_4) %>% 
  bind_rows(., data_ropme_3)

rm(data_rectangle, data_eez_yemen, data_persga_4, data_ropme_3)

# 6. Add subregion names ----

data_gcrmn_regions <- data_gcrmn_regions %>% 
  mutate(subregion_name = case_when(region == "Australia" & subregion == 1 ~ "Cocos Keeling and Christmas Island",
                                    region == "Australia" & subregion == 2 ~ "Central West Australian Shelf",
                                    region == "Australia" & subregion == 3 ~ "Northwest Australian Shelf",
                                    region == "Australia" & subregion == 4 ~ "Northern Australia",
                                    region == "Australia" & subregion == 5 ~ "Eastern Australian shelf / Great Barrier Reef",
                                    region == "Australia" & subregion == 6 ~ "Coral Sea",
                                    region == "Australia" & subregion == 7 ~ "Lord Howe and Norfolk Islands",
                                    region == "Brazil" & subregion == 1 ~ "Fernando de Noronha and Rocas Atoll",
                                    region == "Brazil" & subregion == 2 ~ "Northeastern Brazil",
                                    region == "Brazil" & subregion == 3 ~ "Eastern Brazil",
                                    region == "Brazil" & subregion == 4 ~ "Trindade and Martin Vaz Islands",
                                    region == "Brazil" & subregion == 5 ~ "Amazonia",
                                    region == "Caribbean" & subregion == 1 ~ "Bahamas and Bermuda",
                                    region == "Caribbean" & subregion == 2 ~ "Eastern Caribbean",
                                    region == "Caribbean" & subregion == 3 ~ "Southern Caribbean",
                                    region == "Caribbean" & subregion == 4 ~ "Western Caribbean",
                                    region == "Caribbean" & subregion == 5 ~ "Greater Antilles",
                                    region == "Caribbean" & subregion == 6 ~ "Florida and Gulf of Mexico",
                                    region == "EAS" & subregion == 1 ~ "Northern Coral Triangle",
                                    region == "EAS" & subregion == 2 ~ "Central Coral Triangle",
                                    region == "EAS" & subregion == 3 ~ "Sunda Shelf",
                                    region == "EAS" & subregion == 4 ~ "Southern Java and Sunda",
                                    region == "EAS" & subregion == 5 ~ "Andaman",
                                    region == "EAS" & subregion == 6 ~ "South China Sea",
                                    region == "EAS" & subregion == 7 ~ "Kuroshio",
                                    region == "ETP" & subregion == 1 ~ "Southern Baja California",
                                    region == "ETP" & subregion == 2 ~ "Central America",
                                    region == "ETP" & subregion == 3 ~ "Panama Bight",
                                    region == "ETP" & subregion == 4 ~ "Galapagos",
                                    region == "ETP" & subregion == 5 ~ "Revillagigedos and Clipperton",
                                    region == "Pacific" & subregion == 1 ~ "Tropical Northwestern Pacific",
                                    region == "Pacific" & subregion == 2 ~ "Eastern Coral Triangle",
                                    region == "Pacific" & subregion == 3 ~ "Tropical Southwestern Pacific",
                                    region == "Pacific" & subregion == 4 ~ "Hawaiian archipelago",
                                    region == "Pacific" & subregion == 5 ~ "Marshall, Gilbert, and Ellis Islands",
                                    region == "Pacific" & subregion == 6 ~ "Central Polynesia",
                                    region == "Pacific" & subregion == 7 ~ "Southeast Polynesia",
                                    region == "PERSGA" & subregion == 1 ~ "Northern Red Sea",
                                    region == "PERSGA" & subregion == 2 ~ "Central Red Sea",
                                    region == "PERSGA" & subregion == 3 ~ "Southern Red Sea",
                                    region == "PERSGA" & subregion == 4 ~ "Gulf of Aden",
                                    region == "ROPME" & subregion == 1 ~ "Persian/Arabian Gulf",
                                    region == "ROPME" & subregion == 2 ~ "Gulf of Oman",
                                    region == "ROPME" & subregion == 3 ~ "Southern Oman",
                                    region == "South Asia" & subregion == 1 ~ "Chagos",
                                    region == "South Asia" & subregion == 2 ~ "Maldives",
                                    region == "South Asia" & subregion == 3 ~ "West and South Indian Shelf",
                                    region == "South Asia" & subregion == 4 ~ "Bay of Bengal",
                                    region == "WIO" & subregion == 1 ~ "East African Coast",
                                    region == "WIO" & subregion == 2 ~ "Seychelles",
                                    region == "WIO" & subregion == 3 ~ "Mascarene Islands",
                                    region == "WIO" & subregion == 4 ~ "Madagascar and Comoros",
                                    region == "WIO" & subregion == 5 ~ "Bight of Sofala")) %>% 
  mutate(subregion = paste(region, subregion, sep = " "))

# 7. Export the data ----

## 7.1 Ecoregions ----

data_gcrmn_ecoregions <- data_gcrmn_regions %>% 
  mutate(subregion = paste(region, subregion, sep = " ")) %>% 
  group_by(region, subregion, subregion_name, ecoregion) %>% 
  summarise(geometry = st_union(geometry)) %>% 
  ungroup()

data_gcrmn_ecoregions <- nngeo::st_remove_holes(data_gcrmn_ecoregions) %>% 
  st_transform(crs = 4326) %>% 
  st_make_valid()

save(data_gcrmn_ecoregions, file = "data/gcrmn-regions/gcrmn_ecoregions.RData")

st_write(obj = data_gcrmn_ecoregions, dsn = "data/gcrmn-regions/gcrmn_ecoregions.shp", delete_dsn = TRUE)

## 7.2 GCRMN subregions ----

data_gcrmn_subregions <- data_gcrmn_regions %>% 
  select(-ecoregion) %>% 
  group_by(region, subregion, subregion_name) %>% 
  summarise(geometry = st_union(geometry)) %>% 
  ungroup() %>% 
  nngeo::st_remove_holes(.) %>% 
  st_transform(crs = 4326) %>% 
  st_make_valid()

save(data_gcrmn_subregions, file = "data/gcrmn-regions/gcrmn_subregions.RData")

st_write(obj = data_gcrmn_subregions, dsn = "data/gcrmn-regions/gcrmn_subregions.shp", delete_dsn = TRUE)

## 7.3 GCRMN regions ----

data_gcrmn_regions <- data_gcrmn_regions %>% 
  select(-subregion, -subregion_name, -ecoregion) %>% 
  group_by(region) %>% 
  summarise(geometry = st_union(geometry)) %>% 
  ungroup()

data_gcrmn_regions <- nngeo::st_remove_holes(data_gcrmn_regions) %>% 
  st_transform(crs = 4326) %>% 
  st_make_valid()

save(data_gcrmn_regions, file = "data/gcrmn-regions/gcrmn_regions.RData")

st_write(obj = data_gcrmn_regions, dsn = "data/gcrmn-regions/gcrmn_regions.shp", delete_dsn = TRUE)

# 8. Make the plot ----

## 8.1 Load Natural Earth Data ----

data_country <- st_read("data/natural-earth-data/ne_10m_admin_0_countries/ne_10m_admin_0_countries.shp") %>% 
  st_transform(crs = "+proj=eqearth")

data_graticules <- st_read("data/natural-earth-data/ne_10m_graticules_20/ne_10m_graticules_20.shp")%>% 
  st_transform(crs = "+proj=eqearth")

## 8.2 Change projection of GCRMN regions ----

data_gcrmn_regions <- data_gcrmn_regions %>% 
  st_transform(crs = "+proj=eqearth")

## 8.3 Create the border of background map ----

lats <- c(90:-90, -90:90, 90)
longs <- c(rep(c(180, -180), each = 181), 180)

background_map_border <- list(cbind(longs, lats)) %>%
  st_polygon() %>%
  st_sfc(crs = 4326) %>% 
  st_sf() %>%
  st_transform(crs = "+proj=eqearth")

## 8.4 Create the plot ----

ggplot() +
  geom_sf(data = background_map_border, fill = "white", color = "grey30", linewidth = 0.25) +
  geom_sf(data = data_graticules, color = "#ecf0f1", linewidth = 0.25) +
  geom_sf(data = background_map_border, fill = NA, color = "grey30", linewidth = 0.25) +
  geom_sf(data = data_gcrmn_regions, aes(fill = region)) +
  geom_sf(data = data_country, color = "#24252a", fill = "#dadfe1") +
  theme(text = element_text(family = "Open Sans"),
        axis.ticks = element_blank(),
        axis.text = element_blank(),
        legend.position = "bottom",
        legend.background = element_rect(fill = "transparent", color = NA),
        legend.title = element_blank(),
        panel.background = element_blank(),
        plot.background = element_rect(fill = "transparent", color = NA)) +
  guides(fill = guide_legend(override.aes = list(size = 5, color = NA)))

ggsave("figs/map_regions.png", bg = "transparent", height = 5, width = 8, dpi = 300)

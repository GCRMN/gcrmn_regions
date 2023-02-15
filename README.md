# gcrmn_regions <img src='figs/logo_gcrmn.png' align="right" height="80" />

## 1. Introduction

The goal of this repository is to provide the R code used to create the 10 GCRMN (*Global Coral Reef Monitoring Network*) regions. These regions are the following:

* Australia
* Brazil
* Caribbean
* EAS = East Asian Seas
* ETP = Eastern Tropical Pacific
* Pacific
* PERSGA = Regional Organization for the Conservation of the Environment of the Red Sea and Gulf of Aden
* ROPME = Regional Organization for the Protection of the Marine Environment
* South Asia
* WIO = Western Indian Ocean

![gcrmn_regions](figs/map_regions.png)

**Figure 1.** Map of the ten GCRMN regions.

## 2. How the regions were created?

The raw data used to create the ten GCRMN regions where obtained from the *Marine Ecoregions of the World* ([Spalding *et al.*, 2007](https://doi.org/10.1641/B570707)). The corresponding shapefile of these raw data are located in `data` (*Marine_Ecoregions_Of_the_World__MEOW_.shp*). The ecoregions were aggregated to create the ten GCRMN regions. The resulting file is located in `data` (*gcrmn_regions.RData*).


## 3. References

Spalding, M. D., Fox, H. E., Allen, G. R., Davidson, N., Ferdaña, Z. A., Finlayson, M. A. X., [...] & Robertson, J. (**2007**). [Marine ecoregions of the world: a bioregionalization of coastal and shelf areas](https://doi.org/10.1641/B570707). *BioScience*, 57(7), 573-583.
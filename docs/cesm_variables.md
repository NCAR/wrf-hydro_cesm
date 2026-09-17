* CESM Variables

** CTSM NUOPC Variables
These variables can be found in [src/cpl/nuopc/lnd_import_export.F90](https://github.com/ESCOMP/CTSM/blob/master/src/cpl/nuopc/lnd_import_export.F90).

| Variable                    | Description                  |
|-----------------------------|------------------------------|
| *Sa_z*                      | Atmospheric level height     |
| *Sa_topo*                   | Surface elevation            |
| *Sa_u*                      | Zonal wind (E-W)             |
| *Sa_v*                      | Meridional wind (N-S)        |
| *Sa_ptem*                   | Potential temperature        |
| *Sa_shum*                   | Specific humidity            |
| *Sa_pbot*                   | Surface pressure             |
| *Sa_tbot*                   | Near-surface temperature     |
| *Faxa_rainc*                | Convective rain              |
| *Faxa_rainl*                | Large-scale rain             |
| *Faxa_snowc*                | Convective snow              |
| *Faxa_snowl*                | Large-scale snow             |
| *Faxa_lwdn*                 | Downward longwave radiation  |
| *Faxa_swvdr*                | Visible direct SW radiation  |
| *Faxa_swndr*                | NIR direct SW radiation      |
| *Faxa_swvdf*                | Visible diffuse SW radiation |
| *Faxa_swndf*                | NIR diffuse SW radiation     |
| *Faxa_bcph*                 | Black carbon deposition      |
| *Faxa_ocph*                 | Organic carbon deposition    |
| *Faxa_dstwet*               | Wet dust deposition          |
| *Faxa_dstdry*               | Dry dust deposition          |
| *Sa_methaneaxa_ndep*        | Methane / N deposition (?)   |
| *Faxa_ndep*                 | Nitrogen deposition          |
| *Sa_o3*                     | Ozone concentration          |
| *Sa_co2prog*                | Prognostic CO₂               |
| *Sa_co2diag*                | Diagnostic CO₂               |
| *Flrr_flood*                | Flood runoff flux            |
| *Flrr_volr*                 | River volume flux            |
| *Flrr_volrmch*              | Main channel flow            |
| *Sr_tdepth*                 | River depth                  |
| *Sr_tdepth_max*             | Max river depth              |
| *Sg_ice_covered_elev*       | Glacier ice elevation        |
| *Sg_topo_elev*              | Glacier topography           |
| *Flgg_hflx_elev*            | Geothermal heat flux         |
| *Sg_icemask*                | Glacier mask                 |
| *Sg_icemask_coupled_fluxes* | Glacier mask (coupled)       |
| *Sl_lfrin*                  | Land fraction input          |
| *Sl_t*                      | Land temperature             |
| *Sl_snowh*                  | Snow depth                   |
| *Sl_avsdr*                  | Albedo vis direct            |
| *Sl_anidr*                  | Albedo NIR direct            |
| *Sl_avsdf*                  | Albedo vis diffuse           |
| *Sl_anidf*                  | Albedo NIR diffuse           |
| *Sl_tref*                   | Reference temperature        |
| *Sl_qref*                   | Reference humidity           |
| *Fall_taux*                 | Zonal stress                 |
| *Fall_tauy*                 | Meridional stress            |
| *Fall_lat*                  | Latent heat flux             |
| *Fall_sen*                  | Sensible heat flux           |
| *Fall_lwup*                 | Upward longwave              |
| *Fall_evap*                 | Evaporation flux             |
| *Fall_swnet*                | Net shortwave                |
| *Fall_flxdst*               | Dust flux                    |
| *Fall_methane*              | Methane flux                 |
| *Sl_u10*                    | 10m wind                     |
| *Sl_ram1*                   | Aerodynamic resistance       |
| *Sl_fv*                     | Vegetation fraction          |
| *Sl_soilw*                  | Soil water                   |
| *Fall_fco2_lnd*             | CO₂ land flux                |
| *Sl_ddvel*                  | Deposition velocity          |
| *Fall_voc*                  | VOC flux                     |
| *Fall_fire*                 | Fire emissions               |
| *Sl_fztop*                  | Frozen soil depth            |
| *Flrl_rofsur*               | Surface runoff               |
| *Flrl_rofsub*               | Subsurface runoff            |
| *Flrl_rofgwl*               | Groundwater runoff           |
| *Flrl_rofi*                 | Ice runoff                   |
| *Flrl_irrig*                | Irrigation flux              |
| *Sl_tsrf_elev*              | Surface temp (elev)          |
| *Sl_topo_elev*              | Surface elevation            |
| *Flgl_qice_elev*            | Glacier ice flux             |

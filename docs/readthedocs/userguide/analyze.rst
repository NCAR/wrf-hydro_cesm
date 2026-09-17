Analysis
========

The following is meant to be run from a `Jupyter notebook <https://jupyter.org/>`_
and loads Python packages that are used for analysis.

.. code-block:: python

   import numpy as np
   import pandas as pd
   import xarray as xr
   import matplotlib.pyplot as plt
   from matplotlib.colors import LogNorm, TwoSlopeNorm


The following plots the terrain and LSM land-use index. For a simple plot

.. code-block:: python

   hgt = geo.HGT_M.isel(Time=0)
   lm = geo.LANDMASK.isel(Time=0)
   hgt.plot(); plt.show()
   lm.plot(); plt.show()

For better labeling of axis and prettier plotting

.. code-block:: python

   # open domain file
   geo = xr.open_dataset(RUN_DIR / "DOMAIN" / "geo_em.d01.nc")
   ny_lsm, nx_lsm = geo.sizes["south_north"], geo.sizes["west_east"]

   # print domain info
   print(f"LSM grid: {nx_lsm} x {ny_lsm} cells, DX = {geo.attrs['DX']:.0f} m, centre {geo.attrs['CEN_LAT']:.3f}N {geo.attrs['CEN_LON']:.3f}E")
   print(f"lat {float(geo.XLAT_M.min()):.2f}..{float(geo.XLAT_M.max()):.2f}   lon {float(geo.XLONG_M.min()):.2f}..{float(geo.XLONG_M.max()):.2f}")


   hgt = geo.HGT_M.isel(Time=0)
   lm = geo.LANDMASK.isel(Time=0)
   LON1K = geo.XLONG_M.isel(Time=0).values
   LAT1K = geo.XLAT_M.isel(Time=0).values
   ASPECT = 1 / np.cos(np.deg2rad(float(geo.attrs["CEN_LAT"])))   # so 1 km looks like 1 km on lat/lon axes
   fig, axs = plt.subplots(1, 2, figsize=(11, 4.6))
   im = axs[0].pcolormesh(geo.XLONG_M.isel(Time=0), geo.XLAT_M.isel(Time=0), hgt.where(lm == 1), cmap="terrain", shading="auto")
   axs[0].contour(geo.XLONG_M.isel(Time=0), geo.XLAT_M.isel(Time=0), lm, levels=[0.5], colors="k", linewidths=0.5)
   plt.colorbar(im, ax=axs[0], label="HGT_M  terrain height [m]")
   axs[0].set_title("WRF-Hydro LSM grid (1 km): terrain"); axs[0].set_xlabel("longitude"); axs[0].set_ylabel("latitude")
   im = axs[1].pcolormesh(geo.XLONG_M.isel(Time=0), geo.XLAT_M.isel(Time=0), geo.LU_INDEX.isel(Time=0), cmap="tab20", shading="auto")
   axs[1].set_title("LU_INDEX  land-use class"); axs[1].set_xlabel("longitude")
   plt.tight_layout(); plt.show()

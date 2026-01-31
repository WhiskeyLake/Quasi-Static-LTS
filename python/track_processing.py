
import geopandas as gpd
import numpy as np
from pathlib import Path
from pyproj import Transformer
from scipy.interpolate import splprep, splev
import scipy.io as sio

def process_geojson(path, out_mat="track.mat", n_points=2000):
    path = Path(path)
    out_mat = Path(out_mat)
    if not path.exists():
        raise FileNotFoundError(f"{path} not found (resolved: {path.resolve()}). CWD={Path.cwd()}")
    out_mat.parent.mkdir(parents=True, exist_ok=True)
    gdf = gpd.read_file(str(path))
    line = gdf.geometry.iloc[0]
    coords = list(line.coords)

    transformer = Transformer.from_crs("EPSG:4326", "EPSG:3857", always_xy=True)
    xy = np.array([transformer.transform(lon, lat) for lon, lat in coords])

    ds = np.sqrt(np.sum(np.diff(xy, axis=0)**2, axis=1))
    s = np.insert(np.cumsum(ds), 0, 0)

    tck, u = splprep([xy[:,0], xy[:,1]], s=5)
    u_fine = np.linspace(0, 1, n_points)
    x_s, y_s = splev(u_fine, tck)

    # compute arc-length of the smoothed spline (accurate spacing)
    s_spline = np.insert(np.cumsum(np.sqrt(np.diff(x_s)**2 + np.diff(y_s)**2)), 0, 0)

    # derivatives with respect to arc-length (s) for numerical stability
    dx_ds = np.gradient(x_s, s_spline)
    dy_ds = np.gradient(y_s, s_spline)
    ddx_ds = np.gradient(dx_ds, s_spline)
    ddy_ds = np.gradient(dy_ds, s_spline)

    # curvature kappa(s) = (x' y'' - y' x'') / (x'^2 + y'^2)^(3/2)
    denom = (dx_ds**2 + dy_ds**2)**1.5
    # avoid divide-by-zero / extremely small denominators
    small = denom < 1e-12
    kappa = np.empty_like(denom)
    kappa[small] = 0.0
    kappa[~small] = (dx_ds[~small]*ddy_ds[~small] - dy_ds[~small]*ddx_ds[~small]) / denom[~small]

    # save arc-length (meters), curvature (1/m), and optionally coordinates
    track = {"s": s_spline, "kappa": kappa, "x": x_s, "y": y_s}
    sio.savemat(out_mat, track)

if __name__ == "__main__":
    base = Path(__file__).resolve().parent
    data_tracks = base.parent / "data" / "tracks"
    geojson = data_tracks / "az-2016.geojson"
    out_mat = data_tracks / "baku.mat"
    process_geojson(geojson, out_mat)

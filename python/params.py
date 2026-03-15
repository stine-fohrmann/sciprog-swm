import numpy as np
import pandas as pd

# Global constants
g = 9.81            # gravitational acceleration [m/s²]
nx, ny = 500, 500   # number of spatial steps [1]
nt = 7200/60        # number of time steps [1]
dx, dy = 1e3, 1e3 # spatial step length [m]
dump = 60           # data was dumped every 60 s
dt = dump           # time step length [s]

# Define color map
cmap = 'RdBu_r'

# Coordinates
coords_t = np.arange(0, nt, 1) # range of time steps
coords_x = np.arange(0, nx, 1) # range of space steps in x-direction

# Formatted time and space coordinates
t_min   = coords_t * dt/60 # in min
t_form  = np.datetime64('2026') + t_min.astype('timedelta64[m]') # yyyy-mm-ddThh:mm
# time_only = pd.to_datetime(t_form).dt.strftime('%H:%M')
# time_only = t_form % np.timedelta64(1, 'D')  # Get time portion as timedelta
x_km    = coords_x * (dx/1e3) # in km

# Coordinates and distances along diagonal 
diag_km = x_km                       # coordinates along diagonal in km
diag_dist_km = np.sqrt(2*diag_km**2) # distances along diagonal in km
diag_dist_m  = diag_dist_km*1e3      # distances along diagonal in m
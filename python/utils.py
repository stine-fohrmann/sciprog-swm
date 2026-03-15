import numpy as np
import matplotlib.pyplot as plt
from params import *


# Plots snapshots of the simulation at specified time steps
def plot_snapshots(data, ts_to_plot, filepath, show_cbar=True):
    # Define levels for contour plot
    levels = np.arange(-1.5, 1.51, 0.01)
    cbar_ticks = np.arange(-1.5, 2, 0.5)

    # Create figure
    fig, axes = plt.subplots(1, len(ts_to_plot), figsize=(10,4), sharey=True, constrained_layout=True)

    # Define meshgrid for contour plot
    X, Y = np.meshgrid(data.xpos*(dx/1e3), data.ypos*(dy/1e3))

    # Plot height data for each time step
    for ax, t_idx in zip(axes, ts_to_plot):
        cp = ax.contourf(X, Y, data.h[t_idx], levels=levels, cmap=cmap)
        # time_str = t_form[t_idx]
        time_str = t_form[t_idx].astype(str)[11:16]
        ax.set_title(time_str, fontsize='medium')
        ax.set_aspect(1)
        # ax.set_xlabel(r'Zonal direction $x\ [km]$')

    axes[0].set_ylabel(r'Meridional direction $y$ [km]')

    fig.supxlabel(r'Zonal direction $x$ [km]', fontsize='medium', y=0.15)

    if show_cbar:
        w = 0.7
        cbar_ax = fig.add_axes([0.5-(w/2), 0.1, w, 0.04])
        cbar = fig.colorbar(cp,
            label=r'Sea surface height $h$ [m]',
            orientation='horizontal',
            cax=cbar_ax, 
            ticks=cbar_ticks)

    fig.savefig(f'{filepath}', bbox_inches='tight')
    fig.show()


from scipy.fft import rfftfreq, rfft

# Performs real fast forward Fourier transform and returns average wavelength
def mean_wavelength(data, ts_to_use):
    # Select heights along diagonal
    h_diag = data.h.where(data.xpos == data.ypos).stack(diag=('xpos', 'ypos')).dropna('diag')

    # List for storing dominant wavelengths
    dom_wl_m = []

    # Find dominant wavelength at each time step
    for ts in ts_to_use:
        # Select height at current time step
        h = h_diag.isel(time=ts)

        # Remove mean
        h_prime = h - np.mean(h)

        # Real FFT
        spec  = rfft(h_prime)    # complex spectrum
        freq  = rfftfreq(len(h_prime), d=diag_dist_m[1] - diag_dist_m[0])  # cycles per m
        power = np.abs(spec)**2  # power spectrum

        # Find dominant peak and add to list
        peak_idx = np.argmax(power[1:]) + 1 # exclude find element
        lambda_peak = 1 / freq[peak_idx]    # in m
        dom_wl_m.append(lambda_peak)

    # Convert back to km
    dom_wl_km = np.array(dom_wl_m)/1e3

    # Average wavelength
    mean_wl_km = np.mean(dom_wl_km)
    return mean_wl_km


# Function for plotting Hovmöller diagram (distance along diagonal vs time)
# Plot either against formatted time -> time_formatted=True
# or against time steps -> time_formatted=False
def plot_hovmoeller(data, filepath, time_formatted=True):
    # Select heights along diagonal
    h = data.h.where(data.xpos == data.ypos).stack(diag=('xpos', 'ypos')).dropna('diag')

    fig = plt.figure(figsize=(5,8))

    # Define height levels and ticks for colourbar
    levels = np.arange(-1.5, 1.51, 0.01)
    cbar_ticks = np.arange(-1.5, 2, 0.5)

    if time_formatted:
        # Plot against formatted time
        cf = plt.contourf(diag_dist_km, t_form, h, levels, cmap=cmap, extend='both')
    else:
        # Plot against time steps
        cf = plt.contourf(diag_dist_km, coords_t, h, levels, cmap=cmap, extend='both')

    cbar = plt.colorbar(cf, label=r'Sea surface height $h\ [m]$',
                            orientation='horizontal',
                            # extendrect=True,
                            ticks=cbar_ticks,
                            pad=0.05)

    # Invert y axis so time starts goes top to bottom
    plt.gca().invert_yaxis()

    plt.xlabel(r'Diagonal distance [in $km$]')

    fig.savefig(filepath, bbox_inches='tight')
    fig.show()


# Returns index of max height at specified time step (int)
def dist_of_max_height(data, ts):
    h = data.h.where(data.xpos == data.ypos).stack(diag=('xpos', 'ypos')).dropna('diag')
    maxidx = max(h.isel(time=ts)).diag.item()[0]
    return diag_dist_km[maxidx]


# Performs real fast forward Fourier transform and returns average period
def mean_period(data, ts_to_use):
    # Select heights along diagonal
    h_diag = data.h.where(data.xpos == data.ypos).stack(diag=('xpos', 'ypos')).dropna('diag')

    # List for storing dominant periods (in min)
    dom_periods = []

    for ts in ts_to_use:
        # Select time series until current time step
        h = h_diag[:, ts]

        # Apply a window to reduce spectral leakage
        window = np.hanning(len(h))
        h_win  = h * window

        # Real FFT
        spec  = rfft(h_win)
        freq  = rfftfreq(len(h_win), d=dt)   # cycles per s
        power = np.abs(spec)**2             # power spectrum

        # Find dominant peak
        peak_idx  = np.argmax(power[1:]) + 1 # skip first element
        f_dom     = freq[peak_idx]           # temporal frequency
        T_dom_s   = 1 / f_dom                # period in s
        T_dom_min = T_dom_s / 60             # period in min

        dom_periods.append(T_dom_min)

    avg_period_min = np.mean(dom_periods)
    return avg_period_min




'''
# Function for plotting h at selected time steps
def plot_data(data, num_timesteps, total_timesteps):

    cmap = 'RdBu_r'
    levels = np.linspace(-1, 1, 101)

    fig, axes = plt.subplots(1,num_timesteps, figsize=(10,8), sharey=True)
    x, y = np.meshgrid(data.xpos, data.ypos)

    for i in range(num_timesteps-1):
        t = int(total_timesteps/num_timesteps * i)
        plot = axes[i].contourf(x, y, data.h[t], levels=levels, cmap=cmap)
        axes[i].set_title(f'time = {t}')

    plot = axes[-1].contourf(x, y, data.h[total_timesteps], levels=levels, cmap=cmap)
    axes[-1].set_title(f'time = {total_timesteps}')

    for ax in axes:
        ax.set_aspect(1)

    w = 0.7
    cbar_ax = fig.add_axes([0.5-(w/2), 0.25, w, 0.04])
    fig.colorbar(plot, label=r'Sea surface height $h$ $[m]$', orientation='horizontal', cax=cbar_ax)

    fig.tight_layout()
    fig.show()

def get_distances(data, timesteps):
    dist = []

    for t in range(timesteps):
        h_vals = []
        for i in range(500):
            h = data.h.isel(time=t, xpos=i, ypos=i).item()
            h_vals.append(h)
        
        dist.append(h_vals)
        
    return np.array(dist)
'''
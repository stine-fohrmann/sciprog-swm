
! constants (SI units)
integer, parameter :: nx=500, ny=500, nt=7200
real,    parameter :: dx=1000.0, dy=1000.0, dt=1.0, dump=60.
real,    parameter :: g=8.81, pi=acos(-1.)
character(len=20) :: filename='/data/swm_slope.nc'

! custom types
type :: state
real, dimension(nx, ny) :: u, v, h
end type state

! variables
real, dimension(nx, ny) :: f, d, ud, vd
integer :: i, j, n
real :: kx, ky
type (state) :: ocean_state

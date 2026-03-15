subroutine outcdf(ocean_state,d)

implicit none

! include netcdf parameters
include 'netcdf.inc'

integer :: icdf,iret,cdfid,ifill
integer :: xposdim,yposdim,timedim
integer :: tid,u_id,v_id,h_id,d_id
integer, dimension(3) :: base_date
integer, dimension(3) :: dims
integer, dimension(3) :: corner,edges
data icdf /0/
save

! include model parameters
include 'param.h'

if (icdf.eq.0) then

! enter define mode
cdfid = nccre(filename,ncclob,iret)
ifill = ncsfil(cdfid,ncnofill,iret)

! define dimensions
xposdim = ncddef(cdfid,'xpos',nx,iret)
yposdim = ncddef(cdfid,'ypos',ny,iret)
timedim = ncddef(cdfid,'time',ncunlim,iret)

! define variables and attributes

! 1d vars
dims(1) = timedim

! time
tid = ncvdef(cdfid,'time',ncfloat,1,dims,iret)
call ncaptc(cdfid,tid,'long_name',ncchar,4,'time',iret)
call ncaptc(cdfid,tid,'units',ncchar,33,'seconds since 2026-01-01 00:00:00',iret)

! 2d vars
dims(2) = yposdim
dims(1) = xposdim

! d
d_id = ncvdef(cdfid,'d',ncfloat,2,dims,iret)
call ncaptc(cdfid,d_id,'long_name',ncchar,1,'d',iret)
call ncaptc(cdfid,d_id,'units',ncchar,1,'m',iret)  

! 3d vars
dims(3) = timedim
dims(2) = yposdim
dims(1) = xposdim

! u
u_id = ncvdef(cdfid,'u',ncfloat,3,dims,iret)
call ncaptc(cdfid,u_id,'long_name',ncchar,1,'u',iret)
call ncaptc(cdfid,u_id,'units',ncchar,3,'m/s',iret)

! v
v_id = ncvdef(cdfid,'v',ncfloat,3,dims,iret)
call ncaptc(cdfid,v_id,'long_name',ncchar,1,'v',iret)
call ncaptc(cdfid,v_id,'units',ncchar,3,'m/s',iret)

! h
h_id = ncvdef(cdfid,'h',ncfloat,3,dims,iret)
call ncaptc(cdfid,h_id,'long_name',ncchar,1,'h',iret)
call ncaptc(cdfid,h_id,'units',ncchar,1,'m',iret)

! global attributes
call ncaptc(cdfid,ncglobal,'experiment',ncchar,80,'swm',iret)

base_date(1) = 2026
base_date(2) = 1
base_date(3) = 1

call ncapt(cdfid,ncglobal,'base_date',nclong,3,base_date,iret) 
call ncendf(cdfid,iret)

else

cdfid = ncopn(filename,ncwrite,iret)
ifill = ncsfil(cdfid,ncnofill,iret)

endif

!  end of define mode and start of store mode
    
icdf = icdf + 1

! store 1d variables
corner(1) = icdf

! time
tid = ncvid(cdfid,'time',iret)
call ncvpt1(cdfid,tid,corner,float(icdf-1)*dump,iret)

! store 2d variables
corner(1) = 1
corner(2) = 1
edges(1) = nx
edges(2) = ny

! d
d_id = ncvid(cdfid,'d',iret)
call ncvpt(cdfid,d_id,corner,edges,d,iret)

! store 3d variables
corner(1) = 1
corner(2) = 1
corner(3) = icdf
edges(1) = nx
edges(2) = ny
edges(3) = 1

! u
u_id = ncvid(cdfid,'u',iret)
call ncvpt(cdfid,u_id,corner,edges,ocean_state%u,iret)

! v
v_id = ncvid(cdfid,'v',iret)
call ncvpt(cdfid,v_id,corner,edges,ocean_state%v,iret)

! h
h_id = ncvid(cdfid,'h',iret)
call ncvpt(cdfid,h_id,corner,edges,ocean_state%h,iret)

call ncclos(cdfid,iret)

end subroutine outcdf

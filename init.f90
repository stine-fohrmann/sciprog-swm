
subroutine init(ocean_state, f, d)
    implicit none
    include 'param.h'

    do i = 1, nx
        do j = 1, ny
            f(i,j) = 0.8e-4 ! in 1/s
            ! d(i,j) = 4000.  ! in m
            d(i,j)=4000-(4000-500)*(0.5-0.5*tanh((2*pi*((i-(0.5*nx))*dx+(j-(0.5*ny))*dy))/(2*200000)))
        end do
    end do

    kx=10*(2*pi)/(nx*dx)
    ky=10*(2*pi)/(ny*dy)


    do i = 1, nx
        do j = 1, ny
            
            ocean_state%u(i,j) = (-1 / (d(i,j) * (kx**2 + ky**2))) &
                    * (kx*sqrt(f(i,j)**2 + g*d(i,j)*(kx**2 + ky**2)) * cos(kx*i*dx + ky*j*dy) + f(i,j)*ky*sin(kx*i*dx + ky*j*dy)) &
                    * exp(-((0.2*kx * (i-(0.7*nx)) * dx)**2 + (0.2*ky * (j-(0.7*ny)) * dy)**2))
            
            
            ocean_state%v(i,j)=(1/(d(i,j)*(kx**2+ky**2))) &
                *(-ky*sqrt(f(i,j)**2+g*d(i,j)*(kx**2+ky**2)) &
                *cos(kx*i*dx+ky*j*dy)+f(i,j)*kx*sin(kx*i*dx+ky*j*dy)) &
                *exp(-((0.2*kx*(i-(0.7*nx))*dx)**2+(0.2*ky*(j-(0.7*ny))*dy)**2))
            
            ocean_state%h(i,j)=cos(kx*i*dx+ky*j*dy) &
                *exp(-((0.2*kx*(i-(0.7*nx))*dx)**2+(0.2*ky*(j-(0.7*ny))*dy)**2))
        end do
    end do



end subroutine init
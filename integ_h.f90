! Solve equation (9) for the next time step
subroutine integ_h(ocean_state, d)
    implicit none
    include 'param.h'

    do i = 2, nx-1
        do j = 2, ny-1
            ocean_state%h(i,j) = ocean_state%h(i,j) &
                    - dt/(2*dx) * (d(i+1, j) * ocean_state%u(i+1, j) &
                    - d(i-1, j) * ocean_state%u(i-1, j)) &
                    - dt/(2*dy) * (d(i, j+1) * ocean_state%v(i, j+1) - d(i, j-1) * ocean_state%v(i, j-1))
        end do
    end do

end subroutine integ_h
! Solve equation (8) for the next time step
subroutine integ_v(ocean_state, f)
    implicit none
    include 'param.h'

    do i = 1, nx
        do j = 2, ny-1
            ocean_state%v(i,j) = ocean_state%v(i,j) &
                - f(i,j) * dt * ocean_state%u(i,j) &
                - g * dt/(2*dy) * (ocean_state%h(i, j+1) - ocean_state%h(i, j-1))
        end do
    end do

end subroutine integ_v
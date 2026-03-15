! Solve equation (7) for the next time step
subroutine integ_u(ocean_state, f)
    implicit none
    include 'param.h'

    do i = 2, nx-1
        do j = 1, ny
            ocean_state%u(i,j) = ocean_state%u(i,j) &
                 + f(i,j) * dt * ocean_state%v(i,j) &
                 - g * (dt/(2*dx)) * (ocean_state%h(i+1, j) - ocean_state%h(i-1, j))
        end do
    end do

end subroutine integ_u
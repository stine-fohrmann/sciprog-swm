! program start
program swm
    implicit none

    ! include model parameters
    include 'param.h'
    
    ! initial conditions
    call init(ocean_state, f, d)

    ! loop over time steps
    do n = 1, nt
        ! solve equation 7 (compute next u)
        call integ_u(ocean_state, f)
        ! solve equation 8 (compute next v)
        call integ_v(ocean_state, f)
        ! solve equation 9 (compute next h)
        call integ_h(ocean_state, d)
        
        ! calculate doubly-periodic boundary conditions
        call bound(ocean_state%u)
        call bound(ocean_state%v)
        call bound(ocean_state%h)

        ! calculate and write to screen at specified times the maximum value of h
        if (mod(real(n), dump) == 0) then
            write(*,*) n, maxval(ocean_state%h)
        end if

        ! write the entire u,v,h and d fields to one NetCDF file
        call outcdf(ocean_state,d)
    ! end of loop over time steps
    end do

! program end
end program swm
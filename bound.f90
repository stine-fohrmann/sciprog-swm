
subroutine bound(arr)
    implicit none
    include 'param.h'

    real, dimension(nx, ny), intent(inout) :: arr

    do i = 1, nx
        arr(i, ny) = arr(i, 2)
        arr(i, 1)  = arr(i, ny-1)
    end do

    do j = 1, ny
        arr(1,  j) = arr(nx-1, j)
        arr(nx, j) = arr(2,    j)
    end do

end subroutine bound

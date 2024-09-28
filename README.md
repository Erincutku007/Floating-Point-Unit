# Floating Point arithmetic unit implementation for my RISCV core.
All of the designs are implemented as a single-cycle design. None of them are lumped together to create a pipelined or accumulator design. \
At the current state, everything is ready except for the division unit. I am planning to implement division later.\
C codes to create test vectors are also included in the respitory. Everything except add-sub logic is working as intended in the IEEE 754 standard.
Add-sub logic makes a one-bit rounding error in the %2 of the test vectors. This is probably caused by the discarded bits after the mantissa alignment. 

# Verification Testbenches
This folder contains the verification testbenches for some of the provided IPs and examples. Also, it contains all needed files to simulate the testbenches. To run the simulation use the provided Makefile.
- `make fw_sim` : Simulates a testbench that verifies the UART AHB Bridge as well as the Flash Writer.
- `make sim_ahb` : Simulates a simople AHB system made out of example-1.v, example-2.v and example-3.v
- `make sim_apb` : Verifies example-4. A simple APB sub-system with a single slave.
- `make sim_sram` : Verifies AHB SRAM Controller.
- `make sim_flash_ctrk` : Verifies AHB Flash Controller.

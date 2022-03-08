# SoCBUS
## Overview
A set of HDL modules and header files to accelerate the process of constructing AMBA (AHB-lite and APB) based SoCs:
- [`AB_APN_BRIDGE.v`](AHB_APB_BRIDGE.v) : AHB-Lite to APB Bridge with programmable clock divider.
- [`AHB_DMAC_1CH.v`](AHB_DMAC_1CH.v) : A single channel DMA controller with AHB-Lite Master and Slave Interfaces.
- [`AHB_FLASH_CTRL.v`](AHB_FLASH_CTRL.v) : AHB-Lite QSPI FLash Controller with Read-Only Direct Mapped Cache. 
- [`AHB_FLASH_WRITER.v`](AHB_FLASH_WRITER.v) : AHB-Lite Flash Writer (Slave).
- [`AHB_MUX_2M1S.v`](AHB_MUX_2M1S.v) : AHB-Lite 2x1 Master multiplexor (2 modes of operation).
- [`AHB_UART_MASTER.v`](AHB_UART_MASTER.v) : UART to AHB-Lite (Master) Bridge.
- [`FIFO.v`](FIFO.v) : A parametrized FIFO.

## Repo Structure
- [`/dv`](/dv) : Verification Testbenches and the associates include and Make files.
- [`/include`](/include) : Utility include files for constructing AHB and APB based sub-systems.
- [`/examples`](/examples) : Examples to demonstrate the usage of the AHB/APB nclude files. 
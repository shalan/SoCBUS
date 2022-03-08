# SoCBUS
## Overview
A set of HDL modules and header files to accelerate the process of constructing AMBA (AHB-lite and APB) based SoCs:
- [`rtl/AB_APN_BRIDGE.v`](AHB_APB_BRIDGE.v) : AHB-Lite to APB Bridge with programmable clock divider.
- [`rtl/AHB_DMAC_1CH.v`](AHB_DMAC_1CH.v) : A single channel DMA controller with AHB-Lite Master and Slave Interfaces.
- [`rtl/AHB_FLASH_CTRL.v`](AHB_FLASH_CTRL.v) : AHB-Lite QSPI FLash Controller with Read-Only Direct Mapped Cache. 
- [`rtl/AHB_FLASH_WRITER.v`](AHB_FLASH_WRITER.v) : AHB-Lite Flash Writer (Slave).
- [`rtl/AHB_MUX_2M1S.v`](AHB_MUX_2M1S.v) : AHB-Lite 2x1 Master multiplexor (2 modes of operation).
- [`rtl/AHB_UART_MASTER.v`](AHB_UART_MASTER.v) : UART to AHB-Lite (Master) Bridge.
- [`rtl/FIFO.v`](FIFO.v) : A parametrized FIFO.

## Repo Structure
- [`/dv`](/dv) : Verification Testbenches and the associates include and Make files.
- [`/include`](/include) : Utility include files for constructing AHB and APB based sub-systems.
- [`/examples`](/examples) : Examples to demonstrate the usage of the AHB/APB nclude files. 

## Status
| IP  | Description | Status | Testbench |
| ------------- | ------------- | ------------- | ------------- |
| [AHB_SRAM](rtl/AHB_SRAM.v)  | AHB SRAM Controller | 98%  | [AHB_SRAM_TB.v](dv/AHB_SRAM_TB.v)
| [AHB_UART_MASTER](rtl/AHB_UART_MASTER.v)  | A UART that can act as AHB master | 90%  | [AHB_UART_MASTER.v](dv/AHB_UART_MASTER_TB.v)
| [AHB_FLASH_WRITER](rtl/AHB_FLASH_WRITER.v)  | AHB Slave used to program the QSI Flash | 95%  | [AHB_UART_MASTER.v](dv/AHB_UART_MASTER_TB.v)
| [AHB_FLASH_CTRL](rtl/AHB_FLASH_CTRL.v)  | AHB QSI Flash Controller with a small DM cache (read only) | 95%  | [n/a]()
| [AHB_APB_BRIDGE](rtl/AHB_APB_BRIDGE.v)  | AHB/APB Bridge | 95%  | [example_4_tb.v](dv/example_4_tb.v) 
| [AHB_MUX_2M1S](rtl/AHB_MUX_2M1S.v)  | Dual mode AHB masters multiplexor | 95%  | [n/a]() 

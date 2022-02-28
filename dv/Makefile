sim: AHB_UART_MASTER_TB.v ../AHB_UART_MASTER.v ../AHB_FLASH_WRITER.v
	iverilog -I ../ -Wall -o sim_flash.vvp $? sst26wf080b.v
	vvp sim_flash.vvp

sim_fw: AHB_UART_MASTER_TB.v ../AHB_UART_MASTER.v ../AHB_FLASH_WRITER.v
	iverilog -I ../ -Wall -o sim_fw.vvp $? sst26wf080b.v
	vvp sim_flash.vvp

../tmp/1.v: ../examples/example-1.v
	iverilog -I ../ -E -o ../tmp/1.v $?

../tmp/2.v: ../examples/example-2.v
	iverilog -I ../ -E -o ../tmp/2.v $?

../tmp/3.v: ../examples/example-3.v
	iverilog -I ../ -E -o ../tmp/3.v $?

sim_ahb: ../examples/example-1.v ../examples/example-2.v ../examples/example-3.v
	iverilog -I ../ -Wall -o sim_ahb.vvp $? example_3_tb.v 
	vvp sim_ahb.vvp 

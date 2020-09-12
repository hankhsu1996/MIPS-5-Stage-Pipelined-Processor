IVERILOG = iverilog -g2005-sv


.PHONY:	all
all:	simv

TESTBENCH = testbench/tb_mips_if_id.v
SIMFILES = rtl/config.v rtl/general/*.v \
	rtl/core/mips_defines.v \
	rtl/core/mips_if_*.v \
	rtl/core/mips_id_*.v \
	rtl/core/mips_ex_*.v \
	rtl/core/mips_if.v \
	rtl/core/mips_id.v \
	rtl/core/mips_ex.v \
	rtl/core/mips_mem.v \
	rtl/core/mips_wb.v \
	rtl/core/mips_core.v \
	rtl/core/cache_d.v rtl/core/cache_i.v \
	rtl/core/dsd_top.v



simv:	$(SIMFILES) $(TESTBENCH)
	$(IVERILOG) $(SIMFILES) $(TESTBENCH) -o test


.PHONY: clean
clean:
	rm -rvf test *.out **/*.out

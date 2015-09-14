library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ensc350_package.all;

entity DMux is
	port (
		op_wb1							: in wb_select;
		alu_out ,mul_out, mem_out	: in std_logic_vector(data_size-1 downto 0);
		D									: out std_logic_vector(data_size-1 downto 0)		
	);
end DMux;

architecture behavioural of DMux is
begin
	process (alu_out, mul_out, mem_out, op_wb1)
	begin
		if op_wb1 = wb_alu then 
			D <= alu_out;
		else
			if op_wb1 = wb_mul then
				D <= mul_out;
			else 
				D <= mem_out;
			end if;	
			
		end if;	
	end process; 

end behavioural;
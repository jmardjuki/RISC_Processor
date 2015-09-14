library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ensc350_package.all;

entity AM_Mux is
	port (
		in_rs							: in std_logic_vector(data_size-1 downto 0);
		immed							: in std_logic_vector (data_size-1 downto 0);
		imm_sel						: in operand_select;
		output						: out std_logic_vector(data_size-1 downto 0)		
	);
end AM_Mux;

architecture behavioural of AM_Mux is
begin
	process (in_rs, immed, imm_sel)
	begin
		if imm_sel = operand_rs2 then 
			output <= in_rs;
		else
			output <= immed;
		end if;	
	end process; 
end behavioural;
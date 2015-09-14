library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use work.ensc350_package.all;

entity FULL_ALU is 

	port(
			in1 : in std_logic_vector(data_size-1 downto 0);
			in2 : in std_logic_vector(data_size-1 downto 0);
			op : in alu_commands;
			result : out std_logic_vector(data_size-1 downto 0)
	);
			
end FULL_ALU;

architecture behavioral of FULL_ALU is

signal sum, diff: std_logic_vector(data_size downto 0);
signal ucmp, cmp: std_logic_vector(data_size-1 downto 0);

begin

		sum <= std_logic_vector(resize(signed(in1),data_size+1)+resize(signed(in2),data_size+1));
		diff <= std_logic_vector(resize(signed(in1),data_size+1)-resize(signed(in2),data_size+1));
		ucmp <= std_logic_vector(to_signed(1,data_size)) when unsigned(in1) < unsigned(in2) else
					std_logic_vector(to_signed(0,data_size));
		cmp <= std_logic_vector(to_signed(1,data_size)) when signed(in1) < signed(in2) else 
					std_logic_vector(to_signed(0,data_size));
					
		alu_mux: result <= sum(data_size-1 downto 0) when op=alu_add or op=alu_addu else
																	diff(data_size-1 downto 0) when op=alu_sub or op=alu_subu else
																	cmp when op=alu_slt else
																	ucmp when op=alu_sltu else
																	in1 and in2 when op=alu_and else
																	in1 or in2 when op=alu_or else
																	in1 xor in2 when op=alu_xor else
																	in1 nor in2 when op=alu_nor else
																	std_logic_vector(shift_left(signed(in1), to_integer(signed(in2)))) when op=alu_sll else
																	std_logic_vector(shift_right(signed(in1), to_integer(signed(in2)))) when op=alu_srl else
																	std_logic_vector(shift_right(signed(in1), to_integer(signed(in2)))) when op=alu_sra else
																	std_logic_vector(shift_left(resize(signed(in2(7 downto 0)), data_size), data_size/2)) or std_logic_vector(resize(signed(in1(7 downto 0)), data_size)) when op=alu_lui else
																	(others=>'0');																
end behavioral;
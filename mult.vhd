-- Multiplifier
library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_SIGNED.all;
use ieee.numeric_std.all;
use work.ensc350_package.all;

entity mult is
	port(
		in1, in2	: in std_logic_vector(data_size-1 downto 0);
		mul_op	: in mul_commands;
		mult_out		: out std_logic_vector(data_size-1 downto 0)
	);
end mult;

architecture behav_mult of mult is
	
begin	
	mult: process(mul_op,in1,in2)
		variable output, temp : std_logic_vector(2*data_size-1 downto 0);
		begin
		if ( mul_op = mul_mul) then
			temp	:= std_logic_vector(signed(in1)*signed(in2));
			output := temp(2*data_size-1 downto 0);
			
		else
			output	:= (others=>'0');
		end if;	
		
		mult_out		<= output(data_size-1 downto 0);
	end process;	
end behav_mult;
		
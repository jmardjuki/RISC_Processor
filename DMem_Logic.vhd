-- DMem_Logic
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.ensc350_package.all;

-- -=:=--=:=--=:=--=:=--=:=--=:=--=:=--=:=--=:=--=:=--=:=-
entity DMem_Logic is
	port (
		in1, in2					: in std_logic_vector(data_size-1 downto 0);
		immed						: in std_logic_vector(data_size-1 downto 0); -- not really sure about the size
		mem_op					: in mem_commands;
		ddata_in					: in std_logic_vector (data_size-1 downto 0);
		dmem_read,dmem_write : out std_logic;
		dmem_out					: out std_logic_vector (data_size-1 downto 0);
		ddata_out				: out std_logic_vector (data_size-1 downto 0);
		daddr_out				: out std_logic_vector(daddr_size-1 downto 0)
		);		
end entity DMem_Logic;
-- -=:=--=:=--=:=--=:=--=:=--=:=--=:=--=:=--=:=--=:=--=:=-

architecture behavioural of DMem_Logic is
	
--	signal resizeImmed : std_logic_vector(daddr_size-1 downto 0);
begin
	DMem: process(in1, in2, mem_op, immed, ddata_in)
		begin
			if mem_op = mem_lw then 
				dmem_read <= '1'; 
				dmem_write <= '0';	
				daddr_out <= std_logic_vector(resize(unsigned(signed(in1) + signed(immed)),daddr_size));	
				ddata_out <= (others => '0');
			elsif mem_op = mem_sw then
				dmem_write <= '1';
				dmem_read <= '0';		
				daddr_out <= std_logic_vector(resize(unsigned(signed(in2) + signed(immed)),daddr_size));	
				ddata_out <= in1;
			else
				dmem_read <= '0';
				dmem_write <= '0';
				ddata_out <= (others => '0'); -- making it easier to debug
				daddr_out <= (others => '0');
			end if;
			--ddata_out <= in1;
			dmem_out <= ddata_in;
--			resizeImmed <= std_logic_vector(resize(signed(immed), daddr_size));
			--daddr_out <= std_logic_vector(unsigned(signed(in2(11 downto 0)) + signed(immed(daddr_size-1 downto 0))));
			
	end process;		
end behavioural;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.ensc350_package.all;

entity Rfile is
	
	port (
		clk		: in std_logic;
		resetn	: in std_logic;
		ra,rb		: in std_logic_vector(rf_addr_size-1 downto 0);
		rd1		: in std_logic_vector(rf_addr_size-1 downto 0);
		d1_in		: in std_logic_vector(data_size-1 downto 0);
		a_out		: out std_logic_vector(data_size-1 downto 0);
		b_out		: out std_logic_vector(data_size-1 downto 0)
	);
end Rfile;
	
architecture behavioral of Rfile is
	type rf_bus_array is array (2**rf_addr_size-1 downto 0) of std_logic_vector(data_size-1 downto 0);
	signal reg_in, reg_out: rf_bus_array;
begin
	-- Note: on most RISC architectures -NOT ARM!-Register 0 is grounded 
	--reg_out(0) <= (others => '0');

	Registers: process(clk,resetn)
	begin
	reg_out(0) <= (others => '0');
		for i in 1 to (2**rf_addr_size-1) loop
			if resetn='0' then
				reg_out(i) <= (others => '0');
			elsif clk'event and clk='1' then
					reg_out(i)<= reg_in(i);
			end if;
		end loop;
	end process;

--Reg_file Reads
--
READ_A_MUX:a_out <= reg_out(Conv_Integer(unsigned(ra)));
READ_B_MUX:b_out <= reg_out(Conv_Integer(unsigned(rb)));

--Reg_file writes.
	WRITE_D_MUX: process(rd1,d1_in,reg_out)
	begin
		for i in 1 to(2**rf_addr_size-1) loop
			if i = Conv_Integer(unsigned(rd1)) then
				reg_in(i) <= d1_in;
			else
				reg_in(i) <= reg_out(i);
			end if;
		end loop;
	end process;
	
end behavioral;
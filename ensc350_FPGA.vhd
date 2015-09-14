library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

use work.ensc350_package.all;

entity ensc350_FPGA is
port(
	CLOCK_50: in std_logic;
	Key : in std_logic_vector(0 downto 0); 
	HEX0: out std_logic_vector(6 downto 0);
	HEX1: out std_logic_vector(6 downto 0); 
	HEX2: out std_logic_vector(6 downto 0);
	HEX3: out std_logic_vector(6 downto 0)
);	

end ensc350_FPGA;
architecture tb of ensc350_FPGA is

  component ensc350
	 port(  clk,resetn           : in  Std_logic;
			iaddr_out            : out Std_logic_vector(iaddr_size-1 downto 0);
			idata_in             : in  Std_logic_vector(instr_size-1 downto 0);
			daddr_out            : out Std_logic_vector(daddr_size-1 downto 0);
			dmem_read,dmem_write : out std_logic;
			ddata_in             : in  Std_logic_vector(data_size-1  downto 0);
			ddata_out            : out Std_logic_vector(data_size-1  downto 0));
  end component;
  
  constant half_period : time := 10 ns;
  constant size : positive := 16;
  signal clk,clkn,resetn    :  std_logic;
  signal iaddr_out          :  Std_logic_vector(iaddr_size-1 downto 0);
  signal daddr_out          :  Std_logic_vector(daddr_size-1 downto 0);
  signal idata_in           :  Std_logic_vector(instr_size-1 downto 0);
  signal ddata_in,ddata_out :  Std_logic_vector(data_size-1 downto 0);
  signal D_wen,D_ren,I_wen,I_ren : Std_logic;
  signal D_bitwen           : std_logic_vector(data_size-1 downto 0);               
  signal I_bitwen           : std_logic_vector(instr_size-1 downto 0);
  
  type decoder_InArray is array (0 to 3) of std_logic_vector(3 downto 0);
  type decoder_OutArray is array (0 to 3) of std_logic_vector(6 downto 0);
  
  signal decoder_InSignal 	: decoder_InArray;
  signal decoder_OutSignal : decoder_OutArray;
  
begin

	clk <= CLOCK_50;
	resetn <= Key(0);  
	

	
    IRAM : altsyncram
	GENERIC MAP ( clock_enable_input_a => "BYPASS",	clock_enable_output_a => "BYPASS",init_file => "imemory.mif",
		intended_device_family => "Cyclone IV E", lpm_hint => "ENABLE_RUNTIME_MOD=NO",	lpm_type => "altsyncram",
		numwords_a => 2**iaddr_size, operation_mode => "SINGLE_PORT", outdata_aclr_a => "NONE",
		outdata_reg_a => "UNREGISTERED", power_up_uninitialized => "FALSE", read_during_write_mode_port_a => "NEW_DATA_NO_NBE_READ",
		widthad_a => iaddr_size, width_a => instr_size,	width_byteena_a => 1 )
	PORT MAP (	address_a=>iaddr_out, clock0=>clk, data_a=>idata_in, rden_a=>I_ren, wren_a=>I_wen, q_a=>idata_in);

	DRAM : altsyncram
	GENERIC MAP ( clock_enable_input_a => "BYPASS",	clock_enable_output_a => "BYPASS",init_file => "dmemory.mif",
		intended_device_family => "Cyclone IV E", lpm_hint => "ENABLE_RUNTIME_MOD=NO",	lpm_type => "altsyncram",
		numwords_a => 2**daddr_size, operation_mode => "SINGLE_PORT", outdata_aclr_a => "NONE",
		outdata_reg_a => "UNREGISTERED", power_up_uninitialized => "FALSE", read_during_write_mode_port_a => "NEW_DATA_NO_NBE_READ",
		widthad_a => daddr_size, width_a => data_size,width_byteena_a => 1 )
	PORT MAP (	address_a=>daddr_out, clock0=>clkn, data_a=>ddata_out, rden_a=>D_ren, wren_a=>D_wen, q_a=>ddata_in);
	
	clkn <= not clk; I_wen <= '0'; I_ren <= '1';
	
	ensc350Processor : ensc350 port map (clk, resetn,iaddr_out, idata_in, daddr_out,D_ren,D_wen,ddata_in, ddata_out );
	
	decoder_InSignal(0)  <= ddata_out(15 downto 12);
	decoder_InSignal(1)  <= ddata_out(11 downto 8);
	decoder_InSignal(2)  <= ddata_out(7 downto 4);
	decoder_InSignal (3)  <= ddata_out(3 downto 0);
	
	segDisplay0: entity work.segment7_conv port map( D => decoder_InSignal(0), O => decoder_OutSignal(3));
	segDisplay1: entity work.segment7_conv port map( D => decoder_InSignal(1), O => decoder_OutSignal(2));
	segDisplay2: entity work.segment7_conv port map( D => decoder_InSignal(2), O => decoder_OutSignal(1));
	segDisplay3: entity work.segment7_conv port map( D => decoder_InSignal(3), O => decoder_OutSignal(0));
	

	
	FPGA: process (clk, resetn)   -- Keeping the circuit reset for 15 ns before starting computation
	begin
		if resetn ='0' then 
				HEX0 <= "0001110";
				HEX1 <= "0001110";
				HEX2 <= "0001110";
				HEX3 <= "0001110";	
				
		elsif clk'event and clk ='1' then
			if ( daddr_out(11 downto 0) = x"f01") then
				HEX0 <= decoder_OutSignal(0);
				HEX1 <= decoder_OutSignal(1);
				HEX2 <= decoder_OutSignal(2);
				HEX3 <= decoder_OutSignal(3);
			end if;
		end if;
	end process; 

--FPGA_logic: for i in 0 to 4 generate
--	
--	delay_in(i+1) <= delay_out(i);
--	
--	COEFF_MUL: mul_out(i) <= std_logic_vector( signed(delay_out(i)) * signed(C(i)) );
--DELAY_FF : process(clk, resetn)
--	begin 
--		if resetn='0' then
--				HEX0 <= "0001110";
--				HEX1 <= "0001110";
--				HEX2 <= "0001110";
--				HEX3 <= "0001110";	
--		elsif rising_edge(clk) then
--		--elsif clk'event and clk='1' then *avoid using clock event and clock=1, said by frank
--			delay_out(i) <= delay_in(i);
--		end if;
--	end process;
--end generate TAPS_logic;

--	 
	
	
end tb;
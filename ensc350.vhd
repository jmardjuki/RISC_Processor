library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

--LIBRARY altera_mf;
--USE altera_mf.altera_mf_components.all;


use work.ensc350_package.all;

entity ensc350 is
	port( 
		clk,resetn				: in Std_logic;
		idata_in					: in Std_logic_vector(instr_size-1 downto 0);
		ddata_in					: in Std_logic_vector(data_size-1 downto 0);
		iaddr_out				: out Std_logic_vector(iaddr_size-1 downto 0);
		daddr_out				: out Std_logic_vector(daddr_size-1 downto 0);
		dmem_read,dmem_write : out std_logic;
		ddata_out				: out Std_logic_vector(data_size-1 downto 0)
	);
end ensc350;

architecture behavioural of ensc350 is

	signal idata_in_signal							: std_logic_vector(instr_size-1 downto 0);
	signal immed_signal								: std_logic_vector(data_size-1 downto 0);
	signal alu_op_signal								: alu_commands;
	signal mul_op_signal								: mul_commands;
	signal mem_op_signal								: mem_commands;
	signal pc_op_signal								: pc_commands;
	signal imm_sel_signal							: operand_select;
	signal wb_op_signal								: wb_select;
	signal clock, reset								: std_logic;
	signal rs1_signal, rs2_signal, rd_signal	: std_logic_vector(rf_addr_size-1 downto 0);
	signal d1_signal									: std_logic_vector(data_size-1 downto 0); 
	signal a_out_signal								: std_logic_vector(data_size-1 downto 0);
	signal b_out_signal								: std_logic_vector(data_size-1 downto 0);
	signal ddata_in_signal							: std_logic_vector(data_size-1 downto 0);
	signal dmem_read_signal,dmem_write_signal	: std_logic;
	signal dmem_out_signal							: std_logic_vector (data_size-1 downto 0);
	signal daddr_out_signal							: std_logic_vector (daddr_size-1 downto 0);
	signal instr_out_signal							: std_logic_vector (iaddr_size-1 downto 0);
	signal alu_out_signal 							: std_logic_vector (data_size-1 downto 0);
	signal mul_out_signal							: std_logic_vector (data_size-1 downto 0);
	signal AM_output_signal							: std_logic_vector (data_size-1 downto 0);		
	signal ddata_out_signal							: std_logic_vector (data_size-1 downto 0);		
	

	
	begin
		clock <= clk;
		reset <= resetn;
		idata_in_signal <= idata_in;
		ddata_in_signal <= ddata_in;
		dmem_read <= dmem_read_signal ;
		dmem_write <= dmem_write_signal;
		daddr_out <= daddr_out_signal;
		iaddr_out <= instr_out_signal;
		ddata_out <= ddata_out_signal;
		
		
		idecode: entity work.instr_decode port map(
			idata_in => idata_in_signal, 
			rs1 => rs1_signal, 
			rs2 =>rs2_signal, 
			rd => rd_signal,
			immediate => immed_signal,
			alu_op => alu_op_signal,
			mul_op => mul_op_signal,
			mem_op => mem_op_signal, 
			pc_op => pc_op_signal,
			imm_sel => imm_sel_signal, 
			wb_op => wb_op_signal
			);
		
		rfile: entity work.Rfile port map(
			clk => clock,
			resetn => reset,	
			ra => rs1_signal,
			rb => rs2_signal,	
			rd1 => rd_signal,		
			d1_in => d1_signal,		
			a_out =>	a_out_signal,	
			b_out	=> b_out_signal	
		);
		
		Dmem_logic: entity work.DMem_Logic port map(
			in1 => a_out_signal,
			in2 => b_out_signal,					
			immed	=>	immed_signal,				
			mem_op => mem_op_signal,				
			ddata_in	=> ddata_in_signal,				
			dmem_read => dmem_read_signal,
			dmem_write => dmem_write_signal,
			dmem_out	=> dmem_out_signal,				
			daddr_out => daddr_out_signal,
			ddata_out => ddata_out_signal
		);
		
		pcl: entity work.PCLogic port map(
			clk => clock, 
			rst=> reset, 
			rs1 => a_out_signal, 
			rs2=> b_out_signal, 
			offset => immed_signal, 
			pc_op => pc_op_signal, 
			instr_out=> instr_out_signal
			); 
			
		DMutiplexers: entity work.DMux port map(
			op_wb1 => wb_op_signal,							
			alu_out => alu_out_signal,
			mul_out => mul_out_signal,
			mem_out => dmem_out_signal,
			D => d1_signal									
		);
		
		AMultiplexer: entity work.AM_Mux port map(
			in_rs	=> b_out_signal,						
			immed	=> immed_signal,						
			imm_sel => imm_sel_signal,						
			output => AM_output_signal						
			);
			
					
		ALU: entity work.FULL_ALU 	port map(
			in1 => a_out_signal,
			in2 => AM_output_signal,
			op => alu_op_signal,
			result => alu_out_signal
			);
			
		Multiplier: entity work.mult port map(
			in1 => a_out_signal,
			in2 => b_out_signal,	
			mul_op => mul_op_signal,	
			mult_out => mul_out_signal		
			);

end behavioural;

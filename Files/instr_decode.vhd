-- INSTR_Decode
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.ensc350_package.all;

-- -=:=--=:=--=:=--=:=--=:=--=:=--=:=--=:=--=:=--=:=--=:=---=:=--=:=-
entity INSTR_Decode is
	port (
		idata_in			: in	std_logic_vector ( instr_size-1 downto 0);
		rs1, rs2, rd	: out std_logic_vector ( rf_addr_size-1 downto 0);
		immediate		: out std_logic_vector ( data_size-1 downto 0);
		alu_op			: out alu_commands;
		mul_op			: out mul_commands;
		mem_op			: out mem_commands;
		pc_op				: out pc_commands;
		imm_sel			: out operand_select;
		wb_op				: out wb_select 		
	);
end entity INSTR_Decode;
-- -=:=--=:=--=:=--=:=--=:=--=:=--=:=--=:=--=:=--=:=--=:=---=:=--=:=-

architecture behav_INSTR_Decode of INSTR_Decode is
	
begin

	decoding: process (idata_in)
	variable primaryOP, secondaryOP: std_logic_vector(rf_addr_size-1 downto 0);
	begin
		primaryOP := idata_in(instr_size-1 downto 16);
-----RRR instructions-----------------------	
---- immediate signal not selected--------------		
--case primaryOP is		
--		when op_RRR => 
--			rd <= idata_in(15 downto 12);
--			rs1 <= idata_in(11 downto 8);
--			rs2 <= idata_in(7 downto 4);
--			secondaryOP <= idata_in(3 downto 0);
--			imm_sel <= operand_rs2;	
		
			
		if primaryOP = op_RRR then
			rd <= idata_in(15 downto 12);
			rs1 <= idata_in(11 downto 8);
			rs2 <= idata_in(7 downto 4);
			secondaryOP := idata_in(3 downto 0);
			imm_sel <= operand_rs2;	
			immediate <= (others => '0');
			-- !! Not sure if all op code are covered
			
			case secondaryOP is
			
				when op_add =>
				alu_op <= alu_add;
				wb_op <= wb_alu;
				mul_op <= mul_nop;
				mem_op <= mem_nop;
				pc_op <= pc_carryon;
						
				when op_sub =>
				alu_op <= alu_sub;
				wb_op <= wb_alu;
				mul_op <= mul_nop;
				mem_op <= mem_nop;
				pc_op <= pc_carryon;	
				
				when op_and =>
				alu_op <= alu_and;
				wb_op <= wb_alu;
				mul_op <= mul_nop;
				mem_op <= mem_nop;
				pc_op <= pc_carryon;
				
				when op_or =>
				alu_op <= alu_or;
				wb_op <= wb_alu;
				mul_op <= mul_nop;
				mem_op <= mem_nop;
				pc_op <= pc_carryon;
				
				when op_slt =>
				alu_op <= alu_slt;
				wb_op <= wb_alu;
				mul_op <= mul_nop;
				mem_op <= mem_nop;
				pc_op <= pc_carryon;	
				
				when op_sll =>
				alu_op <= alu_sll;
				wb_op <= wb_alu;
				mul_op <= mul_nop;
				mem_op <= mem_nop;
				pc_op <= pc_carryon;	
				
				when op_srl =>
				alu_op <= alu_srl;
				wb_op <= wb_alu;
				mul_op <= mul_nop;
				mem_op <= mem_nop;
				pc_op <= pc_carryon;
				
				when op_sra =>
				alu_op <= alu_sra;
				wb_op <= wb_alu;
				mul_op <= mul_nop;
				mem_op <= mem_nop;
				pc_op <= pc_carryon;
				
				when op_mul =>
				alu_op <= alu_add;
				wb_op <= wb_mul;
				mul_op <= mul_mul;
				mem_op <= mem_nop;
				pc_op <= pc_carryon;	
				
				when others => 
				alu_op <= alu_add;
				wb_op <= wb_alu;
				mul_op <= mul_nop;
				mem_op <= mem_nop;
				pc_op <= pc_carryon;
				
			end case;
------------------------------------------------------------------------------			
			
		else
-----RRI instructions-----------------------	
---- immediate signal selected--------------+		
			immediate <= std_logic_vector(resize(signed(idata_in(7 downto 0)),data_size));
			imm_sel <= operand_immed;
		
		rs2 <= (others=>'0');-- default rs2
		wb_op <= wb_alu;
		--immediate <= (others =>'0');
		
		case primaryOP is
			
			when op_addi =>
			alu_op <= alu_add;
			wb_op <= wb_alu;
			mul_op <= mul_nop;
			mem_op <= mem_nop;
			pc_op <= pc_carryon;
			rd <= idata_in(15 downto 12);
			rs1 <= idata_in(11 downto 8);	
			
			when op_andi =>
			alu_op <= alu_and;
			wb_op <= wb_alu;
			mul_op <= mul_nop;
			mem_op <= mem_nop;
			pc_op <= pc_carryon;		
			rd <= idata_in(15 downto 12);
			rs1 <= idata_in(11 downto 8);
			
			when op_slti =>
			alu_op <= alu_slt;
			wb_op <= wb_alu;
			mul_op <= mul_nop;
			mem_op <= mem_nop;
			pc_op <= pc_carryon;		
			rd <= idata_in(15 downto 12);
			rs1 <= idata_in(11 downto 8);	

			when op_lui =>
			alu_op <= alu_lui;
			wb_op <= wb_alu;
			mul_op <= mul_nop;
			mem_op <= mem_nop;
			pc_op <= pc_carryon;	
			rd <= idata_in(15 downto 12);
			rs1 <= idata_in(11 downto 8);
		
			when op_j =>
			alu_op <= alu_add;
			pc_op <= pc_jump;
			mul_op <= mul_nop;
			mem_op <= mem_nop;	
			rs1 <= idata_in(15 downto 12);
			rd <= "0000";
			
			when op_beq =>
			alu_op <= alu_add;
			pc_op <= pc_beq;
			mul_op <= mul_nop;
			mem_op <= mem_nop;	
			rs1 <= idata_in(15 downto 12);
			rs2 <= idata_in(11 downto 8 );
			rd <= "0000";
			
			when op_bneq =>
			alu_op <= alu_add;
			pc_op <= pc_bneq;
			mul_op <= mul_nop;
			mem_op <= mem_nop;
			rs1 <= idata_in(15 downto 12);
			rs2 <= idata_in(11 downto 8 );
			rd <= "0000";
			
			when op_lw =>
			alu_op <= alu_add;
			mem_op <= mem_lw;
			wb_op <= wb_mem;
			mul_op <= mul_nop;
			pc_op <= pc_carryon;
			rd <= idata_in(15 downto 12);
			rs1 <= idata_in(11 downto 8 );
			
			when op_sw =>
			alu_op <= alu_add;
			mem_op <= mem_sw;
			mul_op <= mul_nop;
			-- no write back 
			pc_op <= pc_carryon;
			rs1 <= idata_in(15 downto 12);
			rs2 <= idata_in(11 downto 8 );
			rd <= "0000";
			
			when others =>
			alu_op <= alu_add;
			wb_op <= wb_alu;
			mul_op <= mul_nop;
			mem_op <= mem_nop;
			pc_op <= pc_carryon;
			rd <= idata_in(15 downto 12);
			rs1 <= idata_in(11 downto 8);	
			
		end case;
-----------------------------------------------------------------------------------------------------------------------------		

				
			end if;	
			
	end process;		
end architecture behav_INSTR_Decode;

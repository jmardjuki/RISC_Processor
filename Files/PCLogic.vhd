-- PCLogic
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.ensc350_package.all;

-- -=:=--=:=--=:=--=:=--=:=--=:=--=:=--=:=--=:=--=:=--=:=-
entity PCLogic is
	port (
		clk, rst		: in std_logic;
		rs1, rs2		: in std_logic_vector(data_size-1 downto 0);
		offset		: in std_logic_vector(data_size-1 downto 0);
		pc_op			: in pc_commands;
		instr_out	: out std_logic_vector(iaddr_size-1 downto 0)
		);		
end entity PCLogic;
-- -=:=--=:=--=:=--=:=--=:=--=:=--=:=--=:=--=:=--=:=--=:=-

architecture PCCounter of PCLogic is
	signal PC_curr, PC_new : std_logic_vector (iaddr_size-1 downto 0):=(others=>'0');
begin

	doPC: process(rs1, rs2, offset, pc_op, PC_curr)
	begin
		if (pc_op = pc_beq) then
			if ( rs1 = rs2 ) then
				PC_new <= std_logic_vector(signed(offset(iaddr_size-1 downto 0)) + signed(PC_curr)); 
			else
				PC_new <= std_logic_vector(signed(PC_curr)+1);
			end if;
		elsif(pc_op = pc_bneq) then
			if ( rs1 = rs2 ) then
				PC_new <= std_logic_vector(signed(PC_curr)+1);
			else
				PC_new <= std_logic_vector(signed(PC_curr) + signed(offset(iaddr_size-1 downto 0))); 
			end if;			
		elsif(pc_op = pc_jump) then
			PC_new <= std_logic_vector(signed(rs1(iaddr_size-1 downto 0))); 
		else
			PC_new <= std_logic_vector(signed(PC_curr)+1);
		end if;	
	
	end process doPC;
	
	PC_FF: process(clk, rst)
	begin 	
	   if rst='0' then 
		   PC_curr <= (others=>'1');
		elsif clk'event and clk='1' then 
			PC_curr <= PC_new;			
	  end if;
	end process;	
	instr_out <=PC_new;	
end architecture PCCounter;
	
		
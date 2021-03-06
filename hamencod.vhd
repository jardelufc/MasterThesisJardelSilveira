----------------------------------------------------------------------------------
-- Company: 
-- Student: 		 David Viana 
-- 
-- Create Date:    15:02:03 09/11/2008 
-- Design Name: 
-- Module Name:    ham_enc - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ham_enc is
generic (jpc_width : integer);
port(
		reset 		:in std_logic;
		tclk 			:in std_logic;
		enable		:in std_logic;
		data 			:in std_logic_vector (31 downto 0);
		addr_in		:in std_logic_vector (jpc_width-3 downto 0);

		addr_out		:out std_logic_vector (jpc_width-3 downto 0);	
		rdy_cache	:out std_logic;
		data_out		:out std_logic_vector (31 downto 0);
		Ham_out		:out std_logic_vector (15 downto 0)
);
end ham_enc;

architecture Behavioral of ham_enc is
	--Signal ability	: std_logic;
begin
process(tclk,reset)
	
	-- variable sync : std_logic;
    variable D		: std_logic_vector(32 downto 1);
	 variable H		: std_logic_vector(16 downto 1);
	 variable temp : std_logic_vector(12 downto 1);

	 begin

	 if (tclk = '1' and reset = '1') then
			D := x"00000000";
			H := x"0000";
			Ham_out <= x"0000";
			
	 elsif enable = '1' and tclk = '1' then
			D := data;
			temp := x"000";

			-- primeiro byte D(8 downto 1);

			temp(12 downto 9) := D(8 downto 5);
			temp(7 downto 5)  := D(4 downto 2);			
			temp(3)  			:= D(1);			
			
			H(1) := temp(1) xor temp(3) xor temp(5) xor temp(7) xor temp(9) xor temp(11) ;
			
			H(2) := temp(2) xor temp(3) xor temp(6) xor temp(7) xor temp(10) xor temp(11);			
			
			H(3) := temp(4) xor temp(5) xor temp(6) xor temp(7) xor temp(12);	
			
			H(4) := temp(8) xor temp(9) xor temp(10) xor temp(11) xor temp(12);
			
			-- segundo byte D(16 downto 9);
			temp := x"000";
			temp(12 downto 9) := D(16 downto 13);
			temp(7 downto 5)  := D(12 downto 10);			
			temp(3)  			:= D(9);			
			
			H(5) := temp(1) xor temp(3) xor temp(5) xor temp(7) xor temp(9) xor temp(11) ;
			
			H(6) := temp(2) xor temp(3) xor temp(6) xor temp(7) xor temp(10) xor temp(11);			
			
			H(7) := temp(4) xor temp(5) xor temp(6) xor temp(7) xor temp(12);	
			
			H(8) := temp(8) xor temp(9) xor temp(10) xor temp(11) xor temp(12);			

			-- terceiro byte D(24 downto 17);
			temp := x"000";			
			temp(12 downto 9) := D(24 downto 21);
			temp(7 downto 5)  := D(20 downto 18);			
			temp(3)  			:= D(17);
			
			H(9) := temp(1) xor temp(3) xor temp(5) xor temp(7) xor temp(9) xor temp(11) ;
			
			H(10) := temp(2) xor temp(3) xor temp(6) xor temp(7) xor temp(10) xor temp(11);			
			
			H(11) := temp(4) xor temp(5) xor temp(6) xor temp(7) xor temp(12);	
			
			H(12) := temp(8) xor temp(9) xor temp(10) xor temp(11) xor temp(12);
			
			-- quarto byte D(32 downto 25);
			temp := x"000";			
			temp(12 downto 9) := D(32 downto 29);
			temp(7 downto 5)  := D(28 downto 26);			
			temp(3)  			:= D(25);			
			
			H(13) := temp(1) xor temp(3) xor temp(5) xor temp(7) xor temp(9) xor temp(11) ;
			
			H(14) := temp(2) xor temp(3) xor temp(6) xor temp(7) xor temp(10) xor temp(11);			
			
			H(15) := temp(4) xor temp(5) xor temp(6) xor temp(7) xor temp(12);	
			
			H(16) := temp(8) xor temp(9) xor temp(10) xor temp(11) xor temp(12);
			
			addr_out <= addr_in;			
			Ham_out <= H;
			data_out<= D;
			rdy_cache <= '1';
			
	 elsif tclk = '1' then
	 
		rdy_cache <= '0';
		
	 end if;
	 
  end process;

end Behavioral;


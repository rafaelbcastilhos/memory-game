-----------------------------------
library ieee;
use ieee.std_logic_1164.all;
------------------------------------
entity SEQ2 is port ( 
	address: in std_logic_vector(3 downto 0);
	data: out std_logic_vector(17 downto 0) 
);
end entity;

architecture Rom_Arch of SEQ2 is
	type memory is array (00 to 15) of std_logic_vector(17 downto 0);
	constant my_Rom : memory := (
		00 => "000000000000000001",
		01 => "000000000000000010",
		02 => "000000000000000100",
		03 => "000000000000001000",
		04 => "000000000000010000",
		05 => "000000000000100000",
		06 => "000000000001000000",
		07 => "000000000010000000",
		08 => "000000000100000000",
		09 => "000000001000000000",
		10 => "000000010000000000",
		11 => "000000100000000000",
		12 => "000001000000000000",
		13 => "000010000000000000",
		14 => "000100000000000000",
		15 => "001000000000000000");
begin
	process (address) --//o adress vai ser o número da rodada.
	begin
	case address is
		when "0000" => data <= my_rom(00);
		when "0001" => data <= my_rom(01);
		when "0010" => data <= my_rom(02);
		when "0011" => data <= my_rom(03);
		when "0100" => data <= my_rom(04);
		when "0101" => data <= my_rom(05);
		when "0110" => data <= my_rom(06);
		when "0111" => data <= my_rom(07);
		when "1000" => data <= my_rom(08);
		when "1001" => data <= my_rom(09);
		when "1010" => data <= my_rom(10);
		when "1011" => data <= my_rom(11);
		when "1100" => data <= my_rom(12);
		when "1101" => data <= my_rom(13);
		when "1110" => data <= my_rom(14);
		when others => data <= my_rom(15);
		end case;
	end process;
end architecture Rom_Arch;

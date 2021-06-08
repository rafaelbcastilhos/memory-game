library ieee;
use ieee.std_logic_1164.all;

entity regsetup is port (
	IN_REG_SETUP: in std_logic_vector(13 downto 0);
	R: in std_logic;
    E: in std_logic;
    CLK_500Hz: in std_logic;
	OUT_REG_SETUP: out std_logic_vector(13 downto 0) 
);
end regsetup;

architecture behv of regsetup is
begin
	process(CLK_500Hz, R, E)
	begin
		if (R = '1' and E = '1') then
			OUT_REG_SETUP <= "00000000000000";
		elsif (CLK_500Hz'event and CLK_500Hz = '1') then
			if (E = '1') then
				OUT_REG_SETUP <= IN_REG_SETUP;
			end if;
		end if;
	end process;
end behv;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity counterbonus is port (
	IN_COUNTER_BONUS: in std_logic_vector(5 downto 0);
	IN_SET_SETUP_BONUS: in std_logic_vector(3 downto 0);
	SET, E, CLK_500Hz: in std_logic;
	OUT_END_BONUS: out std_logic;
	OUT_COUNTER_BONUS: out std_logic_vector(5 downto 0)
);
end counterbonus;

architecture counterb of counterbonus is
    signal counter: std_logic_vector(5 downto 0);
	begin
		process(CLK_500Hz, SET)
		begin
			-- set assíncrono
			if (SET = '1') then
				counter <= "00" & IN_SET_SETUP_BONUS;
				OUT_END_BONUS <= '0';
			elsif (CLK_500Hz'event AND CLK_500Hz = '1') then 
				if (E = '1') then 
					if (counter < "000000") then
						OUT_END_BONUS <= '1';
					else
						counter <= counter - IN_COUNTER_BONUS;
						OUT_END_BONUS <= '0';	
					end if;
				end if;
			end if;
		end process;

		OUT_COUNTER_BONUS <= counter;
end counterb;

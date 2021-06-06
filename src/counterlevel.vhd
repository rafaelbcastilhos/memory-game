library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity counterlevel is port (
	IN_COUNTER_LEVEL: in std_logic_vector(3 downto 0);
	R, E, CLK_1Hz: in std_logic;
	OUT_END_FPGA: out std_logic
);
end counterlevel;

architecture counterl of counterlevel is
    signal counter: std_logic_vector(3 downto 0) := "0000";
	begin
		process(CLK_1Hz, R)
		begin
			-- reset assíncrono
			if (R = '1') then
				OUT_END_FPGA <= '0';
				counter <= "0000";
			elsif (CLK_1Hz'event AND CLK_1Hz = '1') then 
				if (E = '1') then 
					if (counter = IN_COUNTER_LEVEL) then
						counter <= "0000";
						OUT_END_FPGA <= '1';
					else
						counter <= counter + "0001";
						OUT_END_FPGA <= '0';
					end if;
				end if;
			end if;
		end process;
end counterl;
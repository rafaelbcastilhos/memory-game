library ieee;   
use ieee.std_logic_1164.all;

entity decBCD is port (
    bin_in: in std_logic_vector(3 downto 0);
    bcd_out: out std_logic_vector(7 downto 0)
);
end entity decBCD;

architecture binBCD of decBCD is
begin
    bcd_out <= "00000000" when bin_in = "0000" else
        "00000001" when bin_in = "0001" else
        "00000010" when bin_in = "0010" else
        "00000011" when bin_in = "0011" else
        "00000100" when bin_in = "0100" else
        "00000101" when bin_in = "0101" else
        "00000110" when bin_in = "0110" else
        "00000111" when bin_in = "0111" else
        "00001000" when bin_in = "1000" else
        "00001001" when bin_in = "1001" else
        "00010000" when bin_in = "1010" else
        "00010001" when bin_in = "1011" else
        "00010010" when bin_in = "1100" else
        "00010011" when bin_in = "1101" else
        "00010100" when bin_in = "1110" else
        "00010101";

end architecture binBCD;
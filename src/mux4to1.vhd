library ieee;
use ieee.std_logic_1164.all;

entity mux4to1 is port (
    w0, w1, w2, w3: in std_logic_vector(17 downto 0);
    s: in std_logic_vector(1 downto 0);
    f: out std_logic_vector(17 downto 0)
);
end mux4to1;

architecture mux4x1 of mux4to1 is
begin
    with s select
        f <= w0 when "00",
        w1 when "01",
        w2 when "10",
        w3 when others;
end mux4x1;
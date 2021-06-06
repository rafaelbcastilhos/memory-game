library ieee;
use ieee.std_logic_1164.all;

entity mux2to1_7b is port (
    w0, w1: in std_logic_vector(6 downto 0);
    s: in std_logic;
    f: out std_logic_vector(6 downto 0)
);
end mux2to1_7b;

architecture mux2x1_7 of mux2to1_7b is
begin
    with s select
        f <= w0 when '0',
        w1 when others;
end mux2x1_7;
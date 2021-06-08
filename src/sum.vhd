library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.std_logic_unsigned.all; 

entity sum is port (
    f: in std_logic_vector(17 downto 0);
    q: out std_logic_vector(5 downto 0)
);
end sum;

architecture arqsum of sum is
    signal a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17: std_logic_vector(5 downto 0);
begin
    a0 <= "00000" & f(0);
    a1 <= "00000" & f(1);
    a2 <= "00000" & f(2);
    a3 <= "00000" & f(3);
    a4 <= "00000" & f(4);
    a5 <= "00000" & f(5);
    a6 <= "00000" & f(6);
    a7 <= "00000" & f(7);
    a8 <= "00000" & f(8);
    a9 <= "00000" & f(9);
    a10 <= "00000" & f(10);
    a11 <= "00000" & f(11);
    a12 <= "00000" & f(12);
    a13 <= "00000" & f(13);
    a14 <= "00000" & f(14);
    a15 <= "00000" & f(15);
    a16 <= "00000" & f(16);
    a17 <= "00000" & f(17);

    q <= a0+ a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8 + a9 + a10 + a11 + a12 + a13 + a14 + a15 + a16 + a17;
end arqsum;
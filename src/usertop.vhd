library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.std_logic_signed.all;

entity usertop is port (
    CLOCK_50: in std_logic;
    CLK_500Hz: in std_logic;
    CLK_1Hz: in std_logic;
    RKEY: in std_logic_vector(3 downto 0);
    KEY: in std_logic_vector(3 downto 0);
    RSW: in std_logic_vector(17 downto 0);
    SW: in std_logic_vector(17 downto 0);
    LEDR: out std_logic_vector(17 downto 0);
    HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7: out std_logic_vector(6 downto 0)
);
end usertop;

architecture arqusertop of usertop is
    signal end_time, end_round, end_bonus, end_fpga, r1, e1, e2, e3, e4, e5, e6: std_logic;
    signal BTN: std_logic_vector(1 downto 0);

    component controlador is port (
        clock,reset,enter, end_fpga, end_bonus, end_time, end_round: in std_logic;
        r1, e1, e2, e3, e4, e5, e6: out std_logic 
    );
    end component;

    component datapath is port(
        sw_entra: in std_logic_vector(17 downto 0);
        r1, e1,e2,e3,e4,e5, e6, clk1, clk50, key_entra: in std_logic;
        h0, h1, h2, h3, h4, h5, h6, h7: out std_logic_vector(6 downto 0);
        led_out: out std_logic_vector (17 downto 0);
        end_time, end_bonus, end_round, end_FPGA: out std_logic
    );
    end component;

    component ButtonSync is port (
        KEY0, KEY1, CLK: in std_logic;
        BTN0, BTN1: out std_logic
    );
    end component;

begin
    botao: buttonsync port map (
        key(0), key(1), 
        CLK_500Hz, 
        BTN(0), BTN(1)
    );

    data: datapath port map (
        sw(17 downto 0), 
        r1,
        e1, e2, e3, e4, e5, e6, 
        clk_1hz, CLK_500Hz,
        BTN(1), 
        HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, 
        ledr(17 downto 0), 
        end_time, end_bonus, end_round, end_FPGA
    );

    control: controlador port map (
        CLK_500Hz, 
        BTN(0), BTN(1), 
        end_FPGA, end_bonus, end_time, end_round, 
        r1, 
        e1, e2, e3, e4, e5, e6
    );

end arqusertop;
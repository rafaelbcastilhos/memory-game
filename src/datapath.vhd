library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.std_logic_signed.all;

entity datapath is port(
    sw_entra: in std_logic_vector(17 downto 0);
    r1, e1, e2, e3, e4, e5, e6, clk1, clk50, key_entra: in std_logic;
    h0, h1, h2, h3, h4, h5, h6, h7: out std_logic_vector(6 downto 0);
    led_out: out std_logic_vector (17 downto 0);
    end_time, end_bonus, end_round, end_FPGA: out std_logic
);
end datapath;

architecture arqdata of datapath is
    signal out_end_time, out_end_bonus, out_end_round, out_end_FPGA, end_round_aux: std_logic; -- sinais de saida
    signal r1_or_e4, e3_and_not_key_entra: std_logic; -- expressoes de reset e enable
    signal SETUP: std_logic_vector(13 downto 0); -- saida do setup
    signal TIME_OUT, ROUND_OUT, concat_hex4: std_logic_vector(3 downto 0); -- saida do contador de tempo e round
    signal ROUND_BCD: std_logic_vector(7 downto 0); -- saida da conversao de bin para bcd
    signal SEQ1_OUT, SEQ2_OUT, SEQ3_OUT, SEQ4_OUT, SEQ_FPGA, seq_fpga_xor_sw_entra: std_logic_vector(17 downto 0); -- saida das sequencia, fpga e expressao xor
    signal SUM_BIT_BIT_OUT, BONUS_OUT: std_logic_vector(5 downto 0); -- saida de soma de bits da comparacao e saida do contador de bonus
    signal F_POINTS, U_POINTS: std_logic_vector(11 downto 0); -- & de pontos

    signal OUT_1_HEX7, OUT_2_HEX7: std_logic_vector(6 downto 0); -- saida mux2x1 hex7
    signal OUT_DEC_HEX6, OUT_1_HEX6, OUT_2_HEX6: std_logic_vector(6 downto 0); -- saida mux2x1 hex6
    signal OUT_1_HEX5, OUT_2_HEX5: std_logic_vector(6 downto 0); -- saida mux2x1 hex5
    signal OUT_DEC_HEX4, OUT_1_HEX4, OUT_2_HEX4: std_logic_vector(6 downto 0); -- saida mux2x1 e dec7seg hex4
    signal OUT_1_HEX3, OUT_2_HEX3: std_logic_vector(6 downto 0); -- saida mux2x1 hex3
    signal OUT_DEC1_HEX2, OUT_DEC2_HEX2, OUT_DEC3_HEX2, OUT_1_HEX2, OUT_2_HEX2: std_logic_vector(6 downto 0); -- saida mux2x1 e dec7seg hex2
    signal OUT_DEC1_HEX1, OUT_DEC2_HEX1, OUT_DEC3_HEX1, OUT_1_HEX1, OUT_2_HEX1: std_logic_vector(6 downto 0); -- saida mux2x1 e dec7seg hex1
    signal OUT_DEC1_HEX0, OUT_DEC2_HEX0, OUT_DEC3_HEX0, OUT_DEC4_HEX0, OUT_1_HEX0, OUT_2_HEX0: std_logic_vector(6 downto 0); -- saida mux2x1 e dec7seg hex0

    component regsetup is port (
        IN_REG_SETUP: in std_logic_vector(13 downto 0);
        R: in std_logic;
        E: in std_logic;
        CLK_500Hz: in std_logic;
        OUT_REG_SETUP: out std_logic_vector(13 downto 0)
    );
    end component;

    component sum is port (
        f: in std_logic_vector(17 downto 0);
        q: out std_logic_vector(5 downto 0)
    );
    end component;

    component dec7seg is port (
        bcd_in: in std_logic_vector(3 downto 0);
        out_7seg: out std_logic_vector(6 downto 0)
    );
    end component;

    component SEQ1 is port (
        address: in std_logic_vector(3 downto 0);
        data: out std_logic_vector(17 downto 0)
    );
    end component;

    component SEQ2 is port (
        address: in std_logic_vector(3 downto 0);
        data: out std_logic_vector(17 downto 0)
    );
    end component;

    component SEQ3 is port (
        address: in std_logic_vector(3 downto 0);
        data: out std_logic_vector(17 downto 0)
    );
    end component;

    component SEQ4 is port (
        address: in std_logic_vector(3 downto 0);
        data: out std_logic_vector(17 downto 0)
    );
    end component;

    component mux2to1_7b is port (
        w0, w1: in std_logic_vector(6 downto 0);
        s: in std_logic;
        f: out std_logic_vector(6 downto 0)
    );
    end component;

    component mux2to1_18b is port (
        w0, w1: in std_logic_vector(17 downto 0);
        s: in std_logic;
        f: out std_logic_vector(17 downto 0)
    );
    end component;

    component mux4to1 is port (
        w0, w1, w2, w3: in std_logic_vector(17 downto 0);
        s: in std_logic_vector(1 downto 0);
        f: out std_logic_vector(17 downto 0)
    );
    end component;

    component decBCD is port (
        bin_in: in std_logic_vector(3 downto 0);
        bcd_out: out std_logic_vector(7 downto 0)
    );
    end component;

    component counterlevel is port (
        IN_COUNTER_LEVEL: in std_logic_vector(3 downto 0);
        R, E, CLK_1Hz: in std_logic;
        OUT_END_FPGA: out std_logic
    );
    end component;

    component countertime is port (
        IN_COUNTER_TIME: in std_logic_vector(3 downto 0);
        R, E, CLK_1Hz: in std_logic;
        OUT_END_TIME: out std_logic;
        OUT_COUNTER_TIME: out std_logic_vector(3 downto 0)
    );
    end component;

    component counterround is port (
        IN_COUNTER_ROUND: in std_logic_vector(3 downto 0);
        IN_SET_SETUP_ROUND: in std_logic_vector(3 downto 0);
        SET, E, CLK_500Hz: in std_logic;
        OUT_END_ROUND: out std_logic;
        OUT_COUNTER_ROUND: out std_logic_vector(3 downto 0)
    );
    end component;

    component counterbonus is port (
        IN_COUNTER_BONUS: in std_logic_vector(5 downto 0);
        IN_SET_SETUP_BONUS: in std_logic_vector(3 downto 0);
        SET, E, CLK_500Hz: in std_logic;
        OUT_END_BONUS: out std_logic;
        OUT_COUNTER_BONUS: out std_logic_vector(5 downto 0)
    );
    end component;

begin
    -- port map para registrador setup
    REG_setup: regsetup port map(sw_entra(13 downto 0), r1, e1, clk50, SETUP);
    r1_or_e4 <= r1 or e4;

    -- port map para contador de level
    Counter_level: counterlevel port map(SETUP(9 downto 6), r1_or_e4, e2, clk1, out_end_FPGA);

    -- port map para contador de tempo
    Counter_time: countertime port map("1010", r1_or_e4, e3, clk1, out_end_time, TIME_OUT);

    -- port map para contador de rodada
    Counter_round: counterround port map("0000", SETUP(3 downto 0), e1, e4, clk50, out_end_round, ROUND_OUT);

    dec4binx8bcd: decBCD port map(ROUND_OUT, ROUND_BCD);

    -- map ports para sequencias
    SEQ_1: SEQ1 port map(ROUND_OUT, SEQ1_OUT);
    SEQ_2: SEQ2 port map(ROUND_OUT, SEQ2_OUT);
    SEQ_3: SEQ3 port map(ROUND_OUT, SEQ3_OUT);
    SEQ_4: SEQ4 port map(ROUND_OUT, SEQ4_OUT);

    -- port map para escolher qual sequencia
    MUX4x1: mux4to1 port map(SEQ1_OUT, SEQ2_OUT, SEQ3_OUT, SEQ4_OUT, SETUP(5 downto 4), SEQ_FPGA);

    -- operacao para encontrar diferencas entre sequencia da FPGA e entrada do usuario
    seq_fpga_xor_sw_entra <= SEQ_FPGA xor sw_entra;

    -- port map para soma de bits de erros
    SUM_BIT_BIT: sum port map(seq_fpga_xor_sw_entra, SUM_BIT_BIT_OUT);

    e3_and_not_key_entra <= e3 and (not key_entra);

    -- port map para contador de bonus
    Counter_bonus: counterbonus port map(SUM_BIT_BIT_OUT, SETUP(13 downto 10), e1, e3_and_not_key_entra, clk50, out_end_bonus, BONUS_OUT);

    F_POINTS <= "00" & ROUND_OUT & (not BONUS_OUT);
    U_POINTS <= "00" & (not ROUND_OUT) & BONUS_OUT;

    -- status
    end_time <= out_end_time;
    end_bonus <= out_end_bonus;
    end_FPGA <= out_end_FPGA;
    end_round <= out_end_round; 
    end_round_aux <= out_end_round;

    -- ledr
    mux2x1_18_ledr: mux2to1_18b port map("000000000000000000", SEQ_FPGA, e2, led_out);

    -- hex7
    mux2x1_7_hex7_1: mux2to1_7b port map("1000111", "0101111", e5, OUT_1_HEX7);
    mux2x1_7_hex7_2: mux2to1_7b port map("0001110", "1000001", end_round_aux, OUT_2_HEX7);
    mux2x1_7_hex7_3: mux2to1_7b port map(OUT_1_HEX7, OUT_2_HEX7, e6, h7);

    -- hex6
    decod7seg_hex_6: dec7seg port map(SETUP(9 downto 6), OUT_DEC_HEX6);
    mux2x1_7_hex6_1: mux2to1_7b port map(OUT_DEC_HEX6, "0100011", e5, OUT_1_HEX6);
    mux2x1_7_hex6_2: mux2to1_7b port map("0001100", "0010010", end_round_aux, OUT_2_HEX6);
    mux2x1_7_hex6_3: mux2to1_7b port map(OUT_1_HEX6, OUT_2_HEX6, e6, h6);

    -- hex5
    mux2x1_7_hex5_1: mux2to1_7b port map("1110001", "1100011", e5, OUT_1_HEX5);
    mux2x1_7_hex5_2: mux2to1_7b port map("0010000", "0000110", end_round_aux, OUT_2_HEX5);
    mux2x1_7_hex5_3: mux2to1_7b port map(OUT_1_HEX5, OUT_2_HEX5, e6, h5);

    -- hex4
    concat_hex4 <= "00" & SETUP(5 downto 4);
    decod7seg_hex_4: dec7seg port map(concat_hex4, OUT_DEC_HEX4);
    mux2x1_7_hex4_1: mux2to1_7b port map(OUT_DEC_HEX4, "0101011", e5, OUT_1_HEX4);
    mux2x1_7_hex4_2: mux2to1_7b port map("0001000", "0101111", end_round_aux, OUT_2_HEX4);
    mux2x1_7_hex4_3: mux2to1_7b port map(OUT_1_HEX4, OUT_2_HEX4, e6, h4);

    -- hex3
    mux2x1_7_hex3_1: mux2to1_7b port map("0000111", "0100001", e5, OUT_1_HEX3);
    mux2x1_7_hex3_2: mux2to1_7b port map("0110111", "0110111", end_round_aux, OUT_2_HEX3);
    mux2x1_7_hex3_3: mux2to1_7b port map(OUT_1_HEX3, OUT_2_HEX3, e6, h3);

    -- hex2
    decod7seg_1_hex_2: dec7seg port map(TIME_OUT, OUT_DEC1_HEX2);
    mux2x1_7_hex2_1: mux2to1_7b port map(OUT_DEC1_HEX2, "0110111", e5, OUT_1_HEX2);

    decod7seg_2_hex_2: dec7seg port map(F_POINTS(11 downto 8), OUT_DEC2_HEX2);
    decod7seg_3_hex_2: dec7seg port map(U_POINTS(11 downto 8), OUT_DEC3_HEX2);
    mux2x1_7_hex2_2: mux2to1_7b port map(OUT_DEC2_HEX2, OUT_DEC3_HEX2, end_round_aux, OUT_2_HEX2);

    mux2x1_7_hex2_3: mux2to1_7b port map(OUT_1_HEX2, OUT_2_HEX2, e6, h2);

    -- hex1
    decod7seg_1_hex_1: dec7seg port map(ROUND_BCD(7 downto 4), OUT_DEC1_HEX1);
    mux2x1_7_hex1_1: mux2to1_7b port map("0000011", OUT_DEC1_HEX1, e5, OUT_1_HEX1);

    decod7seg_2_hex_1: dec7seg port map(F_POINTS(7 downto 4), OUT_DEC2_HEX1);
    decod7seg_3_hex_1: dec7seg port map(U_POINTS(7 downto 4), OUT_DEC3_HEX1);
    mux2x1_7_hex1_2: mux2to1_7b port map(OUT_DEC2_HEX1, OUT_DEC3_HEX1, end_round_aux, OUT_2_HEX1);

    mux2x1_7_hex1_3: mux2to1_7b port map(OUT_1_HEX1, OUT_2_HEX1, e6, h1);

    -- hex0
    decod7seg_1_hex_0: dec7seg port map(BONUS_OUT(3 downto 0), OUT_DEC1_HEX0);
    decod7seg_2_hex_0: dec7seg port map(ROUND_BCD(3 downto 0), OUT_DEC2_HEX0);
    mux2x1_7_hex0_1: mux2to1_7b port map(OUT_DEC1_HEX0, OUT_DEC2_HEX0, e5, OUT_1_HEX0);

    decod7seg_3_hex_0: dec7seg port map(F_POINTS(3 downto 0), OUT_DEC3_HEX0);
    decod7seg_4_hex_0: dec7seg port map(U_POINTS(3 downto 0), OUT_DEC4_HEX0);
    mux2x1_7_hex0_2: mux2to1_7b port map(OUT_DEC3_HEX0, OUT_DEC4_HEX0, end_round_aux, OUT_2_HEX0);

    mux2x1_7_hex0_3: mux2to1_7b port map(OUT_1_HEX0, OUT_2_HEX0, e6, h0);
end arqdata;

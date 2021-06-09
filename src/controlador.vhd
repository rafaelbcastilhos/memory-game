library ieee;
use ieee.std_logic_1164.all;

entity controlador is port (
    clock, reset, enter, end_fpga, end_bonus, end_time, end_round: in std_logic;
    r1, e1, e2, e3, e4, e5, e6: out std_logic 
);
end controlador;

architecture fsmcontrolador of controlador is
    type STATES is (start, setup, play_fpga, play_user, check, result, next_round, wait1);
    signal EAtual, PEstado: STATES;
begin
    process(clock, reset)
	begin
        if (reset = '0') then
            EAtual <= start;
        elsif (clock'event AND clock = '1') then 
            EAtual <= PEstado;
        end if;
	end process;

    process(EAtual, enter, end_fpga, end_bonus, end_time, end_round)
			begin
				case EAtual is 
                    when start =>
                    -- reseta 
                    -- mostra displays com L(level), J(jogo), t(tempo), b(bonus)
                    -- leds apagados
                    -- proximo estado: setup
                        r1 <= '1';
                        e1 <= '1';
                        e2 <= '0';
                        e3 <= '0';
                        e4 <= '0';
                        e5 <= '0';
                        e6 <= '0';
						PEstado <= setup;
					when setup =>
                    -- ativa registrador do setup
                    -- le entrada sw(13..0)
                    -- mostra displays com L(level), J(jogo), t(tempo), b(bonus)
                    -- leds apagados
                    -- proximo estado: se clique de enter -> play_fpga
                        r1 <= '0';
                        e1 <= '1';
                        e2 <= '0';
                        e3 <= '0';
                        e4 <= '0';
                        e5 <= '0';
                        e6 <= '0';
                        if(enter = '0') then
                            PEstado <= play_fpga;
                        end if;
                    when play_fpga =>
                    -- leds acessos com a sequencia da fpga
                    -- com tempo definido no estado anterior sw(9..6)
                    -- mostra displays com L(level), J(jogo), t(tempo), b(bonus)
                    -- proximo estado: se end fpga -> play_user
                        r1 <= '0';
                        e1 <= '0';
                        e2 <= '1';
                        e3 <= '0';
                        e4 <= '0';
                        e5 <= '0';
                        e6 <= '0';
                        if(end_fpga = '1') then
                            PEstado <= play_user;
                        end if;
                    when play_user =>
                    -- le tentativa em sw(17..0)
                    -- mostra displays com L(level), J(jogo), t(tempo), b(bonus)
                    -- leds apagados
                    -- proximo estado: se clique de enter -> check. se end time -> result
                        r1 <= '0';
                        e1 <= '0';
                        e2 <= '0';
                        e3 <= '1';
                        e4 <= '0';
                        e5 <= '0';
                        e6 <= '0';
                        if(enter = '0') then
                            PEstado <= check;
                        elsif(end_time = '1') then
                            PEstado <= result;
                        end if;
                    when check =>
                    -- avalia em quantas posicoes o usuario errou na replicacao
                    -- mostra displays com L(level), J(jogo), t(tempo), b(bonus)
                    -- leds apagados
                    -- proximo estado: se end bonus -> result. se end round -> result. se nao -> next_round
                        r1 <= '0';
                        e1 <= '0';
                        e2 <= '0';
                        e3 <= '1';
                        e4 <= '0';
                        e5 <= '0';
                        e6 <= '0';
                        if(end_bonus = '1') then
                            PEstado <= result;
                        elsif(end_round = '1') then
                            PEstado <= result;
                        else
                            PEstado <= next_round;
                        end if;
                    when next_round =>
                    -- conta rodada
                    -- mostra displays com L(level), J(jogo), t(tempo), b(bonus)
                    -- leds apagados
                    -- proximo estado: wait
                        r1 <= '0';
                        e1 <= '0';
                        e2 <= '0';
                        e3 <= '0';
                        e4 <= '1';
                        e5 <= '0';
                        e6 <= '0';
                        PEstado <= wait1;
                    when wait1 =>
                    -- mostra displays com round= e o valor da rodada
                    -- leds apagados
                    -- reset da contagem da fpga e tempo da tentativa do usuario
                    -- proximo estado: se clique de enter -> play_fpga
                        r1 <= '0';
                        e1 <= '0';
                        e2 <= '0';
                        e3 <= '0';
                        e4 <= '0';
                        e5 <= '1';
                        e6 <= '0';
                        if(enter = '0') then
                            PEstado <= play_fpga;
                        end if;
                    when result =>
                    -- dependendo do vencedor mostra displays com USEr= ou FPgA= e a pontuacao final
                    -- leds apagados
                    -- proximo estado: se clique de enter -> start
                        r1 <= '0';
                        e1 <= '0';
                        e2 <= '0';
                        e3 <= '0';
                        e4 <= '0';
                        e5 <= '0';
                        e6 <= '1';
                        if(enter = '0') then
                            PEstado <= start;
                        end if;
                end case;
    end process;

end fsmcontrolador;
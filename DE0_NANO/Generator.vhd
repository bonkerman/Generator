library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Generator is
	Port ( 
			CLOCK_50 	: in STD_LOGIC;
--//////////// LED //////////
			LED			: out STD_LOGIC_VECTOR(7 DOWNTO 0);
--//////////// SW //////////
			KEY				: in STD_LOGIC_VECTOR(1 DOWNTO 0);
			SW           : in STD_LOGIC_VECTOR(3 DOWNTO 0);
			GPIO_2 : inout STD_LOGIC_VECTOR(11 DOWNTO 0)
											);
end entity;

architecture main of Generator is
	shared variable cnt: integer range 0 to 50000000  :=0;
	shared variable freq : integer range 0 to 50 :=1;
	signal dbnc, flag : std_logic;
	
	alias clk is CLOCK_50;
begin

	process(clk)
		begin
			if(rising_edge(clk)) then
				cnt := cnt + 1;
				if(dbnc = '0') then
					if(KEY="01" and freq/=50) then
						freq := freq + 1;
						dbnc <= '1';
					elsif(KEY="10" and freq/=1) then
						freq := freq - 1;
						dbnc <= '1';
					end if;
				end if;
				if(KEY="11") then
					dbnc <= '0';
					if(cnt = freq*(10000*conv_integer(SW))) then
						cnt := 0;
						if(flag = '0') then
							GPIO_2(0) <= '0';
							flag <= '1';
							LED <= (others => '0');
						elsif(flag = '1') then
							GPIO_2(0) <= '1';
							flag <= '0';
							LED <= conv_std_logic_vector(freq, LED'length);
						end if;
					end if;
				end if;
			end if;
	end process;
end main;
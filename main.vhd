--------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Entity my_fsm is
	Port (T, L, CLK, RESET : in std_logic;-- T is Temperture , L is Light ,CLK is clock for check state
		 -- RESET for return to ST0
	      M : in std_logic_vector (2 downto 0);-- M is Moisture 0-7
              Y : out std_logic_vector(1 downto 0);-- is out put for displyes st0,st1,st2  
         anodes : out STD_LOGIC_VECTOR (3 downto 0);
       segments : out STD_LOGIC_VECTOR (7 downto 0);
             Z1 : out std_logic;-- is out put for displyes st0,st1,st2  
	   MOIS : out std_logic_vector (2 downto 0);-- Relatad outpust to Moisture
	   TEMP : out std_logic;--Relatad outpust to Temperture
	  LIGHT : out std_logic);--Relatad outpust to Light
End my_fsm;


Architecture fsm of my_fsm is

component Seg7 
    port (ABCD : in std_logic_vector (3 downto 0);
          AN : out std_logic_vector (3 downto 0);
          segment7 : out std_logic_vector (7 downto 0));
end component;


	Type state_type is (ST0, ST1);-- first N then P then convert to binary and => Y (to be Synthesized)
	Signal PS, NS : state_type;
	Signal X : std_logic_vector (3 downto 0);-- State of 7-segment (4 bits to cover different modes) It could be done with two
Begin

sseg7 : Seg7
port map (ABCD => X,
          AN => anodes,
          segment7 => segments);

	sync_proc : process(CLK, NS, RESET)
	Begin
		if (RESET = '1') then PS <= ST0;
		Elsif (rising_edge(CLK)) then PS <= NS;
		End if;
	End process sync_proc;


Comb_proc: process(PS, T, L, M)
Begin
		Z1 <= '0';
		Case PS is
			When ST0 => 
				If (T = '1' or L = '1') and (M <= "001") then NS <= ST1; Z1 <= '1'; X <= "1111"; MOIS <= M; TEMP <= T; LIGHT <= L;------F
				Elsif (T = '0' and L = '0') and (M <= "011") then NS <= ST1; Z1 <= '1'; X <= "1111"; MOIS <= M; TEMP <= T; LIGHT <= L;--S
				Else NS <= ST0; Z1 <= '0'; X <= "0000"; MOIS <= M; TEMP <= T; LIGHT <= L;-----------------------------------------------M
				end if;-----------------------------------------------------------------------------------------------------------------
			When ST1 =>---------------------------------------------------------------------------------------------------------------------M
				If (M >= "111") then NS <= ST0; Z1 <= '0'; X <= "0000"; MOIS <= M; TEMP <= T; LIGHT <= L;-------------------------------A
				elsif (M >= "011") and (T = '1' or L = '1') then NS <= ST0; Z1 <= '0'; X <= "0000"; MOIS <= M; TEMP <= T; LIGHT <= L;---S
				Else NS <= ST1; Z1 <= '1'; X <= "1111"; MOIS <= M; TEMP <= T; LIGHT <= L;-----------------------------------------------H
				end if;-----------------------------------------------------------------------------------------------------------------I
			when others =>------------------------------------------------------------------------------------------------------------------N
				Z1 <= '0'; NS <= ST0; X <= "0000"; MOIS <= M; TEMP <= T; LIGHT <= L;----------------------------------------------------
		End case;
End process comb_proc;


With PS select
		Y <= "00" when ST0,
	         "01" when ST1,
	         "11" when others;
End fsm;
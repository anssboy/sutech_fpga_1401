-----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Seg7 is
    Port ( ABCD: in STD_LOGIC_VECTOR (3 downto 0);-- two of bits could be defined,bat this case not all seven-segment modes were used in other project.
           AN: out STD_LOGIC_VECTOR (3 downto 0);   -- anodes for 7seg
           segment7 : out STD_LOGIC_VECTOR (7 downto 0) -- outputs as a bus/bundle // -- ABCDEFG and DP (RIGHT to LEFT)
          ); 
end Seg7;
architecture Behavioral of Seg7 is
begin
 myproc: process (ABCD)
    begin
               if (ABCD = "1111") then     -- Water state, that X = 1
                   AN <="1110";    -- 1st anode turned on
                   segment7 <= "10001001";  -- Displays 'H' for water
          
               else           
                   AN <= "1110"; -- No water state
                   segment7 <= "10111111"; -- Displays '-' for no water 
                       
               end if;
    end process;     
end Behavioral;
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock is 
port(CLK: inout std_logic);
end clock;
    
    
    architecture imp of clock is
        begin
            process
                begin 
                    clk <= not clk;
                    wait for 50 ns; --------change value after half period
            
        end process;
    end imp;

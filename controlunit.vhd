library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use IEEE.std_logic_arith.all;
use IEEE.numeric_bit.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_unsigned.all;
use IEEE.math_real.all;
use IEEE.math_complex.all;

entity controller is port(
   clk3           :     in std_logic;
   reset          :     in std_logic;
   IR             :     in std_logic_vector(4 downto 0);
   int            :     in std_logic;
   zero           :     in std_logic;
   inta           :     out std_logic;
   WR             :     out std_logic;
   RD             :     out std_logic;
   opfetch        :     out std_logic;
   pcen           :     out std_logic;
   den1           :     out std_logic;
   den2           :     out std_logic;
   aen            :     out std_logic;
   SPload         :     out std_logic;
   PCload         :     out std_logic;
   IRload         :     out std_logic;
   Psel           :     out std_logic_vector(1 downto 0);
   Ssel           :     out std_logic_vector(1 downto 0);
   ALUsel         :     out std_logic_vector(4 downto 0);
   Rsel           :     out std_logic_vector(1 downto 0);
   sub2           :     out std_logic;
   jmpMux         :     out std_logic;
   we             :     out std_logic;
   rbe            :     out std_logic;
   rae            :     out std_logic
);
   
   end controller;
   
   architecture imp of controller is
     component zerobuf is port(
	clk1: in std_logic;
	reset: in std_logic;
	input : in std_logic;
	output: out std_logic;
	enable: in std_logic
     );
     end component;

      type state_type is (
           s_start,
           s_fetch,
           s_decode,
           s_mov,
           s_add,
           s_sub,
           s_andd,
           s_orr,
           s_nott,
           s_inc,
           s_dec,
           s_sr,
           s_sl,
           s_rr,
           s_clear,
           s_jmp,
           s_jz,
           s_jnz,
           s_call,
           s_ret,
           s_nop,
           s_halt,
	   s_push,
           s_pop,
           s_write,
           s_read,
           s_movi,
           s_wait1,
           s_wait2,
           s_wait3);
           
    signal state:   state_type :=s_start;

signal zero_enable : std_logic;
signal zero_output : std_logic;
    
    begin
    zero_buffer: zerobuf port map(clk1=>clk3, reset=>reset, input=>zero, output=>zero_output,enable=>zero_enable  );
    NEXT_STATE_LOGIC: process(clk3, reset)
       begin

           if(reset ='1') then
               state <= s_start;
            elsif(clk3'event and clk3='1') then
                
                case state is
                    
                    when s_start => state <= s_fetch;
                    when s_fetch => state <= s_decode;
                    when s_decode => 
		    	if(int = '0') then                        
                        case IR(4 downto 0) is
                            when "00000" => state <= s_mov;
                            when "00001" => state <= s_add;
                            when "00010" => state <= s_sub;
                            when "00011" => state <= s_andd;
                            when "00100" => state <= s_orr;
                            when "00101" => state <= s_nott;
                            when "00110" => state <= s_inc;
                            when "00111" => state <= s_dec; 
                            when "01000" => state <= s_sr;
                            when "01001" => state <= s_sl;
                            when "01010" => state <= s_rr;
                            when "01011" => state <= s_clear;
                            when "01100" => state <= s_jmp;
                            when "01101" => if(zero_output = '1') then state <= s_jz;
											elsif(zero_output = '0') then state <= s_nop; --16/12/2016 uras hoca diyor ki bu olur .
											end if;
							
                            when "01110" =>if(zero_output = '0') then state <= s_jnz;
											elsif(zero_output = '1') then state <= s_nop; --16/12/2016 uras hoca diyor ki bu olur .
											end if;
								
                            when "01111" => state <= s_call;
                            when "10000" => state <= s_ret;
                            when "10001" => state <= s_nop;
                            when "10010" => state <= s_halt;
                            when "10011" => state <= s_push;
                            when "10100" => state <= s_pop;
                            when "10101" => state <= s_write;
                            when "10110" => state <= s_read;
                            when "10111" => state <= s_movi;
                            when others => state <= s_start;
                       end case;

			elsif (int = '1') then
				state <= s_call;
			end if;

		    when s_halt => state <= s_halt;
		    when s_nop => state <= s_fetch;
                    when s_wait2 => state <= s_fetch;
                    when others => state <= s_fetch;
               end case;
          end if;
      end process; 
      
    OUTPUT_LOGIC: process(state) 
    begin
    case state is
          when s_start =>
             inta       <= 'X';
             WR         <= 'X';
             RD         <= 'X';
             opfetch    <= 'X';
             pcen       <= '0';
             den1       <= '0';
             den2       <= '0';
             aen        <= '0';
             SPload     <= '0';
             PCload     <= '0';
             IRload     <= '0';
             Psel       <= "10";
             Ssel       <= "XX";
             ALUsel     <= "XXXXX";
             Rsel       <= "XX";
             sub2       <= 'X';
             jmpMux     <= 'X';
             we         <= '0';
             rbe        <= '0';
             rae        <= '0';
	     zero_enable <= '0';
                     

         when s_fetch =>
             inta       <= 'X';
             WR         <= 'X';
             RD         <= 'X';
             opfetch    <= '1';
             pcen       <= '0';
             den1       <= '1';
             den2       <= '0';
             aen        <= '1';
             SPload     <= '0';
             PCload     <= '1';
             IRload     <= '0';
             Psel       <= "10";
             Ssel       <= "01";
             ALUsel     <= "XXXXX";
             Rsel       <= "XX";
             sub2       <= '0';
             jmpMux     <= '0';
             we         <= '0';
             rbe        <= '0';
             rae        <= '0';
	     zero_enable <= '0';
             
         when s_decode =>
             inta       <= 'X';
             WR         <= 'X';
             RD         <= 'X';
             opfetch    <= '1';
             pcen       <= '0';
             den1       <= '1';
             den2       <= '0';
             aen        <= '0';
             SPload     <= '0';
             PCload     <= '0';
             IRload     <= '1';
             Psel       <= "10";
             Ssel       <= "01";
             ALUsel     <= "00000";
             Rsel       <= "XX";
             sub2       <= '0';
             jmpMux     <= '0';
             we         <= '0';
             rbe        <= '0';
             rae        <= '0'; 
	     zero_enable <= '0';
             
         when s_mov =>
             inta       <= 'X';
             WR         <= 'X';
             RD         <= 'X';
             opfetch    <= '0';
             pcen       <= '0';
             den1       <= '1';
             den2       <= '0';
             aen        <= '0';
             SPload     <= '0';
             PCload     <= '0';
             IRload     <= '0';
             Psel       <= "10";
             Ssel       <= "01";
             ALUsel     <= "00000";
             Rsel       <= "10";
             sub2       <= 'X';
             jmpMux     <= '0';
             we         <= '1';
             rbe        <= '0';
             rae        <= '1';
	     zero_enable <= '1';  

		 when s_add =>
             inta       <= 'X';
             WR         <= 'X';
             RD         <= 'X';
             opfetch    <= '0';
             pcen       <= '0';
             den1       <= '0';
             den2       <= '0';
             aen        <= '0';
             SPload     <= '0';
             PCload     <= '0';
             IRload     <= '0';
             Psel       <= "10";
             Ssel       <= "01";
             ALUsel     <= "00100";
             Rsel       <= "10";
             sub2       <= 'X';
             jmpMux     <= '0';
             we         <= '1';
             rbe        <= '1';
             rae        <= '1';	
	     zero_enable <= '1'; 

		when s_sub =>
             inta       <= 'X';
             WR         <= 'X';
             RD         <= 'X';
             opfetch    <= '0';
             pcen       <= '0';
             den1       <= '0';
             den2       <= '0';
             aen        <= '0';
             SPload     <= '0';
             PCload     <= '0';
             IRload     <= '0';
             Psel       <= "10";
             Ssel       <= "01";
             ALUsel     <= "00101";
             Rsel       <= "10";
             sub2       <= 'X';
             jmpMux     <= '0';
             we         <= '1';
             rbe        <= '1';
             rae        <= '1';	
	     zero_enable <= '1';  

		when s_andd =>
             inta       <= 'X';
             WR         <= 'X';
             RD         <= 'X';
             opfetch    <= '0';
             pcen       <= '0';
             den1       <= '0';
             den2       <= '0';
             aen        <= '0';
             SPload     <= '0';
             PCload     <= '0';
             IRload     <= '0';
             Psel       <= "10";
             Ssel       <= "01";
             ALUsel     <= "00001";
             Rsel       <= "10";
             sub2       <= 'X';
             jmpMux     <= '0';
             we         <= '1';
             rbe        <= '1';
             rae        <= '1';		
	     zero_enable <= '1'; 

		when s_orr =>
             inta       <= 'X';
             WR         <= 'X';
             RD         <= 'X';
             opfetch    <= '0';
             pcen       <= '0';
             den1       <= '0';
             den2       <= '0';
             aen        <= '0';
             SPload     <= '0';
             PCload     <= '0';
             IRload     <= '0';
             Psel       <= "10";
             Ssel       <= "01";
             ALUsel     <= "00010";
             Rsel       <= "10";
             sub2       <= 'X';
             jmpMux     <= '0';
             we         <= '1';
             rbe        <= '1';
             rae        <= '1';	
	     zero_enable <= '1'; 
		
			 
		when s_nott =>
             inta       <= 'X';
             WR         <= 'X';
             RD         <= 'X';
             opfetch    <= '0';
             pcen       <= '0';
             den1       <= '1';
             den2       <= '0';
             aen        <= '0';
             SPload     <= '0';
             PCload     <= '0';
             IRload     <= '0';
             Psel       <= "10";
             Ssel       <= "01";
             ALUsel     <= "00011";
             Rsel       <= "10";
             sub2       <= 'X';
             jmpMux     <= '0';
             we         <= '1';
             rbe        <= '0';
             rae        <= '1';	
	     zero_enable <= '1'; 
			 
		when s_inc =>
             inta       <= 'X';
             WR         <= 'X';
             RD         <= 'X';
             opfetch    <= '0';
             pcen       <= '0';
             den1       <= '1';
             den2       <= '0';
             aen        <= '0';
             SPload     <= '0';
             PCload     <= '0';
             IRload     <= '0';
             Psel       <= "10";
             Ssel       <= "01";
             ALUsel     <= "00110";
             Rsel       <= "10";
             sub2       <= 'X';
             jmpMux     <= '0';
             we         <= '1';
             rbe        <= '0';
             rae        <= '1';	
	     zero_enable <= '1'; 
			 
		when s_dec =>
             inta       <= 'X';
             WR         <= 'X';
             RD         <= 'X';
             opfetch    <= '0';
             pcen       <= '0';
             den1       <= '1';
             den2       <= '0';
             aen        <= '0';
             SPload     <= '0';
             PCload     <= '0';
             IRload     <= '0';
             Psel       <= "10";
             Ssel       <= "01";
             ALUsel     <= "00111";
             Rsel       <= "10";
             sub2       <= 'X';
             jmpMux     <= '0';
             we         <= '1';
             rbe        <= '0';
             rae        <= '1';	
	     zero_enable <= '1'; 
			 
		when s_sr =>
             inta       <= 'X';
             WR         <= 'X';
             RD         <= 'X';
             opfetch    <= '0';
             pcen       <= '0';
             den1       <= '1';
             den2       <= '0';
             aen        <= '0';
             SPload     <= '0';
             PCload     <= '0';
             IRload     <= '0';
             Psel       <= "10";
             Ssel       <= "01";
             ALUsel     <= "10000";
             Rsel       <= "10";
             sub2       <= 'X';
             jmpMux     <= '0';
             we         <= '1';
             rbe        <= '0';
             rae        <= '1';	
	     zero_enable <= '1';  
			 
		when s_sl =>
             inta       <= 'X';
             WR         <= 'X';
             RD         <= 'X';
             opfetch    <= '0';
             pcen       <= '0';
             den1       <= '1';
             den2       <= '0';
             aen        <= '0';
             SPload     <= '0';
             PCload     <= '0';
             IRload     <= '0';
             Psel       <= "10";
             Ssel       <= "01";
             ALUsel     <= "01000";
             Rsel       <= "10";
             sub2       <= 'X';
             jmpMux     <= '0';
             we         <= '1';
             rbe        <= '0';
             rae        <= '1';	
	     zero_enable <= '1'; 
			 
		when s_rr =>
             inta       <= 'X';
             WR         <= 'X';
             RD         <= 'X';
             opfetch    <= '0';
             pcen       <= '0';
             den1       <= '1';
             den2       <= '0';
             aen        <= '0';
             SPload     <= '0';
             PCload     <= '0';
             IRload     <= '0';
             Psel       <= "10";
             Ssel       <= "01";
             ALUsel     <= "11000";
             Rsel       <= "10";
             sub2       <= 'X';
             jmpMux     <= '0';
             we         <= '1';
             rbe        <= '0';
             rae        <= '1';	
	     zero_enable <= '1'; 
			 
		when s_clear =>
             inta       <= 'X';
             WR         <= 'X';
             RD         <= 'X';
             opfetch    <= '0';
             pcen       <= '0';
             den1       <= '1';
             den2       <= '0';
             aen        <= '0';
             SPload     <= '0';
             PCload     <= '0';
             IRload     <= '0';
             Psel       <= "10";
             Ssel       <= "01";
             ALUsel     <= "00000";	
             Rsel       <= "01";
             sub2       <= 'X';
             jmpMux     <= '0';
             we         <= '1';
             rbe        <= '0';
             rae        <= '0';	
	     zero_enable <= '1'; 
			 
		when s_jmp =>
             inta       <= 'X';
             WR         <= 'X';
             RD         <= 'X';
             opfetch    <= '0';
             pcen       <= '0';
             den1       <= '1';
             den2       <= '0';
             aen        <= '0';
             SPload     <= '0';
             PCload     <= '0';
             IRload     <= '0';
             Psel       <= "10";
             Ssel       <= "01";
             ALUsel     <= "00000";	
             Rsel       <= "XX";
             sub2       <= 'X';
             jmpMux     <= '1';
             we         <= '0';
             rbe        <= '0';
             rae        <= '0';	
	     zero_enable <= '1'; 
			 
		when s_jz =>
             inta       <= 'X';
             WR         <= 'X';
             RD         <= 'X';
             opfetch    <= '0';
             pcen       <= '0';
             den1       <= '1';
             den2       <= '0';
             aen        <= '0';
             SPload     <= '0';
             PCload     <= '0';
             IRload     <= '0';
             Psel       <= "10";
             Ssel       <= "01";
             ALUsel     <= "00000";	
             Rsel       <= "XX";
             sub2       <= 'X';
             jmpMux     <= '1';
             we         <= '0';
             rbe        <= '0';
             rae        <= '0';	
	     zero_enable <= '1'; 
			 
		when s_jnz =>
             inta       <= 'X';
             WR         <= 'X';
             RD         <= 'X';
             opfetch    <= '0';
             pcen       <= '0';
             den1       <= '1';
             den2       <= '0';
             aen        <= '0';
             SPload     <= '0';
             PCload     <= '0';
             IRload     <= '0';
             Psel       <= "10";
             Ssel       <= "01";
             ALUsel     <= "00000";	
             Rsel       <= "XX";
             sub2       <= 'X';
             jmpMux     <= '1';
             we         <= '0';
             rbe        <= '0';
             rae        <= '0';	
	     zero_enable <= '1'; 

		when s_call =>
             inta       <= 'X';
             WR         <= '1';
             RD         <= '0';
             opfetch    <= '0';
             pcen       <= '1';
             den1       <= '0';
             den2       <= '0';
             aen        <= '1';
             SPload     <= '1';
             PCload     <= '0';
             IRload     <= '0';
             Psel       <= "10";
             Ssel       <= "10";
             ALUsel     <= "XXXXX";	
             Rsel       <= "XX";
             sub2       <= '0';--cikarma
             jmpMux     <= '1';
             we         <= '0';
             rbe        <= '0';
             rae        <= '0';	
	     zero_enable <= '1'; 

		when s_ret =>
             inta        <= 'X';
             WR          <= '0';
             RD          <= '1';
             opfetch     <= '0';
             pcen        <= '0';
             den1        <= '1';
             den2        <= '0';
             aen         <= '1';
             SPload      <= '1';
             PCload      <= '0';
             IRload      <= '0';
             Psel        <= "01";
             Ssel        <= "10";
             ALUsel      <= "XXXXX";	
             Rsel        <= "XX";
             sub2        <= '1';--toplama
             jmpMux      <= '0';
             we          <= '0';
             rbe         <= '0';
             rae         <= '0';	
	     zero_enable <= '1'; 

		when s_nop =>
             inta       <= 'X';
             WR         <= 'X';
             RD         <= 'X';
             opfetch    <= '0';
             pcen       <= '0';
             den1       <= '0';
             den2       <= '1';
             aen        <= '0';
             SPload     <= '0';
             PCload     <= '0';
             IRload     <= '0';
             Psel       <= "10";
             Ssel       <= "01";
             ALUsel     <= "00000";	
             Rsel       <= "XX";
             sub2       <= 'X';
             jmpMux     <= '0';
             we         <= '0';
             rbe        <= '0';
             rae        <= '0';	
	     zero_enable <= '1'; 

		when s_halt =>
             inta       <= 'X';
             WR         <= 'X';
             RD         <= 'X';
             opfetch    <= 'X';
             pcen       <= 'X';
             den1       <= 'X';
             den2       <= 'X';
             aen        <= 'X';
             SPload     <= 'X';
             PCload     <= 'X';
             IRload     <= 'X';
             Psel       <= "XX";
             Ssel       <= "XX";
             ALUsel     <= "XXXXX";	
             Rsel       <= "XX";
             sub2       <= 'X';
             jmpMux     <= 'X';
             we         <= 'X';
             rbe        <= 'X';
             rae        <= 'X';	
	     zero_enable <= '1'; 

		when s_push =>
             inta       <= 'X';
             WR         <= '1';
             RD         <= '0';
             opfetch    <= '0';
             pcen       <= '0';
             den1       <= '0';
             den2       <= '1';
             aen        <= '1';
             SPload     <= '1';
             PCload     <= '0';
             IRload     <= '0';
             Psel       <= "10";
             Ssel       <= "10";
             ALUsel     <= "XXXXX";
             Rsel       <= "11";
             sub2       <= '0';-- 0 cikarma yapar
             jmpMux     <= '0';
             we         <= '0';
             rbe        <= '1';
             rae        <= '0';
	     zero_enable <= '1';  

		when s_pop =>
             inta       <= 'X';
             WR         <= '0';
             RD         <= '1';
             opfetch    <= '0';
             pcen       <= '0';
             den1       <= '1';
             den2       <= '0';
             aen        <= '1';
             SPload     <= '1';
             PCload     <= '0';
             IRload     <= '0';
             Psel       <= "10";
             Ssel       <= "10";
             ALUsel     <= "00100";	
             Rsel       <= "01";
             sub2       <= '1';
             jmpMux     <= '0';
             we         <= '1';
             rbe        <= '0';
             rae        <= '0';	
	     zero_enable <= '1'; 
------------------------denenecek--------------------------
		when s_write =>
             inta       <= 'X';
             WR         <= '1';
             RD         <= '0';
             opfetch    <= '0';
             pcen       <= '0';
             den1       <= '0';
             den2       <= '1';
             aen        <= '1';
             SPload     <= '0';
             PCload     <= '0';
             IRload     <= '0';
             Psel       <= "10";
             Ssel       <= "00";
             ALUsel     <= "00000";	
             Rsel       <= "00";
             sub2       <= 'X';
             jmpMux     <= '0';
             we         <= '0';
             rbe        <= '1';
             rae        <= '1';	
	     zero_enable <= '1'; 

		when s_read =>
             inta       <= 'X';
             WR         <= '0';
             RD         <= '1';
             opfetch    <= '0';
             pcen       <= '0';
             den1       <= '1';
             den2       <= '0';
             aen        <= '1';
             SPload     <= '0';
             PCload     <= '0';
             IRload     <= '0';
             Psel       <= "10";
             Ssel       <= "00";
             ALUsel     <= "00000";	
             Rsel       <= "11";
             sub2       <= 'X';
             jmpMux     <= '0';
             we         <= '1';
             rbe        <= '0';
             rae        <= '1';	
	     zero_enable <= '1'; 
-----------------------movi yapildi---------------------------           
         when s_movi =>
             inta       <= '0';
             WR         <= '0';
             RD         <= '0';
             opfetch    <= '0';
             pcen       <= '0';
             den1       <= '1';
             den2       <= '0';
             aen        <= '0';
             SPload     <= '0';
             PCload     <= '0';
             IRload     <= '0';
             Psel       <= "10";
             Ssel       <= "01";
             ALUsel     <= "00000";
             Rsel       <= "00";
             sub2       <= 'X';
             jmpMux     <= '0';
             we         <= '1';
             rbe        <= '0';
             rae        <= '0';
	     zero_enable <= '1'; 
			 
		
              
              
                           
        when others => 
             inta       <= 'X';
             WR         <= 'X';
             RD         <= 'X';
             opfetch    <= 'X';
             pcen       <= 'X';
             den1       <= 'X';
             den2       <= 'X';
             aen        <= 'X';
             SPload     <= 'X';
             PCload     <= 'X';
             IRload     <= 'X';
             Psel       <= "XX";
             Ssel       <= "XX";
             ALUsel     <= "XXXXX";
             Rsel       <= "XX";
             sub2       <= 'X';
             jmpMux     <= 'X';
             we         <= 'X';
             rbe        <= 'X';
             rae        <= 'X';                        
   end case;
   end process;
 end imp;




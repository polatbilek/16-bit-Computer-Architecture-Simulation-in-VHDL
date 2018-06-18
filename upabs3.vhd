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
use work.opcodes.all;

entity upabs3 is port(
   clk9:       in std_logic;
   reset:      in std_logic;
   opfetch:    out std_logic;
   INT:        in std_logic;
   INTA:       out std_logic;
   WR:         out std_logic;
   RD:         out std_logic;
   A:          out std_logic_vector(15 downto 0);
   Datain:     in std_logic_vector(15 downto 0);
   Dataout:    out std_logic_vector(15 downto 0)
);
end upabs3;

   architecture imp of upabs3 is
component dataPath is port(
clk10 : in std_logic;
reset : in std_logic;

pcen: in std_logic;
den1: in std_logic;
den2: in std_logic;
aen: in std_logic;

SPload: in std_logic;
PCload : in std_logic;

Psel : in std_logic_vector(1 downto 0);
Ssel : in std_logic_vector(1 downto 0);
Rsel : in std_logic_vector(1 downto 0);

sub2: in std_logic;
jmpMux : in std_logic;
opfetch : out std_logic;

IR : out std_logic_vector (4 downto 0);
IRload : in std_logic;

zero: out std_logic;
ALUsel : in std_logic_vector (4 downto 0);

regWa : in std_logic_vector(2 downto 0);
regRaa: in std_logic_vector(2 downto 0);
regRba: in std_logic_vector(2 downto 0);
regWe : in std_logic;
regRbe : in std_logic;
regRae : in std_logic;

outDataBus: out std_logic_vector(15 downto 0);
inDataBus: in std_logic_vector(15 downto 0);
outAddressBus: out std_logic_vector(15 downto 0)
);
end component;

component controller is port(
   clk3           :     in std_logic;
   reset          :     in std_logic;
   IR             :     in std_logic_vector (4 downto 0);
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
   ALUsel         :     out std_logic_vector (4 downto 0);
   Rsel           :     out std_logic_vector(1 downto 0);
   sub2           :     out std_logic;
   jmpMux         :     out std_logic;
   we             :     out std_logic;
   rbe            :     out std_logic;
   rae            :     out std_logic
);
   
   end component;

signal ooutDataBus:  std_logic_vector(15 downto 0);
signal iinDataBus:  std_logic_vector(15 downto 0);
signal ooutAddressBus:  std_logic_vector(15 downto 0);
signal ppcen: std_logic;
signal dden1: std_logic;
signal dden2: std_logic;
signal aaen: std_logic;
signal SSPload: std_logic;
signal PPCload: std_logic;
signal PPsel : std_logic_vector(1 downto 0);
signal SSsel : std_logic_vector(1 downto 0);
signal RRsel : std_logic_vector(1 downto 0);
signal IIR: std_logic_vector(4 downto 0);
signal rregWa: std_logic_vector(2 downto 0);
signal rregRaa: std_logic_vector(2 downto 0);
signal rregRba: std_logic_vector(2 downto 0);
signal AALUsel: std_logic_vector(4 downto 0);
signal IIRload: std_logic;
signal zzero: std_logic;
signal rregWe: std_logic;
signal rregRbe: std_logic;
signal rregRae: std_logic;
signal ssub2: std_logic;
signal jjmpMux: std_logic;
signal oopfetch: std_logic;


   
   

   begin
       CU: controller port map(clk3=>clk9, reset=>reset,IR=>IIR,INT=>INT,zero=>zzero,INTA =>INTA,WR=>WR,RD=>RD,opfetch=>oopfetch,pcen=>ppcen,den1=>dden1,den2=>dden2,aen=>aaen,SPload=>SSPload,PCload=>PPCload,IRload=>IIRload,Psel=>PPsel,Ssel=>SSsel,ALUsel=>AALUsel,Rsel=>RRsel,sub2=>ssub2,jmpMux=>jjmpMux,we=>rregWe,rbe=>rregRbe,rae=>rregRae);
       DP: datapath port map(clk10=>clk9, reset=>reset, pcen=> ppcen, den1=> dden1, den2=> dden2, aen=>aaen, SPload=> SSPload, PCload=>PPCload, Psel=>PPsel, Ssel=>SSsel, Rsel=> RRsel, sub2=> ssub2, jmpMux=>jjmpMux, opfetch=> oopfetch, IR=>IIR, IRload=>IIRload, zero=>zzero, ALUsel=> AALUsel, regWa=>rregWa, regRaa=>rregRaa, regRba=>rregRba, regWe=>rregWe, regRbe=>rregRbe, regRae=>rregRae, outDataBus=>dataout, inDataBus=>datain, outAddressBus=>A);
       
       
       
       
       
end imp;

--- 2020 RSRC new "260M Lab 5" VHDL Code: Digital Roulette
--- Current file name:  testbench.vhd
--- Last Revised:  8/7/2020; 12:34 p.m.
--- Author:  WDR
--- Copyright:  William D. Richard, Ph.D.

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL ;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY testbench IS
PORT(clk        : IN  STD_LOGIC ;
     reset_l    : IN  STD_LOGIC ;
     clk100     : IN  STD_LOGIC ;
     clk25      : OUT STD_LOGIC ;
     an         : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0) ;
     ca         : OUT   STD_LOGIC ;
     cb         : OUT   STD_LOGIC ;
     cc         : OUT   STD_LOGIC ;
     cd         : OUT   STD_LOGIC ;
     ce         : OUT   STD_LOGIC ;
     cf         : OUT   STD_LOGIC ;
     cg         : OUT   STD_LOGIC ;
     dp         : OUT   STD_LOGIC) ;
END testbench ;

ARCHITECTURE structure OF testbench IS

   COMPONENT rsrc
   PORT(clk      : IN    STD_LOGIC ;
        reset_l  : IN    STD_LOGIC ;
        d        : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
        address  : OUT   STD_LOGIC_VECTOR(31 DOWNTO 0) ;
        read     : OUT   STD_LOGIC ;
        write    : OUT   STD_LOGIC ;
        done     : IN    STD_LOGIC) ;
   END COMPONENT ;

   COMPONENT eprom
   PORT(d        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
        address  : IN  STD_LOGIC_VECTOR(9 DOWNTO 0) ;
        ce_l     : IN  STD_LOGIC ;
        oe_l     : IN  STD_LOGIC) ;
   END COMPONENT ;

   COMPONENT sram
   PORT (d       : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         address : IN    STD_LOGIC_VECTOR(9 DOWNTO 0) ;
         ce_l    : IN    STD_LOGIC ;
         oe_l    : IN    STD_LOGIC ;
         we_l    : IN    STD_LOGIC ;
         clk     : IN    STD_LOGIC) ;
   END COMPONENT ;
   
   COMPONENT pins
   PORT (clk     : IN    STD_LOGIC ;
         reset_l : IN    STD_LOGIC ;
         d       : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         ce_l    : IN    STD_LOGIC ;
         oe_l    : IN    STD_LOGIC ;
         we_l    : IN    STD_LOGIC ;
         an      : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0) ;
         ca      : OUT   STD_LOGIC ;
         cb      : OUT   STD_LOGIC ;
         cc      : OUT   STD_LOGIC ;
         cd      : OUT   STD_LOGIC ;
         ce      : OUT   STD_LOGIC ;
         cf      : OUT   STD_LOGIC ;
         cg      : OUT   STD_LOGIC ;
         dp      : OUT   STD_LOGIC) ;
   END COMPONENT ;

   SIGNAL reset_l_temp  : STD_LOGIC ;
   SIGNAL reset_l_sync  : STD_LOGIC ;
   SIGNAL d             : STD_LOGIC_VECTOR(31 DOWNTO 0):= "00000000000000000000000000000000" ;
   SIGNAL address       : STD_LOGIC_VECTOR(31 DOWNTO 0):= "00000000000000000000000000000000" ;
   SIGNAL read          : STD_LOGIC ;
   SIGNAL write         : STD_LOGIC ;
   SIGNAL done          : STD_LOGIC ;
   SIGNAL eprom_ce_l    : STD_LOGIC ;
   SIGNAL eprom_oe_l    : STD_LOGIC ;
   SIGNAL pins_ce_l     : STD_LOGIC ;
   SIGNAL pins_oe_l     : STD_LOGIC ;
   SIGNAL pins_we_l     : STD_LOGIC ;
   SIGNAL sram_ce_l     : STD_LOGIC ;
   SIGNAL sram_oe_l     : STD_LOGIC ;
   SIGNAL sram_we_l     : STD_LOGIC ;
   SIGNAL cnt           : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00" ;

BEGIN

   clkprocess:PROCESS(clk100)
   BEGIN
      IF (clk100 = '1' AND clk100'event) THEN
         cnt <= cnt + 1 ;
      END IF;
   END PROCESS clkprocess ;

   clk25 <= cnt(1) ;

   syncprocess:PROCESS(clk)
   BEGIN
      IF (clk = '1' AND clk'event) THEN
         reset_l_temp <= reset_l ;
         reset_l_sync <= reset_l_temp ;
      END IF;
   END PROCESS syncprocess ;

   eprom_ce_l   <= '0' WHEN (address(31 DOWNTO 12) = "00000000000000000000" AND read = '1') ELSE '1' ;
   sram_ce_l    <= '0' WHEN (address(31 DOWNTO 12) = "00000000000000000001" AND (read = '1' OR write = '1')) ELSE '1' ;
   pins_ce_l    <= '0' WHEN (address(31 DOWNTO 2) =  "111111111111111111111111111111" AND (read = '1' OR write ='1')) ELSE '1' ;

   eprom_oe_l   <= '0' WHEN read = '1' ELSE '1' ;
   sram_oe_l    <= '0' WHEN read = '1' ELSE '1' ;
   pins_oe_l    <= '0' WHEN read = '1' ELSE '1' ;

   sram_we_l    <= '0' WHEN write = '1' ELSE '1' ;
   pins_we_l    <= '0' WHEN write = '1' ELSE '1' ;

   done <= '1' WHEN (eprom_ce_l = '0' OR sram_ce_l = '0' OR pins_ce_l = '0') ELSE '0' ;

   rsrc1:rsrc      
   PORT MAP(clk       => clk,
            reset_l   => reset_l_sync,
            d         => d,
            address   => address,
            read      => read,
            write     => write,
            done      => done);

   eprom1:eprom    
   PORT MAP(d         => d,
            address   => address(11 DOWNTO 2),
            ce_l      => eprom_ce_l,
            oe_l      => eprom_oe_l);
 
   sram1:sram
   PORT MAP(d         => d,
            address   => address(11 DOWNTO 2),
            ce_l      => sram_ce_l,
            oe_l      => sram_oe_l,
            we_l      => sram_we_l,
            clk       => clk);

   pins1:pins
   PORT MAP (clk     => clk,
             reset_l => reset_l_sync,
             d       => d,
             ce_l    => pins_ce_l,
             oe_l    => pins_oe_l,
             we_l    => pins_we_l,
             an      => an,
             ca      => ca,
             cb      => cb,
             cc      => cc,
             cd      => cd,
             ce      => ce,
             cf      => cf,
             cg      => cg,
             dp      => dp) ;

END structure;
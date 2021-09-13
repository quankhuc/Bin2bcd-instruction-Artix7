--- Pins
--- Copyright William D. Richard, Ph.D.
--- January 26, 2021

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_UNSIGNED.ALL ;

ENTITY pins IS
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
END pins ;

ARCHITECTURE foo OF pins IS

   SIGNAL   myreg    : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL   mycnt    : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL   sel      : STD_LOGIC_VECTOR(2 DOWNTO 0) ;
   SIGNAL   ahexchar : STD_LOGIC_VECTOR(3 DOWNTO 0) ;
   
BEGIN

   readprocess:PROCESS(ce_l,oe_l,mycnt)
   begin
      IF (ce_l = '0' AND oe_l = '0') THEN
         d <= "0000000000000000000000000000000" & mycnt(24) ;
      else
	 d <= (OTHERS => 'Z') ;
      END IF;
   END PROCESS readprocess ; 

   writeprocess:PROCESS(clk)
   begin
      IF (clk = '1' AND clk'event) THEN
         IF (reset_l = '0') THEN
            myreg <= "00000000000000000000000000000000" ;
         ELSIF (ce_l = '0' AND we_l = '0') THEN
            myreg <= d ;
         END IF;
      END IF;
   END PROCESS writeprocess ;

   cntprocess:PROCESS(clk)
   begin
      IF (clk = '1' AND clk'event) THEN
         IF (reset_l = '0') THEN
            mycnt <= "00000000000000000000000000000000" ;
         ELSE
            mycnt <= mycnt + 1 ;
         END IF;
      END IF;
   END PROCESS cntprocess ;

  sel <= mycnt(19 DOWNTO 17) ;

   WITH sel SELECT
      an <= "11111110" WHEN "000" ,
            "11111101" WHEN "001" ,
            "11111011" WHEN "010" ,
            "11110111" WHEN "011" ,
            "11101111" WHEN "100" ,
            "11011111" WHEN "101" ,
            "10111111" WHEN "110" ,
            "01111111" WHEN "111" ,
            "11111111" WHEN OTHERS ;

   WITH sel SELECT
      ahexchar <= myreg(3 DOWNTO 0)   WHEN "000" ,
                  myreg(7 DOWNTO 4)   WHEN "001" ,
                  myreg(11 DOWNTO 8)  WHEN "010" ,
                  myreg(15 DOWNTO 12) WHEN "011" ,
                  myreg(19 DOWNTO 16) WHEN "100" ,
                  myreg(23 DOWNTO 20) WHEN "101" ,
                  myreg(27 DOWNTO 24) WHEN "110" ,
                  myreg(31 DOWNTO 28) WHEN "111" ,
                  myreg(3 DOWNTO 0)   WHEN OTHERS ;

   WITH ahexchar SELECT
      ca <= '0' WHEN "0000" ,
            '1' WHEN "0001" ,
            '0' WHEN "0010" ,
            '0' WHEN "0011" ,
            '1' WHEN "0100" ,
            '0' WHEN "0101" ,
            '0' WHEN "0110" ,
            '0' WHEN "0111" ,
            '0' WHEN "1000" ,
            '0' WHEN "1001" ,
            '0' WHEN "1010" ,
            '1' WHEN "1011" ,
            '0' WHEN "1100" ,
            '1' WHEN "1101" ,
            '0' WHEN "1110" ,
            '0' WHEN "1111" ,
            '1' WHEN OTHERS ;

   WITH ahexchar SELECT
      cb <= '0' WHEN "0000" ,
            '0' WHEN "0001" ,
            '0' WHEN "0010" ,
            '0' WHEN "0011" ,
            '0' WHEN "0100" ,
            '1' WHEN "0101" ,
            '1' WHEN "0110" ,
            '0' WHEN "0111" ,
            '0' WHEN "1000" ,
            '0' WHEN "1001" ,
            '0' WHEN "1010" ,
            '1' WHEN "1011" ,
            '1' WHEN "1100" ,
            '0' WHEN "1101" ,
            '1' WHEN "1110" ,
            '1' WHEN "1111" ,
            '1' WHEN OTHERS ;

   WITH ahexchar SELECT
      cc <= '0' WHEN "0000" ,
            '0' WHEN "0001" ,
            '1' WHEN "0010" ,
            '0' WHEN "0011" ,
            '0' WHEN "0100" ,
            '0' WHEN "0101" ,
            '0' WHEN "0110" ,
            '0' WHEN "0111" ,
            '0' WHEN "1000" ,
            '0' WHEN "1001" ,
            '0' WHEN "1010" ,
            '0' WHEN "1011" ,
            '1' WHEN "1100" ,
            '0' WHEN "1101" ,
            '1' WHEN "1110" ,
            '1' WHEN "1111" ,
            '1' WHEN OTHERS ;

   WITH ahexchar SELECT
      cd <= '0' WHEN "0000" ,
            '1' WHEN "0001" ,
            '0' WHEN "0010" ,
            '0' WHEN "0011" ,
            '1' WHEN "0100" ,
            '0' WHEN "0101" ,
            '0' WHEN "0110" ,
            '1' WHEN "0111" ,
            '0' WHEN "1000" ,
            '1' WHEN "1001" ,
            '1' WHEN "1010" ,
            '0' WHEN "1011" ,
            '0' WHEN "1100" ,
            '0' WHEN "1101" ,
            '0' WHEN "1110" ,
            '1' WHEN "1111" ,
            '1' WHEN OTHERS ;

   WITH ahexchar SELECT
      ce <= '0' WHEN "0000" ,
            '1' WHEN "0001" ,
            '0' WHEN "0010" ,
            '1' WHEN "0011" ,
            '1' WHEN "0100" ,
            '1' WHEN "0101" ,
            '0' WHEN "0110" ,
            '1' WHEN "0111" ,
            '0' WHEN "1000" ,
            '1' WHEN "1001" ,
            '0' WHEN "1010" ,
            '0' WHEN "1011" ,
            '0' WHEN "1100" ,
            '0' WHEN "1101" ,
            '0' WHEN "1110" ,
            '0' WHEN "1111" ,
            '1' WHEN OTHERS ;

   WITH ahexchar SELECT
      cf <= '0' WHEN "0000" ,
            '1' WHEN "0001" ,
            '1' WHEN "0010" ,
            '1' WHEN "0011" ,
            '0' WHEN "0100" ,
            '0' WHEN "0101" ,
            '0' WHEN "0110" ,
            '1' WHEN "0111" ,
            '0' WHEN "1000" ,
            '0' WHEN "1001" ,
            '0' WHEN "1010" ,
            '0' WHEN "1011" ,
            '0' WHEN "1100" ,
            '1' WHEN "1101" ,
            '0' WHEN "1110" ,
            '0' WHEN "1111" ,
            '1' WHEN OTHERS ;

   WITH ahexchar SELECT
      cg <= '1' WHEN "0000" ,
            '1' WHEN "0001" ,
            '0' WHEN "0010" ,
            '0' WHEN "0011" ,
            '0' WHEN "0100" ,
            '0' WHEN "0101" ,
            '0' WHEN "0110" ,
            '1' WHEN "0111" ,
            '0' WHEN "1000" ,
            '0' WHEN "1001" ,
            '0' WHEN "1010" ,
            '0' WHEN "1011" ,
            '1' WHEN "1100" ,
            '0' WHEN "1101" ,
            '0' WHEN "1110" ,
            '0' WHEN "1111" ,
            '1' WHEN OTHERS ;

   dp <= '1' ;

END foo ;

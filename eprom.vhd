---2019 BIN-TO-VHD CONVERTER 1.0
---Copyright William D. Richard, Ph.D.

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY eprom IS
   PORT (d        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) ;
         address  : IN  STD_LOGIC_VECTOR(9 DOWNTO 0) ;
         ce_l     : IN  STD_LOGIC ;
         oe_l     : IN  STD_LOGIC) ;
   END eprom ;

ARCHITECTURE behavioral OF eprom IS

   SIGNAL data    : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
   SIGNAL sel     : STD_LOGIC_VECTOR(31 DOWNTO 0) ;

BEGIN

   sel <= "00000000000000000000" & address & "00" ;

   WITH sel  SELECT
   data <=
      X"2f81fffc" WHEN X"00000000" , --- 	la 	r30,PINS	; IO addresses to r30
      X"2fc0001c" WHEN X"00000004" , --- 	la	r31,TOP		; r31 holds the loop address
      X"28400000" WHEN X"00000008" , --- 	la	r1,0		; Initialize difference engine coefficients
      X"308f4231" WHEN X"0000000c" , --- 	lar	r2,1000001
      X"28c1fffa" WHEN X"00000010" , --- 	la	r3,-6
      X"2901ffe2" WHEN X"00000014" , --- 	la	r4,-30
      X"2941ffe8" WHEN X"00000018" , --- 	la	r5,-24
      X"60422000" WHEN X"0000001c" , --- TOP:	add	r1,r1,r2	; Update the difference engine values
      X"60843000" WHEN X"00000020" , --- 	add	r2,r2,r3
      X"60c64000" WHEN X"00000024" , --- 	add	r3,r3,r4
      X"61085000" WHEN X"00000028" , ---	add	r4,r4,r5
      X"403e2004" WHEN X"0000002c" , --- 	brpl	r31,r2		; Branch conditionally to TOP testing for peak
      X"38401000" WHEN X"00000030" , ---	bin2bcd r1,r1			; Replace wtih bin2bcd r1,r1
      X"187c0000" WHEN X"00000034" , ---	st r1,0(r30)		; Display the lower 8 BCD digits
      X"f8000000" WHEN X"00000038" , ---	stop
      X"00000000" WHEN OTHERS ;

   readprocess:PROCESS(ce_l,oe_l,data)
   begin
      IF (ce_l = '0' AND oe_l = '0') THEN
         d(31 DOWNTO 0) <= data ;
      else
	 d(31 DOWNTO 0) <= (OTHERS => 'Z') ;
      END IF;
   END PROCESS readprocess ;

END behavioral ;

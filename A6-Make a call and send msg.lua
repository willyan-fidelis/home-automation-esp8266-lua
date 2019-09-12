--https://www.jagelectronicsshop.com/single-post/2016/11/29/How-to-make-Calls-and-Send-SMS-using-A6-GSMGPRS-Module-and-Terminal-Software
--http://www.alselectro.com/gsm-a6-board.html
--https://alselectro.wordpress.com/2016/08/13/gsm-a6-module-from-the-developers-of-esp8266/
--https://www.elecrow.com/download/A6%20module%20AT%20commands.pdf

-- Enable Error msg verbose:
AT+CMEE=2

--Test
AT

--Make a call:
ATD01547988319021;
--End a call:
ATH

ATD047988319021

ATD998100102;


--Recive a msg:
AT+CMGF=1

--Send a msg:

AT+CMGF=1

AT+CMGS="0154788319021"

Hellooooow





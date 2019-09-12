--https://forum.arduino.cc/index.php?topic=414466.0
AT+CGATT=1
AT+CGDCONT=1, "IP","claro.com.br"
AT+CGACT=1,1
AT+CGACT?
AT+CIPSTATUS
AT+CIFSR

AT+CIPSTART="TCP","anoticia.clicrbs.com.br",21
AT+CIPSTART="TCP","m2msupport.net",21
AT+CIPSTART="TCP","74.124.194.252",21
--------------------------------------
AT+CIPSTART="TCP","mujkotel.wz.cz",21
AT+CIPSEND
> GET /index.html HTTP/1.1
Host:www.mujkotel.wz.cz



\0x1a
at+cipclose

AT+CIPSTART="TCP","homesense.eu.ai",80
--------------------------------------
AT+CIPSTART="TCP","m2msupport.net",21
AT+CIPSEND

> GET /m2msupport/http_get_test.php HTTP/1.1
Host:www.m2msupport.net
Connection:keep-alive



AT+CIPCLOSE

AT+CIPCLOSE
--------------------------------------
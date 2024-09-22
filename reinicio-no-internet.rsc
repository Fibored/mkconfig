Checa si hay internet en un lapso de 5 minutos, si no hay, realiza un reinicio del mikrotik, se compone de Netwatch y el script.


/tool netwatch
add disabled=no down-script=":if ([/system resource get uptime]>30) do={\r\
    \n  :log info \"Not ping on 8.8.8.8\";\r\
    \n  /system script run AutomaticRestart;\r\
    \n}" host=8.8.8.8 http-codes="" interval=5m test-script="" type=simple \
    up-script=""

/system script
add dont-require-permissions=no name=AutomaticRestart owner=Rivera policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":\
    local PingCount 300;\r\
    \n:local stop false;\r\
    \n:while ([/ping 8.8.8.8 count=1 interval=5]=0 && stop=false) do={\r\
    \n  :set PingCount (\$PingCount-5);\r\
    \n  #:log info \"Reboot after \$PingCount s\";\r\
    \n :if (\$PingCount<=0) do={\r\
    \n    :set stop true;\r\
    \n    :log info \"NOT PING ON 8.8.8.8 - REBOOT!!!\";\r\
    \n    /system reboot;\r\
    \n  };\r\
    \n};\r\
    \n\r\
    \n:set PingCount (300-\$PingCount);\r\
    \n:if (stop=false) do={:log info \"Reboot stop after \$PingCount/300 s\";}\
    ;"

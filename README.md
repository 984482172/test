#!/bin/sh
#
#*****************************************************
#This script only for RHEL and SLES linux
#WT: Reboot interval 
#SF: Script file path
#LF: Log file path
#The three parameters can be defined by Test Engineer
#according your specified requirement
#Designed by Jason.Yuan & Honlly.Liu 
#*****************************************************

SF="/root/Desktop/LinuxReboot.sh"
LF="/root/Desktop/LinuxRebootLog.txt"

[ -f $SF ] || { echo "Error file path in script!"; exit 1; }
[ $# -gt 1 ] && { echo "Error parameter number!"; exit 1; }
[ $# = 1 ] && [ $1 != "stop" ] && [ $1 != "start" ] && { echo "Error parameter: $1"; exit 1; }

[ $# = 1 ] && [ $1 = "stop" ] && { 
FLAG=`crontab -l`;
[ -z "$FLAG" ] && { echo "Stop failed!"; exit 1; }; 
crontab -r && echo "Stop success!"; 
exit 1; 
}

if [ $# = 0 ]; then
echo -n "Please define your reboot interval(default is 5 mins),unit:minute-> "
read temp
WT=${temp:-"5"}
CN=1
ST=$(date +"%Y-%m-%d %H:%M:%S")
CT=$ST
TT="00:00:00"
[ -f $LF ] && rm -f $LF
echo 2 > /etc/cyclenum
echo $ST > /etc/starttime
crontabs="*/$WT * * * * $SF start";
[ -d /var/spool/cron/tabs ] && echo "$crontabs" > /var/spool/cron/tabs/root || echo "$crontabs" > /var/spool/cron/root;
else
CN=`cat /etc/cyclenum`
ST=`cat /etc/starttime`
echo $(($CN+1)) > /etc/cyclenum
CT=$(date +"%Y-%m-%d %H:%M:%S")
TT=$(($(date +%s)-$(date +%s -d "$ST")))
iHour=$(($TT/3600))
iMinute=$((($TT%3600)/60))
iSecond=$((($TT%3600)%60))
TT=`printf "%02d:%02d:%02d" $iHour $iMinute $iSecond`
[ $iHour -ge 24 ] && { crontab -r; exit 1; }
fi

echo "[$CN] Auto Reboot Start At $CT [$TT]" >> $LF
/sbin/reboot || reboot

#test edits

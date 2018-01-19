#!/bin/sh
echo -e "----------------------\n";
echo -e "|--开始安装DDOS防护--|\n"
echo -e "----------------------\n\n";
APP_PATH="/usr/local/ddos"
if [ ! -d "${APP_PATH}" ] ;then
	mkdir $APP_PATH
	cd $APP_PATH
	wget http://vnser.oss-cn-shanghai.aliyuncs.com/ddos.zip
	unzip ddos.zip
	chmod 777 ./*
	killall hook_ddos &>/dev/null
	$APP_PATH/hook_ddos &
	echo -e "/usr/local/ddos/hook_ddos &>/dev/null &" >> /etc/rc.local
else
	echo -e "DDOS防御已开启,无需重复开启~\n"
fi;	
rm -rf ddos.zip*

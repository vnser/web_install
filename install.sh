#!/bin/bash
clear;
echo -e "
+-----------------------欢迎使用思微linux服务器一键安装脚本------------------------+
+   welcome to use, a key to micro Linux server installation script                +
+  支持安装：vtftpd、httpd、nginx、php、mysql5.5/5.6、subversion(svn)、redis       +
+  适用于机型: 阿里、腾讯-centos 6.x 7.x                                           +
+                                                                      by: vnser   +
+----------------------------------------------------------------------------------+
"
source inc_head.sh
#安装ftp服务器
echo -e "是否安装vsftpd(ftp服务器):？(y/n)";
read is_ftp
if [ "${is_ftp}" == "y" ];then
	./vsftpd-install.sh
fi;
#安装nginx
echo -e "是否安装web服务器？(y/n):";
read is_web;
if [ "${is_web}" == "y" ];then
    echo -e "选择你要安装的web服务:\n1.nginx1.9\n2.apache2.4.20"
    read is_web_type
    if [ "$is_web_type" == "1" ];then
        ./nginx-install.sh
    else
        ./httpd-install.sh
    fi;
fi;
#安装php
echo -e "是否安装php5.6？(y/n):";
read is_php;
if [ "${is_php}" == "y" ];then
	./php-install.sh
fi;

#安装mysql
echo -e "是否安装mysql？(y/n):";
read is_mysql;
if [ "${is_mysql}" == "y" ];then
	echo -e "选择你要安装mysql的版本?\n1.mysql5.5\n2.mysql5.6"
	read mysql_ver
	if [ "${mysql_ver}" == "1" ];then
		 ./mysql5.5_install.sh
	else
		 ./mysql5.6_install.sh
	fi;
fi;

#./mysql5.6_install.sh
echo -e "是否安装Redis(y/n)?"
read is_redis
if [ "${is_redis}" == "y" ];then
	./redis-install.sh
fi;

echo -e "是否安装subversion(svn版本控制工具)？(y/n):"
read is_svn
if [ "${is_svn}" == "y" ];then
    ./subversion-install.sh
fi;
echo -e "是否安装守护进程(可抵御普通cc工具攻击)？(y/n):"
read is_ddos
if [ "${is_ddos}" == "y" ];then
   #安装ddos防御脚本
	./install_ddos.sh
fi;

#cp -arf ${conf_path}/rc.local /etc/rc.d
if [ -z "`sed -n '/\/usr\/sbin\/reser/p' /etc/rc.local`" ];then
	#写入开机自启钩子
	echo -e "/usr/sbin/reser" >> /etc/rc.local
	chmod 777 /etc/rc.d/rc.local
	echo -e "已创建命令至\"/usr/sbin/reser\"开机钩子启动脚本“rc.local”~\n"
fi;	
sleep 1;

echo 'export PATH="$PATH:/usr/local/mysql/bin:/usr/local/redis:/usr/local/php/sbin:/usr/local/php/bin:/usr/local/svn/bin:/usr/local/httpd/bin/"'>>/root/.bash_profile;
chmod 777 /root/.bash_profile
/root/.bash_profile

echo -e "创建快捷重启命令“reser”~\n"
sleep 1;

cp -arf ~/install/restart.sh /usr/sbin/reser
chmod 777 /usr/sbin/reser

echo -e "########安装结束\(^o^)/~######\n"

echo -e "+------更改服务器默认配置项---+\n";

sleep 1;
echo 2048 >/proc/sys/net/core/somaxconn
echo -e "已更改默认tcp最大连接数为\""`cat /proc/sys/net/core/somaxconn`"\"\n"

sleep 1;
sed -i "s/MAILTO=root/MAILTO=\"\"/g" /etc/crontab
sed -i "1iMAILTO=\"\""  /var/spool/cron/root
service crond restart
service postfix stop
chkconfig postfix off

echo -e "已关闭crond服务执行失败循环发邮件生成文件卡磁盘\n"
sleep 1;

echo -e "取消“You have new mail in /var/spool/mail/root”长时间提示\n"
echo "unset MAILCHECK" >> /etc/profile
source /etc/profile

echo -e "########正在启动全部安装服务~~~~"
cd /root
rm -rf install* ini_hook*

#启动服务器
/usr/sbin/reser
#!/bin/sh

app_path=/usr/local/

#检测进程是否在进行
check_sta(){
    #echo $1
    cou=`ps -ef |grep $1 |grep -vc "grep"`
    #echo $count
    if [ 0 == $cou ];then
        return 0;
    fi
    return 1;
}

#检测nginx
check_sta nginx
if [ $? == 1 ]; then
    killall nginx >& /dev/null
    echo -en "\n正在关闭nginx~\n"
fi;

#检测httpd
check_sta httpd
if [ $? == 1 ]; then
    killall httpd >& /dev/null
    echo -en "\n正在关闭httpd~\n"
fi;

#检测php-fpm
check_sta php-fpm
if [ $? == 1 ]; then
    killall php-fpm >& /dev/null
    echo -en "\n正在关闭php-fpm~\n"
fi;

#检测mysql
check_sta mysqld
if [ $? == 1 ]; then
    killall mysqld >& /dev/null
	sleep 1;
    echo -en "\n正在关闭mysql~\n"
fi;

#检测redis
check_sta redis-server
if [ $? == 1 ]; then
    killall redis-server >& /dev/null
    echo -en "\n正在关闭redis~\n"
    sleep 1;
fi;

#检测SUBVERSION
check_sta svnserve
if [ $? == 1 ]; then
    killall svnserve >& /dev/null
    echo -en "\n正在关闭svn(版本控制)~\n"
fi;

#检测vsftp
check_sta vsftpd
if [ $? == 1 ]; then
    killall vsftpd >& /dev/null
    echo -e "\n正在关闭ftp~\n"
fi;
sleep 1;
########启动
echo -e "\n\n------------------------retart-启动日志$(date +%Y-%m-%d_%H:%M:%S)---------------------------------" &>> /tmp/restart.log
#启动nginx
if [ -d "${app_path}nginx" ];then
    echo -en "\n正在启动nginx: "
    echo -e "\n\nNGINX:" &>>  /tmp/restart.log
    ${app_path}nginx/sbin/nginx &>> /tmp/restart.log
    check_sta nginx
    if [ $? == 0 ];then
        echo -en "[\e[0;31;1m失败\e[0m]\n";
    else
        echo -en "[\e[1;32m成功\e[0m]\n"
    fi;
fi;

#启动apache
if [ -d "${app_path}httpd" ];then
    echo -en "\n正在启动httpd: "
    echo -e "\n\nHTTPD:" &>>  /tmp/restart.log
    ${app_path}httpd/bin/httpd &>> /tmp/restart.log
    check_sta httpd
    if [ $? == 0 ];then
        echo -en "[\e[0;31;1m失败\e[0m]\n";
        #echo -e "\n\n" &>>  /tmp/restart.log
    else
        echo -en "[\e[1;32m成功\e[0m]\n"
    fi;
fi;

#启动php
if [ -d "${app_path}php" ];then
    echo -en "\n正在启动php: "
    echo -e "\n\nPHP-FPM:" &>>  /tmp/restart.log
    ${app_path}php/sbin/php-fpm -c ${app_path}php/lib/php.ini -y ${app_path}php/etc/php-fpm.conf &>> /tmp/restart.log
    check_sta php-fpm
    if [ $? == 0 ];then
        echo -en "[\e[0;31;1m失败\e[0m]\n";
       # echo -e "\n\n" &>>  /tmp/restart.log
    else
        echo -en "[\e[1;32m成功\e[0m]\n"
    fi;
fi;

#启动mysql
if [ -d "${app_path}mysql" ];then
    echo -en "\n正在启动mysql: "
    echo -e "\n\nMYSQL:" &>>  /tmp/restart.log
    #${app_path}mysql/bin/mysqld --defaults-file=${app_path}mysql/conf/my.cnf &>> /tmp/restart.log &
    ${app_path}mysql/bin/mysqld_safe --defaults-file=${app_path}mysql/conf/my.cnf &>> /tmp/restart.log &
    sleep 1;
    check_sta mysqld
    if [ $? == 0 ];then
        echo -en "[\e[0;31;1m失败\e[0m]\n";
        #echo -e "\n\n" &>>  /tmp/restart.log
    else
        echo -en "[\e[1;32m成功\e[0m]\n"
    fi;
fi;

#启动redis
if [ -d "${app_path}redis" ];then
    echo -en "\n正在启动redis: "
    echo -e "\n\nREDIS:" &>>  /tmp/restart.log
    ${app_path}redis/redis-server ${app_path}redis/redis.conf &>> /tmp/restart.log &
    check_sta redis-server
    if [ $? == 0 ];then
        echo -en "[\e[0;31;1m失败\e[0m]\n";
        #echo -e "\n\n" &>>  /tmp/restart.log
    else
        echo -en "[\e[1;32m成功\e[0m]\n"
    fi;
fi;

#启动vstftpd
if [ -d "/etc/vsftpd" ];then
    echo -en "\n正在启动ftp: "
    echo -e "\n\nVSFTPD:" &>>  /tmp/restart.log
    service vsftpd start &>>  /tmp/restart.log
    check_sta vsftpd
    if [ $? == 0 ];then
        echo -en "[\e[0;31;1m失败\e[0m]\n";
       # echo -e "\n\n" &>>  /tmp/restart.log
    else
        echo -en "[\e[1;32m成功\e[0m]\n"
    fi;
fi;

#启动subversion
if [ -d "${app_path}svn" ];then
    echo -en "\n正在启动svn(版本控制): "
    echo -e "\n\nSVN:" &>>  /tmp/restart.log
    ${app_path}svn/bin/svnserve -d -r ${app_path}svn/data/ &>> /tmp/restart.log
    check_sta svnserve
    if [ $? == 0 ];then
        echo -en "[\e[0;31;1m失败\e[0m]\n";
        #echo -e "\n\n" &>>  /tmp/restart.log
    else
        echo -en "[\e[1;32m成功\e[0m]\n"
    fi;
fi;
echo "";
#
##nginx_path信息
#nginx_path=${app_path}nginx
#nginx=${nginx_path}/sbin/nginx
#
##php path信息
#php_path=${app_path}php
#php_fpm=${php_path}/sbin/php-fpm
#php_ini=${php_path}/lib/php.ini
#php_fpm_conf=${php_path}/etc/php-fpm.conf
#
#
##--启动区--
##启动php-fpm
#${php_fpm} -c ${php_ini} -y ${php_fpm_conf}
##nginx启动
#
##redis启动
#${app_path}redis/redis-server ${app_path}redis/redis.conf &
#/usr/local/mysql/bin/mysqld --defaults-file=${app_path}mysql/conf/my.cnf &
#service vsftpd start #启动ftp服务器
#svnserve -d -r /usr/local/svn/data/

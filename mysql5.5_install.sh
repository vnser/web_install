
echo -e "----------------------\n";
echo -e "|--开始安装MYSQL5.5--|\n"
echo -e "----------------------\n\n";
source inc_head.sh

if [ ! -d "${app_path}mysql" ] ;then
	cd ${app_path}
	yum install libaio* -y
	#wget http://dev.mysql.com/get/Downloads/MySQL-5.5/mysql-5.5.49-linux2.6-x86_64.tar.gz
	wget http://swxfile.oss-cn-hangzhou.aliyuncs.com/mysql-5.5.49-linux2.6-x86_64.tar.gz
	tar -zxvf mysql-5.5.49-linux2.6-x86_64.tar.gz
	#cd ${app_path}mysql-5.5.49-linux2.6-x86_64
	mv  ${app_path}mysql-5.5.49-linux2.6-x86_64 mysql
	cd ${app_path}mysql
	#添加运行用户组及用户
	egrep "^mysql" /etc/group >& /dev/null  
	if [ $? -ne 0 ]  
	then 
	   groupadd mysql
	fi 
	egrep "^mysql" /etc/passwd >& /dev/null  
	if [ $? -ne 0 ]  
	then 
		useradd -s /sbin/false -g mysql mysql  
	fi;
	mkdir ${app_path}mysql/conf
	cp -arf ${conf_path}/mysql5.5/my.cnf ${app_path}mysql/conf/my.cnf
	chmod 644 ${app_path}mysql/conf/my.cnf
	#执行安装
	${app_path}mysql/scripts/mysql_install_db --defaults-file=${app_path}mysql/conf/my.cnf --datadir=${app_path}mysql/data --basedir=${app_path}mysql --user=mysql
	chown -R mysql:mysql ./
	chown -R mysql:mysql ./data
	sleep 2;
	#${app_path}mysql/bin/mysqld --defaults-file=${app_path}mysql/conf/my.cnf & #--user=root &
	${app_path}mysql/bin/mysqld_safe --defaults-file=${app_path}mysql/conf/my.cnf &>> /tmp/restart.log &
	${app_path}mysql/bin/mysqld_safe --defaults-file=${app_path}mysql/conf/my.cnf &>> /tmp/restart.log &
	sleep 5;
	${app_path}mysql/bin/mysql -e "delete from mysql.user where user=''";
	${app_path}mysql/bin/mysql -e "update mysql.user set password = password('root') where user='root' ";
	${app_path}mysql/bin/mysql -e "update mysql.user set host='%' where user='root'" &>> /dev/null
	${app_path}mysql/bin/mysql -e "flush privileges";
else
	echo -e '--MySQL5.5已安装\n';
fi;
cd ${app_path}
rm -rf mysql-5.5.49-linux2.6-x86_64.tar.gz mysql-5.5.49-linux2.6-x86_64

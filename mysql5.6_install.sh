
echo -e "----------------------\n";
echo -e "|--开始安装MYSQL5.6--|\n"
echo -e "----------------------\n\n";

source inc_head.sh

if [ ! -d "${app_path}mysql" ] ;then

	yum install libaio* -y
	cd ${app_path}
	#wget http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.30-linux-glibc2.5-x86_64.tar.gz
	wget http://swxfile.oss-cn-hangzhou.aliyuncs.com/mysql-5.6.30-linux-glibc2.5-x86_64.tar.gz
	tar -zxvf mysql-5.6.30-linux-glibc2.5-x86_64.tar.gz
	#cd ${app_path}mysql-5.5.49-linux2.6-x86_64
	mv ${app_path}mysql-5.6.30-linux-glibc2.5-x86_64 mysql
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
		useradd -g mysql mysql  
	fi  

	#复制配置文件
	mkdir ${app_path}mysql/conf
	cp -arf ${conf_path}mysql5.6/my.cnf ${app_path}mysql/conf/my.cnf
	chmod 644 ${app_path}mysql/conf/my.cnf

	#安装Mysql
	${app_path}mysql/scripts/mysql_install_db --basedir=${app_path}mysql --datadir=${app_path}mysql/data --defaults-file=${app_path}mysql/conf/my.cnf --user=mysql
	chmod 777 ${app_path}mysql
	#更改文件夹所以权
	chown -R mysql:mysql ./
	sleep 2;
	#chown -R mysql:mysql data
	${app_path}/mysql/bin/mysqld_safe --defaults-file=${app_path}mysql/conf/my.cnf &>> /tmp/restart.log &
	${app_path}/mysql/bin/mysqld_safe --defaults-file=${app_path}mysql/conf/my.cnf &>> /tmp/restart.log &
	#${app_path}mysql/bin/mysqld --defaults-file=${app_path}mysql/conf/my.cnf & #--user=root &
	sleep 5;
	${app_path}/mysql/bin/mysql -e "delete from mysql.user where user=''";
	${app_path}/mysql/bin/mysql -e "update mysql.user set password = password('root') where user='root' ";
	${app_path}/mysql/bin/mysql -e "grant all privileges on *.* to root@'%' identified by 'root'";
	${app_path}/mysql/bin/mysql -e "flush privileges";

else
	echo -e '--MySQL5.6已安装\n'
fi;

cd ${app_path}
rm -rf mysql-5.6.30-linux-glibc2.5-x86_64.tar.gz mysql-5.6.30-linux-glibc2.5-x86_64

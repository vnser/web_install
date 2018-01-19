
echo -e "--------------------\n";
echo -e "|--开始安装PHP5.6--|\n"
echo -e "--------------------\n\n";
source inc_head.sh

#安装插件
yum install libxml2 -y
yum install libxml2-devel -y
yum install curl curl-devel -y
yum install libjpeg-devel -y
yum install libpng -y
yum install libpng-devel -y
yum install freetype-devel -y

if [ ! -d "${app_path}lib/libmcrypt" ] ;then
	cd ${app_path}  #切换当前操作目录
	#wget ftp://mcrypt.hellug.gr/pub/crypto/mcrypt/attic/libmcrypt/libmcrypt-2.5.7.tar.gz
	wget http://swxfile.oss-cn-hangzhou.aliyuncs.com/libmcrypt-2.5.7.tar.gz
	#解压  
	tar -zxvf libmcrypt-2.5.7.tar.gz   
	#进入目录  
	cd ${app_path}libmcrypt-2.5.7  
	#编译（默认安装到/usr/local/lib/）  
	./configure 
	#执行安装  
	make && make install
else
	echo -e "--libmcrypt已安装\n"
fi;

if [ ! -d "${app_path}php" ] ;then
	#######php
	cd ${app_path}  #切换当前操作目录
	#wget http://php.net/distributions/php-5.6.19.tar.gz
	wget http://swxfile.oss-cn-hangzhou.aliyuncs.com/php-5.6.19.tar.gz
	tar -vxzf php-5.6.19.tar.gz
	cd ${app_path}php-5.6.19
	./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --enable-fpm --with-fpm-user=www --with-fpm-group=www --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-iconv-dir --with-freetype-dir=/usr/local/freetype --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr/bin/xml2-config --enable-xml --disable-rpath --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --enable-mbregex --enable-mbstring --enable-ftp --with-gd --enable-gd-native-ttf --with-mhash --enable-pcntl --enable-sockets --with-xmlrpc  --enable-zip --enable-soap --with-gettext --disable-fileinfo
	make && make install
	#复制php配置
	cp -arf ${conf_path}php/php-fpm.conf ${app_path}php/etc/ 
	cp -arf ${conf_path}php/php.ini ${app_path}php/lib/
	cp -arf ${conf_path}php/ext/* ${app_path}php/lib/php/extensions/no-debug-non-zts-20131226/
	egrep "^www" /etc/group >& /dev/null  
	if [ $? -ne 0 ]  
	then 
	   groupadd www
	fi 
	egrep "^www" /etc/passwd >& /dev/null  
	if [ $? -ne 0 ]  
	then 
		useradd -s /sbin/false -g www www
	fi;
else
	echo -e "--PHP 已安装\n"
fi;


cd ${app_path}
rm -rf php-5.6.19.tar.gz libmcrypt-2.5.7.tar.gz libmcrypt-2.5.7



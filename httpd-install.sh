##2017-12-16 11:02:22更新
echo -e "----------------------\n";
echo -e "|--开始安装APACHE2.4--|\n"
echo -e "----------------------\n\n";
source inc_head.sh
yum install -y  patch
if [ ! -d "${app_path}apr" ] ;then
###安装apr
	echo -e "检测apr未安装,安装中...\n";
	cd ${app_path}
	wget http://software-vnser.oss-cn-hangzhou.aliyuncs.com/apr-1.6.3.tar.gz
	tar -vxzf apr-1.6.3.tar.gz
	cd /usr/local/apr-1.6.3
	./configure --prefix=/usr/local/apr
	make && make install
else
	echo -e "--apr已安装"
fi;



if [ ! -d "${app_path}apr-util" ] ;then
###安装apr-util
	cd ${app_path}
	wget http://swxfile.oss-cn-hangzhou.aliyuncs.com/apr-util-1.3.12.tar.gz
	tar -vxzf apr-util-1.3.12.tar.gz
	cd ./apr-util-1.3.12
	./configure --prefix=/usr/local/apr-util -with-apr=/usr/local/apr/bin/apr-1-config
	make && make install
else
	echo -e "--apr-util已经安装\n"
fi;
if [ ! -d "${app_path}pcre" ] ;then
	#######安装pcre URL重写 伪静态
	cd ${app_path}  #切换当前操作目录
	#wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.37.tar.gz #下载pcre 安装成功 在安装nginx
	wget http://swxfile.oss-cn-hangzhou.aliyuncs.com/pcre-8.37.tar.gz
	tar -vxzf pcre-8.37.tar.gz
	cd pcre-8.37
	./configure --prefix=${app_path}pcre
	make && make install	
else
	echo -e "--pcre已安装\n"
fi;

if [ ! -d "${app_path}httpd" ] ;then

    #安装apache
	cd ${app_path}
	#wget http://mirrors.hust.edu.cn/apache//httpd/httpd-2.4.18.tar.gz
	wget http://swxfile.oss-cn-hangzhou.aliyuncs.com/httpd-2.4.20.tar.gz
	tar -vxzf httpd-2.4.20.tar.gz
	cd ./httpd-2.4.20
	./configure --prefix=/usr/local/httpd --enable-so --with-apr=/usr/local/apr --with-apr-util=/usr/local/apr-util/ --with-pcre=/usr/local/pcre --enable-mpms-shared=all
	make && make install

	#创建www根目录
	if [ ! -d "/var/www" ];then
		mkdir /var/www
	fi;

	#安装mod_fastcgi
	cd ${app_path}
	wget http://swxfile.oss-cn-hangzhou.aliyuncs.com/mod_fastcgi-2.4.6.tar.gz
	tar -vxzf mod_fastcgi-2.4.6.tar.gz
	cd ${app_path}mod_fastcgi-2.4.6
	cp -arf Makefile.AP2 Makefile
	cp -arf ${conf_path}httpd/byte-compile-against-apache24.diff ${app_path}mod_fastcgi-2.4.6/byte-compile-against-apache24.diff
	patch -p1 < byte-compile-against-apache24.diff
	make top_dir=/usr/local/httpd 
	make top_dir=/usr/local/httpd install

	#配置apache
	cp -arf ${conf_path}httpd/httpd.conf ${app_path}httpd/conf/
	cp -arf ${conf_path}httpd/httpd-vhosts.conf ${app_path}httpd/conf/extra/
	cp -arf ${conf_path}httpd/httpd-mpm.conf ${app_path}httpd/conf/extra/
	cp -arf ${conf_path}httpd/httpd-php_fpm.conf ${app_path}httpd/conf/extra/
	
	#配置用户
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
	echo -e "--APACHE已经安装\n"
fi;
cd ${app_path}
rm -rf apr-1.6.3 apr-util-1.3.12 apr-util-1.3.12.tar.gz apr-1.6.3.tar.gz httpd-2.4.20.tar.gz httpd-2.4.20  mod_fastcgi-2.4.6.tar.gz  mod_fastcgi-2.4.6 httpd-2.4.20.tar.gz httpd-2.4.20 pcre-8.37 pcre-8.37.tar.gz
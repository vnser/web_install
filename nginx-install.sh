
echo -e "----------------------\n";
echo -e "|--开始安装NGINX1.9--|\n"
echo -e "----------------------\n\n";

source inc_head.sh


#GCC未安装安装GCC
yum install gcc gcc-c++ -y
yum -y install openssl openssl-devel  



if [ ! -d "${app_path}nginx" ] ;then

	if [ ! -d "${app_path}pcre-8.37" ] ;then
		#######安装pcre URL重写 伪静态
		cd ${app_path}  #切换当前操作目录
		#wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.37.tar.gz #下载pcre 安装成功 在安装nginx
		wget http://swxfile.oss-cn-hangzhou.aliyuncs.com/pcre-8.37.tar.gz
		tar -vxzf pcre-8.37.tar.gz
		#cd pcre-8.37
		#./configure --prefix=${app_path}pcre
		#make && make install	
	#else
	#	echo -e "--pcre已安装\n"
	fi;

	if [ ! -d "${app_path}zlib-1.2.8" ] ;then
		#######安装zlib 用于http请求压缩
		cd ${app_path}
		#wget http://120.52.72.54/zlib.net/c3pr90ntcsf0/zlib-1.2.8.tar.gz
		wget http://swxfile.oss-cn-hangzhou.aliyuncs.com/zlib-1.2.8.tar.gz
		tar -vxzf zlib-1.2.8.tar.gz
	#	cd ${app_path}zlib-1.2.8
	#	./configure --prefix=${app_path}zlib
	#	make && make install
	#else
	#	echo -e "--zlib已安装\n"
		
	fi;

	#######安装NGinx
	cd ${app_path}  #切换当前操作目录
	#wget http://nginx.org/download/nginx-1.9.12.tar.gz #下载nginx安装包
	wget http://swxfile.oss-cn-hangzhou.aliyuncs.com/nginx-1.9.12.tar.gz
	tar -vxzf nginx-1.9.12.tar.gz #解压压缩包到/nginx-1.9.12目录
	cd ${app_path}nginx-1.9.12 #切换操作当前目录至/nginx-1.9.12目录
	wget http://software-vnser.oss-cn-hangzhou.aliyuncs.com/echo-nginx-module-0.61.tar.gz 
	tar -vxzf echo-nginx-module-0.61.tar.gz 
	./configure --prefix=${app_path}nginx --with-pcre=${app_path}pcre-8.37 --with-zlib=${app_path}zlib-1.2.8 --with-http_ssl_module --add-module=${app_path}nginx-1.9.12/echo-nginx-module-0.61
	make &&  make install;
	#复制nginx配置
	cp -arf ${conf_path}nginx/* ${app_path}nginx/conf
	if [ ! -d "/var/www" ];then
		mkdir /var/www
		chmod -R 777 /var/www
	fi;
	cp -arf ${conf_path}/nginx/.rewrite /var/www/.rewrite
	
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
	echo -e "--nginx已安装\n"
fi;
########清理资源#####
cd ${app_path}
rm -rf pcre-8.37.tar.gz pcre-8.37 zlib-1.2.8.tar.gz zlib-1.2.8 nginx-1.9.12.tar.gz nginx-1.9.12
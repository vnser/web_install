echo -e "------------------------------------\n";
echo -e "|--开始安装SUBVERSION版本管理工具--|\n"
echo -e "------------------------------------\n\n";
source inc_head.sh
if [ ! -d "${app_path}apr" ] ;then
###安装apr
	echo -e "检测apr未安装,安装中...\n";
	cd ${app_path}
	wget http://swxfile.oss-cn-hangzhou.aliyuncs.com/apr-1.4.5.tar.gz
	tar -vxzf apr-1.4.5.tar.gz
	cd /usr/local/apr-1.4.5
	./configure --prefix=/usr/local/apr
	make && make install
else
	echo -e "--apr已安装\n"
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

if [ ! -d "${app_path}zlib" ] ;then
#######安装zlib 用于http请求压缩
	echo -e "检测zlib未安装,安装中...\n";
	cd ${app_path}
	#wget http://120.52.72.54/zlib.net/c3pr90ntcsf0/zlib-1.2.8.tar.gz
	wget http://swxfile.oss-cn-hangzhou.aliyuncs.com/zlib-1.2.8.tar.gz
	tar -vxzf zlib-1.2.8.tar.gz
	cd ${app_path}zlib-1.2.8
	./configure --prefix=${app_path}zlib
	make && make install
else
	echo -e "--zlib已安装\n";
fi;

if [ ! -d "${app_path}svn" ] ;then
	cd ${app_path}
	wget http://swxfile.oss-cn-hangzhou.aliyuncs.com/subversion-1.9.4.tar.gz
	tar -vxzf subversion-1.9.4.tar.gz
	cd ./subversion-1.9.4
	#下载sqllite插件
	wget http://swxfile.oss-cn-hangzhou.aliyuncs.com/sqlite-amalgamation-3071501.zip
	unzip sqlite-amalgamation-3071501.zip -d sqlite-amalgamation
	
	./configure --prefix=/usr/local/svn --without-berkeley-db --with-zlib=/lib/ --with-apr=/usr/local/apr --with-apr-util=/usr/local/apr-util --with-zlib=/usr/local/zlib
	make && make install
	#创建工作副本
	mkdir ${app_path}/svn/data
	${app_path}/svn/bin/svnadmin create ${app_path}/svn/data
	rm -rf /usr/bin/svn

else
	echo -e "--svn已经安装\n"
fi;

cd ${app_path}
rm -rf apr-1.4.5.tar.gz apr-util-1.3.12.tar.gz zlib-1.2.8.tar.gz subversion-1.9.4.tar.gz apr-1.4.5 apr-util-1.3.12 zlib-1.2.8 subversion-1.9.4

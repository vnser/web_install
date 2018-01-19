
echo -e "--------------------------\n";
echo -e "|--开始安装REDIS 2.8.12--|\n"
echo -e "--------------------------\n\n";

source inc_head.sh

if [ ! -d "${app_path}redis" ] ;then
	cd ${app_path}
	#wget http://download.redis.io/releases/redis-2.8.12.tar.gz
	wget http://swxfile.oss-cn-hangzhou.aliyuncs.com/redis-2.8.12.tar.gz
	tar -zxvf redis-2.8.12.tar.gz
	cd ${app_path}redis-2.8.12
	make
	mkdir ${app_path}redis
	mv ${app_path}redis-2.8.12/redis.conf ${app_path}redis
	mv ${app_path}redis-2.8.12/src/redis-* ${app_path}redis
	chmod 777 ${app_path}redis/*
	#复制redis配置
	cp -arf ${conf_path}redis/redis.conf ${app_path}redis/
else
	echo -e "--redis已经安装\n"
fi;

cd ${app_path}
rm -rf redis-2.8.12.tar.gz redis-2.8.12
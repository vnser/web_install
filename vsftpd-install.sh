
echo -e "--------------------------\n";
echo -e "|--开始安装VSFTPD服务器--|\n"
echo -e "--------------------------\n\n";
source inc_head.sh


if [ ! -d "/etc/vsftpd" ] ;then
	yum  -y install vsftpd
	#复制ftp服务器配置
	cp -arf ${conf_path}vsftpd/* /etc/vsftpd/
	chmod 644 /etc/vsftpd/*
else
	echo -e "--VSTPDS服务器已安装"
fi;

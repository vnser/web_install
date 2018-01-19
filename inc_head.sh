#头部文件
#安装程序目录
app_path='/usr/local/'
conf_path='/root/install/conf/'
#移除系统默认命令别名
unalias mv rm cp >& /dev/null
yum install -y gcc gcc-c++
yum install -y psmisc
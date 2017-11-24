@echo off
title ACME自动构建工具1.0 by qiweb 20171124
color 0a
set author=https://github.com/QIWEB/BAT_MAVNE_SVN_EMAIL_TOMCAT_AOUT
:::::::::::::: 参数设置::::::::::::::
set dirs=E:\KangShiFu
set script_bat=C:\Users\zhangqi\Desktop\auto
set db_config_dirs=C:\Users\zhangqi\Desktop\auto\acme_config

rem ftp 设置
set ftpfile=%script_bat%\putfiles.ftp
set logfile=%script_bat%\putfiles.log
set ftpip=192.168.0.91
set fptuser=tomcat
set ftppassword=tomcat

rem 邮件设置
set from=zhangqi@163.com
set user=zhangqi@163.com
set pass=地对地导弹
set to=zhangqi@163.com,qufengle@163.com,wangfengbo@163.com,liubinghong@163.com,xuwei@163.com,zhuyalin@163.com
set subj=ACME自动构建发布成功通知
set mail=%script_bat%\qiweb_auto_log.txt
rem 附件 可以是任何*.jpg *.txt
set attach=%script_bat%\qiweb_auto_log.txt
set server=smtp.qiye.163.com
set debug=-debug -log %script_bat%\blat.log -timestamp

rem 就是blat发邮件工具的目录
set blat_home=%script_bat%

echo %date% %time% 开始任务 自动发布构建> %script_bat%\qiweb_auto_log.txt
SET WORKING_COPY=E:/KangShiFu
svn update %WORKING_COPY% 
echo %date% %time%  =================代码svn更新完成 >> %script_bat%\qiweb_auto_log.txt


echo %date% %time%  删除缓存 %dirs%\launch-single\target >> %script_bat%\qiweb_auto_log.txt
rd /s /q %dirs%\launch-single\target

echo %date% %time%  ===============代码maven构建开始 >> %script_bat%\qiweb_auto_log.txt
cd e:
cd E:\KangShiFu
cd c:
cd E:\KangShiFu
cd e:
echo  -Dmaven.repo.local=D:\idea+maven+jdk+tomcat\maven_repository
rem svn checkout  https://xxxxx　E:/KangShiFu --username　zhangqi --password xxxx

rem mvn clean package  -DskipTests -Dmaven.repo.local=D:\idea+maven+jdk+tomcat\maven_repository
call E:\KangShiFu\start_mvn.bat.lnk

echo %date% %time%  ===============代码maven构建完成 >> %script_bat%\qiweb_auto_log.txt




echo 1、设置工作目录：%dirs% >> %script_bat%\qiweb_auto_log.txt
xcopy /e /i /y %dirs%\launch-single\target\acme\static  %dirs%\launch-single\target\acme

echo 2、移动模板 >> %script_bat%\qiweb_auto_log.txt
xcopy /e /i /y %dirs%\launch-single\target\acme\templates %dirs%\launch-single\target\acme\WEB-INF\classes\templates


echo 3、修改日志和全局配置文件 >> %script_bat%\qiweb_auto_log.txt
xcopy /e /i /y %db_config_dirs%\91xml  %dirs%\launch-single\target\acme\WEB-INF\classes
echo 4、手动添加acme-lib下第三方jar >> %script_bat%\qiweb_auto_log.txt
xcopy /e /i /y %db_config_dirs%\jar  %dirs%\launch-single\target\acme\WEB-INF\lib
echo 5、重命名原始war包 >> %script_bat%\qiweb_auto_log.txt

ren %dirs%\launch-single\target\acme.war acme_%random%.war
echo 6、生成war包 >> %script_bat%\qiweb_auto_log.txt
cd %dirs%\launch-single\target\acme
e:

jar cvf acme.war */
rem cd %dirs%\launch-single\target\acme
rem "C:\Program Files\WinRAR/WinRAR.exe" a -s -r -ibck %dirs%\launch-single\target\acme.war

echo 7、切换原始工作目录 >> %script_bat%\qiweb_auto_log.txt
cd c:
cd %script_bat%
cd c:

echo %date% %time%  备份 acme.war >> %script_bat%\qiweb_auto_log.txt
rem RENAME %script_bat%\acme.war %script_bat%\acme_%random%_bak.war
ren %script_bat%\acme.war acme_%random%.war
echo %date% %time%  移动到ftp目录 >> %script_bat%\qiweb_auto_log.txt
xcopy /e /i /y %dirs%\launch-single\target\acme\acme.war  %script_bat%\acme.war


echo %date% %time% ftp上传war 到tomcat  >> %script_bat%\qiweb_auto_log.txt


echo open %ftpip% > "%ftpfile%"
rem 把下面行中的 username和password改为你的用户名和密码
echo user %fptuser% %ftppassword% >> "%ftpfile%"
rem ------------------------------
echo bin >> "%ftpfile%"
rem 进入FTP server 中的"X"目录
rem echo cd X >> "%ftpfile%" //如果服务器已经对ftp上传文件进行了配置rem echo cd X >> "%ftpfile%" 注释该行
rem ------------------------------
rem 进入本地C盘根目录
echo lcd %script_bat% >> "%ftpfile%"
rem ------------------------------
echo put %script_bat%\acme.war >> "%ftpfile%"
echo quit >> "%ftpfile%"
echo -------------------------------- >> "%logfile%"
date /t >> "%logfile%"
time /t >> "%logfile%"
echo -------------------------------- >> "%logfile%"
ftp -n < "%ftpfile%" >> "%logfile%"
del "%ftpfile%"
echo @echo on
rem -----------脚本结束---------------


echo %date% %time%  正在发邮件 >>  %script_bat%\qiweb_auto_log.txt
@echo off
:::::::::::::: 参数设置::::::::::::::

::::::::::::::::: 运行blat 发送邮件:::::::::::::::::
%blat_home%\blat %mail% -to %to% -base64 -charset Gb2312 -subject %subj% -attach %attach% -server %server% -f %from% -u %user% -pw %pass% %debug%

#!/bin/bash
#define date
dir=$(date +"%d-%m-%y-backup")

#cek date 
cekdate=$(date | awk '{print $3}' )

#define backup dir
mkdir -p /opt/directory-backup 

#cek retention
cekretention=$(ls  /opt/directory-backup/ | wc -l)

#hapus retention
if [ $cekretention -gt 6 ]
then
	getoldestdir=$(ls -ltr /opt/directory-backup/ | grep backup | head -1 | awk '{print $9}')
	echo move oldest directory
	mv /opt/directory-backup/$getoldestdir /opt/directory-backup/$dir
	echo run backup...
	mkdir -p /opt/directory-backup/$dir/database
	rsync -avzh /opt/directory/* /opt/directory-backup/$dir/
	sshpass -p 'sD&B6Miz#e!d' rsync --progress -avz -e ssh root@192.168.20.157:/opt/mongodata /opt/directory-backup/$dir/database
	echo done backup!

else
	#jalankad
	echo run backup!
	mkdir -p /opt/directory-backup/$dir/database
	rsync -avzh /opt/directory/* /opt/directory-backup/$dir/
	sshpass -p 'sD&B6Miz#e!d' rsync --progress -avz -e ssh root@192.168.20.157:/opt/mongodata /opt/directory-backup/$dir/database
	echo done backup!
fi

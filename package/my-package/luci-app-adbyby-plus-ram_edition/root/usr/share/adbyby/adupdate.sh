#!/bin/sh
Status_1=$1

init(){
	# 防止重复启动
	local pid
	for pid in $(ps | grep "${0##*/}" | grep -v grep | awk '{print $1}' &); do
		[ $pid -ne $$ ] && exit 1
	done

	if ! mount | grep adbyby >/dev/null 2>&1; then
		echo "Adbyby is not mounted,Stop update!"
		exit 1
	fi

	while [ "$Status_1" == "check" ]; do
		wget-ssl --spider --quiet --tries=1 --timeout=3 www.baidu.com >/dev/null 2>&1
		[ "$?" != "0" ] && sleep 2 || break
	done
}

download(){
	rm -f /usr/share/adbyby/data/*.bak
	rm -f /tmp/lazy.txt /tmp/video.txt

	wget-ssl -4 -t 2 -T 3 -O /tmp/lazy.txt https://coding.net/u/adbyby/p/xwhyc-rules/git/raw/master/lazy.txt
	if [ "$?" == "0" ]; then
		echo "Download Adbyby general rules from coding.net success!"
	else
		echo "Download Adbyby general rules from Github..."
		wget-ssl -4 -t 2 -T 10 -O /tmp/lazy.txt https://raw.githubusercontent.com/adbyby/xwhyc-rules/master/lazy.txt
		[ "$?" == "0" ] && echo "Download general rules success!" || echo "Download general rules failed!"
	fi
	wget-ssl -4 -t 2 -T 3 -O /tmp/video.txt https://coding.net/u/adbyby/p/xwhyc-rules/git/raw/master/video.txt
	if [ "$?" == "0" ]; then
		echo "Download Adbyby video rules from coding.net success!"
	else
		echo "Download Adbyby video rules from Github..."
		wget-ssl -4 -t 2 -T 10 -O /tmp/video.txt https://raw.githubusercontent.com/adbyby/xwhyc-rules/master/video.txt
		[ "$?" == "0" ] && echo "Download video rules success!" || echo "Download general rules failed!"
	fi
}

checkfile(){
	md5sum /usr/share/adbyby/data/lazy.txt /usr/share/adbyby/data/video.txt > /tmp/local-md5.json
	wget-ssl -4 -t 2 -T 3 -O /tmp/md5.json https://coding.net/u/adbyby/p/xwhyc-rules/git/raw/master/md5.json || wget-ssl -4 -t 2 -T 10 -O /tmp/md5.json https://raw.githubusercontent.com/adbyby/xwhyc-rules/master/md5.json
	lazy_local=$(grep 'lazy' /tmp/local-md5.json | awk -F' ' '{print $1}')
	video_local=$(grep 'video' /tmp/local-md5.json | awk -F' ' '{print $1}')  
	lazy_online=$(sed  's/":"/\n/g' /tmp/md5.json  |  sed  's/","/\n/g' | sed -n '2p')
	video_online=$(sed  's/":"/\n/g' /tmp/md5.json  |  sed  's/","/\n/g' | sed -n '4p')
	if [ "$lazy_online"x != "$lazy_local"x -o "$video_online"x != "$video_local"x ]; then
		download
		md5sum /tmp/lazy.txt /tmp/video.txt > /tmp/local-md5.json
		lazy_local=$(grep 'lazy' /tmp/local-md5.json | awk -F' ' '{print $1}')
		video_local=$(grep 'video' /tmp/local-md5.json | awk -F' ' '{print $1}')
		if [ "$lazy_online"x == "$lazy_local"x -a "$video_online"x == "$video_local"x ]; then
			mv -f /tmp/lazy.txt /usr/share/adbyby/data/lazy.txt
			mv -f /tmp/video.txt /usr/share/adbyby/data/video.txt
			echo $(date +"%Y-%m-%d %H:%M:%S") > /tmp/adbyby.updated
			Status_2=1
		fi
	fi
	rm -f /tmp/local-md5.json /tmp/md5.json
}

judgment(){
	if [ "$Status_1" == "restartdnsmasq" -a "$Status_2" == "1" ];then
		echo "Adbyby rules and Adblock rules need update!"
		/etc/init.d/adbyby up_stop
	elif [ "$Status_1" == "restartdnsmasq" -a "$Status_2" != "1" ];then
		echo "Adbyby rules no change!"
		echo "Adblock rules need update!"
		cp -f /tmp/adbyby/adbyby_adblock/dnsmasq.adblock /var/etc/dnsmasq-adbyby.d/04-dnsmasq.adblock
		echo "Restart Dnsmasq"
		/etc/init.d/dnsmasq restart >/dev/null 2>&1
		rm -f /tmp/lazy.txt /tmp/video.txt
		echo $(date +"%Y-%m-%d %H:%M:%S") > /tmp/adbyby.updated
		exit 0
	elif [ "$Status_1" != "restartdnsmasq" -a "$Status_2" == "1" ];then
		echo "Adbyby rules need update!"
		/etc/init.d/adbyby up_stop
	else
		echo "All rules no change!"
		rm -f /tmp/lazy.txt /tmp/video.txt
		echo $(date +"%Y-%m-%d %H:%M:%S") > /tmp/adbyby.updated
		exit 0
	fi
	/etc/init.d/adbyby start
}

init
checkfile
judgment

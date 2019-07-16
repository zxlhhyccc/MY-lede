#!/bin/sh

	[ "$1" != "--down" ] && exit 1
	# 防止重复启动
	for pid in $(ps | grep "${0##*/}" | grep -v grep | awk '{print $1}' &); do
		[ $pid -ne $$ ] && exit 1
	done

	if ! mount | grep adbyby >/dev/null 2>&1; then
		echo "Adbyby is not mounted,Stop update!"
		exit 1
	fi

	while : ; do
		wget-ssl --spider --quiet --tries=1 --timeout=3 www.baidu.com >/dev/null 2>&1
		[ "$?" != "0" ] && sleep 2 || break
	done

	echo "开始下载Adblock规则文件..."
	mkdir -p /tmp/adbyby/adbyby_adblock
	wget-ssl -4 -t 2 -T 10 -O /tmp/adbyby/adbyby_adblock/dnsmasq.adblock https://coding.net/u/Small_5/p/adbyby/git/raw/master/dnsmasq.adblock
	if [ "$?" != "0" ];then
		echo "下载Adblock规则失败，请重试！"
		rm -f /tmp/adbyby/adbyby_adblock/dnsmasq.adblock
		exit 1
	fi

	echo "开始下载Adblock规则MD5文件..."
	wget-ssl -4 -t 2 -T 10 -O /tmp/adbyby/adbyby_adblock/md5 https://coding.net/u/Small_5/p/adbyby/git/raw/master/md5_1
	if [ "$?" != "0" ]; then
		echo "下载Adblock规则MD5文件失败，请重试！"
		rm -f /tmp/adbyby/adbyby_adblock/dnsmasq.adblock /tmp/adbyby/adbyby_adblock/md5
		exit 1
	fi

	md5_local=$(md5sum /tmp/adbyby/adbyby_adblock/dnsmasq.adblock | awk -F' ' '{print $1}')
	md5_online=$(sed 's/":"/\n/g' /tmp/adbyby/adbyby_adblock/md5 | sed 's/","/\n/g' | sed -n '2P')
	rm -f /tmp/adbyby/adbyby_adblock/md5
	if [ "$md5_local"x != "$md5_online"x ]; then
		echo "校验Adblock规则MD5失败，请重试！"
		rm -f /tmp/adbyby/adbyby_adblock/adbyby_adblock/dnsmasq.adblock
		exit 1
	fi

	/etc/init.d/adbyby restart >/dev/null 2>&1 &

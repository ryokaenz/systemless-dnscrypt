#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in post-fs-data mode
# More info in the main Magisk thread

if [ ! -e /sdcard/resolvername ]; then 
		echo " " > /sdcard/resolvername; 
fi
if [ "`cat /sdcard/resolvername`" = " " ];then 
		RESOLVER_NAME=dnscrypt.eu-dk
else
		RESOLVER_NAME="`cat /sdcard/resolvername`"
fi
if [ -e "/sdcard/dnscrypt-resolvers.csv" ];then
				RESOLVER_LIST="/sdcard/dnscrypt-resolvers.csv"
				else
				RESOLVER_LIST="$MODDIR/system/etc/dnscrypt-proxy/dnscrypt-resolvers.csv"
fi
dnscrypt-proxy \
--daemonize \
--resolver-name="$RESOLVER_NAME" \
--resolvers-list="$RESOLVER_LIST" && \
iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination 127.0.0.1 && \
iptables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination 127.0.0.1

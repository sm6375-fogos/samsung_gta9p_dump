#!/system/bin/sh

RamSizeGB=`cat /proc/meminfo | grep MemTotal | awk '{print int($2 / 1024 / 1024)}'`
if [ $RamSizeGB -lt 4 ]; then
    echo 0 > /sys/kernel/mm/lru_gen/enabled
else
    echo 7 > /sys/kernel/mm/lru_gen/enabled
fi

#! /system/bin/sh

mode=`getprop debug.perfmond.atrace`
buffer_size=`getprop debug.perfmond.atrace.buffer`
mem_size=`cat /proc/meminfo | grep MemTotal | awk  '{print int($2 / 1024 / 1024)}'`

if [ -f "/data/local/traces/atrace_categories" ]; then
    category_cmd='-f /data/local/traces/atrace_categories'
else
    category_cmd='gfx input view wm am audio camera hal res dalvik rs pm ss aidl sched freq idle binder_lock binder_driver memory memreclaim'
fi

if [ -z "$buffer_size" ]; then
    if [ ${mem_size} -le 4 ]; then
        buffer_size=4096
    else
        buffer_size=16384
    fi
fi

buffer_cmd="-b $buffer_size"

app_cmd="-a com.android.systemui,com.sec.android.app.launcher"

case "$mode" in
    "1")
    atrace --async_start -z -c $buffer_cmd $app_cmd $category_cmd
    setprop debug.perfmond.atrace.enabled true
    ;;
    "2")
    atrace --async_stop
    setprop debug.perfmond.atrace.enabled false
    ;;
    "3")
    name=`getprop debug.perfmond.atrace.name`
    atrace --async_stop -z -c -o /data/local/traces/$name
    chmod 664 /data/local/traces/$name
    atrace --async_start -z -c $buffer_cmd $app_cmd $category_cmd
    ;;
esac

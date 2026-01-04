#!/system/bin/sh
# Copyright (c) 2016, Samsung Electronics Co., Ltd.

# PDP : Preloaded-Data Preservation

if [[ -d /system/preload ]]; then
  echo "[PDP] [pdp_pap__c_p_.sh] there is a /sys /pre folder" > /dev/kmsg
  echo "[PDP] [pdp_pap__c_p_.sh]  size info for each files under /sys /pre :" > /dev/kmsg
  /system/bin/du /system/preload/ -a -d 1 -b > /dev/kmsg

  cd /system/preload

  if [[ -f pdp_systempre_optimized ]]; then

    if [[ -f pdp_sys_pre.tar.gz ]]; then
      echo "[PDP] [pdp_pap__c_p_.s_]  un-tar pdp_sys_pre.tar.gz to /d /a__" > /dev/kmsg
      /system/bin/tar -xpf /system/preload/pdp_sys_pre.tar.gz -C /data/app
      if [ $? -ne 0 ]; then echo "[PDP]![pdp_pap__c_p_.s_] ERROR, untar pdp_sys_pre.tar.gz r= $?" > /dev/kmsg; fi

    else
      echo "[PDP] [pdp_pap__c_p_.sh]  copy files and folders existing in the /s /p to the /d /a" > /dev/kmsg
      /system/bin/cp -v -a -f /system/preload/* /data/app
      if [ $? -ne 0 ]; then echo "[PDP]![pdp_pap__c_p_.sh] ERROR, cp /s/p/* to /d/a r= $?" > /dev/kmsg; fi

      echo "[PDP] [pdp_pap__c_p_.sh]  decompress each *.gz files that exist in the /d /a /APP using gzip" > /dev/kmsg
      echo "[PDP] [pdp_pap__c_p_.sh]  ------------------------------------------------------------------" > /dev/kmsg
      for appdir in `ls -d */`; do
        appname="$(basename ${appdir})"
        cd /data/app/${appname}
        echo "[PDP] [pdp_pap__c_p_.sh]  decompress *.gz files at /data/app/${appname}" > /dev/kmsg
        find . -type f -maxdepth 1 -name '*.gz' -exec gzip -d '{}' \;
        # cd -
      done
    fi

    if [[ -f /data/pdp_bkup/sys_pre_dex.tar ]]; then
      echo "[PDP] [pdp_pap__c_p_.s_]  un-tar sys_pre_dex.tar to /d /a__" > /dev/kmsg
      /system/bin/tar -xpf /data/pdp_bkup/sys_pre_dex.tar -C /data/app
      if [ $? -ne 0 ]; then echo "[PDP]![pdp_pap__c_p_.s_] ERROR, untar sys_pre_dex.tar r= $?" > /dev/kmsg; fi

      /system/bin/rm -f /data/pdp_bkup/sys_pre_dex.tar
    fi

  else
    echo "[PDP] [pdp_pap__c_p_.sh] legacy file copy routine" > /dev/kmsg
    echo "[PDP] [pdp_pap__c_p_.sh]  copy apks from /sys /pre /* to /da /ap" > /dev/kmsg
    /system/bin/cp -v -a -f /system/preload/* /data/app
    if [ $? -ne 0 ]; then echo "[PDP]![pdp_pap__c_p_.sh] ERROR, cp /s/p/* to /d/a r= $?" > /dev/kmsg; fi

  fi

  cd -
fi



if [[ -d /system/carrier/preload ]]; then
  echo "[PDP] [pdp_pap__c_p_.sh] there is a /sys /car /pre folder" > /dev/kmsg
  echo "[PDP] [pdp_pap__c_p_.sh]  size info for each files under /sys /car /pre :" > /dev/kmsg
  /system/bin/du /system/carrier/preload/ -a -d 1 -b > /dev/kmsg

  cd /system/carrier/preload

  if [[ -f pdp_syscarpre_optimized ]]; then

    if [[ -f pdp_syscrpr.tar.gz ]]; then
      echo "[PDP] [pdp_pap__c_p_.s_]  un-tar pdp_syscrpr.tar.gz to /d /a__" > /dev/kmsg
      /system/bin/tar -xpf /system/carrier/preload/pdp_syscrpr.tar.gz -C /data/app
      if [ $? -ne 0 ]; then echo "[PDP]![pdp_pap__c_p_.s_] ERROR, untar pdp_syscrpr.tar.gz r= $?" > /dev/kmsg; fi

    else
      echo "[PDP] [pdp_pap__c_p_.sh]  decompress & un-tar each *.tar.gz at /s /c /p :" > /dev/kmsg
      find . -type f -maxdepth 1 -name '*.tar.gz' -exec tar -xpf '{}' -C /data/app \;

    fi

    if [[ -f /data/pdp_bkup/syscrpr_dex.tar ]]; then
      echo "[PDP] [pdp_pap__c_p_.s_]  un-tar syscrpr_dex.tar to /d /a__" > /dev/kmsg
      /system/bin/tar -xpf /data/pdp_bkup/syscrpr_dex.tar -C /data/app
      if [ $? -ne 0 ]; then echo "[PDP]![pdp_pap__c_p_.s_] ERROR, untar syscrpr_dex.tar r= $?" > /dev/kmsg; fi

      /system/bin/rm -f /data/pdp_bkup/syscrpr_dex.tar
    fi

  else
    echo "[PDP] [pdp_pap__c_p_.sh] legacy file copy routine" > /dev/kmsg
    echo "[PDP] [pdp_pap__c_p_.sh]  copy apks from /sys /car /pre /* to /da /ap" > /dev/kmsg
    /system/bin/cp -v -a -f /system/carrier/preload/* /data/app
    if [ $? -ne 0 ]; then echo "[PDP]![pdp_pap__c_p_.sh] ERROR, cp /s/c/p/* to /d/a r= $?" > /dev/kmsg; fi

  fi

  cd -
fi



# /system/bin/chmod -R 0664 /data/app 2> /dev/kmsg
# /system/bin/chown -R system /data/app 2> /dev/kmsg
# /system/bin/chgrp -R system /data/app 2> /dev/kmsg

# echo "[PDP] [pdp_pap__c_p_.sh]  du /da /ap" > /dev/kmsg
# /system/bin/du /data/app > /dev/kmsg

# init process is waiting for this work to be finished.  let it knows.
echo "[PDP] [pdp_pap__c_p_.sh]  done" > /dev/kmsg
/system/bin/mkdir -p /data/pdp_bkup/fsh_papps_cp_done

# End of Preload_Apps_Copy.sh

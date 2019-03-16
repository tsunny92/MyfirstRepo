#!/bin/bash
user_report="/tmp/users_disk_usage"
if [ -f "$user_report" ]
then
    > /tmp/users_disk_usage
else
    echo "File do not exist, creating it"
fi
# Cpanel user list
users=( $(sudo ls /var/cpanel/users) )
# Here For disk abusers 5242880 is set i.e. 5GB
for i in "${users[@]}"
    do
      #diskusage=`sudo quota -u $i | tail -n1 | awk '{print $2}'|cut -d '*' -f1`
      diskusage=`sudo repquota /home | grep $users  | awk '{print $3}'`
      if [[ $diskusage -gt 5242880 ]]
       then
       #diskusage=`sudo quota -u $i | tail -n1 | awk '{gb= $2 /1024/1024; printf "%.f", gb ; print " GB"}'`
        diskusage=`sudo repquota /home | grep $users  | awk '{gb= $3 /1024/1024; printf "%.f", gb ; print " GB"}'`
        sudo echo -e "$i : $diskusage" >> /tmp/users_disk_usage
      fi
done
echo "`sort -nrk3 /tmp/users_disk_usage | column -t`" > /tmp/users_disk_usage

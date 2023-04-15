#!/bin/bash

# Architechture
architech=$(uname -a)

#CPU physical
cpu_phy=$(grep ^"core id" /proc/cpuinfo | sort -u | wc -l)

#CPU virtual
cpu_vir=$(cat /proc/cpuinfo | grep processor | wc -l)

#RAM
total_mem=$(free --mega | awk '$1 == "Mem:" {print $2}')
used_mem=$(free --mega | awk '$1 == "Mem:" {print $3}')
percentage_mem=$(free --mega | awk '$1 == "Mem:" {printf ("%.2f"), $3/$2 * 100}')

#Disk Usage
total_disk=$(df -m | grep "/dev/" | grep -v "/root" | awk '{total += $2} END {printf ("%.1fGb\n"), total/1024}')
used_disk=$(df -m | grep "/dev/" |grep -v "/root" | awk '{used += $3} END {printf ("%.1fGb\n"), used/1024}')
percentage_disk=$(df -m | grep "/dev/" | grep -v "/root" | awk '{total += $2} {used += $3} END {printf ("%d"), used/total*100}')

#CPU load
cpu_load=$(mpstat -P ALL | awk 'NR == 4 {for (i=4; i < 13; i++) total+=$i; print total; i=0}')

#Last Reboot
last_re=$(uptime -s)

#LVM active or not
LVM_use=$(if [ $(lsblk | grep "LVM" | wc -l) == 0 ]; then echo no; else echo yes; fi)

#Connections
estab_conn=$(ss -ta | grep ESTAB | wc -l)

#User Amount
nbr_usr=$(who | wc -l)

#IPv4 and MAC address
IPv4=$(hostname -I)
MAC=$(ip link | grep ether | awk '{print $2}')

#Sudo Command Amount
sudo=$(journalctl _COMM=sudo | grep COMMAND | wc -l)



wall " 	#Architecture: $architech
	#CPU physical : $cpu_phy
	#vCPU : $cpu_vir
	#Memory Usage: $used_mem/${total_mem}MB ($percentage_mem%)
	#Disk Usage: $used_disk/$total_disk ($percentage_disk%)
	#CPU load: $cpu_load%
	#Last boot: $last_re
	#LVM use: $LVM_use
	#Connections TCP : $estab_conn ESTABLISHED
	#User log: $nbr_usr
	#Network: $IPv4 ($MAC)
	#Sudo : $sudo cmd"
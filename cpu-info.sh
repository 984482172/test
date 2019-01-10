#!/bin/bash
#filename: cpu-info.sh
#this script only work in a Linux sysytem which has one or more identical physical CPU(s)

echo -n "logical CPU number in total:"
cat /proc/cpuinfo | grep "processor" | wc -l
cat /proc/cpuinfo | grep -qi "core id"
if [ $? -ne 0 ]; then
        echo "Warning. No multi-core or hyper-threading is enabled."
        exit 0;
fi

echo -n "physical CPU number in total:"

cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l
echo -n "core number in a physical CPU:"

core_per_phy_cpu=$(cat /proc/cpuinfo | grep "core id" | sort | uniq | wc -l)
echo $core_per_phy_cpu
echo -n "logical CPU number in a physical CPU:"

logical_cpu_per_phy_cpu=$(cat /proc/cpuinfo | grep "siblings" | sort | uniq | awk -F: '{print $2}')
echo $logical_cpu_per_phy_cpu


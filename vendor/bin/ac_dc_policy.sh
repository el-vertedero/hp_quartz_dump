#=============================================================================
# Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
# All rights reserved.
# Confidential and Proprietary - Qualcomm Technologies, Inc.
#=============================================================================

case "$1" in
        AC)
                # Frequency ramp up to hispeed frequency at 85% load instead of 90%.
                echo 85 > /sys/devices/system/cpu/cpu4/cpufreq/walt/hispeed_load
                echo 85 > /sys/devices/system/cpu/cpu8/cpufreq/walt/hispeed_load

                # RTG (Related task group) tasks immediately wake up at higher floor frequency.
                echo 998400  > /sys/devices/system/cpu/cpu0/cpufreq/walt/rtg_boost_freq
                echo 1190400 > /sys/devices/system/cpu/cpu4/cpufreq/walt/rtg_boost_freq

                # When utilization reaches 70% (reduced from 80%) of capacity in current window,
                # frequency is ramped up to next corner.
                echo "2147483647 70" > /sys/devices/system/cpu/cpu0/cpufreq/walt/zone_max_util_pct
                echo "2147483647 70" > /sys/devices/system/cpu/cpu4/cpufreq/walt/zone_max_util_pct
                echo "2147483647 70" > /sys/devices/system/cpu/cpu8/cpufreq/walt/zone_max_util_pct

                # Enabling colocation to help topapp task placement and get better freq guidance.
                echo 80 > /proc/sys/walt/sched_group_downmigrate
                echo 95 > /proc/sys/walt/sched_group_upmigrate

                # Not restricting any CPUs of cluster1 via core_ctl.
                echo 4 > /sys/devices/system/cpu/cpu4/core_ctl/min_cpus
                echo 100  > /sys/devices/system/cpu/cpu4/core_ctl/offline_delay_ms
                echo 0 0 0 0 > /sys/devices/system/cpu/cpu4/core_ctl/not_preferred

                # Highly aggressive migration for topapp tasks to cluster1 and
                # moderate migration for other cgroups.
                echo 95 85 > /proc/sys/walt/cluster0/sched_background_updownmigrate
                echo 75 65 > /proc/sys/walt/cluster0/sched_foreground_updownmigrate
                echo 80 70 > /proc/sys/walt/cluster0/sched_other_cgroup_updownmigrate
                echo 30 20 > /proc/sys/walt/cluster0/sched_topapp_updownmigrate

                # Utilization threshold % to consider CPU busy.
                echo 30 30 30 30 20 20 20 20 20 20 15 15 > /proc/sys/walt/sched_util_busy_hyst_cpu_util

                # Reducing the scheduling decision window from 16ms to 8ms.
                echo 2 > /proc/sys/walt/sched_ravg_window_nr_ticks
        ;;
        DC)
                echo 90 > /sys/devices/system/cpu/cpu4/cpufreq/walt/hispeed_load
                echo 90 > /sys/devices/system/cpu/cpu8/cpufreq/walt/hispeed_load

                echo 806400 > /sys/devices/system/cpu/cpu0/cpufreq/walt/rtg_boost_freq
                echo 806400 > /sys/devices/system/cpu/cpu4/cpufreq/walt/rtg_boost_freq

                echo "2611200 90" > /sys/devices/system/cpu/cpu0/cpufreq/walt/zone_max_util_pct
                echo "2147483647 80" > /sys/devices/system/cpu/cpu4/cpufreq/walt/zone_max_util_pct
                echo "2147483647 80" > /sys/devices/system/cpu/cpu8/cpufreq/walt/zone_max_util_pct

                echo 0 > /proc/sys/walt/sched_group_downmigrate
                echo 0 > /proc/sys/walt/sched_group_upmigrate

                echo 2 > /sys/devices/system/cpu/cpu4/core_ctl/min_cpus
                echo 100 > /sys/devices/system/cpu/cpu4/core_ctl/offline_delay_ms
                echo 0 0 1 1 > /sys/devices/system/cpu/cpu4/core_ctl/not_preferred

                echo 95 85 > /proc/sys/walt/cluster0/sched_background_updownmigrate
                echo 95 85 > /proc/sys/walt/cluster0/sched_foreground_updownmigrate
                echo 95 85 > /proc/sys/walt/cluster0/sched_other_cgroup_updownmigrate
                echo 95 85 > /proc/sys/walt/cluster0/sched_topapp_updownmigrate

                echo 30 30 30 30 30 30 15 15 30 30 15 15 > /proc/sys/walt/sched_util_busy_hyst_cpu_util

                echo 4 > /proc/sys/walt/sched_ravg_window_nr_ticks
        ;;
esac

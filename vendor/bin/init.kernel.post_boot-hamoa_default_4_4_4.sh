#=============================================================================
# Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
# All rights reserved.
# Confidential and Proprietary - Qualcomm Technologies, Inc.
#=============================================================================

rev=`cat /sys/devices/soc0/revision`

# Configure RT parameters:
# Long running RT task detection is confined to consolidated builds.
# Set RT throttle runtime to 50ms more than long running RT
# task detection time.
# Set RT throttle period to 100ms more than RT throttle runtime.
long_running_rt_task_ms=1200
sched_rt_runtime_ms=`expr $long_running_rt_task_ms + 50`
sched_rt_runtime_us=`expr $sched_rt_runtime_ms \* 1000`
sched_rt_period_ms=`expr $sched_rt_runtime_ms + 100`
sched_rt_period_us=`expr $sched_rt_period_ms \* 1000`
echo $sched_rt_period_us > /proc/sys/kernel/sched_rt_period_us
echo $sched_rt_runtime_us > /proc/sys/kernel/sched_rt_runtime_us

if [ -d /proc/sys/walt ]; then
	# configure maximum frequency when CPUs are partially halted
	echo 2147483647 > /proc/sys/walt/sched_max_freq_partial_halt

	# Core control parameters
	echo 4 > /sys/devices/system/cpu/cpu0/core_ctl/min_cpus
	echo 60 > /sys/devices/system/cpu/cpu0/core_ctl/busy_up_thres
	echo 30 > /sys/devices/system/cpu/cpu0/core_ctl/busy_down_thres
	echo 100 > /sys/devices/system/cpu/cpu0/core_ctl/offline_delay_ms
	echo 4 > /sys/devices/system/cpu/cpu0/core_ctl/task_thres
	echo 0 0 0 0 > /sys/devices/system/cpu/cpu0/core_ctl/not_preferred
	echo 0xFFF > /sys/devices/system/cpu/cpu0/core_ctl/nrrun_cpu_mask
	echo 0x00 > /sys/devices/system/cpu/cpu0/core_ctl/nrrun_cpu_misfit_mask
	echo 0x00 > /sys/devices/system/cpu/cpu0/core_ctl/assist_cpu_mask
	echo 0x00 > /sys/devices/system/cpu/cpu0/core_ctl/assist_cpu_misfit_mask

	echo 2 > /sys/devices/system/cpu/cpu4/core_ctl/min_cpus
	echo 60 > /sys/devices/system/cpu/cpu4/core_ctl/busy_up_thres
	echo 30 > /sys/devices/system/cpu/cpu4/core_ctl/busy_down_thres
	echo 100 > /sys/devices/system/cpu/cpu4/core_ctl/offline_delay_ms
	echo 4 > /sys/devices/system/cpu/cpu4/core_ctl/task_thres
	echo 0 0 1 1 > /sys/devices/system/cpu/cpu4/core_ctl/not_preferred
	echo 0xFF0 > /sys/devices/system/cpu/cpu4/core_ctl/nrrun_cpu_mask
	echo 0x00 > /sys/devices/system/cpu/cpu4/core_ctl/nrrun_cpu_misfit_mask
	echo 0x00 > /sys/devices/system/cpu/cpu4/core_ctl/assist_cpu_mask
	echo 0x00 > /sys/devices/system/cpu/cpu4/core_ctl/assist_cpu_misfit_mask

	echo 2 > /sys/devices/system/cpu/cpu8/core_ctl/min_cpus
	echo 60 > /sys/devices/system/cpu/cpu8/core_ctl/busy_up_thres
	echo 30 > /sys/devices/system/cpu/cpu8/core_ctl/busy_down_thres
	echo 100 > /sys/devices/system/cpu/cpu8/core_ctl/offline_delay_ms
	echo 4 > /sys/devices/system/cpu/cpu8/core_ctl/task_thres
	echo 0 0 1 1 > /sys/devices/system/cpu/cpu8/core_ctl/not_preferred
	echo 0xF00 > /sys/devices/system/cpu/cpu8/core_ctl/nrrun_cpu_mask
	echo 0x00 > /sys/devices/system/cpu/cpu8/core_ctl/nrrun_cpu_misfit_mask
	echo 0x00 > /sys/devices/system/cpu/cpu8/core_ctl/assist_cpu_mask
	echo 0x00 > /sys/devices/system/cpu/cpu8/core_ctl/assist_cpu_misfit_mask

	echo 1 > /sys/devices/system/cpu/cpu0/core_ctl/enable
	echo 1 > /sys/devices/system/cpu/cpu4/core_ctl/enable
	echo 1 > /sys/devices/system/cpu/cpu8/core_ctl/enable

	#Disable big task rotation
	echo 0 > /proc/sys/walt/sched_walt_rotate_big_tasks

	# Configure Single Boost Thread
	echo 0 > /proc/sys/walt/sched_sbt_delay_windows
	echo 0x00 > /proc/sys/walt/sched_sbt_pause_cpus

	# Setting b.L scheduler parameters
	echo 95 85 > /proc/sys/walt/cluster0/sched_background_updownmigrate
	echo 95 85 > /proc/sys/walt/cluster0/sched_foreground_updownmigrate
	echo 95 85 > /proc/sys/walt/cluster0/sched_other_cgroup_updownmigrate
	echo 95 85 > /proc/sys/walt/cluster0/sched_topapp_updownmigrate
	echo 95 85 > /proc/sys/walt/cluster1/sched_background_updownmigrate
	echo 95 85 > /proc/sys/walt/cluster1/sched_foreground_updownmigrate
	echo 95 85 > /proc/sys/walt/cluster1/sched_other_cgroup_updownmigrate
	echo 95 85 > /proc/sys/walt/cluster1/sched_topapp_updownmigrate

	# By setting group upmigrate/downmigrate to 0, colocation is disabled.
	echo 0 > /proc/sys/walt/sched_group_downmigrate
	echo 0 > /proc/sys/walt/sched_group_upmigrate
	echo 400000000 > /proc/sys/walt/sched_coloc_downmigrate_ns
	echo 8500000 1000000 1000000 1000000 1000000 1000000 2000000 2000000 1000000 1000000 2000000 2000000 > /proc/sys/walt/sched_coloc_busy_hyst_cpu_ns
	echo 4095 > /proc/sys/walt/sched_coloc_busy_hysteresis_enable_cpus
	echo 10 10 10 10 10 10 95 95 10 10 95 95 > /proc/sys/walt/sched_coloc_busy_hyst_cpu_busy_pct
	echo 8500000 1000000 1000000 1000000 1000000 1000000 2000000 2000000 1000000 1000000 2000000 2000000 > /proc/sys/walt/sched_util_busy_hyst_cpu_ns
	echo 4095 > /proc/sys/walt/sched_util_busy_hysteresis_enable_cpus
	echo 30 30 30 30 30 30 15 15 30 30 15 15 > /proc/sys/walt/sched_util_busy_hyst_cpu_util
	echo 40 > /proc/sys/walt/sched_cluster_util_thres_pct
	echo 30 > /proc/sys/walt/sched_idle_enough
	echo 10 > /proc/sys/walt/sched_ed_boost

	#Set early upmigrate tunables
	sched_upmigrate=`cat /proc/sys/walt/sched_upmigrate`
	sched_downmigrate=`cat /proc/sys/walt/sched_downmigrate`
	sched_upmigrate=${sched_upmigrate:0:2}
	sched_downmigrate=${sched_downmigrate:0:2}
	gold_early_upmigrate=`expr \( 1024 \* 100 \) \/ $sched_upmigrate`
	gold_early_downmigrate=`expr \( 1024 \* 100 \) \/ $sched_downmigrate`
	echo $gold_early_downmigrate > /proc/sys/walt/sched_early_downmigrate
	echo $gold_early_upmigrate > /proc/sys/walt/sched_early_upmigrate

	# Enable 9 10 11 CPUs for pipeline
	echo 3584 > /proc/sys/walt/sched_pipeline_cpus
	# Enable config 1 by default for pipeline, config2 doesn't play any role
	echo 1 > /proc/sys/walt/sched_pipeline_force_config

	# set the threshold for low latency task boost feature which prioritize
	# binder activity tasks
	echo 325 > /proc/sys/walt/walt_low_latency_task_threshold

	echo 105 > /proc/sys/walt/sched_topapp_weight_pct

	# configure maximum frequency of large and medium cluster for
	# different smart freq ipc reasons
	# Note: Update after perf/power eval
	echo 2147483647 2147483647 2147483647 2147483647 2147483647 > /proc/sys/walt/cluster0/smart_freq/ipc_freq_levels
	echo 2147483647 2147483647 2147483647 2147483647 2147483647 > /proc/sys/walt/cluster1/smart_freq/ipc_freq_levels
	echo 2147483647 2147483647 2147483647 2147483647 2147483647 > /proc/sys/walt/cluster2/smart_freq/ipc_freq_levels

	# Turn off scheduler boost at the end
	echo 0 > /proc/sys/walt/sched_boost

	echo 806400 0 0 0 0 0 0 0 0 0 0 0 > /proc/sys/walt/input_boost/input_boost_freq
	echo 100 > /proc/sys/walt/input_boost/input_boost_ms

	echo "walt" > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
	echo "walt" > /sys/devices/system/cpu/cpufreq/policy4/scaling_governor
	echo "walt" > /sys/devices/system/cpu/cpufreq/policy8/scaling_governor

	echo 0 > /sys/devices/system/cpu/cpufreq/policy0/walt/down_rate_limit_us
	echo 0 > /sys/devices/system/cpu/cpufreq/policy0/walt/up_rate_limit_us
	echo 0 > /sys/devices/system/cpu/cpufreq/policy4/walt/down_rate_limit_us
	echo 0 > /sys/devices/system/cpu/cpufreq/policy4/walt/up_rate_limit_us
	echo 0 > /sys/devices/system/cpu/cpufreq/policy8/walt/down_rate_limit_us
	echo 0 > /sys/devices/system/cpu/cpufreq/policy8/walt/up_rate_limit_us

	echo 1 > /sys/devices/system/cpu/cpufreq/policy0/walt/pl
	echo 1 > /sys/devices/system/cpu/cpufreq/policy4/walt/pl
	echo 1 > /sys/devices/system/cpu/cpufreq/policy8/walt/pl

	echo 2611200 90 > /sys/devices/system/cpu/cpufreq/policy0/walt/zone_max_util_pct

	# Note: Update after perf/power eval
	echo 710400 > /sys/devices/system/cpu/cpufreq/policy0/walt/rtg_boost_freq
	echo 806400 > /sys/devices/system/cpu/cpufreq/policy4/walt/rtg_boost_freq
	echo 806400 > /sys/devices/system/cpu/cpufreq/policy8/walt/rtg_boost_freq
	echo 1190400 > /sys/devices/system/cpu/cpufreq/policy0/walt/hispeed_freq
	echo 2188800 > /sys/devices/system/cpu/cpufreq/policy4/walt/hispeed_freq
	echo 2188800 > /sys/devices/system/cpu/cpufreq/policy8/walt/hispeed_freq
else
	echo "schedutil" > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
	echo "schedutil" > /sys/devices/system/cpu/cpufreq/policy4/scaling_governor
	echo "schedutil" > /sys/devices/system/cpu/cpufreq/policy8/scaling_governor
	echo 1 > /proc/sys/kernel/sched_pelt_multiplier
fi

# Note: Update after perf/power eval
echo 710400 > /sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq
echo 806400 > /sys/devices/system/cpu/cpufreq/policy4/scaling_min_freq
echo 806400 > /sys/devices/system/cpu/cpufreq/policy8/scaling_min_freq
echo "0:710400 4:806400 8:806400" > /data/vendor/perfd/default_scaling_min_freq

# configure bus-dcvs
bus_dcvs="/sys/devices/system/cpu/bus_dcvs"

for device in $bus_dcvs/*
do
	case "$device" in
		*/memlat_settings) continue ;;
	esac

	cat $device/hw_min_freq > $device/boost_freq
done

for llccbw in $bus_dcvs/LLCC/*bwmon-llcc-*
do
	echo "4302 5340 8132 9240 12298 14236 16265 18478 20599" > $llccbw/mbps_zones
	echo 4 > $llccbw/sample_ms
	echo 80 > $llccbw/io_percent
	echo 20 > $llccbw/hist_memory
	echo 5 > $llccbw/hyst_length
	echo 1 > $llccbw/idle_length
	echo 30 > $llccbw/down_thres
	echo 0 > $llccbw/guard_band_mbps
	echo 250 > $llccbw/up_scale
	echo 1600 > $llccbw/idle_mbps
	echo 806000 > $llccbw/max_freq
	echo 25000 > $llccbw/max_freq_max_mbps
	echo 70 > $llccbw/ab_scale
	echo 40 > $llccbw/window_ms
done

for llccbw in $bus_dcvs/LLCC/*bwmon-llcc-gold
do
	echo 120 > $llccbw/io_percent
	echo 180 > $llccbw/low_power_io_percent
	echo "1017600 1017600 1017600" > $llccbw/max_low_power_cluster_freqs
	echo 40000 > $llccbw/max_freq_max_mbps
	echo 1350000 > $llccbw/sched_boost_freq
	echo 1 > $llccbw/use_sched_boost
done

for ddrbw in $bus_dcvs/DDR/*bwmon-ddr
do
	echo "2086 5161 7980 12157 14060 16113 18234 20343" > $ddrbw/mbps_zones
	echo 4 > $ddrbw/sample_ms
	echo 120 > $ddrbw/io_percent
	echo 180 > $ddrbw/low_power_io_percent
	echo "1017600 1017600 1017600" > $ddrbw/max_low_power_cluster_freqs
	echo 20 > $ddrbw/hist_memory
	echo 5 > $ddrbw/hyst_length
	echo 1 > $ddrbw/idle_length
	echo 30 > $ddrbw/down_thres
	echo 0 > $ddrbw/guard_band_mbps
	echo 250 > $ddrbw/up_scale
	echo 1600 > $ddrbw/idle_mbps
	echo 3187000 > $ddrbw/max_freq
	echo 70 > $ddrbw/ab_scale
	echo 40 > $ddrbw/window_ms
done

for qosclusterX in $bus_dcvs/DDRQOS/*clusterX
do
	echo 20000000 > $qosclusterX/ipm_ceil
done

for ddrclusterX in $bus_dcvs/DDR/*clusterX
do
	echo 20000000 > $ddrclusterX/ipm_ceil
done

for llccclusterX in $bus_dcvs/LLCC/*clusterX
do
	echo 20000000 > $llccclusterX/ipm_ceil
done

echo 4 > /proc/sys/kernel/printk

# Change console log level as per console config property
console_config=`getprop persist.vendor.console.silent.config`
case "$console_config" in
	"1")
		echo "Enable console config to $console_config"
		echo 0 > /proc/sys/kernel/printk
	;;
	*)
		echo "Enable console config to $console_config"
	;;
esac

setprop vendor.post_boot.parsed 1

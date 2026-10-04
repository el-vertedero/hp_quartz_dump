#=============================================================================
# Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
# All Rights Reserved.
# Confidential and Proprietary - Qualcomm Technologies, Inc.
#=============================================================================

rev=`cat /sys/devices/soc0/revision`

echo s2idle > /sys/power/mem_sleep
echo qcom-cpu-lpm > /sys/devices/system/cpu/cpuidle/current_governor
echo N > /sys/devices/system/cpu/qcom_lpm/parameters/sleep_disabled

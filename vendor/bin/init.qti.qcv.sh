#! /vendor/bin/sh
#=============================================================================
# Copyright (c) 2020, 2021 Qualcomm Technologies, Inc.
# All Rights Reserved.
# Confidential and Proprietary - Qualcomm Technologies, Inc.
#=============================================================================

if [ -f /sys/devices/soc1/soc_id ]; then
    soc_id=`cat /sys/devices/soc1/soc_id` 2> /dev/null
else
    soc_id=`cat /sys/devices/soc0/soc_id` 2> /dev/null
fi

if [ -f /sys/devices/soc1/chip_id ]; then
    chip_id=`cat /sys/devices/soc1/chip_id` 2> /dev/null
else
    chip_id=`cat /sys/devices/soc0/chip_id` 2> /dev/null
fi
soc_revision=`cat /sys/devices/soc0/revision` 2> /dev/null

# Store soc_id in ro.vendor.qti.soc_id
setprop ro.vendor.qti.soc_id $soc_id

soc_model="$chip_id"

if [ "$soc_id" -eq 555 ]; then
    soc_model="Snapdragon X Elite - X1E80100 - Qualcomm Oryon CPU"
fi

setprop ro.vendor.qti.soc_model "$soc_model"

# Get product board platform from ro.board.platform
board_name="$(getprop ro.board.platform)"

# For chipsets in QCV family, convert soc_id to soc_name
# and store it in ro.vendor.qti.soc_name.
if [ "$soc_id" -eq 707 ] || [ "$soc_id" -eq 708 ] || [ "$soc_id" -eq 755 ] || [ "$soc_id" -eq 760 ]; then
    setprop ro.vendor.qti.soc_name art
    setprop ro.vendor.media_performance_class 37
elif [ "$soc_id" -eq 741 ] || [ "$soc_id" -eq 735 ]; then
    setprop ro.vendor.qti.soc_name pebble
    setprop ro.vendor.qti.soc_revision $soc_revision
elif [ "$soc_id" -eq 660 ] || [ "$soc_id" -eq 661 ] || [ "$soc_id" -eq 704 ]; then
    setprop ro.vendor.qti.soc_name canoe
    setprop ro.vendor.media_performance_class 35
elif [ "$soc_id" -eq 555 ] && [ "$board_name" = "hamoa_la" ]; then
    setprop ro.vendor.qti.soc_name hamoa_la
elif [ "$soc_id" -eq 555 ]; then
    setprop ro.vendor.qti.soc_name hamoa
fi

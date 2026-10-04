#=============================================================================
# Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
# All Rights Reserved.
# Confidential and Proprietary - Qualcomm Technologies, Inc.
#=============================================================================

if [ -f /sys/devices/soc0/soc_id ]; then
	platformid=`cat /sys/devices/soc0/soc_id`
fi

if [ -f /sys/devices/soc1/soc_id ]; then
	platformid=`cat /sys/devices/soc1/soc_id`
fi

case "$platformid" in
	"555")
		# pass as an argument the number of max clusters supported
		/vendor/bin/sh /vendor/bin/init.kernel.post_boot-hamoa.sh 3
		;;
	"635")
		# pass as an argument the number of max clusters supported
		/vendor/bin/sh /vendor/bin/init.kernel.post_boot-purwa.sh 2
		;;
	*)
		echo "***WARNING***: Invalid SoC ID\n\t No postboot settings applied!!\n"
		;;
esac

#!/bin/sh

INSTALLABLE_PARTITIONS="28 30 32 36"
  INSTALLABLE_PARTITION_IMAGES="modem.img bluetooth.img dsp.img persist.img"
  write_base_table() {
  set +e
  local target="$1"
  create_image "${target}" 19189030915
  local blocks
  block_size=$(blocksize "${target}")
  numsecs=$(numsectors "${target}")
  local curr=$(( 32768 ))
  # Make sure Padding is block_size aligned.
  if [ $(( 0 & (block_size - 1) )) -gt 0 ]; then
    echo "Primary Entry Array padding is not block aligned." >&2
    exit 1
  fi
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 134217728 / $block_size`
  if [ `expr 134217728 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 38 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "ota_recovery_a" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  blocks=`expr 1 / $block_size`
  if [ `expr 1 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 2 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "KERN-A" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  blocks=`expr 1 / $block_size`
  if [ `expr 1 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 4 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "KERN-B" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  blocks=`expr 1 / $block_size`
  if [ `expr 1 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 5 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "ROOT-B" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 12884901888 / $block_size`
  if [ `expr 12884901888 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 3 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "super" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  blocks=`expr 4194304 / $block_size`
  if [ `expr 4194304 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 7 `expr $curr / $block_size` ${blocks} 88434509-D9D1-487D-B82C-15EF964CBD4B "vbmeta_a" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  blocks=`expr 4194304 / $block_size`
  if [ `expr 4194304 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 8 `expr $curr / $block_size` ${blocks} 88434509-D9D1-487D-B82C-15EF964CBD4B "vbmeta_b" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 8388608 / $block_size`
  if [ `expr 8388608 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 9 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "init_boot_a" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 8388608 / $block_size`
  if [ `expr 8388608 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 10 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "init_boot_b" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 33554432 / $block_size`
  if [ `expr 33554432 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 11 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "vendor_boot_a" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 33554432 / $block_size`
  if [ `expr 33554432 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 12 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "vendor_boot_b" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  blocks=`expr 67108864 / $block_size`
  if [ `expr 67108864 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 13 `expr $curr / $block_size` ${blocks} FE3A2A5D-4F32-41A7-B725-ACCC3285A309 "boot_a" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  blocks=`expr 67108864 / $block_size`
  if [ `expr 67108864 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 14 `expr $curr / $block_size` ${blocks} FE3A2A5D-4F32-41A7-B725-ACCC3285A309 "boot_b" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 4194304 / $block_size`
  if [ `expr 4194304 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 15 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "pvmfw_a" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 4194304 / $block_size`
  if [ `expr 4194304 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 16 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "pvmfw_b" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 2097152 / $block_size`
  if [ `expr 2097152 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 17 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "dtb_a" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 8388608 / $block_size`
  if [ `expr 8388608 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 18 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "dtbo_a" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 2097152 / $block_size`
  if [ `expr 2097152 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 19 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "dtb_b" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 8388608 / $block_size`
  if [ `expr 8388608 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 20 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "dtbo_b" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 16777216 / $block_size`
  if [ `expr 16777216 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 21 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "desktop_security_persist" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 33554432 / $block_size`
  if [ `expr 33554432 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 22 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "desktop_security_storage" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 4194304 / $block_size`
  if [ `expr 4194304 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 23 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "misc" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 67108864 / $block_size`
  if [ `expr 67108864 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 24 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "metadata" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 33554432 / $block_size`
  if [ `expr 33554432 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 25 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "recovery_a" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 33554432 / $block_size`
  if [ `expr 33554432 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 26 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "recovery_b" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 2097152 / $block_size`
  if [ `expr 2097152 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 27 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "frp_persist" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 367001600 / $block_size`
  if [ `expr 367001600 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 28 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "modem_a" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 367001600 / $block_size`
  if [ `expr 367001600 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 29 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "modem_b" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 8388608 / $block_size`
  if [ `expr 8388608 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 30 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "bluetooth_a" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 8388608 / $block_size`
  if [ `expr 8388608 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 31 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "bluetooth_b" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 78643200 / $block_size`
  if [ `expr 78643200 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 32 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "dsp_a" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 78643200 / $block_size`
  if [ `expr 78643200 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 33 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "dsp_b" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 10485760 / $block_size`
  if [ `expr 10485760 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 34 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "keymaster_a" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 10485760 / $block_size`
  if [ `expr 10485760 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 35 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "keymaster_b" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 33554432 / $block_size`
  if [ `expr 33554432 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 36 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "persist" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  blocks=`expr 268435456 / $block_size`
  if [ `expr 268435456 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 37 `expr $curr / $block_size` ${blocks} 66C9B323-F7FC-48B6-BF96-6F32E335A428 "rawdump" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr $numsecs - \( $curr + 24576 \) / $block_size`
  reserved_blocks=`expr 134217728 / $block_size`
  if [ `expr 134217728 % $block_size` -gt 0 ]; then
     reserved_blocks=`expr $reserved_blocks + 1`
  fi
  blocks=`expr $blocks - $reserved_blocks`
  part_add 1 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "userdata" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  reserved_blocks=`expr 134217728 / $block_size`
  if [ `expr 134217728 % $block_size` -gt 0 ]; then
     reserved_blocks=`expr $reserved_blocks + 1`
  fi
  blocks=${reserved_blocks}
  part_add 39 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "ota_recovery_b" ${target}
  part_prio 7 1 1 ${target}
  part_prio 8 0 1 ${target}
  set -e
}

load_base_vars() {
  DEFAULT_ROOTDEV="/sys/devices/platform/soc/1bf8000.pcie/pci0006:00/0006:00:00.*/0006:*:00.0/nvme/nvme*/nvme*n1"
  PARTITION_SIZE_OTA_RECOVERY_A=134217728
  RESERVED_EBS_OTA_RECOVERY_A=0
  DATA_SIZE_OTA_RECOVERY_A=134217728
  FORMAT_OTA_RECOVERY_A=
  FS_FORMAT_OTA_RECOVERY_A=
  FS_OPTIONS_OTA_RECOVERY_A=""
  PARTITION_NUM_OTA_RECOVERY_A="38"
  PARTITION_TYPE_OTA_RECOVERY_A="data"
  IMAGE_OTA_RECOVERY_A=""
  PARTITION_SIZE_38=134217728
  RESERVED_EBS_38=0
  DATA_SIZE_38=134217728
  FORMAT_38=
  FS_FORMAT_38=
  FS_OPTIONS_38=""
  PARTITION_NUM_38="38"
  PARTITION_TYPE_38="data"
  IMAGE_38=""
  PARTITION_SIZE_KERN_A=1
  RESERVED_EBS_KERN_A=0
  DATA_SIZE_KERN_A=1
  FORMAT_KERN_A=
  FS_FORMAT_KERN_A=
  FS_OPTIONS_KERN_A=""
  PARTITION_NUM_KERN_A="2"
  PARTITION_TYPE_KERN_A="data"
  IMAGE_KERN_A=""
  PARTITION_SIZE_2=1
  RESERVED_EBS_2=0
  DATA_SIZE_2=1
  FORMAT_2=
  FS_FORMAT_2=
  FS_OPTIONS_2=""
  PARTITION_NUM_2="2"
  PARTITION_TYPE_2="data"
  IMAGE_2=""
  PARTITION_SIZE_KERN_B=1
  RESERVED_EBS_KERN_B=0
  DATA_SIZE_KERN_B=1
  FORMAT_KERN_B=
  FS_FORMAT_KERN_B=
  FS_OPTIONS_KERN_B=""
  PARTITION_NUM_KERN_B="4"
  PARTITION_TYPE_KERN_B="data"
  IMAGE_KERN_B=""
  PARTITION_SIZE_4=1
  RESERVED_EBS_4=0
  DATA_SIZE_4=1
  FORMAT_4=
  FS_FORMAT_4=
  FS_OPTIONS_4=""
  PARTITION_NUM_4="4"
  PARTITION_TYPE_4="data"
  IMAGE_4=""
  PARTITION_SIZE_ROOT_B=1
  RESERVED_EBS_ROOT_B=0
  DATA_SIZE_ROOT_B=1
  FORMAT_ROOT_B=
  FS_FORMAT_ROOT_B=
  FS_OPTIONS_ROOT_B=""
  PARTITION_NUM_ROOT_B="5"
  PARTITION_TYPE_ROOT_B="data"
  IMAGE_ROOT_B=""
  PARTITION_SIZE_5=1
  RESERVED_EBS_5=0
  DATA_SIZE_5=1
  FORMAT_5=
  FS_FORMAT_5=
  FS_OPTIONS_5=""
  PARTITION_NUM_5="5"
  PARTITION_TYPE_5="data"
  IMAGE_5=""
  PARTITION_SIZE_SUPER=12884901888
  RESERVED_EBS_SUPER=0
  DATA_SIZE_SUPER=12884901888
  FORMAT_SUPER=
  FS_FORMAT_SUPER=
  FS_OPTIONS_SUPER=""
  PARTITION_NUM_SUPER="3"
  PARTITION_TYPE_SUPER="data"
  IMAGE_SUPER=""
  PARTITION_SIZE_3=12884901888
  RESERVED_EBS_3=0
  DATA_SIZE_3=12884901888
  FORMAT_3=
  FS_FORMAT_3=
  FS_OPTIONS_3=""
  PARTITION_NUM_3="3"
  PARTITION_TYPE_3="data"
  IMAGE_3=""
  PARTITION_SIZE_VBMETA_A=4194304
  RESERVED_EBS_VBMETA_A=0
  DATA_SIZE_VBMETA_A=4194304
  FORMAT_VBMETA_A=
  FS_FORMAT_VBMETA_A=
  FS_OPTIONS_VBMETA_A=""
  PARTITION_NUM_VBMETA_A="7"
  PARTITION_TYPE_VBMETA_A="vbmeta"
  IMAGE_VBMETA_A=""
  PARTITION_SIZE_7=4194304
  RESERVED_EBS_7=0
  DATA_SIZE_7=4194304
  FORMAT_7=
  FS_FORMAT_7=
  FS_OPTIONS_7=""
  PARTITION_NUM_7="7"
  PARTITION_TYPE_7="vbmeta"
  IMAGE_7=""
  PARTITION_SIZE_VBMETA_B=4194304
  RESERVED_EBS_VBMETA_B=0
  DATA_SIZE_VBMETA_B=4194304
  FORMAT_VBMETA_B=
  FS_FORMAT_VBMETA_B=
  FS_OPTIONS_VBMETA_B=""
  PARTITION_NUM_VBMETA_B="8"
  PARTITION_TYPE_VBMETA_B="vbmeta"
  IMAGE_VBMETA_B=""
  PARTITION_SIZE_8=4194304
  RESERVED_EBS_8=0
  DATA_SIZE_8=4194304
  FORMAT_8=
  FS_FORMAT_8=
  FS_OPTIONS_8=""
  PARTITION_NUM_8="8"
  PARTITION_TYPE_8="vbmeta"
  IMAGE_8=""
  PARTITION_SIZE_INIT_BOOT_A=8388608
  RESERVED_EBS_INIT_BOOT_A=0
  DATA_SIZE_INIT_BOOT_A=8388608
  FORMAT_INIT_BOOT_A=
  FS_FORMAT_INIT_BOOT_A=
  FS_OPTIONS_INIT_BOOT_A=""
  PARTITION_NUM_INIT_BOOT_A="9"
  PARTITION_TYPE_INIT_BOOT_A="data"
  IMAGE_INIT_BOOT_A=""
  PARTITION_SIZE_9=8388608
  RESERVED_EBS_9=0
  DATA_SIZE_9=8388608
  FORMAT_9=
  FS_FORMAT_9=
  FS_OPTIONS_9=""
  PARTITION_NUM_9="9"
  PARTITION_TYPE_9="data"
  IMAGE_9=""
  PARTITION_SIZE_INIT_BOOT_B=8388608
  RESERVED_EBS_INIT_BOOT_B=0
  DATA_SIZE_INIT_BOOT_B=8388608
  FORMAT_INIT_BOOT_B=
  FS_FORMAT_INIT_BOOT_B=
  FS_OPTIONS_INIT_BOOT_B=""
  PARTITION_NUM_INIT_BOOT_B="10"
  PARTITION_TYPE_INIT_BOOT_B="data"
  IMAGE_INIT_BOOT_B=""
  PARTITION_SIZE_10=8388608
  RESERVED_EBS_10=0
  DATA_SIZE_10=8388608
  FORMAT_10=
  FS_FORMAT_10=
  FS_OPTIONS_10=""
  PARTITION_NUM_10="10"
  PARTITION_TYPE_10="data"
  IMAGE_10=""
  PARTITION_SIZE_VENDOR_BOOT_A=33554432
  RESERVED_EBS_VENDOR_BOOT_A=0
  DATA_SIZE_VENDOR_BOOT_A=33554432
  FORMAT_VENDOR_BOOT_A=
  FS_FORMAT_VENDOR_BOOT_A=
  FS_OPTIONS_VENDOR_BOOT_A=""
  PARTITION_NUM_VENDOR_BOOT_A="11"
  PARTITION_TYPE_VENDOR_BOOT_A="data"
  IMAGE_VENDOR_BOOT_A=""
  PARTITION_SIZE_11=33554432
  RESERVED_EBS_11=0
  DATA_SIZE_11=33554432
  FORMAT_11=
  FS_FORMAT_11=
  FS_OPTIONS_11=""
  PARTITION_NUM_11="11"
  PARTITION_TYPE_11="data"
  IMAGE_11=""
  PARTITION_SIZE_VENDOR_BOOT_B=33554432
  RESERVED_EBS_VENDOR_BOOT_B=0
  DATA_SIZE_VENDOR_BOOT_B=33554432
  FORMAT_VENDOR_BOOT_B=
  FS_FORMAT_VENDOR_BOOT_B=
  FS_OPTIONS_VENDOR_BOOT_B=""
  PARTITION_NUM_VENDOR_BOOT_B="12"
  PARTITION_TYPE_VENDOR_BOOT_B="data"
  IMAGE_VENDOR_BOOT_B=""
  PARTITION_SIZE_12=33554432
  RESERVED_EBS_12=0
  DATA_SIZE_12=33554432
  FORMAT_12=
  FS_FORMAT_12=
  FS_OPTIONS_12=""
  PARTITION_NUM_12="12"
  PARTITION_TYPE_12="data"
  IMAGE_12=""
  PARTITION_SIZE_BOOT_A=67108864
  RESERVED_EBS_BOOT_A=0
  DATA_SIZE_BOOT_A=67108864
  FORMAT_BOOT_A=
  FS_FORMAT_BOOT_A=
  FS_OPTIONS_BOOT_A=""
  PARTITION_NUM_BOOT_A="13"
  PARTITION_TYPE_BOOT_A="kernel"
  IMAGE_BOOT_A=""
  PARTITION_SIZE_13=67108864
  RESERVED_EBS_13=0
  DATA_SIZE_13=67108864
  FORMAT_13=
  FS_FORMAT_13=
  FS_OPTIONS_13=""
  PARTITION_NUM_13="13"
  PARTITION_TYPE_13="kernel"
  IMAGE_13=""
  PARTITION_SIZE_BOOT_B=67108864
  RESERVED_EBS_BOOT_B=0
  DATA_SIZE_BOOT_B=67108864
  FORMAT_BOOT_B=
  FS_FORMAT_BOOT_B=
  FS_OPTIONS_BOOT_B=""
  PARTITION_NUM_BOOT_B="14"
  PARTITION_TYPE_BOOT_B="kernel"
  IMAGE_BOOT_B=""
  PARTITION_SIZE_14=67108864
  RESERVED_EBS_14=0
  DATA_SIZE_14=67108864
  FORMAT_14=
  FS_FORMAT_14=
  FS_OPTIONS_14=""
  PARTITION_NUM_14="14"
  PARTITION_TYPE_14="kernel"
  IMAGE_14=""
  PARTITION_SIZE_PVMFW_A=4194304
  RESERVED_EBS_PVMFW_A=0
  DATA_SIZE_PVMFW_A=4194304
  FORMAT_PVMFW_A=
  FS_FORMAT_PVMFW_A=
  FS_OPTIONS_PVMFW_A=""
  PARTITION_NUM_PVMFW_A="15"
  PARTITION_TYPE_PVMFW_A="data"
  IMAGE_PVMFW_A=""
  PARTITION_SIZE_15=4194304
  RESERVED_EBS_15=0
  DATA_SIZE_15=4194304
  FORMAT_15=
  FS_FORMAT_15=
  FS_OPTIONS_15=""
  PARTITION_NUM_15="15"
  PARTITION_TYPE_15="data"
  IMAGE_15=""
  PARTITION_SIZE_PVMFW_B=4194304
  RESERVED_EBS_PVMFW_B=0
  DATA_SIZE_PVMFW_B=4194304
  FORMAT_PVMFW_B=
  FS_FORMAT_PVMFW_B=
  FS_OPTIONS_PVMFW_B=""
  PARTITION_NUM_PVMFW_B="16"
  PARTITION_TYPE_PVMFW_B="data"
  IMAGE_PVMFW_B=""
  PARTITION_SIZE_16=4194304
  RESERVED_EBS_16=0
  DATA_SIZE_16=4194304
  FORMAT_16=
  FS_FORMAT_16=
  FS_OPTIONS_16=""
  PARTITION_NUM_16="16"
  PARTITION_TYPE_16="data"
  IMAGE_16=""
  PARTITION_SIZE_DTB_A=2097152
  RESERVED_EBS_DTB_A=0
  DATA_SIZE_DTB_A=2097152
  FORMAT_DTB_A=
  FS_FORMAT_DTB_A=
  FS_OPTIONS_DTB_A=""
  PARTITION_NUM_DTB_A="17"
  PARTITION_TYPE_DTB_A="data"
  IMAGE_DTB_A=""
  PARTITION_SIZE_17=2097152
  RESERVED_EBS_17=0
  DATA_SIZE_17=2097152
  FORMAT_17=
  FS_FORMAT_17=
  FS_OPTIONS_17=""
  PARTITION_NUM_17="17"
  PARTITION_TYPE_17="data"
  IMAGE_17=""
  PARTITION_SIZE_DTBO_A=8388608
  RESERVED_EBS_DTBO_A=0
  DATA_SIZE_DTBO_A=8388608
  FORMAT_DTBO_A=
  FS_FORMAT_DTBO_A=
  FS_OPTIONS_DTBO_A=""
  PARTITION_NUM_DTBO_A="18"
  PARTITION_TYPE_DTBO_A="data"
  IMAGE_DTBO_A=""
  PARTITION_SIZE_18=8388608
  RESERVED_EBS_18=0
  DATA_SIZE_18=8388608
  FORMAT_18=
  FS_FORMAT_18=
  FS_OPTIONS_18=""
  PARTITION_NUM_18="18"
  PARTITION_TYPE_18="data"
  IMAGE_18=""
  PARTITION_SIZE_DTB_B=2097152
  RESERVED_EBS_DTB_B=0
  DATA_SIZE_DTB_B=2097152
  FORMAT_DTB_B=
  FS_FORMAT_DTB_B=
  FS_OPTIONS_DTB_B=""
  PARTITION_NUM_DTB_B="19"
  PARTITION_TYPE_DTB_B="data"
  IMAGE_DTB_B=""
  PARTITION_SIZE_19=2097152
  RESERVED_EBS_19=0
  DATA_SIZE_19=2097152
  FORMAT_19=
  FS_FORMAT_19=
  FS_OPTIONS_19=""
  PARTITION_NUM_19="19"
  PARTITION_TYPE_19="data"
  IMAGE_19=""
  PARTITION_SIZE_DTBO_B=8388608
  RESERVED_EBS_DTBO_B=0
  DATA_SIZE_DTBO_B=8388608
  FORMAT_DTBO_B=
  FS_FORMAT_DTBO_B=
  FS_OPTIONS_DTBO_B=""
  PARTITION_NUM_DTBO_B="20"
  PARTITION_TYPE_DTBO_B="data"
  IMAGE_DTBO_B=""
  PARTITION_SIZE_20=8388608
  RESERVED_EBS_20=0
  DATA_SIZE_20=8388608
  FORMAT_20=
  FS_FORMAT_20=
  FS_OPTIONS_20=""
  PARTITION_NUM_20="20"
  PARTITION_TYPE_20="data"
  IMAGE_20=""
  PARTITION_SIZE_DESKTOP_SECURITY_PERSIST=16777216
  RESERVED_EBS_DESKTOP_SECURITY_PERSIST=0
  DATA_SIZE_DESKTOP_SECURITY_PERSIST=16777216
  FORMAT_DESKTOP_SECURITY_PERSIST=
  FS_FORMAT_DESKTOP_SECURITY_PERSIST=
  FS_OPTIONS_DESKTOP_SECURITY_PERSIST=""
  PARTITION_NUM_DESKTOP_SECURITY_PERSIST="21"
  PARTITION_TYPE_DESKTOP_SECURITY_PERSIST="data"
  IMAGE_DESKTOP_SECURITY_PERSIST=""
  PARTITION_SIZE_21=16777216
  RESERVED_EBS_21=0
  DATA_SIZE_21=16777216
  FORMAT_21=
  FS_FORMAT_21=
  FS_OPTIONS_21=""
  PARTITION_NUM_21="21"
  PARTITION_TYPE_21="data"
  IMAGE_21=""
  PARTITION_SIZE_DESKTOP_SECURITY_STORAGE=33554432
  RESERVED_EBS_DESKTOP_SECURITY_STORAGE=0
  DATA_SIZE_DESKTOP_SECURITY_STORAGE=33554432
  FORMAT_DESKTOP_SECURITY_STORAGE=
  FS_FORMAT_DESKTOP_SECURITY_STORAGE=
  FS_OPTIONS_DESKTOP_SECURITY_STORAGE=""
  PARTITION_NUM_DESKTOP_SECURITY_STORAGE="22"
  PARTITION_TYPE_DESKTOP_SECURITY_STORAGE="data"
  IMAGE_DESKTOP_SECURITY_STORAGE=""
  PARTITION_SIZE_22=33554432
  RESERVED_EBS_22=0
  DATA_SIZE_22=33554432
  FORMAT_22=
  FS_FORMAT_22=
  FS_OPTIONS_22=""
  PARTITION_NUM_22="22"
  PARTITION_TYPE_22="data"
  IMAGE_22=""
  PARTITION_SIZE_MISC=4194304
  RESERVED_EBS_MISC=0
  DATA_SIZE_MISC=4194304
  FORMAT_MISC=
  FS_FORMAT_MISC=
  FS_OPTIONS_MISC=""
  PARTITION_NUM_MISC="23"
  PARTITION_TYPE_MISC="data"
  IMAGE_MISC=""
  PARTITION_SIZE_23=4194304
  RESERVED_EBS_23=0
  DATA_SIZE_23=4194304
  FORMAT_23=
  FS_FORMAT_23=
  FS_OPTIONS_23=""
  PARTITION_NUM_23="23"
  PARTITION_TYPE_23="data"
  IMAGE_23=""
  PARTITION_SIZE_METADATA=67108864
  RESERVED_EBS_METADATA=0
  DATA_SIZE_METADATA=67108864
  FORMAT_METADATA=
  FS_FORMAT_METADATA=ext4
  FS_OPTIONS_METADATA=""
  PARTITION_NUM_METADATA="24"
  PARTITION_TYPE_METADATA="data"
  IMAGE_METADATA=""
  PARTITION_SIZE_24=67108864
  RESERVED_EBS_24=0
  DATA_SIZE_24=67108864
  FORMAT_24=
  FS_FORMAT_24=ext4
  FS_OPTIONS_24=""
  PARTITION_NUM_24="24"
  PARTITION_TYPE_24="data"
  IMAGE_24=""
  PARTITION_SIZE_RECOVERY_A=33554432
  RESERVED_EBS_RECOVERY_A=0
  DATA_SIZE_RECOVERY_A=33554432
  FORMAT_RECOVERY_A=
  FS_FORMAT_RECOVERY_A=
  FS_OPTIONS_RECOVERY_A=""
  PARTITION_NUM_RECOVERY_A="25"
  PARTITION_TYPE_RECOVERY_A="data"
  IMAGE_RECOVERY_A=""
  PARTITION_SIZE_25=33554432
  RESERVED_EBS_25=0
  DATA_SIZE_25=33554432
  FORMAT_25=
  FS_FORMAT_25=
  FS_OPTIONS_25=""
  PARTITION_NUM_25="25"
  PARTITION_TYPE_25="data"
  IMAGE_25=""
  PARTITION_SIZE_RECOVERY_B=33554432
  RESERVED_EBS_RECOVERY_B=0
  DATA_SIZE_RECOVERY_B=33554432
  FORMAT_RECOVERY_B=
  FS_FORMAT_RECOVERY_B=
  FS_OPTIONS_RECOVERY_B=""
  PARTITION_NUM_RECOVERY_B="26"
  PARTITION_TYPE_RECOVERY_B="data"
  IMAGE_RECOVERY_B=""
  PARTITION_SIZE_26=33554432
  RESERVED_EBS_26=0
  DATA_SIZE_26=33554432
  FORMAT_26=
  FS_FORMAT_26=
  FS_OPTIONS_26=""
  PARTITION_NUM_26="26"
  PARTITION_TYPE_26="data"
  IMAGE_26=""
  PARTITION_SIZE_FRP_PERSIST=2097152
  RESERVED_EBS_FRP_PERSIST=0
  DATA_SIZE_FRP_PERSIST=2097152
  FORMAT_FRP_PERSIST=
  FS_FORMAT_FRP_PERSIST=
  FS_OPTIONS_FRP_PERSIST=""
  PARTITION_NUM_FRP_PERSIST="27"
  PARTITION_TYPE_FRP_PERSIST="data"
  IMAGE_FRP_PERSIST=""
  PARTITION_SIZE_27=2097152
  RESERVED_EBS_27=0
  DATA_SIZE_27=2097152
  FORMAT_27=
  FS_FORMAT_27=
  FS_OPTIONS_27=""
  PARTITION_NUM_27="27"
  PARTITION_TYPE_27="data"
  IMAGE_27=""
  PARTITION_SIZE_USERDATA=4294967296
  RESERVED_EBS_USERDATA=0
  DATA_SIZE_USERDATA=4294967296
  FORMAT_USERDATA=
  FS_FORMAT_USERDATA=
  FS_OPTIONS_USERDATA=""
  PARTITION_NUM_USERDATA="1"
  PARTITION_TYPE_USERDATA="data"
  IMAGE_USERDATA=""
  PARTITION_SIZE_1=4294967296
  RESERVED_EBS_1=0
  DATA_SIZE_1=4294967296
  FORMAT_1=
  FS_FORMAT_1=
  FS_OPTIONS_1=""
  PARTITION_NUM_1="1"
  PARTITION_TYPE_1="data"
  IMAGE_1=""
  PARTITION_SIZE_OTA_RECOVERY_B=134217728
  RESERVED_EBS_OTA_RECOVERY_B=0
  DATA_SIZE_OTA_RECOVERY_B=134217728
  FORMAT_OTA_RECOVERY_B=
  FS_FORMAT_OTA_RECOVERY_B=
  FS_OPTIONS_OTA_RECOVERY_B=""
  PARTITION_NUM_OTA_RECOVERY_B="39"
  PARTITION_TYPE_OTA_RECOVERY_B="data"
  IMAGE_OTA_RECOVERY_B=""
  PARTITION_SIZE_39=134217728
  RESERVED_EBS_39=0
  DATA_SIZE_39=134217728
  FORMAT_39=
  FS_FORMAT_39=
  FS_OPTIONS_39=""
  PARTITION_NUM_39="39"
  PARTITION_TYPE_39="data"
  IMAGE_39=""
  PARTITION_SIZE_MODEM_A=367001600
  RESERVED_EBS_MODEM_A=0
  DATA_SIZE_MODEM_A=367001600
  FORMAT_MODEM_A=
  FS_FORMAT_MODEM_A=
  FS_OPTIONS_MODEM_A=""
  PARTITION_NUM_MODEM_A="28"
  PARTITION_TYPE_MODEM_A="data"
  IMAGE_MODEM_A="modem.img"
  PARTITION_SIZE_28=367001600
  RESERVED_EBS_28=0
  DATA_SIZE_28=367001600
  FORMAT_28=
  FS_FORMAT_28=
  FS_OPTIONS_28=""
  PARTITION_NUM_28="28"
  PARTITION_TYPE_28="data"
  IMAGE_28="modem.img"
  PARTITION_SIZE_MODEM_B=367001600
  RESERVED_EBS_MODEM_B=0
  DATA_SIZE_MODEM_B=367001600
  FORMAT_MODEM_B=
  FS_FORMAT_MODEM_B=
  FS_OPTIONS_MODEM_B=""
  PARTITION_NUM_MODEM_B="29"
  PARTITION_TYPE_MODEM_B="data"
  IMAGE_MODEM_B=""
  PARTITION_SIZE_29=367001600
  RESERVED_EBS_29=0
  DATA_SIZE_29=367001600
  FORMAT_29=
  FS_FORMAT_29=
  FS_OPTIONS_29=""
  PARTITION_NUM_29="29"
  PARTITION_TYPE_29="data"
  IMAGE_29=""
  PARTITION_SIZE_BLUETOOTH_A=8388608
  RESERVED_EBS_BLUETOOTH_A=0
  DATA_SIZE_BLUETOOTH_A=8388608
  FORMAT_BLUETOOTH_A=
  FS_FORMAT_BLUETOOTH_A=
  FS_OPTIONS_BLUETOOTH_A=""
  PARTITION_NUM_BLUETOOTH_A="30"
  PARTITION_TYPE_BLUETOOTH_A="data"
  IMAGE_BLUETOOTH_A="bluetooth.img"
  PARTITION_SIZE_30=8388608
  RESERVED_EBS_30=0
  DATA_SIZE_30=8388608
  FORMAT_30=
  FS_FORMAT_30=
  FS_OPTIONS_30=""
  PARTITION_NUM_30="30"
  PARTITION_TYPE_30="data"
  IMAGE_30="bluetooth.img"
  PARTITION_SIZE_BLUETOOTH_B=8388608
  RESERVED_EBS_BLUETOOTH_B=0
  DATA_SIZE_BLUETOOTH_B=8388608
  FORMAT_BLUETOOTH_B=
  FS_FORMAT_BLUETOOTH_B=
  FS_OPTIONS_BLUETOOTH_B=""
  PARTITION_NUM_BLUETOOTH_B="31"
  PARTITION_TYPE_BLUETOOTH_B="data"
  IMAGE_BLUETOOTH_B=""
  PARTITION_SIZE_31=8388608
  RESERVED_EBS_31=0
  DATA_SIZE_31=8388608
  FORMAT_31=
  FS_FORMAT_31=
  FS_OPTIONS_31=""
  PARTITION_NUM_31="31"
  PARTITION_TYPE_31="data"
  IMAGE_31=""
  PARTITION_SIZE_DSP_A=78643200
  RESERVED_EBS_DSP_A=0
  DATA_SIZE_DSP_A=78643200
  FORMAT_DSP_A=
  FS_FORMAT_DSP_A=
  FS_OPTIONS_DSP_A=""
  PARTITION_NUM_DSP_A="32"
  PARTITION_TYPE_DSP_A="data"
  IMAGE_DSP_A="dsp.img"
  PARTITION_SIZE_32=78643200
  RESERVED_EBS_32=0
  DATA_SIZE_32=78643200
  FORMAT_32=
  FS_FORMAT_32=
  FS_OPTIONS_32=""
  PARTITION_NUM_32="32"
  PARTITION_TYPE_32="data"
  IMAGE_32="dsp.img"
  PARTITION_SIZE_DSP_B=78643200
  RESERVED_EBS_DSP_B=0
  DATA_SIZE_DSP_B=78643200
  FORMAT_DSP_B=
  FS_FORMAT_DSP_B=
  FS_OPTIONS_DSP_B=""
  PARTITION_NUM_DSP_B="33"
  PARTITION_TYPE_DSP_B="data"
  IMAGE_DSP_B=""
  PARTITION_SIZE_33=78643200
  RESERVED_EBS_33=0
  DATA_SIZE_33=78643200
  FORMAT_33=
  FS_FORMAT_33=
  FS_OPTIONS_33=""
  PARTITION_NUM_33="33"
  PARTITION_TYPE_33="data"
  IMAGE_33=""
  PARTITION_SIZE_KEYMASTER_A=10485760
  RESERVED_EBS_KEYMASTER_A=0
  DATA_SIZE_KEYMASTER_A=10485760
  FORMAT_KEYMASTER_A=
  FS_FORMAT_KEYMASTER_A=
  FS_OPTIONS_KEYMASTER_A=""
  PARTITION_NUM_KEYMASTER_A="34"
  PARTITION_TYPE_KEYMASTER_A="data"
  IMAGE_KEYMASTER_A=""
  PARTITION_SIZE_34=10485760
  RESERVED_EBS_34=0
  DATA_SIZE_34=10485760
  FORMAT_34=
  FS_FORMAT_34=
  FS_OPTIONS_34=""
  PARTITION_NUM_34="34"
  PARTITION_TYPE_34="data"
  IMAGE_34=""
  PARTITION_SIZE_KEYMASTER_B=10485760
  RESERVED_EBS_KEYMASTER_B=0
  DATA_SIZE_KEYMASTER_B=10485760
  FORMAT_KEYMASTER_B=
  FS_FORMAT_KEYMASTER_B=
  FS_OPTIONS_KEYMASTER_B=""
  PARTITION_NUM_KEYMASTER_B="35"
  PARTITION_TYPE_KEYMASTER_B="data"
  IMAGE_KEYMASTER_B=""
  PARTITION_SIZE_35=10485760
  RESERVED_EBS_35=0
  DATA_SIZE_35=10485760
  FORMAT_35=
  FS_FORMAT_35=
  FS_OPTIONS_35=""
  PARTITION_NUM_35="35"
  PARTITION_TYPE_35="data"
  IMAGE_35=""
  PARTITION_SIZE_PERSIST=33554432
  RESERVED_EBS_PERSIST=0
  DATA_SIZE_PERSIST=33554432
  FORMAT_PERSIST=
  FS_FORMAT_PERSIST=
  FS_OPTIONS_PERSIST=""
  PARTITION_NUM_PERSIST="36"
  PARTITION_TYPE_PERSIST="data"
  IMAGE_PERSIST="persist.img"
  PARTITION_SIZE_36=33554432
  RESERVED_EBS_36=0
  DATA_SIZE_36=33554432
  FORMAT_36=
  FS_FORMAT_36=
  FS_OPTIONS_36=""
  PARTITION_NUM_36="36"
  PARTITION_TYPE_36="data"
  IMAGE_36="persist.img"
  PARTITION_SIZE_RAWDUMP=268435456
  RESERVED_EBS_RAWDUMP=0
  DATA_SIZE_RAWDUMP=268435456
  FORMAT_RAWDUMP=
  FS_FORMAT_RAWDUMP=
  FS_OPTIONS_RAWDUMP=""
  PARTITION_NUM_RAWDUMP="37"
  PARTITION_TYPE_RAWDUMP="minidump"
  IMAGE_RAWDUMP=""
  PARTITION_SIZE_37=268435456
  RESERVED_EBS_37=0
  DATA_SIZE_37=268435456
  FORMAT_37=
  FS_FORMAT_37=
  FS_OPTIONS_37=""
  PARTITION_NUM_37="37"
  PARTITION_TYPE_37="minidump"
  IMAGE_37=""
}

#!/bin/sh

INSTALLABLE_PARTITIONS="28 30 32 36"
  INSTALLABLE_PARTITION_IMAGES="modem.img bluetooth.img dsp.img persist.img"
  write_partition_table() {
  set +e
  local target="$1"
  create_image "${target}" 19189030915
  local blocks
  block_size=$(blocksize "${target}")
  numsecs=$(numsectors "${target}")
  local curr=$(( 32768 ))
  # Make sure Padding is block_size aligned.
  if [ $(( 0 & (block_size - 1) )) -gt 0 ]; then
    echo "Primary Entry Array padding is not block aligned." >&2
    exit 1
  fi
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 134217728 / $block_size`
  if [ `expr 134217728 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 38 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "ota_recovery_a" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  blocks=`expr 1 / $block_size`
  if [ `expr 1 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 2 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "KERN-A" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  blocks=`expr 1 / $block_size`
  if [ `expr 1 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 4 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "KERN-B" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  blocks=`expr 1 / $block_size`
  if [ `expr 1 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 5 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "ROOT-B" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 12884901888 / $block_size`
  if [ `expr 12884901888 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 3 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "super" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  blocks=`expr 4194304 / $block_size`
  if [ `expr 4194304 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 7 `expr $curr / $block_size` ${blocks} 88434509-D9D1-487D-B82C-15EF964CBD4B "vbmeta_a" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  blocks=`expr 4194304 / $block_size`
  if [ `expr 4194304 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 8 `expr $curr / $block_size` ${blocks} 88434509-D9D1-487D-B82C-15EF964CBD4B "vbmeta_b" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 8388608 / $block_size`
  if [ `expr 8388608 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 9 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "init_boot_a" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 8388608 / $block_size`
  if [ `expr 8388608 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 10 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "init_boot_b" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 33554432 / $block_size`
  if [ `expr 33554432 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 11 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "vendor_boot_a" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 33554432 / $block_size`
  if [ `expr 33554432 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 12 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "vendor_boot_b" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  blocks=`expr 67108864 / $block_size`
  if [ `expr 67108864 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 13 `expr $curr / $block_size` ${blocks} FE3A2A5D-4F32-41A7-B725-ACCC3285A309 "boot_a" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  blocks=`expr 67108864 / $block_size`
  if [ `expr 67108864 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 14 `expr $curr / $block_size` ${blocks} FE3A2A5D-4F32-41A7-B725-ACCC3285A309 "boot_b" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 4194304 / $block_size`
  if [ `expr 4194304 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 15 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "pvmfw_a" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 4194304 / $block_size`
  if [ `expr 4194304 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 16 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "pvmfw_b" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 2097152 / $block_size`
  if [ `expr 2097152 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 17 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "dtb_a" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 8388608 / $block_size`
  if [ `expr 8388608 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 18 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "dtbo_a" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 2097152 / $block_size`
  if [ `expr 2097152 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 19 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "dtb_b" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 8388608 / $block_size`
  if [ `expr 8388608 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 20 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "dtbo_b" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 16777216 / $block_size`
  if [ `expr 16777216 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 21 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "desktop_security_persist" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 33554432 / $block_size`
  if [ `expr 33554432 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 22 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "desktop_security_storage" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 4194304 / $block_size`
  if [ `expr 4194304 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 23 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "misc" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 67108864 / $block_size`
  if [ `expr 67108864 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 24 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "metadata" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 33554432 / $block_size`
  if [ `expr 33554432 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 25 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "recovery_a" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 33554432 / $block_size`
  if [ `expr 33554432 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 26 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "recovery_b" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 2097152 / $block_size`
  if [ `expr 2097152 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 27 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "frp_persist" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 367001600 / $block_size`
  if [ `expr 367001600 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 28 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "modem_a" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 367001600 / $block_size`
  if [ `expr 367001600 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 29 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "modem_b" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 8388608 / $block_size`
  if [ `expr 8388608 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 30 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "bluetooth_a" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 8388608 / $block_size`
  if [ `expr 8388608 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 31 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "bluetooth_b" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 78643200 / $block_size`
  if [ `expr 78643200 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 32 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "dsp_a" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 78643200 / $block_size`
  if [ `expr 78643200 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 33 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "dsp_b" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 10485760 / $block_size`
  if [ `expr 10485760 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 34 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "keymaster_a" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 10485760 / $block_size`
  if [ `expr 10485760 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 35 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "keymaster_b" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr 33554432 / $block_size`
  if [ `expr 33554432 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 36 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "persist" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  blocks=`expr 268435456 / $block_size`
  if [ `expr 268435456 % $block_size` -gt 0 ]; then
     blocks=`expr $blocks + 1`
  fi
  part_add 37 `expr $curr / $block_size` ${blocks} 66C9B323-F7FC-48B6-BF96-6F32E335A428 "rawdump" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  if [ `expr $curr % 2097152` -gt 0 ]; then
    curr=`expr $curr + 2097152 - $curr % 2097152`
  fi
  blocks=`expr $numsecs - \( $curr + 24576 \) / $block_size`
  reserved_blocks=`expr 134217728 / $block_size`
  if [ `expr 134217728 % $block_size` -gt 0 ]; then
     reserved_blocks=`expr $reserved_blocks + 1`
  fi
  blocks=`expr $blocks - $reserved_blocks`
  part_add 1 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "userdata" ${target}
  curr=`expr $curr + $blocks \* $block_size`
  reserved_blocks=`expr 134217728 / $block_size`
  if [ `expr 134217728 % $block_size` -gt 0 ]; then
     reserved_blocks=`expr $reserved_blocks + 1`
  fi
  blocks=${reserved_blocks}
  part_add 39 `expr $curr / $block_size` ${blocks} 0FC63DAF-8483-4772-8E79-3D69D8477DE4 "ota_recovery_b" ${target}
  part_prio 7 1 1 ${target}
  part_prio 8 0 0 ${target}
  set -e
}

load_partition_vars() {
  DEFAULT_ROOTDEV=""
  PARTITION_SIZE_OTA_RECOVERY_A=134217728
  RESERVED_EBS_OTA_RECOVERY_A=0
  DATA_SIZE_OTA_RECOVERY_A=134217728
  FORMAT_OTA_RECOVERY_A=
  FS_FORMAT_OTA_RECOVERY_A=
  FS_OPTIONS_OTA_RECOVERY_A=""
  PARTITION_NUM_OTA_RECOVERY_A="38"
  PARTITION_TYPE_OTA_RECOVERY_A="data"
  IMAGE_OTA_RECOVERY_A=""
  PARTITION_SIZE_38=134217728
  RESERVED_EBS_38=0
  DATA_SIZE_38=134217728
  FORMAT_38=
  FS_FORMAT_38=
  FS_OPTIONS_38=""
  PARTITION_NUM_38="38"
  PARTITION_TYPE_38="data"
  IMAGE_38=""
  PARTITION_SIZE_KERN_A=1
  RESERVED_EBS_KERN_A=0
  DATA_SIZE_KERN_A=1
  FORMAT_KERN_A=
  FS_FORMAT_KERN_A=
  FS_OPTIONS_KERN_A=""
  PARTITION_NUM_KERN_A="2"
  PARTITION_TYPE_KERN_A="data"
  IMAGE_KERN_A=""
  PARTITION_SIZE_2=1
  RESERVED_EBS_2=0
  DATA_SIZE_2=1
  FORMAT_2=
  FS_FORMAT_2=
  FS_OPTIONS_2=""
  PARTITION_NUM_2="2"
  PARTITION_TYPE_2="data"
  IMAGE_2=""
  PARTITION_SIZE_KERN_B=1
  RESERVED_EBS_KERN_B=0
  DATA_SIZE_KERN_B=1
  FORMAT_KERN_B=
  FS_FORMAT_KERN_B=
  FS_OPTIONS_KERN_B=""
  PARTITION_NUM_KERN_B="4"
  PARTITION_TYPE_KERN_B="data"
  IMAGE_KERN_B=""
  PARTITION_SIZE_4=1
  RESERVED_EBS_4=0
  DATA_SIZE_4=1
  FORMAT_4=
  FS_FORMAT_4=
  FS_OPTIONS_4=""
  PARTITION_NUM_4="4"
  PARTITION_TYPE_4="data"
  IMAGE_4=""
  PARTITION_SIZE_ROOT_B=1
  RESERVED_EBS_ROOT_B=0
  DATA_SIZE_ROOT_B=1
  FORMAT_ROOT_B=
  FS_FORMAT_ROOT_B=
  FS_OPTIONS_ROOT_B=""
  PARTITION_NUM_ROOT_B="5"
  PARTITION_TYPE_ROOT_B="data"
  IMAGE_ROOT_B=""
  PARTITION_SIZE_5=1
  RESERVED_EBS_5=0
  DATA_SIZE_5=1
  FORMAT_5=
  FS_FORMAT_5=
  FS_OPTIONS_5=""
  PARTITION_NUM_5="5"
  PARTITION_TYPE_5="data"
  IMAGE_5=""
  PARTITION_SIZE_SUPER=12884901888
  RESERVED_EBS_SUPER=0
  DATA_SIZE_SUPER=12884901888
  FORMAT_SUPER=
  FS_FORMAT_SUPER=
  FS_OPTIONS_SUPER=""
  PARTITION_NUM_SUPER="3"
  PARTITION_TYPE_SUPER="data"
  IMAGE_SUPER=""
  PARTITION_SIZE_3=12884901888
  RESERVED_EBS_3=0
  DATA_SIZE_3=12884901888
  FORMAT_3=
  FS_FORMAT_3=
  FS_OPTIONS_3=""
  PARTITION_NUM_3="3"
  PARTITION_TYPE_3="data"
  IMAGE_3=""
  PARTITION_SIZE_VBMETA_A=4194304
  RESERVED_EBS_VBMETA_A=0
  DATA_SIZE_VBMETA_A=4194304
  FORMAT_VBMETA_A=
  FS_FORMAT_VBMETA_A=
  FS_OPTIONS_VBMETA_A=""
  PARTITION_NUM_VBMETA_A="7"
  PARTITION_TYPE_VBMETA_A="vbmeta"
  IMAGE_VBMETA_A=""
  PARTITION_SIZE_7=4194304
  RESERVED_EBS_7=0
  DATA_SIZE_7=4194304
  FORMAT_7=
  FS_FORMAT_7=
  FS_OPTIONS_7=""
  PARTITION_NUM_7="7"
  PARTITION_TYPE_7="vbmeta"
  IMAGE_7=""
  PARTITION_SIZE_VBMETA_B=4194304
  RESERVED_EBS_VBMETA_B=0
  DATA_SIZE_VBMETA_B=4194304
  FORMAT_VBMETA_B=
  FS_FORMAT_VBMETA_B=
  FS_OPTIONS_VBMETA_B=""
  PARTITION_NUM_VBMETA_B="8"
  PARTITION_TYPE_VBMETA_B="vbmeta"
  IMAGE_VBMETA_B=""
  PARTITION_SIZE_8=4194304
  RESERVED_EBS_8=0
  DATA_SIZE_8=4194304
  FORMAT_8=
  FS_FORMAT_8=
  FS_OPTIONS_8=""
  PARTITION_NUM_8="8"
  PARTITION_TYPE_8="vbmeta"
  IMAGE_8=""
  PARTITION_SIZE_INIT_BOOT_A=8388608
  RESERVED_EBS_INIT_BOOT_A=0
  DATA_SIZE_INIT_BOOT_A=8388608
  FORMAT_INIT_BOOT_A=
  FS_FORMAT_INIT_BOOT_A=
  FS_OPTIONS_INIT_BOOT_A=""
  PARTITION_NUM_INIT_BOOT_A="9"
  PARTITION_TYPE_INIT_BOOT_A="data"
  IMAGE_INIT_BOOT_A=""
  PARTITION_SIZE_9=8388608
  RESERVED_EBS_9=0
  DATA_SIZE_9=8388608
  FORMAT_9=
  FS_FORMAT_9=
  FS_OPTIONS_9=""
  PARTITION_NUM_9="9"
  PARTITION_TYPE_9="data"
  IMAGE_9=""
  PARTITION_SIZE_INIT_BOOT_B=8388608
  RESERVED_EBS_INIT_BOOT_B=0
  DATA_SIZE_INIT_BOOT_B=8388608
  FORMAT_INIT_BOOT_B=
  FS_FORMAT_INIT_BOOT_B=
  FS_OPTIONS_INIT_BOOT_B=""
  PARTITION_NUM_INIT_BOOT_B="10"
  PARTITION_TYPE_INIT_BOOT_B="data"
  IMAGE_INIT_BOOT_B=""
  PARTITION_SIZE_10=8388608
  RESERVED_EBS_10=0
  DATA_SIZE_10=8388608
  FORMAT_10=
  FS_FORMAT_10=
  FS_OPTIONS_10=""
  PARTITION_NUM_10="10"
  PARTITION_TYPE_10="data"
  IMAGE_10=""
  PARTITION_SIZE_VENDOR_BOOT_A=33554432
  RESERVED_EBS_VENDOR_BOOT_A=0
  DATA_SIZE_VENDOR_BOOT_A=33554432
  FORMAT_VENDOR_BOOT_A=
  FS_FORMAT_VENDOR_BOOT_A=
  FS_OPTIONS_VENDOR_BOOT_A=""
  PARTITION_NUM_VENDOR_BOOT_A="11"
  PARTITION_TYPE_VENDOR_BOOT_A="data"
  IMAGE_VENDOR_BOOT_A=""
  PARTITION_SIZE_11=33554432
  RESERVED_EBS_11=0
  DATA_SIZE_11=33554432
  FORMAT_11=
  FS_FORMAT_11=
  FS_OPTIONS_11=""
  PARTITION_NUM_11="11"
  PARTITION_TYPE_11="data"
  IMAGE_11=""
  PARTITION_SIZE_VENDOR_BOOT_B=33554432
  RESERVED_EBS_VENDOR_BOOT_B=0
  DATA_SIZE_VENDOR_BOOT_B=33554432
  FORMAT_VENDOR_BOOT_B=
  FS_FORMAT_VENDOR_BOOT_B=
  FS_OPTIONS_VENDOR_BOOT_B=""
  PARTITION_NUM_VENDOR_BOOT_B="12"
  PARTITION_TYPE_VENDOR_BOOT_B="data"
  IMAGE_VENDOR_BOOT_B=""
  PARTITION_SIZE_12=33554432
  RESERVED_EBS_12=0
  DATA_SIZE_12=33554432
  FORMAT_12=
  FS_FORMAT_12=
  FS_OPTIONS_12=""
  PARTITION_NUM_12="12"
  PARTITION_TYPE_12="data"
  IMAGE_12=""
  PARTITION_SIZE_BOOT_A=67108864
  RESERVED_EBS_BOOT_A=0
  DATA_SIZE_BOOT_A=67108864
  FORMAT_BOOT_A=
  FS_FORMAT_BOOT_A=
  FS_OPTIONS_BOOT_A=""
  PARTITION_NUM_BOOT_A="13"
  PARTITION_TYPE_BOOT_A="kernel"
  IMAGE_BOOT_A=""
  PARTITION_SIZE_13=67108864
  RESERVED_EBS_13=0
  DATA_SIZE_13=67108864
  FORMAT_13=
  FS_FORMAT_13=
  FS_OPTIONS_13=""
  PARTITION_NUM_13="13"
  PARTITION_TYPE_13="kernel"
  IMAGE_13=""
  PARTITION_SIZE_BOOT_B=67108864
  RESERVED_EBS_BOOT_B=0
  DATA_SIZE_BOOT_B=67108864
  FORMAT_BOOT_B=
  FS_FORMAT_BOOT_B=
  FS_OPTIONS_BOOT_B=""
  PARTITION_NUM_BOOT_B="14"
  PARTITION_TYPE_BOOT_B="kernel"
  IMAGE_BOOT_B=""
  PARTITION_SIZE_14=67108864
  RESERVED_EBS_14=0
  DATA_SIZE_14=67108864
  FORMAT_14=
  FS_FORMAT_14=
  FS_OPTIONS_14=""
  PARTITION_NUM_14="14"
  PARTITION_TYPE_14="kernel"
  IMAGE_14=""
  PARTITION_SIZE_PVMFW_A=4194304
  RESERVED_EBS_PVMFW_A=0
  DATA_SIZE_PVMFW_A=4194304
  FORMAT_PVMFW_A=
  FS_FORMAT_PVMFW_A=
  FS_OPTIONS_PVMFW_A=""
  PARTITION_NUM_PVMFW_A="15"
  PARTITION_TYPE_PVMFW_A="data"
  IMAGE_PVMFW_A=""
  PARTITION_SIZE_15=4194304
  RESERVED_EBS_15=0
  DATA_SIZE_15=4194304
  FORMAT_15=
  FS_FORMAT_15=
  FS_OPTIONS_15=""
  PARTITION_NUM_15="15"
  PARTITION_TYPE_15="data"
  IMAGE_15=""
  PARTITION_SIZE_PVMFW_B=4194304
  RESERVED_EBS_PVMFW_B=0
  DATA_SIZE_PVMFW_B=4194304
  FORMAT_PVMFW_B=
  FS_FORMAT_PVMFW_B=
  FS_OPTIONS_PVMFW_B=""
  PARTITION_NUM_PVMFW_B="16"
  PARTITION_TYPE_PVMFW_B="data"
  IMAGE_PVMFW_B=""
  PARTITION_SIZE_16=4194304
  RESERVED_EBS_16=0
  DATA_SIZE_16=4194304
  FORMAT_16=
  FS_FORMAT_16=
  FS_OPTIONS_16=""
  PARTITION_NUM_16="16"
  PARTITION_TYPE_16="data"
  IMAGE_16=""
  PARTITION_SIZE_DTB_A=2097152
  RESERVED_EBS_DTB_A=0
  DATA_SIZE_DTB_A=2097152
  FORMAT_DTB_A=
  FS_FORMAT_DTB_A=
  FS_OPTIONS_DTB_A=""
  PARTITION_NUM_DTB_A="17"
  PARTITION_TYPE_DTB_A="data"
  IMAGE_DTB_A=""
  PARTITION_SIZE_17=2097152
  RESERVED_EBS_17=0
  DATA_SIZE_17=2097152
  FORMAT_17=
  FS_FORMAT_17=
  FS_OPTIONS_17=""
  PARTITION_NUM_17="17"
  PARTITION_TYPE_17="data"
  IMAGE_17=""
  PARTITION_SIZE_DTBO_A=8388608
  RESERVED_EBS_DTBO_A=0
  DATA_SIZE_DTBO_A=8388608
  FORMAT_DTBO_A=
  FS_FORMAT_DTBO_A=
  FS_OPTIONS_DTBO_A=""
  PARTITION_NUM_DTBO_A="18"
  PARTITION_TYPE_DTBO_A="data"
  IMAGE_DTBO_A=""
  PARTITION_SIZE_18=8388608
  RESERVED_EBS_18=0
  DATA_SIZE_18=8388608
  FORMAT_18=
  FS_FORMAT_18=
  FS_OPTIONS_18=""
  PARTITION_NUM_18="18"
  PARTITION_TYPE_18="data"
  IMAGE_18=""
  PARTITION_SIZE_DTB_B=2097152
  RESERVED_EBS_DTB_B=0
  DATA_SIZE_DTB_B=2097152
  FORMAT_DTB_B=
  FS_FORMAT_DTB_B=
  FS_OPTIONS_DTB_B=""
  PARTITION_NUM_DTB_B="19"
  PARTITION_TYPE_DTB_B="data"
  IMAGE_DTB_B=""
  PARTITION_SIZE_19=2097152
  RESERVED_EBS_19=0
  DATA_SIZE_19=2097152
  FORMAT_19=
  FS_FORMAT_19=
  FS_OPTIONS_19=""
  PARTITION_NUM_19="19"
  PARTITION_TYPE_19="data"
  IMAGE_19=""
  PARTITION_SIZE_DTBO_B=8388608
  RESERVED_EBS_DTBO_B=0
  DATA_SIZE_DTBO_B=8388608
  FORMAT_DTBO_B=
  FS_FORMAT_DTBO_B=
  FS_OPTIONS_DTBO_B=""
  PARTITION_NUM_DTBO_B="20"
  PARTITION_TYPE_DTBO_B="data"
  IMAGE_DTBO_B=""
  PARTITION_SIZE_20=8388608
  RESERVED_EBS_20=0
  DATA_SIZE_20=8388608
  FORMAT_20=
  FS_FORMAT_20=
  FS_OPTIONS_20=""
  PARTITION_NUM_20="20"
  PARTITION_TYPE_20="data"
  IMAGE_20=""
  PARTITION_SIZE_DESKTOP_SECURITY_PERSIST=16777216
  RESERVED_EBS_DESKTOP_SECURITY_PERSIST=0
  DATA_SIZE_DESKTOP_SECURITY_PERSIST=16777216
  FORMAT_DESKTOP_SECURITY_PERSIST=
  FS_FORMAT_DESKTOP_SECURITY_PERSIST=
  FS_OPTIONS_DESKTOP_SECURITY_PERSIST=""
  PARTITION_NUM_DESKTOP_SECURITY_PERSIST="21"
  PARTITION_TYPE_DESKTOP_SECURITY_PERSIST="data"
  IMAGE_DESKTOP_SECURITY_PERSIST=""
  PARTITION_SIZE_21=16777216
  RESERVED_EBS_21=0
  DATA_SIZE_21=16777216
  FORMAT_21=
  FS_FORMAT_21=
  FS_OPTIONS_21=""
  PARTITION_NUM_21="21"
  PARTITION_TYPE_21="data"
  IMAGE_21=""
  PARTITION_SIZE_DESKTOP_SECURITY_STORAGE=33554432
  RESERVED_EBS_DESKTOP_SECURITY_STORAGE=0
  DATA_SIZE_DESKTOP_SECURITY_STORAGE=33554432
  FORMAT_DESKTOP_SECURITY_STORAGE=
  FS_FORMAT_DESKTOP_SECURITY_STORAGE=
  FS_OPTIONS_DESKTOP_SECURITY_STORAGE=""
  PARTITION_NUM_DESKTOP_SECURITY_STORAGE="22"
  PARTITION_TYPE_DESKTOP_SECURITY_STORAGE="data"
  IMAGE_DESKTOP_SECURITY_STORAGE=""
  PARTITION_SIZE_22=33554432
  RESERVED_EBS_22=0
  DATA_SIZE_22=33554432
  FORMAT_22=
  FS_FORMAT_22=
  FS_OPTIONS_22=""
  PARTITION_NUM_22="22"
  PARTITION_TYPE_22="data"
  IMAGE_22=""
  PARTITION_SIZE_MISC=4194304
  RESERVED_EBS_MISC=0
  DATA_SIZE_MISC=4194304
  FORMAT_MISC=
  FS_FORMAT_MISC=
  FS_OPTIONS_MISC=""
  PARTITION_NUM_MISC="23"
  PARTITION_TYPE_MISC="data"
  IMAGE_MISC=""
  PARTITION_SIZE_23=4194304
  RESERVED_EBS_23=0
  DATA_SIZE_23=4194304
  FORMAT_23=
  FS_FORMAT_23=
  FS_OPTIONS_23=""
  PARTITION_NUM_23="23"
  PARTITION_TYPE_23="data"
  IMAGE_23=""
  PARTITION_SIZE_METADATA=67108864
  RESERVED_EBS_METADATA=0
  DATA_SIZE_METADATA=67108864
  FORMAT_METADATA=
  FS_FORMAT_METADATA=ext4
  FS_OPTIONS_METADATA=""
  PARTITION_NUM_METADATA="24"
  PARTITION_TYPE_METADATA="data"
  IMAGE_METADATA=""
  PARTITION_SIZE_24=67108864
  RESERVED_EBS_24=0
  DATA_SIZE_24=67108864
  FORMAT_24=
  FS_FORMAT_24=ext4
  FS_OPTIONS_24=""
  PARTITION_NUM_24="24"
  PARTITION_TYPE_24="data"
  IMAGE_24=""
  PARTITION_SIZE_RECOVERY_A=33554432
  RESERVED_EBS_RECOVERY_A=0
  DATA_SIZE_RECOVERY_A=33554432
  FORMAT_RECOVERY_A=
  FS_FORMAT_RECOVERY_A=
  FS_OPTIONS_RECOVERY_A=""
  PARTITION_NUM_RECOVERY_A="25"
  PARTITION_TYPE_RECOVERY_A="data"
  IMAGE_RECOVERY_A=""
  PARTITION_SIZE_25=33554432
  RESERVED_EBS_25=0
  DATA_SIZE_25=33554432
  FORMAT_25=
  FS_FORMAT_25=
  FS_OPTIONS_25=""
  PARTITION_NUM_25="25"
  PARTITION_TYPE_25="data"
  IMAGE_25=""
  PARTITION_SIZE_RECOVERY_B=33554432
  RESERVED_EBS_RECOVERY_B=0
  DATA_SIZE_RECOVERY_B=33554432
  FORMAT_RECOVERY_B=
  FS_FORMAT_RECOVERY_B=
  FS_OPTIONS_RECOVERY_B=""
  PARTITION_NUM_RECOVERY_B="26"
  PARTITION_TYPE_RECOVERY_B="data"
  IMAGE_RECOVERY_B=""
  PARTITION_SIZE_26=33554432
  RESERVED_EBS_26=0
  DATA_SIZE_26=33554432
  FORMAT_26=
  FS_FORMAT_26=
  FS_OPTIONS_26=""
  PARTITION_NUM_26="26"
  PARTITION_TYPE_26="data"
  IMAGE_26=""
  PARTITION_SIZE_FRP_PERSIST=2097152
  RESERVED_EBS_FRP_PERSIST=0
  DATA_SIZE_FRP_PERSIST=2097152
  FORMAT_FRP_PERSIST=
  FS_FORMAT_FRP_PERSIST=
  FS_OPTIONS_FRP_PERSIST=""
  PARTITION_NUM_FRP_PERSIST="27"
  PARTITION_TYPE_FRP_PERSIST="data"
  IMAGE_FRP_PERSIST=""
  PARTITION_SIZE_27=2097152
  RESERVED_EBS_27=0
  DATA_SIZE_27=2097152
  FORMAT_27=
  FS_FORMAT_27=
  FS_OPTIONS_27=""
  PARTITION_NUM_27="27"
  PARTITION_TYPE_27="data"
  IMAGE_27=""
  PARTITION_SIZE_USERDATA=4294967296
  RESERVED_EBS_USERDATA=0
  DATA_SIZE_USERDATA=4294967296
  FORMAT_USERDATA=
  FS_FORMAT_USERDATA=
  FS_OPTIONS_USERDATA=""
  PARTITION_NUM_USERDATA="1"
  PARTITION_TYPE_USERDATA="data"
  IMAGE_USERDATA=""
  PARTITION_SIZE_1=4294967296
  RESERVED_EBS_1=0
  DATA_SIZE_1=4294967296
  FORMAT_1=
  FS_FORMAT_1=
  FS_OPTIONS_1=""
  PARTITION_NUM_1="1"
  PARTITION_TYPE_1="data"
  IMAGE_1=""
  PARTITION_SIZE_OTA_RECOVERY_B=134217728
  RESERVED_EBS_OTA_RECOVERY_B=0
  DATA_SIZE_OTA_RECOVERY_B=134217728
  FORMAT_OTA_RECOVERY_B=
  FS_FORMAT_OTA_RECOVERY_B=
  FS_OPTIONS_OTA_RECOVERY_B=""
  PARTITION_NUM_OTA_RECOVERY_B="39"
  PARTITION_TYPE_OTA_RECOVERY_B="data"
  IMAGE_OTA_RECOVERY_B=""
  PARTITION_SIZE_39=134217728
  RESERVED_EBS_39=0
  DATA_SIZE_39=134217728
  FORMAT_39=
  FS_FORMAT_39=
  FS_OPTIONS_39=""
  PARTITION_NUM_39="39"
  PARTITION_TYPE_39="data"
  IMAGE_39=""
  PARTITION_SIZE_MODEM_A=367001600
  RESERVED_EBS_MODEM_A=0
  DATA_SIZE_MODEM_A=367001600
  FORMAT_MODEM_A=
  FS_FORMAT_MODEM_A=
  FS_OPTIONS_MODEM_A=""
  PARTITION_NUM_MODEM_A="28"
  PARTITION_TYPE_MODEM_A="data"
  IMAGE_MODEM_A="modem.img"
  PARTITION_SIZE_28=367001600
  RESERVED_EBS_28=0
  DATA_SIZE_28=367001600
  FORMAT_28=
  FS_FORMAT_28=
  FS_OPTIONS_28=""
  PARTITION_NUM_28="28"
  PARTITION_TYPE_28="data"
  IMAGE_28="modem.img"
  PARTITION_SIZE_MODEM_B=367001600
  RESERVED_EBS_MODEM_B=0
  DATA_SIZE_MODEM_B=367001600
  FORMAT_MODEM_B=
  FS_FORMAT_MODEM_B=
  FS_OPTIONS_MODEM_B=""
  PARTITION_NUM_MODEM_B="29"
  PARTITION_TYPE_MODEM_B="data"
  IMAGE_MODEM_B=""
  PARTITION_SIZE_29=367001600
  RESERVED_EBS_29=0
  DATA_SIZE_29=367001600
  FORMAT_29=
  FS_FORMAT_29=
  FS_OPTIONS_29=""
  PARTITION_NUM_29="29"
  PARTITION_TYPE_29="data"
  IMAGE_29=""
  PARTITION_SIZE_BLUETOOTH_A=8388608
  RESERVED_EBS_BLUETOOTH_A=0
  DATA_SIZE_BLUETOOTH_A=8388608
  FORMAT_BLUETOOTH_A=
  FS_FORMAT_BLUETOOTH_A=
  FS_OPTIONS_BLUETOOTH_A=""
  PARTITION_NUM_BLUETOOTH_A="30"
  PARTITION_TYPE_BLUETOOTH_A="data"
  IMAGE_BLUETOOTH_A="bluetooth.img"
  PARTITION_SIZE_30=8388608
  RESERVED_EBS_30=0
  DATA_SIZE_30=8388608
  FORMAT_30=
  FS_FORMAT_30=
  FS_OPTIONS_30=""
  PARTITION_NUM_30="30"
  PARTITION_TYPE_30="data"
  IMAGE_30="bluetooth.img"
  PARTITION_SIZE_BLUETOOTH_B=8388608
  RESERVED_EBS_BLUETOOTH_B=0
  DATA_SIZE_BLUETOOTH_B=8388608
  FORMAT_BLUETOOTH_B=
  FS_FORMAT_BLUETOOTH_B=
  FS_OPTIONS_BLUETOOTH_B=""
  PARTITION_NUM_BLUETOOTH_B="31"
  PARTITION_TYPE_BLUETOOTH_B="data"
  IMAGE_BLUETOOTH_B=""
  PARTITION_SIZE_31=8388608
  RESERVED_EBS_31=0
  DATA_SIZE_31=8388608
  FORMAT_31=
  FS_FORMAT_31=
  FS_OPTIONS_31=""
  PARTITION_NUM_31="31"
  PARTITION_TYPE_31="data"
  IMAGE_31=""
  PARTITION_SIZE_DSP_A=78643200
  RESERVED_EBS_DSP_A=0
  DATA_SIZE_DSP_A=78643200
  FORMAT_DSP_A=
  FS_FORMAT_DSP_A=
  FS_OPTIONS_DSP_A=""
  PARTITION_NUM_DSP_A="32"
  PARTITION_TYPE_DSP_A="data"
  IMAGE_DSP_A="dsp.img"
  PARTITION_SIZE_32=78643200
  RESERVED_EBS_32=0
  DATA_SIZE_32=78643200
  FORMAT_32=
  FS_FORMAT_32=
  FS_OPTIONS_32=""
  PARTITION_NUM_32="32"
  PARTITION_TYPE_32="data"
  IMAGE_32="dsp.img"
  PARTITION_SIZE_DSP_B=78643200
  RESERVED_EBS_DSP_B=0
  DATA_SIZE_DSP_B=78643200
  FORMAT_DSP_B=
  FS_FORMAT_DSP_B=
  FS_OPTIONS_DSP_B=""
  PARTITION_NUM_DSP_B="33"
  PARTITION_TYPE_DSP_B="data"
  IMAGE_DSP_B=""
  PARTITION_SIZE_33=78643200
  RESERVED_EBS_33=0
  DATA_SIZE_33=78643200
  FORMAT_33=
  FS_FORMAT_33=
  FS_OPTIONS_33=""
  PARTITION_NUM_33="33"
  PARTITION_TYPE_33="data"
  IMAGE_33=""
  PARTITION_SIZE_KEYMASTER_A=10485760
  RESERVED_EBS_KEYMASTER_A=0
  DATA_SIZE_KEYMASTER_A=10485760
  FORMAT_KEYMASTER_A=
  FS_FORMAT_KEYMASTER_A=
  FS_OPTIONS_KEYMASTER_A=""
  PARTITION_NUM_KEYMASTER_A="34"
  PARTITION_TYPE_KEYMASTER_A="data"
  IMAGE_KEYMASTER_A=""
  PARTITION_SIZE_34=10485760
  RESERVED_EBS_34=0
  DATA_SIZE_34=10485760
  FORMAT_34=
  FS_FORMAT_34=
  FS_OPTIONS_34=""
  PARTITION_NUM_34="34"
  PARTITION_TYPE_34="data"
  IMAGE_34=""
  PARTITION_SIZE_KEYMASTER_B=10485760
  RESERVED_EBS_KEYMASTER_B=0
  DATA_SIZE_KEYMASTER_B=10485760
  FORMAT_KEYMASTER_B=
  FS_FORMAT_KEYMASTER_B=
  FS_OPTIONS_KEYMASTER_B=""
  PARTITION_NUM_KEYMASTER_B="35"
  PARTITION_TYPE_KEYMASTER_B="data"
  IMAGE_KEYMASTER_B=""
  PARTITION_SIZE_35=10485760
  RESERVED_EBS_35=0
  DATA_SIZE_35=10485760
  FORMAT_35=
  FS_FORMAT_35=
  FS_OPTIONS_35=""
  PARTITION_NUM_35="35"
  PARTITION_TYPE_35="data"
  IMAGE_35=""
  PARTITION_SIZE_PERSIST=33554432
  RESERVED_EBS_PERSIST=0
  DATA_SIZE_PERSIST=33554432
  FORMAT_PERSIST=
  FS_FORMAT_PERSIST=
  FS_OPTIONS_PERSIST=""
  PARTITION_NUM_PERSIST="36"
  PARTITION_TYPE_PERSIST="data"
  IMAGE_PERSIST="persist.img"
  PARTITION_SIZE_36=33554432
  RESERVED_EBS_36=0
  DATA_SIZE_36=33554432
  FORMAT_36=
  FS_FORMAT_36=
  FS_OPTIONS_36=""
  PARTITION_NUM_36="36"
  PARTITION_TYPE_36="data"
  IMAGE_36="persist.img"
  PARTITION_SIZE_RAWDUMP=268435456
  RESERVED_EBS_RAWDUMP=0
  DATA_SIZE_RAWDUMP=268435456
  FORMAT_RAWDUMP=
  FS_FORMAT_RAWDUMP=
  FS_OPTIONS_RAWDUMP=""
  PARTITION_NUM_RAWDUMP="37"
  PARTITION_TYPE_RAWDUMP="minidump"
  IMAGE_RAWDUMP=""
  PARTITION_SIZE_37=268435456
  RESERVED_EBS_37=0
  DATA_SIZE_37=268435456
  FORMAT_37=
  FS_FORMAT_37=
  FS_OPTIONS_37=""
  PARTITION_NUM_37="37"
  PARTITION_TYPE_37="minidump"
  IMAGE_37=""
}



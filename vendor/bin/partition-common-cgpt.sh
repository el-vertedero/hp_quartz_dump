#!/bin/sh
# Copyright (C) 2025 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Use cgpt to add a partition.
# Usage: part_add <num> <start> <size> <typecode> <label> <device>
part_add() {
  local partnum=$1
  local partstart=$2
  local partend=$(expr $2 + $3 - 1 )
  local typecode=$4
  local label=$5
  local device=$6

  echo "Adding partition ${partnum} ${label} from ${partstart} to ${partend}"
  cgpt add -i ${partnum} -b ${partstart} -s ${3} -t ${typecode} -l ${label} ${device} > /dev/null
}

# Usage: part_prio <set prio> <set tries> <device>
part_prio() {
  local partnum=$1
  local set_prio=$2
  local set_tries=$3
  local device=$4

  echo "Setting priority and tries for ${partnum}"

  if [ ${set_prio} -eq 1 ]; then
    if ! cgpt add -i ${partnum} -P 15 ${device} > /dev/null; then
      return $?
    fi
  fi

  if [ ${set_tries} -eq 1 ]; then
    if ! cgpt add -i ${partnum} -T 15 ${device} > /dev/null; then
      return $?
    fi
  fi
}

# Usage: part_clear_tries <partnum> <device>
part_clear_tries() {
  local partnum=$1
  local device=$2

  echo "Clearing tries for ${partnum}"

  cgpt add -i "${partnum}" -T 0 "${device}" > /dev/null
}

# Usage: part_clear_priority <partnum> <device>
part_clear_priority() {
  local partnum=$1
  local device=$2

  echo "Clearing priority for ${partnum}"

  cgpt add -i "${partnum}" -P 0 "${device}" > /dev/null
}

# Usage: part_set_success <partnum> <device>
part_set_success() {
  local partnum=$1
  local device=$2

  echo "Setting success for ${partnum}"

  cgpt add -i "${partnum}" -S 1 ${device} > /dev/null
}

# Usage: create_image <device> <min_disk_size>
# If <device> is a block device, wipes out the GPT
# If it's not, it creates a new file of the requested size
create_image() {
  local dev="$1"
  local min_disk_size="$2"

  if [ -b "${dev}" ]; then
    # Make sure block size is not greater than 8K. Otherwise the partition
    # start calculation won't fit.
    block_size=$(blocksize "${dev}")
    if [ "${block_size}" -gt 8192 ]; then
      echo "Destination blocksize too large. Only blocksizes of 8192 bytes and \
        smaller are supported." >&2
      exit 1
    fi

    cgpt create -z "${dev}"
    cgpt create "${dev}"
  else
    if [ ! -e "${dev}" ]; then
      # Align to 512 bytes
      min_disk_size=$(((min_disk_size + 511) & ~511))
      truncate -s "${min_disk_size}" "${dev}"
    fi
  fi
}

# Usage: cgpt_recovery <device>
# Recreate and repair the cgpt partition table.
cgpt_recovery() {
  local dev="$1"

  echo ">> Zeroing the partition table at ${dev}"
  cgpt create -z "${dev}"
  echo ">> Creating the initial partition table at ${dev}"
  cgpt create "${dev}"
  echo ">> Sanity reparing the initial partition table at ${dev}"
  cgpt repair "${dev}"

  cgpt boot -p "${dev}"
}


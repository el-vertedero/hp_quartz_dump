#!/bin/sh
# Copyright 2010 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# This contains common constants and functions for installer scripts. This must
# evaluate properly for both /bin/bash and /bin/sh, since it's used both to
# create the initial image at compile time and to install or upgrade a running
# image.

# The GPT tables describe things in terms of 512-byte sectors, but some
# filesystems prefer 4096-byte blocks. These functions help with alignment
# issues.

# This returns the size of a file or device in physical sectors, rounded up if
# needed.
# Invoke as: subshell
# Args: FILENAME
# Return: whole number of sectors needed to fully contain FILENAME
numsectors() {
  local block_size
  local sectors
  local path="$1"

  if [ -b "${path}" ]; then
    local dev="${path##*/}"
    block_size="$(blocksize "${path}")"

    if [ -e "/sys/block/${dev}/size" ]; then
      sectors="$(cat "/sys/block/${dev}/size")"
    else
      part="${path##*/}"
      block="$(get_block_dev_from_partition_dev "${path}")"
      block="${block##*/}"
      sectors="$(cat "/sys/block/${block}/${part}/size")"
    fi
  else
    local bytes
    bytes="$(stat -c%s "${path}")"
    local rem=$(( bytes % 512 ))
    block_size=512
    sectors=$(( bytes / 512 ))
    if [ "${rem}" -ne 0 ]; then
      sectors=$(( sectors + 1 ))
    fi
  fi

  echo $(( sectors / block_size * 512 ))
}

# This returns the block size of a file or device in byte
# Invoke as: subshell
# Args: FILENAME
# Return: block size in bytes
blocksize() {
  local path="$1"
  if [ -b "${path}" ]; then
    local dev="${path##*/}"
    local sys="/sys/block/${dev}/queue/logical_block_size"
    if [ -e "${sys}" ]; then
      cat "${sys}"
    else
      local part="${path##*/}"
      local block
      block="$(get_block_dev_from_partition_dev "${path}")"
      block="${block##*/}"
      cat "/sys/block/${block}/${part}/queue/logical_block_size"
    fi
  else
    echo 512
  fi
}

# Construct a partition device name from a whole disk block device and a
# partition number.
# This works for [/dev/sda, 3] (-> /dev/sda3) as well as [/dev/mmcblk0, 2]
# (-> /dev/mmcblk0p2).
make_partition_dev() {
  local block="$1"
  local num="$2"
  # If the disk block device ends with a number, we add a 'p' before the
  # partition number.
  if (expr "${block}" : ".*[0-9]$" >/dev/null) ; then
    echo "${block}p${num}"
  else
    echo "${block}${num}"
  fi
}

# Extract the partition number from the partition device.
# This works for /dev/sda3 (-> 3) as well as /dev/mmcblk0p2 (-> 2).
get_partition_number() {
  local partition="$1"
  if ! (expr "${partition}" : ".*[0-9]$" >/dev/null) ; then
    echo "Invalid partition name: ${partition}" >&2
    exit 1
  fi
  # Extract the last digit.
  echo "${partition}" | sed -e 's/^.*\([0-9]\)$/\1/'
}

# Construct a partition device name from a whole disk block device and a
# partition number.
# This works for [/dev/sda, 3] (-> /dev/sda3) as well as [/dev/mmcblk0, 2]
# (-> /dev/mmcblk0p2).
make_partition_dev() {
  local block="$1"
  local num="$2"
  # If the disk block device ends with a number, we add a 'p' before the
  # partition number.
  if (expr "${block}" : ".*[0-9]$" >/dev/null) ; then
    echo "${block}p${num}"
  else
    echo "${block}${num}"
  fi
}

#!/vendor/bin/sh
# Copyright (C) 2024 The Android Open Source Project
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

#############################################################
### init.insmod.cfg format:                               ###
### ----------------------------------------------------- ###
### [modprobe] [path|prop name]                           ###
### ...                                                   ###
#############################################################

search_path=""
vendor_modules_load_path=""
system_modules_load_path=""

system_modules_dir="/system/lib/modules"
vendor_modules_dir="/vendor/lib/modules"

if [[  -f "${system_modules_dir}/modules.load" ]]; then
  system_modules_load_path="--all=${system_modules_dir}/modules.load"
  search_path="-d ${system_modules_dir} "
fi

if [[ -f "${vendor_modules_dir}/modules.load" ]]; then
  vendor_modules_load_path="--all=${vendor_modules_dir}/modules.load"
  search_path="${search_path}-d ${vendor_modules_dir}"
fi

if [[ -z "${search_path}" ]]; then
  echo "Unable to locate nor system or vendor kernel modules directory"
  exit 1
fi

if [ $# -eq 1 ]; then
  cfg_file=$1
else
  exit 1
fi

if [ -f $cfg_file ]; then
  while IFS="|" read -r action arg
  do
    case $action in
      "modprobe")
        case ${arg} in
          "vendor -b *")
            arg="-b ${vendor_modules_load_path}" ;;
          "vendor *")
            arg="${vendor_modules_load_path}" ;;
          "system -b *")
            arg="-b ${system_modules_load_path}" ;;
          "system *")
            arg="${system_modules_load_path}" ;;
        esac
	# This script might be run with config to load single modules. If that's the case
	# it won't catch on any condition and would pass directly to the modprobe command execution.
	# That't intended behavior, i.e. when the config would be: 'modprobe|iwlwifi.ko'.
        if [[ -n "${search_path}" ]]; then
          modprobe -a ${search_path} $arg
        fi
        ;;
    esac
  done < $cfg_file
fi

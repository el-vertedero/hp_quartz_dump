#!/vendor/bin/sh
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

# TODO(b/402476836): Delete this whole script.
ADB_ENABLED=0

# eng builds set ro.secure=0.
SECURE="$(getprop ro.secure 1)"
if [ "${SECURE}" -eq "0" ]; then
  ADB_ENABLED=1
else
  # Get GBB flags to see if ADB guard is enabled
  GBB=$(futility gbb --get --flash --flags | grep "flag" | cut -d ' ' -f 2)

  # Extract ADB guard
  ADB_ENABLED="$(( GBB >> 31 & 0x1 ))"
fi

if [ "${ADB_ENABLED}" -eq 1 ]; then
  setprop ro.vendor.adbd.unsafe 1
fi

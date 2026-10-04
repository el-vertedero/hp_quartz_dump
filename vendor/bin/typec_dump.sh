#!/system/bin/sh
#
# Copyright (C) 2023 The Android Open Source Project
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

port=-1;
while true; do
    echo "-----------";
    port=$((port+1));
    /vendor/bin/ectool typecstatus "${port}" 2>/dev/null || break;
    echo "\nPort C${port} SOP Discovery";
    /vendor/bin/ectool typecdiscovery "${port}" sop 2>/dev/null || continue;
    echo "\nPort C${port} SOP' Discovery";
    /vendor/bin/ectool typecdiscovery "${port}" sop-prime 2>/dev/null || continue;
done

echo "\nUSB PD MUX info (pdc platforms only)";
/vendor/bin/ectool usbpdmuxinfo 2>/dev/null;